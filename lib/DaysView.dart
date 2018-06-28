import 'package:flutter/material.dart';
import 'Calendarro.dart';

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

    return new Text("lalala");
  }


}

class DaysViewTileBuilder extends DayTileBuilder {

  DateTime date;
  CalendarroState calendarro;
//  int count = 0;
//  BuildContext context;

  @override
  Widget build(BuildContext context, DateTime date) {
    this.date = date;
    context = context;
    bool isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    var textColor = isWeekend ? Colors.grey : Colors.black;

    var today = DateTime.now();
    bool isToday = today.day == date.day && today.month == date.month && today.year == date.year;

//    Calendarro calendarro = context.ancestorWidgetOfExactType(Calendarro);
//    CalendarroState calendarro = context.ancestorStateOfType(TypeMatcher<CalendarroState>());
    calendarro = Calendarro.of(context) as CalendarroState;

    bool isSelected = calendarro.selectedDate.day == date.day;

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


    return new Expanded(
        child: new GestureDetector(
          child: new Container(
              height: 40.0,
              decoration: boxDecoration,
              child:
              new Center(
                  child: new Text("${date.day}",
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: textColor),
                  )
              )
          ), onTap: handleTap,
        )
    );
  }

  void handleTap() {
    calendarro.setSelectedDate(date);
    calendarro.setCurrentDate(date);
  }
}