import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/events.dart';

import '../Calendarro.dart';
import 'DayTileView.dart';

class DaysView extends StatefulWidget {

  @override
  State createState() {
    return DaysViewState();
  }

}

class DaysViewState extends State<DaysView> {

  final calendarroStateKey = GlobalKey<CalendarroState>();

  Calendarro calendarro;
  PageView pageView;
  StreamSubscription dayClickedEventSubscription;

  @override
  void initState() {
    dayClickedEventSubscription = eventBus.on().listen((event) {
      setState(() {
        var page = calendarro.getPositionOfDate(event.date);
        pageView.controller.jumpToPage(page);
      });
      print(event.date);
    });
  }
  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateUtils.getFirstDayOfCurrentMonth();
    DateTime endDate = DateUtils.getLastDayOfCurrentMonth();

    if (startDate.weekday > 5) {
      startDate = startDate.add(Duration(days: 8 - startDate.weekday));
    }
    calendarro = Calendarro(
      key: calendarroStateKey,
      startDate: startDate,
      endDate: endDate,
      displayMode: DisplayMode.WEEKS,
      dayTileBuilder: DaysViewTileBuilder(),
    );

    var lastPosition = calendarro.getPositionOfDate(endDate);
    pageView = new PageView.builder(
        itemBuilder: (context, position) => buildDayView(position),
        itemCount: lastPosition + 1,
        controller: new PageController(),
        onPageChanged: (position) {
          var nextDay = (calendarro.startDate.weekday - 1 + position);
          var nextDateWeekday = nextDay % 5;
          var nextDateWeek = (nextDay / 5).floor();

          var weekdayDifference =
              nextDateWeekday + 1 - calendarro.startDate.weekday;
          var selectedDate = calendarro.startDate
              .add(new Duration(days: (nextDateWeek * 7 + weekdayDifference)));

          calendarroStateKey.currentState.setSelectedDate(selectedDate);
          calendarroStateKey.currentState.setCurrentDate(selectedDate);
        });
    return new Column(children: <Widget>[
      new Material(child: calendarro, elevation: 4.0, color: Colors.orange),
      new Container(height: 360.0, child: pageView)
    ]);
  }

  DateTime establishStartDate() {
    var startDate = DateTime.now();
    startDate = startDate.subtract(Duration(days: startDate.day - 1 ));
    if (startDate.weekday > 5) {
      startDate = startDate.add(Duration(days: 8 - startDate.weekday));
    }
    return startDate;
  }

  DateTime establishEndDate() {
    var endDate = DateTime.now();
    endDate = DateTime(endDate.year, endDate.month + 1, 1);
    endDate.subtract(Duration(days: 1));
    return endDate;
  }

  Widget buildDayView(int position) {
    return new Column(
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.all(18.0),
            child: new Text("We are fully booked, sir, sorry. $position")),
        Image(
          image: new AssetImage("img/parking_full.png"),
          width: 180.0,
        )
      ],
    );
  }

  @override
  void dispose() {
    dayClickedEventSubscription.cancel();
    super.dispose();
  }
}

class DaysViewTileBuilder extends DayTileBuilder {
  DateTime tileDate;
  CalendarroState calendarro;

  @override
  Widget build(BuildContext context, DateTime tileDate) {
    calendarro = Calendarro.of(context);
    return new DayTileView(date: tileDate, calendarro: calendarro);
  }
}
