import 'package:flutter/material.dart';
import 'package:mobileoffice/main.dart';

import 'package:mobileoffice/ReservationsController.dart';
class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ReservationsController.get().updateReservations().then((monthReservations) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      

    });

    return Container(
      width: 100.0,
      height: 100.0,
      child: new Center(
        child: Text("Mobile Office"),
      ),
    );
  }
}