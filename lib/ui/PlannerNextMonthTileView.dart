
import 'package:flutter/material.dart';
import 'package:mobileoffice/Calendarro.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';

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

  PlannerNextMonthTileViewState({
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
    var textColor = isWeekend ? Colors.grey : Colors.black;

    calendarro = Calendarro.of(context);

    BoxDecoration boxDecoration;
    if (calendarro.isDateSelected(date)) {
      boxDecoration =
      new BoxDecoration(color: Colors.blue, shape: BoxShape.circle);
    }

    var stackChildren = <Widget>[];
    stackChildren.add(new Center(
        child: new Text(
          "${date.day}",
          textAlign: TextAlign.center,
          style: new TextStyle(color: textColor),
        )));

    return new Expanded(
        child: new GestureDetector(
          child: new Container(
              height: 40.0,
              decoration: boxDecoration,
              child: new Stack(children: stackChildren)),
          onTap: handleTap,
        ));
  }

  void handleTap() async {
    print("tap: " + date.toString());
    calendarro.widget.toggleDate(date);
//    calendarro.selectedDate
  }
}
