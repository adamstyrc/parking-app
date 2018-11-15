import 'dart:async';

import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/BookGuestDialog.dart';
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
  var progressButtonKey = GlobalKey<ProgressButtonState>();

  CurrentMonthReservationsController reservationsController;
  bool pastDay;
  bool dayFullyReserved;
  bool dayReservedByMe;
  bool dayFollowedByMe;
  bool holiday;
  int freeSpacesCountForDay;

  DayViewState({this.date});

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
    reservationsController = CurrentMonthReservationsController.get();
    this.pastDay = DateUtils.isSpecialPastDay(date);

    holiday = reservationsController.isHoliday(date.day);
    dayFullyReserved = reservationsController.isDayFullyReserved(date.day);
    dayReservedByMe = reservationsController.isMineReservationInDay(date.day);
    dayFollowedByMe = reservationsController.isDayFollowedByMe(date.day);
    freeSpacesCountForDay =
        reservationsController.getFreeSpacesCountForDay(date.day);

    return LayoutBuilder(
      builder: (context, constraints) =>
          Stack(alignment: FractionalOffset(0.5, 0.0), children: <Widget>[
            Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(getDescriptionText())),
            Positioned(child: getDayImage(), top: 48.0),
            Positioned(
                top: 290.0,
                left: constraints.maxWidth - 80.0,
                child: getGuestImage()),
            Positioned(
              top: 290.0,
              child: getReserveButton(),
            ),
            Positioned(
              top: 332.0,
              child: getAddGuestButton(),
            )
          ]),
    );
  }

  String getDescriptionText() {
    if (holiday) {
      return "Enjoy your day off from work!";
    } else if (dayReservedByMe) {
      var freeSpacesCountForDayText =
          freeSpacesCountForDay > 0 ? freeSpacesCountForDay : "None";
      return "A parking space is waiting for you. $freeSpacesCountForDayText left.";
    } else if (dayFullyReserved) {
      return "We are fully booked, sir, sorry.";
    } else {
      return "Seems you can still fit in.";
    }
  }

  Widget getDayImage() {
    if (holiday) {
      return Image(image: AssetImage("img/holiday.png"), height: 230.0);
    } else if (dayReservedByMe) {
      return Image(
          image: AssetImage("img/parking_reserved.jpg"), height: 230.0);
    } else if (dayFullyReserved) {
      return Image(image: AssetImage("img/parking_full.png"), height: 230.0);
    } else {
      var radius = Radius.circular(8.0);
      return Container(
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
                Text("$freeSpacesCountForDay",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 100.0,
                        fontWeight: FontWeight.bold)),
                Text("FREE",
                    style: TextStyle(color: Colors.green, fontSize: 27.0))
              ], mainAxisSize: MainAxisSize.min),
            )
          ]));
    }
  }

  Widget getReserveButton() {
    bool buttonVisible = !holiday;
    return Opacity(
        opacity: buttonVisible ? 1.0 : 0.0,
        child: ProgressButton(
          key: progressButtonKey,
          onPressed: pastDay
              ? null
              : () {
                  onReserveButtonPressed();
                },
          text: Text(getButtonText()),
        ));
  }

  void onReserveButtonPressed() {
    if (dayReservedByMe || dayFollowedByMe) {
      CurrentMonthReservationsController.get().dropReservation(date).then((_) {
        if (progressButtonKey.currentState != null) {
          progressButtonKey.currentState.setProgress(false);
        }
        setState(() {});
      }).catchError((e) {
        if (progressButtonKey.currentState != null) {
          progressButtonKey.currentState.setProgress(false);
        }
      });
    } else {
      CurrentMonthReservationsController.get().makeReservation(date).then((_) {
        progressButtonKey.currentState.setProgress(false);
      }).catchError((e) {
        progressButtonKey.currentState.setProgress(false);
      });
    }
  }

  String getButtonText() {
    if (dayReservedByMe) {
      return "DROP";
    } else if (freeSpacesCountForDay > 0) {
      return "BOOK";
    } else if (dayFollowedByMe) {
      return "UNFOLLOW";
    } else {
      return "FOLLOW";
    }
  }

  Widget getAddGuestButton() {
    var addingGuestPossible =
        (DateUtils.isToday(date) && DateTime.now().hour >= 9) &&
            !dayFullyReserved;
    return Opacity(
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text("ADD GUEST"),
          onPressed: () {
            var dialog =
                BookGuestDialog().prepareBookGuestDialog(context, date);
            showDialog(context: context, builder: (_) => dialog);
          },
        ),
//        opacity: addingGuestPossible ? 1.0 : 0.0);
        opacity: 0.0);
  }

  Widget getGuestImage() {
    var guestsAdded = true;
    return Opacity(
//        opacity: guestsAdded ? 1.0 : 0.0,
        opacity: 1.0,
        child: GestureDetector(
            child: Image(
              image: AssetImage("img/guests.png"),
              height: 24.0,
            ),
            onTap: () {
              var reservationsForDay = reservationsController.getReservationsForDay(date.day);
              List<String> userNames = List<String>();
              reservationsForDay.forEach((email) => userNames.add(UserController.get().getUserName(email)));
//              List<String> userNames = reservationsForDay.map((r) { return UserController.get().getUserName(r); });
              var dialog = AlertDialog(
                title: Text("Guests list"),
//                content: Text("my mama"),
                content: ListView.builder(
                  // Let the ListView know how many items it needs to build
                  itemCount: reservationsForDay.length,
                  // Provide a builder function. This is where the magic happens! We'll
                  // convert each item into a Widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    final email = reservationsForDay[index];
                    var userName = userNames[index];
                    return ListTile(
                      title: Text(
//                        email,
                        "${index + 1}. $userName",
//                        style: Theme.of(context).textTheme.headline,
                      ),
                    );
                  },
                )
              );
              showDialog(context: context, builder: (_) => dialog);
            }));
  }


}
