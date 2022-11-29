import 'dart:collection';

import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/api/api_helper.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/text_model_with_offset.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/search/data/models/hashtags_response.dart';
import 'package:colibri/features/search/data/models/people_response.dart';
import 'package:colibri/features/search/data/models/search_post_response.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/domain/entity/hashtag_entity.dart';
import 'package:colibri/features/search/domain/repo/search_repo.dart';
import 'package:colibri/main.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepo)
class SearchRepoImpl extends SearchRepo {
  final ApiHelper apiHelper;

  SearchRepoImpl(this.apiHelper);
  @override
  Future<Either<Failure, List<HashTagEntity>>> searchHashtag(
      TextModelWithOffset model) async {
    HashMap<String, String> map = HashMap.from({
      "query": model.queryText,
      "offset": model.offset,
      "page_size": ApiConstants.pageSize.toString()
    });
    var either =
        await apiHelper.get(ApiConstants.searchHashtags, queryParameters: map);
    return either.fold((l) => left(l), (r) {
      var hashtagResponse = HashtagResponse.fromJson(r.data);
      return right(hashtagResponse.data
          .map((e) => HashTagEntity.fromHashTag(e))
          .toList());
    });
  }

  @override
  Future<Either<Failure, List<PeopleEntity>>> searchPeople(
      TextModelWithOffset model) async {
    var loginResponse = await localDataSource.getUserData();
    HashMap<String, String> map = HashMap.from({
      "query": model.queryText,
      "offset": model.offset,
      "page_size": ApiConstants.pageSize.toString()
    });
    var either =
        await apiHelper.get(ApiConstants.searchPeople, queryParameters: map);
    return either.fold((l) => left(l), (r) {
      var hashtagResponse = PeopleResponse.fromJson(r.data);
      return right(hashtagResponse.data
          .map((e) => PeopleEntity.fromPeopleModel(
              e, loginResponse.data.user.userId == e.id))
          .toList());
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> searchPosts(
      TextModelWithOffset model) async {
    HashMap<String, String> map = HashMap.from({
      "query": model.queryText,
      "offset": model.offset,
      "page_size": ApiConstants.pageSize.toString()
    });
    var either =
        await apiHelper.get(ApiConstants.searchPosts, queryParameters: map);
    return either.fold((l) => left(l), (r) {
      var postsResponse = SearcPostsResponse.fromJson(r.data);
      return right(
          postsResponse.data.map((e) => PostEntity.fromFeed(e)).toList());
    });
  }
}
