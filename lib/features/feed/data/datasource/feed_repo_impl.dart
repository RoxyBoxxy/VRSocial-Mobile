import 'dart:collection';
import 'dart:io';
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/api/api_helper.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeedRepo)
class FeedRepoImpl extends FeedRepo {
  final ApiHelper? apiHelper;
  final LocalDataSource? localDataSource;
  // int requestCount=0;
  FeedRepoImpl(this.apiHelper, this.localDataSource);

  @override
  Future<Either<Failure, List<PostEntity>>> getFeeds(String pageKey) async {
    print("fetching apis");
    // requestCount=requestCount+1;
    var queryMap = {"page_size": ApiConstants.pageSize.toString()};
    if (pageKey.isNotEmpty && pageKey != "0")
      queryMap.addAll({"offset": pageKey});
    var response =
        await apiHelper!.get(ApiConstants.feeds, queryParameters: queryMap);
    return response.fold((l) => left(l), (r) {
      return right(FeedResponse.fromJson(r.data)
          .data!
          .feeds!
          .map((e) =>
              PostEntity.fromFeed(e).copyWith(parentPostUsername: e.username))
          .toList());
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> saveNotificationToken() async {
    if (await localDataSource!.isUserLoggedIn()) {
      final pushToken = await localDataSource!.getPushToken();
      await apiHelper!.post(
          ApiConstants.saveNotificationToken,
          HashMap.from({
            "token": pushToken,
            "type": Platform.isAndroid ? "android" : "ios"
          }));
    }
    return right([]);
  }
}
