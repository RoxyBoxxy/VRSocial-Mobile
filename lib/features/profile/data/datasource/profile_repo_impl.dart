import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/api/api_helper.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/push_notification/push_notification_helper.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/posts/data/model/response/follwers_response.dart';
import 'package:colibri/features/profile/data/models/request/profile_posts_model.dart';
import 'package:colibri/features/profile/data/models/request/update_password_request.dart';
import 'package:colibri/features/profile/data/models/request/update_setting_request_model.dart';
import 'package:colibri/features/profile/data/models/request/verify_request_model.dart';
import 'package:colibri/features/profile/data/models/response/bookmarks_response.dart';
import 'package:colibri/features/profile/data/models/response/privacy_response.dart';
import 'package:colibri/features/profile/data/models/response/profile_posts_response.dart';
import 'package:colibri/features/profile/data/models/response/profile_response.dart';
import 'package:colibri/features/profile/domain/entity/follower_entity.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/domain/entity/setting_entity.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:colibri/extensions.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl extends ProfileRepo {
  final ApiHelper apiHelper;
  final LocalDataSource localDataSource;
  final GoogleSignIn _googleSignIn;
  ProfileRepoImpl(this.apiHelper, this.localDataSource, this._googleSignIn);

  // passing null to the this function will add current user id to request object
  @override
  Future<Either<Failure, ProfileEntity>> getProfileData(
      String userIdOrUsername) async {
    var loginResponse = await localDataSource.getUserData();
    var map = {};
    //// if we have username like [null] or same1, john2 etc
    if (userIdOrUsername == null || int.tryParse(userIdOrUsername) != null) {
      map.addAll(
          {"user_id": userIdOrUsername ?? loginResponse.data.user.userId});
    }
    // if the argument is parsed to int successfully then we have user id like 5421,5688 etc
    else {
      map.addAll({"username": userIdOrUsername});
    }

    var either = await apiHelper.get(ApiConstants.profile,
        queryParameters: HashMap.from(map));
    return either.fold((l) => left(l), (r) {
      var profileResponse = ProfileResponse.fromJson(r.data);
      var profileEntity = ProfileEntity.fromProfileResponse(
          profileResponse: profileResponse, loginResponse: loginResponse);
      return right(profileEntity);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPostByCategory(
      PostCategoryModel model) async {
    var loginResponse = await localDataSource.getUserData();
    var map = {
      "user_id": model.userId ?? loginResponse.data.user.userId.toString(),
      "page_size": ApiConstants.pageSize,
      "offset": model.offSetId?.toString(),
      "type": _getPostType(model.postCategory),
    };
    // if(model.offSetId!=null)map.addAll({"offset":model.offSetId.toString()});
    var either =
        await apiHelper.get(ApiConstants.profilePosts, queryParameters: map);
    return either.fold(
        (l) => left(l),
        (r) => right(ProfilePostResponse.fromJson(r.data)
            .data
            .posts
            .map((e) => PostEntity.fromProfilePosts(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getBookmarks(
      String offsetId) async {
    var map = {
      "page_size": ApiConstants.pageSize,
      "offset": offsetId,
    };
    // if(model.offSetId!=null)map.addAll({"offset":model.offSetId.toString()});
    var either =
        await apiHelper.get(ApiConstants.getBookmarks, queryParameters: map);
    return either.fold(
        (l) => left(l),
        (r) => right(BookmarksResponse.fromJson(r.data)
            .data
            .map((e) => PostEntity.fromFeed(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FollowerEntity>>> getFollower(
      PostCategoryModel model) async {
    var loginResponse = await localDataSource.getUserData();
    var map = {
      "user_id": model.userId ?? loginResponse.data.user.userId.toString(),
      "page_size": ApiConstants.pageSize,
      "offset": model.offSetId,
    };
    final either =
        await apiHelper.get(ApiConstants.fetchFollowers, queryParameters: map);
    return either.fold(
        (l) => left(l),
        (r) => right(FollowersResponse.fromJson(r.data)
            .data
            .map((e) => FollowerEntity.fromResponse(
                e, loginResponse.data.user.userId == e.id))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FollowerEntity>>> getFollowing(
      PostCategoryModel model) async {
    final loginResponse = await localDataSource.getUserData();
    final map = {
      "user_id": model.userId ?? loginResponse.data.user.userId.toString(),
      "page_size": ApiConstants.pageSize,
      "offset": model.offSetId,
    };
    var either =
        await apiHelper.get(ApiConstants.fetchFollowing, queryParameters: map);
    return either.fold(
        (l) => left(l),
        (r) => right(FollowersResponse.fromJson(r.data)
            .data
            .map((e) => FollowerEntity.fromResponse(
                e, loginResponse.data.user.userId == e.id))
            .toList()));
  }

  // it can accept both user id i.e of int type and username i.e type of string
  @override
  Future<Either<Failure, dynamic>> followUnFollow(String userId) async =>
      await apiHelper.post(
          ApiConstants.follow, HashMap.from({"user_id": userId}));

  @override
  Future<Either<Failure, SettingEntity>> getUserSettings() async {
    final either = await getProfileData(null);
    final privacyResponse = await getUserPrivacySettings();
    return either.fold(
        (l) => left(l),
        (settingResponse) => privacyResponse.fold(
            (l) => left(l),
            (privacy) => right(
                SettingEntity.fromSettingResponse(settingResponse, privacy))));
    // var loginResponse = await localDataSource.getUserData();
  }

  @override
  Future<Either<Failure, AccountPrivacyEntity>> getUserPrivacySettings() async {
    final either = await apiHelper.get(ApiConstants.privacySettings);
    return either.fold((l) => left(l), (r) {
      final privacyResponse = PrivacyResponse.fromJson(r.data);
      return right(AccountPrivacyEntity.fromResponse(privacyResponse.data));
    });
  }

  @override
  Future<Either<Failure, dynamic>> updateUserSetting(
      UpdateSettingsRequestModel model) async {
    var either = await apiHelper.post(
        ApiConstants.updateUserSettings, HashMap.from(model.toJson()));
    return either.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Either<Failure, dynamic>> updatePassword(
          UpdatePasswordRequest model) async =>
      await apiHelper.post(
          ApiConstants.changePassword, HashMap.from(model.toJson()));

  @override
  Future<Either<Failure, dynamic>> updatePrivacy(
          AccountPrivacyEntity model) async =>
      await apiHelper.post(ApiConstants.updatePrivacySettings,
          HashMap.from(model.toModelJson()));

  @override
  Future<Either<Failure, dynamic>> logOutUser() async {
    var post = await apiHelper.post(ApiConstants.logOut, HashMap());
    return post.fold((l) => left(l), (r) async {
      await localDataSource.clearData();
      await PushNotificationHelper.unregister();
      await _googleSignIn.signOut();
      await FacebookLogin().logOut();
      return right(r);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteAccount(String password) async {
    final either = await apiHelper.post(
        ApiConstants.deleteAccount, HashMap.from({"password": password}));
    return either.fold((l) => left(l), (r) async {
      await localDataSource.clearData();
      ExtendedNavigator.root
          .pushAndRemoveUntil(Routes.loginScreen, (route) => false);
      return right(r);
    });
  }

  @override
  Future<Either<Failure, dynamic>> verifyUserAccount(
      VerifyRequestModel verifyRequestModel) async {
    final map = await verifyRequestModel.toMap;
    return apiHelper.post(ApiConstants.verifyUser, map);
  }

  @override
  Future<Either<Failure, String>> changeLanguage(String lang) async {
    final either = await apiHelper.post(
        ApiConstants.changeLanguage, HashMap.from({"lang_name": lang}));
    return either.fold((l) => left(l), (r) => right(r.data["message"]));
  }

  @override
  Future<Either<Failure, String>> updateAvatar(String image) async {
    final either = await apiHelper.post(ApiConstants.updateAvatar,
        HashMap.from({"avatar": await image.toMultiPart()}));
    return either.fold((l) => left(l), (r) => right(r.data["message"]));
  }

  @override
  Future<Either<Failure, String>> updateCover(String image) async {
    final either = await apiHelper.post(ApiConstants.updateCover,
        HashMap.from({"cover": await image.toMultiPart()}));
    return either.fold((l) => left(l), (r) => right(r.data["message"]));
  }

  @override
  Future<Either<Failure, bool>> getLoginMode() async {
    final sl = await localDataSource.didSocialLoggedIn();
    if (sl != null && sl) {
      return const Right(true);
    } else
      return Left(NoDataFoundFailure(""));
  }
}

String _getPostType(PostCategory type) {
  switch (type) {
    case PostCategory.POSTS:
      return "posts";
      break;
    case PostCategory.LIKED:
      return "likes";
      break;
    case PostCategory.MEDIA:
      return "media";
      break;
    default:
      return null;
  }
}
