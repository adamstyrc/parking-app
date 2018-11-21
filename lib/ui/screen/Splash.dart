import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/screen/Dashboard.dart';
import 'package:mobileoffice/ui/screen/Login.dart';
import 'package:mobileoffice/exception/AuthException.dart';


class Splash extends StatelessWidget {
  Splash() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('Firebase onMessage $message');

        CurrentMonthReservationsController.get().updateReservations().then((currentMonth) {
          eventBus.fire(ReservationsUpdatedEvent());
        });

        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1500), () async {
      var userLogged = await UserController.get().isUserLogged();
      if (!userLogged) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        await UserController.get().updateUser().catchError((e) {
          if (e is AuthException) {
            UserController.get().logout().then((success) {
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Login()));
            });
          }
        });
        await UserController.get().updateUsers();
        await CurrentMonthReservationsController.get().updateReservations();
        await NextMonthReservationsController.get().updateReservations();
        UserController.get().registerPushToken();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }

//      UserController.get().isUserLogged().then((userLogged) {
//        if (!userLogged) {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(builder: (context) => LoginView()),
//          );
//        } else {
//          ReservationsController.get().updateReservations().then((_) {
//            Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(builder: (context) => Dashboard()),
//            );
//          }).catchError((error) {
//            Logger.log(error.toString());
//          });
//        }
//      });
    });

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("img/splash_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: Stack(children: <Widget>[
          Align(
              child: Theme(
                child: CircularProgressIndicator(),
                data: Theme
                    .of(context)
                    .copyWith(accentColor: Colors.orangeAccent),
              ),
              alignment: Alignment(0.0, 0.9)),
        ]));
  }
}
