import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Config.dart';
import 'package:mobileoffice/Logger.dart';
import 'package:mobileoffice/ReservationsController.dart';
import 'package:mobileoffice/UserController.dart';
import 'package:mobileoffice/main.dart';

import 'package:mobileoffice/ui/LoginView.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ReservationsController.get().updateReservations().then((monthReservations) {

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
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          }).catchError((error) {
            Logger.log(error);
          });
        }
      });
    });

//    });

    return Container(
      width: 100.0,
      height: 100.0,
      child: new Center(
        child: Text("Mobile Office"),
      ),
    );
  }
}
