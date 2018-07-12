import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Config.dart';
import 'package:mobileoffice/Logger.dart';
import 'package:mobileoffice/ReservationsController.dart';
import 'package:mobileoffice/UserController.dart';
import 'package:mobileoffice/ui/Dashboard.dart';

import 'package:mobileoffice/ui/LoginView.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1500), () {
      UserController.get().isUserLogged().then((userLogged) {
        if (!userLogged) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        } else {
          ReservationsController.get().updateReservations().then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          }).catchError((error) {
            Logger.log(error.toString());
          });
        }
      });
    });

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("img/splash_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: Align(
            child: Theme(
              child: CircularProgressIndicator(),
              data:
                  Theme.of(context).copyWith(accentColor: Colors.orangeAccent),
            ),
            alignment: Alignment(0.0, 0.9)));
  }
}
