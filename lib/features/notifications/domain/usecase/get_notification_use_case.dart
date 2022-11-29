import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/notifications/data/models/request/notification_or_mention_request_model.dart';
import 'package:colibri/features/notifications/domain/entity/notification_entity.dart';
import 'package:colibri/features/notifications/domain/repo/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationUseCase extends UseCase<List<NotificationEntity>,
    NotificationOrMentionRequestModel> {
  final NotificationRepo notificationRepo;

  GetNotificationUseCase(this.notificationRepo);
  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      NotificationOrMentionRequestModel params) {
    return notificationRepo.getNotifications(params);
  }
}
