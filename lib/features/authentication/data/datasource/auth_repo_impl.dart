import 'dart:collection';
import 'dart:io';

import 'package:colibri/core/common/api/api_helper.dart';
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/features/authentication/data/models/login_response.dart';
import 'package:colibri/features/authentication/domain/repo/auth_repo.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthRepo)
class AuthRepoImpl extends AuthRepo {
  final ApiHelper apiHelper;
  final GoogleSignIn _googleSignIn;
  // final TwitterLogin _twitterLogin;
  final LocalDataSource localDataSource;

  AuthRepoImpl(this.apiHelper, this._googleSignIn, this.localDataSource);

  @override
  Future<Either<Failure, dynamic>> signIn(
      HashMap<String, dynamic> hashMap) async {
    var response = await apiHelper.post(ApiConstants.loginEndPoint, hashMap);
    return response.fold((l) {
      if (l.errorMessage.toLowerCase().contains("incorrect")) {
        return left(ServerFailure(
            "The email and password you entered does not match. Please double-check and try again"));
      }
      return left(l);
    }, (r) async {
      // saving data locally

      var loginResponse = LoginResponse.fromJson(r.data);
      await localDataSource.saveUserData(loginResponse);
      final pushToken = await localDataSource.getPushToken();
      await apiHelper.post(
          ApiConstants.saveNotificationToken,
          HashMap.from({
            "token": pushToken,
            "type": Platform.isAndroid ? "android" : "ios"
          }));
      return right(r);
    });
  }

  @override
  Future<Either<Failure, dynamic>> signUp(HashMap<String, dynamic> hashMap) {
    return apiHelper.post(ApiConstants.signUpEndPoint, hashMap);
  }

  @override
  Future<Either<Failure, String>> fbLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      var r = await apiHelper.post(
          ApiConstants.oauth,
          HashMap.from({
            "access_token": result.accessToken.token,
            "type": "facebook",
            "device_type": Platform.isAndroid ? "android" : "ios"
          }));
      return r.fold((l) {
        return left(ServerFailure("Something went wrong. Please try again"));
      }, (r) async {
        var loginResponse = LoginResponse.fromJson(r.data);
        await localDataSource.saveUserData(loginResponse);
        localDataSource.setSocialLogin(true);
        final pushToken = await localDataSource.getPushToken();
        await apiHelper.post(
            ApiConstants.saveNotificationToken,
            HashMap.from({
              "token": pushToken,
              "type": Platform.isAndroid ? "android" : "ios"
            }));
        return const Right("Successfully login");
      });
    } else if (result.status == FacebookLoginStatus.cancelledByUser)
      return Left(ServerFailure(""));
    else
      return Left(ServerFailure(result.errorMessage));
  }

  @override
  Future<Either<Failure, String>> googleLogin() async {
    try {
      var response = await _googleSignIn.signIn();
      var auth = await response.authentication;
      // var token=await refreshToken();
      var r = await apiHelper.post(
          ApiConstants.oauth,
          HashMap.from({
            "access_token": auth.accessToken,
            "type": "google",
            "device_type": Platform.isAndroid ? "android" : "ios"
          }));
      return r.fold((l) async {
        await _googleSignIn.signOut();
        return left(ServerFailure("Something went wrong. Please try again"));
      }, (r) async {
        // saving data locally

        var loginResponse = LoginResponse.fromJson(r.data);
        await localDataSource.saveUserData(loginResponse);
        localDataSource.setSocialLogin(true);
        final pushToken = await localDataSource.getPushToken();
        await apiHelper.post(
            ApiConstants.saveNotificationToken,
            HashMap.from({
              "token": pushToken,
              "type": Platform.isAndroid ? "android" : "ios"
            }));
        return const Right("Successfully login");
      });
    } catch (e) {
      print('google sign in error $e');
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, String>> twitterLogin() async {
    // final TwitterLoginResult result = await _twitterLogin.authorize();
    // if(result.status==TwitterLoginStatus.loggedIn) return Right(result.session.token);
    // else if(result.status==TwitterLoginStatus.cancelledByUser)return Left(ServerFailure("Cancelled by the user"));
    // else return Left(ServerFailure(result.errorMessage));
  }

  @override
  Future<Either<Failure, String>> resetPassword(String email) async {
    HashMap<String, dynamic> map = HashMap()..addAll({"email": email});
    var response = await apiHelper.post(ApiConstants.resetPassword, map);
    return response.fold((l) => left(l), (r) => right("hello"));
  }
}
