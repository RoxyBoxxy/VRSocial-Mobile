import 'dart:async';

import 'package:colibri/core/common/failure.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class PostPaginatonCubit<T, S> extends Cubit<S> {
  bool isLoading = false;

  final dynamic initCubitState;

  final PagingController<int, T> pagingController =
      PagingController<int, T>(firstPageKey: 0);

  PagingStatus? pagingStatus;

  PostPaginatonCubit(this.initCubitState) : super(initCubitState) {
    pagingController.addPageRequestListener((pageKey) {
      print("current page key : $pageKey");
      _fetchPage(pageKey);
    });
    pagingController.addStatusListener((status) {
      pagingStatus = status;
      print("current page status : $status");
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      isLoading = true;
      final response =
          await (getItems(pageKey) as FutureOr<Either<Failure, List<T>>>);
      response.fold((l) {
        isLoading = false;
        if (l.errorMessage == "No data found")
          pagingController.appendLastPage([]);
        else
          pagingController.error = l.errorMessage;
      }, (items) {
        // check if last item is of advertisement
        isLoading = false;
        if (isLastPage(items)) {
          pagingController.appendLastPage(items);
        } else {
          final nextPageKey = getNextKey(getLastItemWithoutAd(items));
          // final nextPageKey = pagingController.itemList
          pagingController.appendPage(items, nextPageKey);
        }
        // print("size is ${items.length}");
        // pagingController.appendPage(items, nextPageKey);
      });
    } catch (error) {
      isLoading = false;
      pagingController.error = error;
    }
  }

  Future<Either<Failure, List<T>>?> getItems(int pageKey);
  // used for sending to sever for fetching next chunk of data
  int getNextKey(T item);

  // to check if there is no more data available
  bool isLastPage(List<T> item);

  // get last item for getting offset value for pagination
  // if there is object with advertisement there will be no offset
  // so we will have to look the very last object that is not a type of ad object
  T getLastItemWithoutAd(List<T> item);

  Future<void> likeUnlikePost(int index);
  Future<void> repost(int index);
  Future<void> deletePost(int index);
  Future<void> addOrRemoveBookmark(int index);

  Future onOptionItemSelected(PostOptionsEnum postOptionsEnum, int index);

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }

  void onRefresh() {
    if (!isLoading) {
      pagingController.itemList?.clear();
      pagingController.refresh();
    }
  }
}
