
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FeedRepo {
  Future<Either<Failure, List<PostEntity>>> getFeeds(String pageKey);
  Future<Either<Failure, List<PostEntity>>> saveNotificationToken();
}
