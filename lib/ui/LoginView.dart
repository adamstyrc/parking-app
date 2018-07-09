import 'package:flutter/material.dart';
import 'package:mobileoffice/ReservationsController.dart';
import 'package:mobileoffice/UserController.dart';
import 'package:mobileoffice/main.dart';
import 'package:mobileoffice/ui/Dashboard.dart';

class LoginView extends StatefulWidget {
  @override
  State createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {

  final loginTFController = TextEditingController(text: "adam.styrc@vattenfall.com");
  final passwordTFController = TextEditingController(text: "password");

  @override
  Widget build(BuildContext context) {
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
                      RaisedButton(
                        onPressed: () {
                          var email = loginTFController.text.trim();
                          var password = passwordTFController.text.trim();

                          print("login: $email");

                          UserController.get().login(email, password).then((_) {
                            ReservationsController.get().updateReservations().then((_) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
                            }).catchError((Exception e) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
                            });
                          }).catchError(() {

                          });
                        },
                        color: Colors.blue,
                        child: Text("LOGIN"),
                        textColor: Colors.white,
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
