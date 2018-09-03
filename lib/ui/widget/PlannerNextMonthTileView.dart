
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/ui/DateTileDecorator.dart';
import 'package:mobileoffice/ui/ReservationChangeDialog.dart';
import 'package:calendarro/calendarro.dart';

class PlannerNextMonthTileView extends StatefulWidget {
  DateTime date;

  PlannerNextMonthTileView({this.date});

  @override
  State<PlannerNextMonthTileView> createState() {
    return new PlannerNextMonthTileViewState(date: date);
  }
}

class PlannerNextMonthTileViewState extends State<PlannerNextMonthTileView> {
  DateTime date;
  CalendarroState calendarro;

  NextMonthReservationsController nextMonthReservationsController = NextMonthReservationsController.get();

  PlannerNextMonthTileViewState({
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    calendarro = Calendarro.of(context);

    bool isDayOff = nextMonthReservationsController.isDayOff(date);
    var textColor = isDayOff ? Colors.grey : Colors.black;

    BoxDecoration boxDecoration = prepareTileDecoration();

    var stackChildren = <Widget>[];
    stackChildren.add(new Center(
        child: new Text(
          "${date.day}",
          textAlign: TextAlign.center,
          style: new TextStyle(color: textColor),
        )));

    var tileContent = Container(
        height: 40.0,
        decoration: boxDecoration,
        child: new Stack(children: stackChildren));

    if (!isDayOff) {
      return Expanded(
          child: new GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: tileContent,
            onTap: handleTap,
          ));
    } else {
      return Expanded(child: tileContent);
    }
  }

  BoxDecoration prepareTileDecoration() {
    if (nextMonthReservationsController.isNextMonthGranted()) {
      var reservedByMe = nextMonthReservationsController.isMineReservationInDay(
          date.day);

      if (reservedByMe) {
        return DateTileDecorator.BLUE_CIRCLE;
      } else {
        return null;
      }
    } else {
      if (calendarro.isDateSelected(date)) {
        return DateTileDecorator.LIGHTBLUE_CIRCLE;
      } else {
        return null;
      }
    }
  }

  void handleTap() async {
    print("tap: " + date.toString());

    if (!DateUtils.isWeekend(date)) {
      if (nextMonthReservationsController.isNextMonthGranted()) {
        var dialog = ReservationChangeDialog().prepareReservationChangeDialog(
            context, date);
        showDialog(context: context, builder: (_) => dialog);
      } else {
        calendarro.widget.toggleDate(date);
      }
    }
  }
}
