import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/CircleView.dart';
import 'package:mobileoffice/ui/DateTileDecorator.dart';

import '../Calendarro.dart';

class PlannerDateTileView extends StatefulWidget {
  DateTime date;
  CalendarroState calendarro;

  PlannerDateTileView({this.date, this.calendarro});

  @override
  State<PlannerDateTileView> createState() {
    return new PlannerDateTileState(date: date);
  }
}

class PlannerDateTileState extends State<PlannerDateTileView> {
  DateTime date;
  CalendarroState calendarro;
  CurrentMonthReservationsController reservationsController = CurrentMonthReservationsController.get();
  StreamSubscription reservationsUpdatedEventSubscription;

  PlannerDateTileState({
    this.date,
    this.calendarro,
  });

  @override
  void initState() {
    reservationsUpdatedEventSubscription =
        eventBus.on<ReservationsUpdatedEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    reservationsUpdatedEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calendarro = Calendarro.of(context);

    var weekend = DateUtils.isWeekend(date);
    var textColor = weekend ? Colors.grey : Colors.black;

    var stackChildren = <Widget>[];
    stackChildren.add(Center(
        child: Text(
      "${date.day}",
      textAlign: TextAlign.center,
      style: new TextStyle(color: textColor),
    )));

    if (!weekend) {
      var fullyReserved = reservationsController.isDayFullyReserved(date.day);
      stackChildren.add(buildSignaturesRow(fullyReserved));
    }

    return new Expanded(
        child: new GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: new Container(
          height: 40.0,
          decoration: prepareTileDecoration(weekend),
          child: new Stack(children: stackChildren)),
      onTap: handleTap,
    ));
  }

  BoxDecoration prepareTileDecoration(bool isWeekend) {
    var reservedByMe = reservationsController.isMineReservationInDay(date.day);
    var specialPastDay = DateUtils.isSpecialPastDay(date);
    bool isToday = DateUtils.isToday(date);

    if (isToday) {
      if (isWeekend) {
        return DateTileDecorator.ORANGE_BORDER;
      } else if (reservedByMe && specialPastDay) {
        return DateTileDecorator.GREY_CIRCLE_BORDERED;
      } else if (reservedByMe) {
        return DateTileDecorator.BLUE_CIRCLE_BORDERED;
      } else {
        return null;
      }
    } else {
      if (reservedByMe && specialPastDay) {
        return DateTileDecorator.GREY_CIRCLE;
      } else if (reservedByMe) {
        return DateTileDecorator.BLUE_CIRCLE;
      } else {
        return null;
      }
    }
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

    if (!DateUtils.isSpecialPastDay(date)) {
      var dialog = prepareReservationChangeDialog();
      showDialog(context: context, builder: (_) => dialog);
    } else {
      final snackBar = SnackBar(
        content: Text('Cannot change past bookings.'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  AlertDialog prepareReservationChangeDialog() {
    var email = UserController.get().userEmail;
    var isMineReservationInDay =
        reservationsController.isEmailReservationInDay(date.day, email);
    if (isMineReservationInDay) {
      return AlertDialog(
        title: new Text("Drop the reservation"),
        content: new Text(
            "Would you like to drop the reservation for ${DatePrinter.printNiceDate(date)}"),
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
      if (reservationsController.isDayFullyReserved(date.day)) {
        return AlertDialog(
          title: Text("Parking lot overflow"),
          content: Text(
              "Seems that ${DatePrinter.printNiceDate(date)} is under invasion and there are no free places left. Wait for notification if anything gets released."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
      return AlertDialog(
        title: new Text("Make a reservation"),
        content: new Text(
            "Would you like to make a reservation for ${DatePrinter.printNiceDate(date)}"),
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
    reservationsController.makeReservation(date).then((_) {
      Navigator.of(context).pop();
      setState(() {});
    }).catchError((e) {
      Navigator.of(context).pop();
    });
  }

  void onDropReservationPressed(DateTime date) async {
    reservationsController.dropReservation(date).then((_) {
      Navigator.of(context).pop();
      setState(() {});
    }).catchError((e) {
      Navigator.of(context).pop();
    });
  }
}
