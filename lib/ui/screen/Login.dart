import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileoffice/api/WebService.dart';
import 'package:mobileoffice/utils/Logger.dart';
import 'package:mobileoffice/utils/Utils.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/exception/AuthException.dart';
import 'package:mobileoffice/ui/screen/Dashboard.dart';
import 'package:mobileoffice/ui/widget/ProgressButton.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class Login extends StatefulWidget {

  @override
  State createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<Login> {
  final loginTFController = TextEditingController(text: "@vattenfall.com");
  final passwordTFController = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: WebService.SERVER_ADDRESS + '/login',
      clearCookies: true,
      clearCache: true,
      withJavascript: true,
//      appBar: new AppBar(
//        title: new Text("Vattenfall Login"),
//      ),
    );

//    return new Scaffold(
////      body: Container(
////          color: Colors.white,
////          child: Stack(
////            children: <Widget>[
////              Padding(
////                padding: EdgeInsets.all(16.0),
////                child: new Center(
////                  child: Column(
////                    crossAxisAlignment: CrossAxisAlignment.center,
////                    mainAxisSize: MainAxisSize.min,
////                    children: <Widget>[
////                      TextField(
////                        controller: loginTFController,
////                        keyboardType: TextInputType.emailAddress,
////                        decoration: InputDecoration(
////                          hintText: 'email',
////                          contentPadding:
////                              EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
////                        ),
////                      ),
////                      TextField(
////                        controller: passwordTFController,
////                        obscureText: true,
////                        keyboardType: TextInputType.text,
////                        decoration: InputDecoration(
////                          hintText: 'password',
////                          contentPadding:
////                              EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
////                        ),
////                      ),
////                      Container(height: 16.0),
////                      prepareProgressButton(context)
////                    ],
////                  ),
////                ),
////              ),
////              Container(
////                color: Colors.blue,
////                height: 100.0,
////                width: 150.0,
////              )
////            ],
////          )),
////    );
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

//    flutterWebviewPlugin.on
  }

  void goToDashboad() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard()));
  }

  @override
  void dispose() {
    loginTFController.dispose();
    passwordTFController.dispose();
//    flutterWebviewPlugin.dispose();
    super.dispose();
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

  Builder prepareProgressButton(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        var loginButtonKey = GlobalKey<ProgressButtonState>();
        return ProgressButton(
          key: loginButtonKey,
          text: Text("LOGIN"),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            login(loginButtonKey);
          },
        );
      },
    );
  }

  Future login(GlobalKey<ProgressButtonState> loginButtonKey) async {
//
//    var email = loginTFController.text.trim();
//    var password = passwordTFController.text.trim();
//
//    print("login: $email");
//
//    UserController
//        .get()
//        .login(email, password)
//        .then((_) async {
//      await NextMonthReservationsController
//          .get()
//          .updateReservations();
//      await CurrentMonthReservationsController
//          .get()
//          .updateReservations();
//      await UserController.get().updateUser();
//      await UserController.get().updateUsers();
//
//      if (loginButtonKey.currentState != null) {
//        loginButtonKey.currentState.setProgress(false);
//      }
//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (context) => Dashboard()));
//    }).catchError((e) {
//      if (loginButtonKey.currentState != null) {
//        loginButtonKey.currentState.setProgress(false);
//      }
//      if (e is AuthException) {
//        Utils.displaySnackbarText(
//            context, "Invalid login or password.");
//      }
//    });
  }
}
