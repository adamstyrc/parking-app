import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/ui/screen/Login.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatelessWidget {

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
      Text("${userController.user.points.current}", style: TextStyle(color: Colors.orange, fontSize: 28.0)),
      Text("which makes you no. ${userController.user.points.ranking} in the ranking."),
      Container(height: 32.0,),
      FlatButton(onPressed: checkUpdate,
        child: Text("CHECK UPDATE"),
      ),
      FlatButton(onPressed: () {
        logout(context);
      }, child: Text("LOGOUT")),

    ]);
  }


  void checkUpdate() async {
    const url = 'https://visp-parking-web-unix.azurewebsites.net';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void logout(BuildContext context) async {
    UserController.get().logout().then((success) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Login()));
    });
  }
}