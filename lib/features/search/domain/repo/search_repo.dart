import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/text_model_with_offset.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/domain/entity/hashtag_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepo{
  Future<Either<Failure,List<HashTagEntity>>> searchHashtag(TextModelWithOffset model);
  Future<Either<Failure,List<PeopleEntity>>> searchPeople(TextModelWithOffset model);
  Future<Either<Failure,List<PostEntity>>> searchPosts(TextModelWithOffset model);
}