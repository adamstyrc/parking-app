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
            var selectedDate = calendarro.startDate.add(new Duration(days: position));
            calendarro.setSelectedDate(selectedDate);
            calendarro.setCurrentDate(selectedDate);
//            calendarro.state.pageView.controller.nextPage(duration: new Duration(milliseconds: 400),
//            curve: new ElasticInCurve());
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