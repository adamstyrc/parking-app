import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/Splash.dart';


void main() => runApp(MaterialApp(
  title: 'Parking Vattenfall',
  theme: new ThemeData(
    primaryColor: Colors.orange,
    accentColor: Colors.cyan[600],
  ),
  home: new Splash(),
));

