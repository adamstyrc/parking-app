import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Config.dart';
import 'package:mobileoffice/ui/LoginView.dart';

class AccountView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FlatButton(onPressed: () {
        Config.setString(ConfigKeys.ACCESS_TOKEN, "").then((success) {
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginView()));
        });
      }, child: Text("LOGOUT"))
    ]);
  }
}