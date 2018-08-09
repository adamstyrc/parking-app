import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/widget/CircleView.dart';
import 'package:calendarro/calendarro.dart';


class DateTileView extends StatefulWidget {
  DateTime date;
  CalendarroState calendarro;
  DateTileView({this.date, this.calendarro});

  @override
  State<DateTileView> createState() {
    return new DateTileState(date: date);
  }
}

class DateTileState extends State<DateTileView> {
  DateTime date;
  CalendarroState calendarro;
  StreamSubscription reservationsUpdatedEventSubscription;

  DateTileState({
    this.date,
    this.calendarro
  });

  @override
  void initState() {
    reservationsUpdatedEventSubscription = eventBus.on<ReservationsUpdatedEvent>().listen((event) {
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
    var reservationsController = CurrentMonthReservationsController.get();

    bool isDayOff = reservationsController.isDayOff(date);
    var textColor = isDayOff ? Colors.grey : Colors.black;


    bool isToday = DateUtils.isToday(date);

    calendarro = Calendarro.of(context);
    bool isSelected = calendarro.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (isSelected) {
      boxDecoration =
          new BoxDecoration(color: Colors.white, shape: BoxShape.circle);
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

    if (!isDayOff) {
      var reservationsController = CurrentMonthReservationsController.get();
      var fullyReserved = reservationsController.isDayFullyReserved(date.day);
      var reservedByMe = reservationsController.isMineReservationInDay(date.day);
      stackChildren.add(buildSignaturesRow(fullyReserved, reservedByMe));
    }

    return new Expanded(
        child: new GestureDetector(
          behavior: HitTestBehavior.translucent,
      child: new Container(
          height: 40.0,
          decoration: boxDecoration,
          child: new Stack(children: stackChildren)),
      onTap: handleTap,
    ));
  }

  Container buildSignaturesRow(bool occupied, bool reservedByMe) {
    var rowChildren = <Widget>[];

    if (occupied) {
      rowChildren.add(new CircleView(color: Colors.red, radius: 2.0));
    }

    if (reservedByMe) {
      if (rowChildren.isNotEmpty) {
        rowChildren.add(new Container(width: 1.0, height: 2.0));
      }
      rowChildren.add(new CircleView(color: Colors.blue, radius: 2.0));
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

    eventBus.fire(DayClickedEvent(date: date));

//    var webService = WebService();
//    webService.getParkingMonth().then((MonthReservations monthReservations) {
//      print(monthReservations.users);
//    });

    CurrentMonthReservationsController().updateReservations().then((monthReservations) {});
  }
}
