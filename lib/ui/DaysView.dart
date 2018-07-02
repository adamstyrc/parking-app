import 'package:flutter/material.dart';
import '../Calendarro.dart';
import 'package:mobileoffice/ui/CircleView.dart';
import 'DayTileView.dart';

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
    calendarro = Calendarro.of(context);
    return new DayTileView(date: tileDate, calendarro: calendarro);
  }
}