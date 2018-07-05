import 'package:flutter/material.dart';
import '../Calendarro.dart';
import 'package:mobileoffice/ui/CircleView.dart';
import 'package:mobileoffice/ReservationsController.dart';

class PlannerDayTileView extends StatefulWidget {
  DateTime date;
  CalendarroState calendarro;

  PlannerDayTileView({this.date, this.calendarro});

  @override
  State<PlannerDayTileView> createState() {
    return new PlannerDayTileState(date: date);
  }
}

class PlannerDayTileState extends State<PlannerDayTileView> {
  DateTime date;
  CalendarroState calendarro;
  ReservationsController reservationsController = ReservationsController.get();

  PlannerDayTileState({
    this.date,
    this.calendarro,
  });

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    bool isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    var textColor = isWeekend ? Colors.grey : Colors.black;

    var today = DateTime.now();
    bool isToday = today.day == date.day &&
        today.month == date.month &&
        today.year == date.year;

    calendarro = Calendarro.of(context);
//    bool isSelected = calendarro.selectedDate.day == date.day;
    var reservationsForDay = reservationsController.getReservationsForDay(date.day);
    var reservedByMe = reservationsForDay != null && reservationsForDay.isNotEmpty;
//    bool isSelected = date.day % 5 > 1 && !isWeekend;

    BoxDecoration boxDecoration;
    if (reservedByMe && !isWeekend) {
      boxDecoration =
          new BoxDecoration(color: Colors.blue, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = new BoxDecoration(
          border: new Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle);
    }

    var stackChildren = <Widget>[];
    stackChildren.add(new Center(
        child: new Text(
      "${date.day}",
      textAlign: TextAlign.center,
      style: new TextStyle(color: textColor),
    )));

    if (!isWeekend) {
      var fullyReserved = reservationsController.isDayFullyReserved(date.day);
      stackChildren.add(buildSignaturesRow(fullyReserved));
    }

    return new Expanded(
        child: new GestureDetector(
      child: new Container(
          height: 40.0,
          decoration: boxDecoration,
          child: new Stack(children: stackChildren)),
      onTap: handleTap,
    ));
  }

  Container buildSignaturesRow(bool occupied) {
    var rowChildren = <Widget>[];

    if (occupied) {
      rowChildren.add(new CircleView(color: Colors.red, radius: 2.0));
    }
    return new Container(
      child: new Row(
        children: rowChildren,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(
        top: 40 * .70,
      ),
    );
  }

  void handleTap() {
    calendarro.setSelectedDate(date);
    calendarro.setCurrentDate(date);
  }
}
