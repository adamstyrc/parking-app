import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/screen/Progress.dart';
import 'package:mobileoffice/utils/DatePrinter.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';

class ReservationChangeDialog {

  AlertDialog prepareReservationChangeDialog(BuildContext context, DateTime date) {

    ReservationsController reservationsController = getReservationsController(date);

    var email = UserController.get().userName;
    var reservedByMe = reservationsController.isEmailReservationInDay(date.day, email);

    if (reservedByMe) {
      return AlertDialog(
        title: Text("Drop the reservation"),
        content: Text(
            "Would you like to drop the reservation for ${DatePrinter.printNiceDate(date)}"),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              onDropReservationPressed(context, date);
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
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
      return AlertDialog(
        title: Text("Make a reservation"),
        content: Text(
            "Would you like to make a reservation for ${DatePrinter.printNiceDate(date)}"),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              onMakeReservationPressed(context, date);
            },
          ),
        ],
      );
    }
  }

  ReservationsController getReservationsController(DateTime date) {
    ReservationsController reservationsController;
    if (DateUtils.isCurrentMonth(date)) {
      reservationsController = CurrentMonthReservationsController.get();
    } else {
      reservationsController = NextMonthReservationsController.get();
    }
    return reservationsController;
  }

  void onMakeReservationPressed(BuildContext context, DateTime date) {
    Navigator.of(context).pop();
    Navigator.of(context).push(Progress());

    getReservationsController(date).makeReservation(date).then((_) {
      Navigator.of(context).pop();
//      setState(() {});
    }).catchError((e) {
      Navigator.of(context).pop();
    });
  }

  void onDropReservationPressed(BuildContext context, DateTime date) async {
    Navigator.of(context).pop();
    Navigator.of(context).push(Progress());

    getReservationsController(date).dropReservation(date).then((_) {
      Navigator.of(context).pop();
//      setState(() {});
    }).catchError((e) {
      Navigator.of(context).pop();
    });
  }

}