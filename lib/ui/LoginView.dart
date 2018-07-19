import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/FutureReservationsController.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/main.dart';
import 'package:mobileoffice/ui/Dashboard.dart';
import 'package:mobileoffice/ui/ProgressButton.dart';

class LoginView extends StatefulWidget {
  @override
  State createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {

//  final loginTFController = TextEditingController(text: "adam.styrc@vattenfall.com");
//  final passwordTFController = TextEditingController(text: "password");
  final loginTFController = TextEditingController(text: "@vattenfall.com");
  final passwordTFController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loginButtonKey = GlobalKey<ProgressButtonState>();
    return new Scaffold(
      body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: new Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: loginTFController,
                    keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'email',
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                        ),
                      ),
                      TextField(
                        controller: passwordTFController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'password',
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                        ),
                      ),
                      Container(height: 16.0),
                      ProgressButton(
                        key: loginButtonKey,
                        text: Text("LOGIN"),
                        onPressed: () {
                          var email = loginTFController.text.trim();
                          var password = passwordTFController.text.trim();

                          print("login: $email");

                          UserController.get().login(email, password).then((_) async {
                            await FutureReservationsController.get().updateReservations();
                            await CurrentMonthReservationsController.get().updateReservations();
                            await UserController.get().updateUser();

                            loginButtonKey.currentState.setProgress(false);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
                          }).catchError((e) {
                            loginButtonKey.currentState.setProgress(false);
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),

              Container(color: Colors.blue, height: 100.0, width: 150.0,)
            ],
          )),
    );
  }

  @override
  void dispose() {
    loginTFController.dispose();
    passwordTFController.dispose();
    super.dispose();
  }
}
