import 'dart:async';

import 'package:flutter/material.dart';

class Calendarro extends StatefulWidget {

  @override
  CalendarroState createState() => new CalendarroState();

}

class CalendarroState extends State<Calendarro> {
  @override
  Widget build(BuildContext context) {
    return new PageView.builder(
      itemBuilder: (context, position) => new CalendarPage(),
      itemCount: 10,
    );
  }
}

class CalendarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
//      child: new GridView.count(
//        primary: false,
//        padding: const EdgeInsets.all(20.0),
//        crossAxisSpacing: 10.0,
//        crossAxisCount: 2,
//        children: <Widget>[
//          const Text('He\'d have you all unravel at the'),
//          const Text('Heed not the rabble'),
//          const Text('Sound of screams but the'),
//          const Text('Who scream'),
//          const Text('Revolution is coming...'),
//          const Text('Revolution, they...'),
//        ],
//      )

        child: Column(
            children: buildRows()
        )
      );
  }

  List<Widget> buildRows() {
    List<Widget> rows = [];
    rows.add(new CalendarDayLabelsView());

    for (var i = 0; i < 2; i++) {
      rows.add(buildCalendarRow());
    }

    return rows;
  }

  Widget buildCalendarRow() {
    return new Row(
      children: <Widget>[
        CalendarDayItem(),
        CalendarDayItem(),
        CalendarDayItem(),
        CalendarDayItem(),
        CalendarDayItem(),
        CalendarDayItem(),
        CalendarDayItem()
      ],
    );
  }

//    new GridView.builder(gridDelegate: null, itemBuilder: null)
//    new Row(
//      children: <Widget>[new Expanded(
//          child: new Text("Sun", textAlign: TextAlign.center)
//      )]
//    )
//    ]);


}

class CalendarDayItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: new Text("10", textAlign: TextAlign.center)
    );
  }
}

class CalendarDayLabelsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Expanded(
              child: new Text("Mon", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Tue", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Wed", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Thu", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Fri", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Sat", textAlign: TextAlign.center)
          ),
          new Expanded(
              child: new Text("Sun", textAlign: TextAlign.center)
          ),
        ],
      );
  }
}
