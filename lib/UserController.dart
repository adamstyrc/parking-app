
import 'dart:async';

import 'package:mobileoffice/Models/AccessToken.dart';
import 'package:mobileoffice/WebService.dart';

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
    this.accessToken = accessToken.access_token;
  }
}