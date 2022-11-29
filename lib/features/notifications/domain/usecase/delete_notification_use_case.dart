import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/notifications/domain/repo/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteNotificationUseCase extends UseCase<dynamic,List<String>>{
  final NotificationRepo notificationRepo;

  DeleteNotificationUseCase(this.notificationRepo);
  @override
  Future<Either<Failure, dynamic>> call(List<String> params) {
    return notificationRepo.deleteNotification(params);
  }

}