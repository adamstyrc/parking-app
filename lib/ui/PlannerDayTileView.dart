import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/UserController.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
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
  void initState() {}

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
    var reservationsForDay =
        reservationsController.getReservationsForDay(date.day);
    var reservedByMe =
        reservationsForDay != null && reservationsForDay.isNotEmpty;
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

  void handleTap() async {
    print("tap: " + date.toString());

    var dialog = await prepareReservationChangeDialog();
    showDialog(context: context, builder: (_) => dialog);
  }

  Future<AlertDialog> prepareReservationChangeDialog() async {
    var email = await UserController.get().getUserEmail();
    var isMineReservationInDay =
        reservationsController.isEmailReservationInDay(date.day, email);
    if (isMineReservationInDay) {
      return AlertDialog(
        title: new Text("Drop the reservation"),
        content: new Text(
            "Would you like to drop the reservation for ${DatePrinter.printPrettyDate(date)}"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              onDropReservationPressed(date);
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: new Text("Make a reservation"),
        content: new Text(
            "Would you like to make a reservation for ${DatePrinter.printPrettyDate(date)}"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              onMakeReservationPressed(date);
            },
          ),
        ],
      );
    }
  }

  void onMakeReservationPressed(DateTime date) {
    var reservationsController = ReservationsController.get();
    reservationsController.makeReservation(date).then((_) {
      Navigator.of(context).pop();
      setState(() {});
    }).catchError(() {
      Navigator.of(context).pop();
    });
  }

  void onDropReservationPressed(DateTime date) async {
    reservationsController.dropReservation(date).then((_) {
      Navigator.of(context).pop();
      setState(() {});
    }).catchError(() {
      Navigator.of(context).pop();
    });
  }
}
