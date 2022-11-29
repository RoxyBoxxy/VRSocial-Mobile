import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/posts/presentation/widgets/post_pagination_widget.dart';
import 'package:colibri/features/profile/presentation/bloc/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibri/extensions.dart';

class BookMarkScreen extends StatefulWidget {
  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  BookmarkCubit bookmarkCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookmarkCubit = getIt<BookmarkCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<FeedCubit>(context)
            .changeCurrentPage(const ScreenType.home());
        // return Future.value(true);
      },
      child: BlocListener<BookmarkCubit, CommonUIState>(
        bloc: bookmarkCubit,
        listener: (_, state) {
          state.maybeWhen(
              orElse: () {},
              error: (e) => context.showSnackBar(message: e, isError: true),
              success: (s) => context.showSnackBar(message: s, isError: false));
        },
        child: NestedScrollView(
            headerSliverBuilder: (v, c) => [
                  SliverAppBar(
                    elevation: 0.0,
                    collapsedHeight: 60,
                    expandedHeight: 60,
                    floating: true,
                    pinned: true,
                    flexibleSpace: "#hashtag, username, etc..."
                        .toSearchBarField()
                        .toHorizontalPadding(24)
                        .toContainer(height: 65)
                        .makeBottomBorder,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                  )
                ],
            body: RefreshIndicator(
              onRefresh: () {
                bookmarkCubit.onRefresh();
                return Future.value();
              },
              child: PostPaginationWidget(
                isComeHome: false,
                isSliverList: false,
                noDataFoundScreen: NoDataFoundScreen(
                  onTapButton: () {
                    // ExtendedNavigator.root.push(Routes.createPost);
                    BlocProvider.of<FeedCubit>(context)
                        .changeCurrentPage(const ScreenType.home());
                  },
                  title: "No Bookmarks yet!",
                  buttonText: "GO TO THE HOMEPAGE",
                  message: "It looks like you don’t have any bookmarks yet."
                      " To add a post to the list of your bookmarks, go to any post, select arrow down icon and press the bookmark option",
                  icon: const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.colorPrimary,
                    size: 40,
                  ),
                ),
                pagingController: bookmarkCubit.pagingController,
                onTapRepost: bookmarkCubit.repost,
                onTapLike: bookmarkCubit.likeUnlikePost,
                onOptionItemTap: bookmarkCubit.onOptionItemSelected,
              ),
            )).toSafeArea,
      ),
    );
  }
}
