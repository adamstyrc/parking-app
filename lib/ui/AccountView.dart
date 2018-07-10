import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Config.dart';
import 'package:mobileoffice/UserController.dart';
import 'package:mobileoffice/ui/LoginView.dart';

class AccountView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FlatButton(onPressed: () {
        logout(context);
      }, child: Text("LOGOUT"))
    ]);
  }

  void logout(BuildContext context) async {
    UserController.get().logout().then((success) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginView()));
    });
  }
}