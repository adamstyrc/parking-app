import 'package:flutter/material.dart';
import 'Calendarro.dart';
import 'CircleView.dart';
import 'ui/DayTileView.dart';

class DaysView extends StatelessWidget {

  Calendarro calendarro;

  @override
  Widget build(BuildContext context) {
    calendarro = new Calendarro(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(new Duration(days: 30)),
      displayMode: DisplayMode.WEEKS,
      dayTileBuilder: DaysViewTileBuilder(),
    );

    return new Column(children: <Widget>[
      new Material(child: calendarro, elevation: 4.0, color: Colors.orange),
    new Container(
        height: 360.0,
        child: new PageView.builder(
          itemBuilder: (context, position) => buildDayView(position),
          itemCount: 15,
          controller: new PageController(),
          onPageChanged: (position)  {
            var nextDay = (calendarro.startDate.weekday - 1 + position);
            var nextDateWeekday = nextDay % 5;
            var nextDateWeek = (nextDay / 5).floor();

            var weekdayDifference = nextDateWeekday + 1 - calendarro.startDate.weekday;
            var selectedDate = calendarro.startDate.add(new Duration(days: (nextDateWeek * 7 + weekdayDifference)));

            calendarro.setSelectedDate(selectedDate);
            calendarro.setCurrentDate(selectedDate);
          }
        )
    )
    ]);
  }

  Widget buildDayView(int position) {
    return new Column(
      children: <Widget>[
        new Padding(padding: EdgeInsets.all(18.0),
            child: new Text("We are fully booked, sir, sorry.")
        ),

        Image(image: new AssetImage("img/parking_full.png"), width: 180.0,)
      ],
    );
  }


}

class DaysViewTileBuilder extends DayTileBuilder {

  DateTime tileDate;
  CalendarroState calendarro;

  @override
  Widget build(BuildContext context, DateTime tileDate) {
    return new DayTileView(date: tileDate);
    this.tileDate = tileDate;
    bool isWeekend = tileDate.weekday == DateTime.saturday || tileDate.weekday == DateTime.sunday;
    var textColor = isWeekend ? Colors.grey : Colors.black;

    var today = DateTime.now();
    bool isToday = today.day == tileDate.day && today.month == tileDate.month && today.year == tileDate.year;

    calendarro = Calendarro.of(context);

    bool isSelected = calendarro.selectedDate.day == tileDate.day;

    BoxDecoration boxDecoration;
    if (isSelected) {
      boxDecoration = new BoxDecoration(color: Colors.white, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = new BoxDecoration(border: new Border.all(
        color: Colors.white,
        width: 1.0,
      ),
          shape: BoxShape.circle);
    }

    var stackChildren = <Widget>[];
    stackChildren.add(new Center(
        child: new Text("${tileDate.day}",
          textAlign: TextAlign.center,
          style: new TextStyle(color: textColor),
        )
    ));

    if (!isWeekend) {
      stackChildren.add(buildSignaturesRow(true, true));
    }

    return new Expanded(
        child: new GestureDetector(
          child: new Container(
              height: 40.0,
              decoration: boxDecoration,
              child: new Stack(children: stackChildren)),
          onTap: handleTap,
        )
    );
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
        child: new Row(children: rowChildren,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,),
        alignment: Alignment.topCenter,
        padding: new EdgeInsets.only(
          top: 40 * .70,
        ),
      );
  }

  void handleTap() {
    calendarro.setSelectedDate(tileDate);
    calendarro.setCurrentDate(tileDate);
  }
}