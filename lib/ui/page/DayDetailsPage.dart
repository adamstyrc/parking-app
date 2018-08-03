import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/widget/ProgressButton.dart';

class DayDetailsPage extends StatefulWidget {
  DateTime date;

  DayDetailsPage({this.date});

  @override
  State createState() {
    return DayViewState(date: date);
  }
}

class DayViewState extends State<DayDetailsPage> {

  DateTime date;
  StreamSubscription reservationsUpdatedEventSubscription;

  DayViewState({this.date});

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

    bool pastDay = DateUtils.isSpecialPastDay(date);

    bool dayFullyReserved = reservationsController.isDayFullyReserved(date.day);
    bool dayReservedByMe =
        reservationsController.isMineReservationInDay(date.day);
    if (dayReservedByMe) {
      var dropProgressButton = GlobalKey<ProgressButtonState>();
      return new Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(18.0),
              child: new Text("Your space is waiting for you.")),
          Image(
            image: new AssetImage("img/parking_reserved.jpg"),
            height: 230.0,
          ),
          Container(height: 16.0),
          ProgressButton(
            key: dropProgressButton,
            onPressed: pastDay ? null : () {
              CurrentMonthReservationsController.get().dropReservation(date).then((_) {
                dropProgressButton.currentState.setProgress(false);
                setState(() {});
              }).catchError((e) {dropProgressButton.currentState.setProgress(false);});
            }, text: Text("DROP"),
          )
        ],
      );
    } else {
      if (dayFullyReserved) {
        return Column(
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.all(18.0),
                child: new Text("We are fully booked, sir, sorry.")),
            Image(
              image: new AssetImage("img/parking_full.png"),
              width: 180.0,
            )
          ],
        );
      } else {
        var radius = Radius.circular(8.0);
        var freeSpacesCount = reservationsController.getFreeSpacesCountForDay(date.day);

        var bookProgressButtonKey = GlobalKey<ProgressButtonState>();
        return Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(18.0),
                child: new Text("Seems you can still fit in.")),
            Container(
                width: 220.0,
                height: 230.0,
                decoration: new ShapeDecoration(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(radius),
                        side: new BorderSide(color: Colors.lightBlue, width: 3.0))),
                child: Stack(children: <Widget>[
                  Align(
                      alignment: FractionalOffset(0.5, 0.1),
                      child: Text(
                        "PARKING",
                        style: TextStyle(color: Colors.blue, fontSize: 45.0),
                        textAlign: TextAlign.center,
                      )),
                  Align(
                    alignment: FractionalOffset(0.85, 0.9),
                    child: Row(children: <Widget>[
                      Text("$freeSpacesCount", style: TextStyle(color: Colors.green, fontSize: 100.0, fontWeight: FontWeight.bold)),
                      Text("FREE", style: TextStyle(color: Colors.green, fontSize: 27.0))
                    ], mainAxisSize: MainAxisSize.min),
                  )
                ])
            ),
            Container(height: 16.0),
            ProgressButton(
              key: bookProgressButtonKey,
              onPressed: pastDay ? null : () {
                CurrentMonthReservationsController.get().makeReservation(date).then((_) {
                  bookProgressButtonKey.currentState.setProgress(false);
                }).catchError((e) {
                  bookProgressButtonKey.currentState.setProgress(false);
                });
              },
              text: Text("BOOK"),
            )
          ],
        );
      }
    }
  }
}
