import 'package:bloc/bloc.dart';
import 'package:colibri/features/notifications/data/models/request/notification_or_mention_request_model.dart';
import 'package:colibri/features/notifications/domain/usecase/get_notification_use_case.dart';
import 'package:colibri/features/notifications/presentation/pagination/mentions_pagination.dart';
import 'package:colibri/features/notifications/presentation/pagination/notification_pagination.dart';
import 'package:colibri/features/notifications/presentation/widgets/notification_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final GlobalKey<AnimatedListState> animatedListState =
      GlobalKey<AnimatedListState>();
  final items = List<String>.generate(10, (i) => "${i + 1} Hours ago");
  final removedItemsIndex = <int>[];

  // pagination
  final NotificationPagination notificationPagination;
  final MentionsPagination mentionsPagination;

  NotificationCubit(this.notificationPagination, this.mentionsPagination)
      : super(NotificationInitial());

  // getAllNotification() async{
  //   await notificationUseCase(NotificationOrMentionRequestModel());
  // }

  // final removeItemCounterNotifications=BehaviorSubject<int>();
  // Function(int) get changeNotificationRemovedCounter=>removeItemCounterNotifications.sink.add;
  // Stream<int> get notificationRemovedCounter=>removeItemCounterNotifications.stream;
  removeItem() {
    var newList = <String>[];
    items.forEach((element) {
      if (!removedItemsIndex.contains(element)) newList.add(element);
    });
    // items.
    // changeItems(items);
    // removedItemsIndex.clear();
  }

  addItemForDelete(int position) {
    removedItemsIndex.add(position);
    // changeNotificationRemovedCounter(removedItemsIndex.length);
  }

  removeItemForDelete(int position) {
    removedItemsIndex.remove(position);
    // changeNotificationRemovedCounter(removedItemsIndex.length);
    print("positions: $position");
    // items.removeAt(position);
    // animatedListState?.currentState?.removeItem(position, (context, animation) =>
    //     SizeTransition(sizeFactor: animation,child: NotificationItem(time: items[position],index: position),));
  }

  @override
  Future<void> close() {
    notificationPagination.onClose();
    mentionsPagination.onClose();
    return super.close();
  }
}
