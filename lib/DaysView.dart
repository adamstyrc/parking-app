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

  DateTime tileDate;
  CalendarroState calendarro;

  @override
  Widget build(BuildContext context, DateTime tileDate) {
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


    return new Expanded(
        child: new GestureDetector(
          child: new Container(
              height: 40.0,
              decoration: boxDecoration,
              child:
                  new Stack(
        children: <Widget>[
              new Center(
                  child: new Text("${tileDate.day}",
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: textColor),
                  )
              ),
          new Container(
          child: new Text("aa"),
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(
//                top: MediaQuery.of(context).size.height * .58,
                top: 40 * .58,),
          )
              ])
          ), onTap: handleTap,
        )
    );
  }

  void handleTap() {
    calendarro.setSelectedDate(tileDate);
    calendarro.setCurrentDate(tileDate);
  }
}