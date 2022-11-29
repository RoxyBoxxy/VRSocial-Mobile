import 'dart:convert';

import 'package:colibri/features/authentication/data/models/login_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  // final storage;
  // LocalDataSource(this.storage);

  saveUserData(LoginResponse model);

  setSocialLogin(bool isLoginBySocial);

  Future<bool> didSocialLoggedIn();

  Future<bool> isUserLoggedIn();

  clearData();

  Future<LoginResponse> getUserData();

  savePushToken(String token);

  Future<String> getPushToken();

  saveUserAuthentication(UserAuth auth);

  Future<UserAuth> getUserAuth();
}

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  final Dio dio;
  final SharedPreferences storage;

  LocalDataSourceImpl(this.dio, this.storage) : super();
  @override
  Future<bool> isUserLoggedIn() async => await storage.containsKey("user");

  @override
  saveUserData(LoginResponse model) async {
    await storage.setString("user", jsonEncode(model));
    await saveUserAuthentication(model.auth);
  }

  @override
  clearData() async {
    storage.clear();
  }

  @override
  Future<LoginResponse> getUserData() async {
    if (!await isUserLoggedIn()) return null;
    return LoginResponse.fromJson(jsonDecode(await storage.getString('user')));
  }

  @override
  savePushToken(String token) async {
    await storage.setString("push_token", token);
  }

  @override
  Future<String> getPushToken() async => await storage.getString("push_token");

  @override
  Future<UserAuth> getUserAuth() async {
    if (storage.containsKey('auth'))
      return await UserAuth.fromJson(jsonDecode(storage.getString("auth")));
    else if (storage.containsKey('user'))
      return LoginResponse.fromJson(jsonDecode(storage.getString('user'))).auth;
    return null;
  }

  @override
  saveUserAuthentication(UserAuth auth) async {
    await storage.setString("auth", jsonEncode(auth));
  }

  @override
  setSocialLogin(bool isLoginBySocial) async {
    await storage.setBool("social", isLoginBySocial);
  }

  @override
  Future<bool> didSocialLoggedIn() async => await storage.getBool("social");
}
