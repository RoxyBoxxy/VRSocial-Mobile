import 'dart:io';

import 'package:colibri/core/common/failure.dart';
import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/feed/data/models/request/post_request_model.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/posts/domain/entiity/media_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FeedRepo{
  Future<Either<Failure,List<PostEntity>>> getFeeds(String pageKey);
  Future<Either<Failure,List<PostEntity>>> saveNotificationToken();

}