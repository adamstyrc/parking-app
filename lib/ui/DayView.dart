import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/events.dart';

class DayView extends StatefulWidget {
  DateTime date;

  DayView({this.date});

  @override
  State createState() {
    return DayViewState(date: date);
  }
}

class DayViewState extends State<DayView> {
  DateTime date;

  DayViewState({this.date});

  @override
  Widget build(BuildContext context) {
    var reservationsController = ReservationsController.get();

    bool pastDay = DateUtils.isSpecialPastDay(date);

    bool dayFullyReserved = reservationsController.isDayFullyReserved(date.day);
    bool dayReservedByMe =
        reservationsController.isMineReservationInDay(date.day);
    if (dayReservedByMe) {
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
          RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("DROP"),
              onPressed: pastDay ? null : () {
                ReservationsController.get().dropReservation(date).then((_) {
                  setState(() {});
                });
              })
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

        return Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(18.0),
                child: new Text("Seems you can still fit in.")),
            Container(
                width: 200.0,
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
            RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("BOOK"),
                disabledColor: Colors.grey,
                onPressed: pastDay ? null : () {
                  ReservationsController.get().makeReservation(date).then((_) {
                    setState(() {});
                  });
                })
          ],
        );
      }
    }
  }
}
