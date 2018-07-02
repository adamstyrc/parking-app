import 'dart:async';
import 'package:flutter/material.dart';
import '../Calendarro.dart';
import 'DayTileView.dart';


class PlannerView extends StatelessWidget {

  Calendarro calendarro;

  @override
  Widget build(BuildContext context) {
    var dateTimeNow = DateTime.now();
    var firstDayDate = DateTime(dateTimeNow.year, dateTimeNow.month, 1);
    var firstDayNextMonthDate = DateTime(dateTimeNow.year, dateTimeNow.month + 1, 1);
    var lastDayDate = firstDayNextMonthDate.subtract(new Duration(days: 1));

    calendarro = new Calendarro(
      startDate: firstDayDate,
      endDate: lastDayDate,
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: new DaysViewTileBuilder(),
    );

    return new Column(children: <Widget>[
    new Material(child: calendarro, elevation: 4.0, color: Colors.white),
    ]);
  }


}

class DaysViewTileBuilder extends DayTileBuilder {

  DateTime tileDate;
  CalendarroState calendarro;

  @override
  Widget build(BuildContext context, DateTime tileDate) {
    return new DayTileView(date: tileDate);
  }
}