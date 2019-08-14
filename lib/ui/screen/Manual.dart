import 'package:flutter/material.dart';

class Manual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Align(
                  child: Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close,
                              size: 24,
                              color: Colors.black)
                      )
                  ),
                  alignment: FractionalOffset(0.95, 0.0),
                ),
                Text(
                  "Manual\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange, fontSize: 22.0),
                ),
                Text(
                  "1\n "
                  "Parking app is dedicated only to employees from Katowice. If you wish to have a reservation as a guest, please contact Beata Strzałkowska."
                  "\n\n2\n"
                  "Each parking reservation costs 0.2 point once a day gets fully booked. If it was not full, the points are not counted ;)"
                  "\n\n3\n"
                  "Releasing a reservation won't give back points for sure. Your space must be taken by another collegue if the parking was full!"
                  "\n\n4\n"
                  "Plan your next month reservations in advance from Planner. On 28th of current month, system will grant places according to employees demand and their point count."
                  "\n\n5\n"
                  "When a person release it's place, you will get notification if you were subscribing that day. But be quick as who clicks first, gets it! ",
                  textAlign: TextAlign.center,
                )
              ],
            )));
  }
}
