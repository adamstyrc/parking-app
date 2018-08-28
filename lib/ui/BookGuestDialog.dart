import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';

class BookGuestDialog {

  AlertDialog prepareBookGuestDialog(BuildContext context, DateTime date) {
    final guestNameTFController = TextEditingController(text: "");
    return AlertDialog(
//      title: Text("Add a guest"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("After 9 am you can add your guest such as English teacher, when the parking has some space left. Type below who is your guest:"),
          TextField(controller: guestNameTFController,
              decoration: InputDecoration(
                hintText: 'guest name',
              ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("ADD"),
          onPressed: () {
            var guestName = guestNameTFController.text.trim();
            onAddGuestConfirmed(context, date, guestName);
          },
        ),
      ],
    );
  }

  void onAddGuestConfirmed(BuildContext context, DateTime date, String guestName) async {
    CurrentMonthReservationsController.get().addGuestReservation(date, guestName).then((_) {
      Navigator.of(context).pop();
//      setState(() {});
    }).catchError((e) {
      Navigator.of(context).pop();
    });
  }
}