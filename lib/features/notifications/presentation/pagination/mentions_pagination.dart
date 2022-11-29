import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/custom_pagination.dart';
import 'package:colibri/features/notifications/data/models/request/notification_or_mention_request_model.dart';
import 'package:colibri/features/notifications/domain/entity/notification_entity.dart';
import 'package:colibri/features/notifications/domain/usecase/delete_notification_use_case.dart';
import 'package:colibri/features/notifications/domain/usecase/get_notification_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
@injectable
class MentionsPagination extends CustomPagination<NotificationEntity>{
  final GetNotificationUseCase getNotificationUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  final _deletedItemsController=BehaviorSubject<Set<int>>.seeded(Set());
  addDeletedItem(int index){
    _deletedItemsController.sink.add(_deletedItemsController.value..add(index));
  }

  deleteSelectedItem(int index){

    _deletedItemsController.sink.add( _deletedItemsController.value..remove(index));
  }

  Stream<Set<int>> get deletedItems=>_deletedItemsController.stream;

  MentionsPagination(this.getNotificationUseCase, this.deleteNotificationUseCase);
  @override
  Future<Either<Failure, List<NotificationEntity>>> getItems(int pageKey) {
    return getNotificationUseCase(NotificationOrMentionRequestModel(offsetId: pageKey.toString(),
      notificationOrMentionEnum: NotificationOrMentionEnum.MENTIONS
    ));
  }

  @override
  NotificationEntity getLastItemWithoutAd(List<NotificationEntity> item) {
    return item.last;
  }

  @override
  int getNextKey(NotificationEntity item) {
    return int.tryParse(item.notificationId);
  }

  @override
  bool isLastPage(List<NotificationEntity> item) {
    return commonLastPage(item);
  }
  @override
  onClose() {
    _deletedItemsController.close();
    return super.onClose();
  }
  deleteNotification() async {
    List<String> _notificationId=[];
    _deletedItemsController.value.forEach((element) {
      _notificationId.add(pagingController.itemList[element].notificationId);
    });
    _deletedItemsController.sink.add(Set());
    // pagingController..itemList=pagingController.itemList..notifyListeners();
    var either = await deleteNotificationUseCase(_notificationId);
    either.fold((l) => null, (r) {
      onRefresh();
      // _deletedItemsController.sink.add(Set());
      // pagingController..itemList.removeWhere((element) => _notificationId.contains(element.notificationId))..notifyListeners();

    });
  }

}