
import 'dart:async';

import 'package:mobileoffice/Config.dart';
import 'package:mobileoffice/Models/AccessToken.dart';
import 'package:mobileoffice/WebService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {

  String accessToken;
  WebService webService = WebService();

  //SINGLETON
  static final UserController _singleton = new UserController._internal();

  factory UserController() {
    return _singleton;
  }

  static UserController get() {
    return _singleton;
  }

  UserController._internal();
//!SINGLETON

  Future<void> login(String email, String password) async {
    AccessToken accessToken = await webService.postAuth(email, password);

    Config.setString(ConfigKeys.ACCESS_TOKEN, accessToken.access_token).then((_) {
      Config.setString(ConfigKeys.USER_EMAIL, email).then((_) {});
    });

  }

  Future<String> getAccessToken() {
    return Config.getString(ConfigKeys.ACCESS_TOKEN);
  }

  Future<String> getUserEmail() {
    return Config.getString(ConfigKeys.USER_EMAIL);
  }

  Future<bool> isUserLogged() async {
    var accessToken = await Config.getString(ConfigKeys.ACCESS_TOKEN);
    return accessToken != null && accessToken.length > 0;
  }

  Future<bool> setAccessToken(String accessToken) {
    return Config.setString(ConfigKeys.ACCESS_TOKEN, accessToken);
  }
}