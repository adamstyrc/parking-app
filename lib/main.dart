import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/screen/Splash.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Parking Vattenfall',
    theme: new ThemeData(
      primaryColor: Colors.orange,
    ),
    home: new Splash(),
  ));
}

