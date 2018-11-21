import 'dart:async';

import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/page/DayDetailsPage.dart';
import 'package:mobileoffice/ui/widget/DateTileView.dart';
import 'package:calendarro/calendarro.dart';


class DaysPage extends StatefulWidget {
  @override
  State createState() {
    return DaysViewState();
  }
}

class DaysViewState extends State<DaysPage> {
  final calendarroStateKey = GlobalKey<CalendarroState>();

  Calendarro calendarro;
  PageView pageView;
  StreamSubscription dayClickedEventSubscription;

  @override
  void initState() {
    dayClickedEventSubscription =
        eventBus.on<DayClickedEvent>().listen((event) {
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
      startDate = DateUtils.addDaysToDate(startDate, 8 - startDate.weekday);
//      startDate = startDate.add(Duration(days: 8 - startDate.weekday));
    }
    var today = DateTime.now();

    calendarro = Calendarro(
      key: calendarroStateKey,
      startDate: startDate,
      endDate: endDate,
      displayMode: DisplayMode.WEEKS,
      dayTileBuilder: DaysViewTileBuilder(),
      selectedDate: today,
    );

    var lastPosition = calendarro.getPositionOfDate(endDate);
    var todayPosition = calendarro.getPositionOfDate(today);
    pageView = new PageView.builder(
        itemBuilder: (context, position) => buildDayView(position),
        itemCount: lastPosition + 1,
        controller: new PageController(initialPage: todayPosition),
        onPageChanged: (position) {
          DateTime selectedDate = getDateFromPosition(position);

          calendarroStateKey.currentState.setSelectedDate(selectedDate);
          calendarroStateKey.currentState.setCurrentDate(selectedDate);
        });

    return new Column(children: <Widget>[
      new Material(child: calendarro, elevation: 4.0, color: Colors.orange),
      new Container(height: 400.0, child: pageView)
    ]);
  }

  DateTime getDateFromPosition(int position) {
    var nextDay = (calendarro.startDate.weekday - 1 + position);
    var nextDateWeekday = nextDay % 5;
    var nextDateWeek = (nextDay / 5).floor();

    var weekdayDifference = nextDateWeekday + 1 - calendarro.startDate.weekday;
    var selectedDate = DateUtils.addDaysToDate(calendarro.startDate, nextDateWeek * 7 + weekdayDifference);
    return selectedDate;
  }

  Widget buildDayView(int position) {
    DateTime currentSelectedDate = getDateFromPosition(position);
    return DayDetailsPage(date: currentSelectedDate);
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
  Widget build(BuildContext context, DateTime tileDate, DateTimeCallback onTap) {
    calendarro = Calendarro.of(context);
    return new DateTileView(date: tileDate, calendarro: calendarro);
  }
}
