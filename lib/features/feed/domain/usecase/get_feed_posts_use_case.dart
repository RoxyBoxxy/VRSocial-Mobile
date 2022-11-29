import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedPostUseCase extends UseCase<List<PostEntity>, String> {
  final FeedRepo feedRepo;

  GetFeedPostUseCase(this.feedRepo);

  @override
  Future<Either<Failure, List<PostEntity>>> call(String params) {
    return feedRepo.getFeeds(params);
  }
}
