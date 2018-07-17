import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileoffice/storage/Config.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/ui/LoginView.dart';

class AccountView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var userController = UserController.get();

    return Column(children: <Widget>[
      Container(height: 16.0,),
      Text("Account:", style: TextStyle(fontWeight: FontWeight.bold)),
      Container(height: 8.0,),
      Text("${userController.userEmail}"),
      Container(height: 32.0),
      Text("Points:", style: TextStyle(fontWeight: FontWeight.bold)),
      Container(height: 8.0),
      Text("${userController.user.points}", style: TextStyle(color: Colors.orange, fontSize: 28.0)),
      Container(height: 16.0,),
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