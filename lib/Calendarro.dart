import 'dart:async';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';

class Calendarro extends StatefulWidget {

  @override
  CalendarroState createState() => new CalendarroState(
      startDate: DateTime(2018, 4, 24),
      endDate: DateTime(2018, 5, 22),
    displayMode: DisplayMode.WEEKS
  );

}

enum DisplayMode { MONTHS, WEEKS }

class CalendarroState extends State<Calendarro> {
  CalendarroState({
    this.displayMode,
    this.startDate,
    this.endDate
  });

  DateTime startDate;
  DateTime endDate;
  DisplayMode displayMode;

  int pagesCount;

  @override
  Widget build(BuildContext context) {
    int daysRange = endDate.difference(startDate).inDays;
    pagesCount = daysRange ~/ 7 + 1;

    return new Container(
      height: 60.0,
      child: new PageView.builder(
        itemBuilder: (context, position) => buildCalendarPage(position),
        itemCount: pagesCount,
    ));
  }

  Widget buildCalendarPage(int position) {
    int startDayOffset = startDate.weekday - DateTime.monday;

    DateTime pageStartDate;
    DateTime pageEndDate;
    if (position == 0) {
      pageStartDate = startDate;
      pageEndDate = startDate.add(new Duration(days: 6 - startDayOffset));
    } else if (position == pagesCount - 1) {
      pageStartDate = startDate.add(new Duration(days: 7 * position - startDayOffset));
      pageEndDate = endDate;
    } else {
      pageStartDate = startDate.add(new Duration(days: 7 * position - startDayOffset));
      pageEndDate = startDate.add(new Duration(days: 7 * position + 6 - startDayOffset));
    }
    //DisplayMode == WEEKS

    return new CalendarPage(
        pageStartDate: pageStartDate,
        pageEndDate: pageEndDate,
        startDayOffset: startDayOffset);


  }
}

class CalendarPage extends StatelessWidget {
  CalendarPage({
    this.pageStartDate,
    this.pageEndDate,
    this.startDayOffset
});

  DateTime pageStartDate;
  DateTime pageEndDate;
  int startDayOffset;

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: buildRows()
        )
      );
  }

  List<Widget> buildRows() {
    List<Widget> rows = [];
    rows.add(new CalendarDayLabelsView());

    rows.add(
      new Row(children: buildCalendarItems())
    );

    return rows;
  }

  List<Widget> buildCalendarItems() {
    List<Widget> items = [];

    DateTime currentDate = pageStartDate;
    for (int i = 0; i < 7; i++) {
      if (i + 1 >= pageStartDate.weekday && i + 1 <= pageEndDate.weekday) {

        items.add(CalendarDayItem(date: currentDate));
        currentDate = currentDate.add(new Duration(days: 1));
      } else {
        items.add(new Expanded(child: new Text(""),));
      }
    }

    return items;
  }

  Widget buildCalendarItem(DateTime date) {
    return new CalendarDayItem(date: date);
  }
}

class CalendarDayItem extends StatelessWidget {
  CalendarDayItem({this.date});

  DateTime date;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    bool isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    var textColor = isWeekend ? Colors.grey : Colors.black;

    var today = DateTime.now();
    bool isToday = today.day == date.day && today.month == date.month && today.year == date.year;
    BoxDecoration boxDecoration;
    if (isToday) {
      boxDecoration = new BoxDecoration(border: new Border.all(
        color: Colors.white,
        width: 1.0,
      ),
          shape: BoxShape.circle);
    } else if (date.day == 28){
      boxDecoration = new BoxDecoration(color: Colors.white, shape: BoxShape.circle);
    }


    return new Expanded(
          child: new Container(
            height: 40.0,
            decoration: boxDecoration,
            child: new Center(
                child: new Text("${date.day}",
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: textColor),
                )
            )
          )
    );
  }
}

class CalendarDayLabelsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Expanded(
              child: new Text("Mon", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Tue", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Wed", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Thu", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Fri", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Sat", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Sun", textAlign: TextAlign.center)
          ),
        ],
      );
  }
}
