import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/media/media_data.dart';
import 'package:colibri/features/feed/data/models/request/post_request_model.dart';
import 'package:colibri/features/posts/data/model/response/post_detail_response.dart';
import 'package:colibri/features/posts/data/model/request/like_request_model.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:dartz/dartz.dart';

import 'entiity/media_entity.dart';

abstract class PostRepo {
  Future<Either<Failure, dynamic>> likeUnlikePost(String postId);
  Future<Either<Failure, dynamic>> repost(String postId);
  Future<Either<Failure, dynamic>> deletePost(String postId);
  Future<Either<Failure, MediaEntity>> uploadMedia(MediaData mediaData);
  Future<Either<Failure, dynamic>> deleteMedia(MediaEntity mediaEntity);
  Future<Either<Failure, dynamic>> createPost(PostRequestModel mediaData);
  Future<Either<Failure, dynamic>> addOrRemoveBookMark(String postId);
  Future<Either<Failure, List<PeopleEntity>>> getPostLikes(
      LikesRequestModel model);
  Future<Either<Failure, PostDetailResponse>> getThreadedPost(String postId);
}
