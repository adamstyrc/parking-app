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
    calendarro = new Calendarro(
      startDate: DateUtils.getFirstDayOfCurrentMonth(),
      endDate: DateUtils.getLastDayOfCurrentMonth(),
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: new DaysViewTileBuilder(),
    );


    return new Column(children: <Widget>[
      Container(height: 12.0,),
    new Material(child: calendarro, elevation: 4.0, color: Colors.white),
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