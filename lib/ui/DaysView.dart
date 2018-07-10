import 'dart:async';

import 'package:flutter/material.dart';
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
    var startDate2 = DateTime.now();
    startDate2 = startDate2.subtract(Duration(days: startDate2.day - 1 ));
    if (startDate2.weekday > 5) {
      startDate2 = startDate2.add(Duration(days: 8 - startDate2.weekday));
    }
    calendarro = Calendarro(
      key: calendarroStateKey,
      startDate: startDate2,
      endDate: DateTime.now().add(new Duration(days: 30)),
      displayMode: DisplayMode.WEEKS,
      dayTileBuilder: DaysViewTileBuilder(),
    );

    pageView = new PageView.builder(
        itemBuilder: (context, position) => buildDayView(position),
        itemCount: 15,
        controller: new PageController(),
        onPageChanged: (position) {
          var nextDay = (calendarro.startDate.weekday - 1 + position);
          var nextDateWeekday = nextDay % 5;
          var nextDateWeek = (nextDay / 5).floor();

          var weekdayDifference =
              nextDateWeekday + 1 - calendarro.startDate.weekday;
          var selectedDate = calendarro.startDate
              .add(new Duration(days: (nextDateWeek * 7 + weekdayDifference)));

//          var calendarroState = Calendarro.of(context);


          calendarroStateKey.currentState.setSelectedDate(selectedDate);
          calendarroStateKey.currentState.setCurrentDate(selectedDate);
        });
    return new Column(children: <Widget>[
      new Material(child: calendarro, elevation: 4.0, color: Colors.orange),
      new Container(height: 360.0, child: pageView)
    ]);
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
