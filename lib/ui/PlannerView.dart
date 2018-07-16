import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import '../Calendarro.dart';
import 'DateTileView.dart';
import 'PlannerDateTileView.dart';

class PlannerView extends StatelessWidget {
  Calendarro calendarro;

  @override
  Widget build(BuildContext context) {
//    calendarro = new Calendarro(
//      startDate: DateUtils.getFirstDayOfCurrentMonth(),
//      endDate: DateUtils.getLastDayOfCurrentMonth(),
//      displayMode: DisplayMode.MONTHS,
//      dayTileBuilder: new DaysViewTileBuilder(),
//    );

    var monthsPageView = PageView.builder(
        itemBuilder: (context, position) {
          if (position == 0) {
            return Column(children: <Widget>[
              Text("July", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Container(height: 12.0),
              Calendarro(
                startDate: DateUtils.getFirstDayOfCurrentMonth(),
                endDate: DateUtils.getLastDayOfCurrentMonth(),
                displayMode: DisplayMode.MONTHS,
                dayTileBuilder: new DaysViewTileBuilder(),
              ),
            ]);
          } else {
            return Column(children: <Widget>[
              Text("August 2018", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Container(height: 12.0),
              Calendarro(
                startDate: DateUtils.getFirstDayOfNextMonth(),
                endDate: DateUtils.getLastDayOfNextMonth(),
                displayMode: DisplayMode.MONTHS,
                dayTileBuilder: new DaysViewTileBuilder(),
              ),

              RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("UPDATE"),
                  onPressed: () {

                  })
            ]);
          }
        },
        itemCount: 2,
        controller: new PageController(),
        onPageChanged: (position) {});

    return Column(children: <Widget>[
      Container(
        height: 16.0,
      ),
      Container(
          height: 400.0,
          child: new Material(
              child: monthsPageView, elevation: 4.0, color: Colors.white)),
    ]);
  }
}

class DaysViewTileBuilder extends DayTileBuilder {
  DateTime tileDate;
  CalendarroState calendarro;

  DaysViewTileBuilder({this.calendarro});

  @override
  Widget build(BuildContext context, DateTime tileDate) {
    return new PlannerDateTileView(date: tileDate, calendarro: calendarro);
  }
}
