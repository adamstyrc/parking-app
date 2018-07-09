import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/AccountView.dart';
import 'Service.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'Calendarro.dart';
import 'package:mobileoffice/ui/DaysView.dart';
import 'package:mobileoffice/ui/PlannerView.dart';
import 'package:mobileoffice/ui/Splash.dart';


void main() => runApp(MaterialApp(
  title: 'Flutter Demo',
  theme: new ThemeData(
    primaryColor: Colors.orange,
    accentColor: Colors.cyan[600],

  ),
  home: new Splash(),
));


//class DashboardView extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Flutter Demo',
//      theme: new ThemeData(
//        primaryColor: Colors.orange,
//        accentColor: Colors.cyan[600],
//
//      ),
//      home: new MyHomePage(title: 'Vattenfall Parking'),
//    );
//  }
//}


