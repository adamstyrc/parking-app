import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:mobileoffice/api/WebService.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/exception/AuthException.dart';
import 'package:mobileoffice/ui/screen/Dashboard.dart';
import 'package:mobileoffice/utils/Logger.dart';
import 'package:mobileoffice/utils/Utils.dart';


class Login extends StatefulWidget {

  @override
  State createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<Login> {
  FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: WebService.SERVER_ADDRESS + '/login',
      clearCookies: true,
      clearCache: true,
      withJavascript: true,
    );
  }

  @override
  void initState() {
    flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {

    });

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      Logger.log("WebView: ${state.url}");
      Uri uri = Uri.dataFromString(state.url);
      var params = uri.queryParameters;

      if (state.url.startsWith(WebService.SERVER_ADDRESS) && params.containsKey('access_token')) {
        var accessToken = params['access_token'];

        UserController.get().setAccessToken(accessToken).then((success) {
          loadDataForUser().then((_) {
            goToDashboad();
          }).catchError((e) {
            if (e is AuthException) {
              Utils.displaySnackbarText(
                  context, "Invalid login or password.");
            }
          });
        });
      }
    });
  }

  void goToDashboad() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard()));
  }

  Future loadDataForUser() async {
    await NextMonthReservationsController.get()
        .updateReservations();
    await CurrentMonthReservationsController
        .get()
        .updateReservations();
    await UserController.get().updateUser();
    await UserController.get().updateUsers();
  }

}
