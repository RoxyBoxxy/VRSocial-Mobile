import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/feed/domain/repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveNotificationPushUseCase extends UseCase<dynamic, Unit> {
  final FeedRepo feedRepo;

  SaveNotificationPushUseCase(this.feedRepo);
  @override
  Future<Either<Failure, dynamic>> call(Unit params) {
    return feedRepo.saveNotificationToken();
  }
}
