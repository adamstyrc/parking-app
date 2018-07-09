import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/UserController.dart';
import 'package:mobileoffice/main.dart';

import 'package:mobileoffice/ReservationsController.dart';
import 'package:mobileoffice/ui/LoginView.dart';
class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
//    ReservationsController.get().updateReservations().then((monthReservations) {

    Timer(Duration(milliseconds: 1500), () {
      var nextScreen = UserController.get().accessToken == null ? LoginView() : MyHomePage();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
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