import 'dart:async';

import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/controller/CurrentMonthController.dart';
import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/ui/DateTileDecorator.dart';
import 'package:mobileoffice/ui/widget/CircleView.dart';
import 'package:mobileoffice/utils/DatePrinter.dart';
import 'package:mobileoffice/ui/PlannerDateTileBuilder.dart';
import 'package:mobileoffice/ui/page/NextMonthPlannerPage.dart';
import 'package:calendarro/calendarro.dart';

class PlannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlannerPageState();
  }
}

class PlannerPageState extends State<PlannerPage> {
  Calendarro calendarro;
  StreamSubscription reservationsUpdatedEventSubscription;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    reservationsUpdatedEventSubscription =
        eventBus.on<ReservationsUpdatedEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    reservationsUpdatedEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calendarro = Calendarro(
      startDate: DateUtils.getFirstDayOfCurrentMonth(),
      endDate: DateUtils.getLastDayOfCurrentMonth(),
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: new PlannerDateTileBuilder(),
    );

    var monthsPageView = PageView.builder(
        itemBuilder: (context, position) {
          if (position == 0) {
            return buildCurrentMonthPlanner();
          } else {
            return NextMonthPlannerPage(pageController);
          }
        },
        itemCount: 2,
        controller: pageController,
        onPageChanged: (position) {});

    return Column(children: <Widget>[
      Container(
        height: 16.0,
      ),
      Container(
        height: 420.0,
        child: monthsPageView,
      )
    ]);
  }

  Column buildCurrentMonthPlanner() {
    final pointsCounted = CurrentMonthReservationsController.get().getPointsCountedForMonth();

    return Column(children: <Widget>[
      Stack(
        children: <Widget>[
          Align(
              alignment: FractionalOffset(0.5, 0.0),
              child: Text(
                  DatePrinter.printNiceMonthYear(
                      DateUtils.getFirstDayOfCurrentMonth()),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
          Align(
              alignment: FractionalOffset(0.95, 0.0),
              child: GestureDetector(
                  child: Image(
                    image: new AssetImage("img/arrow_right.png"),
                    height: 24.0,
                  ),
                onTap: () {
                    pageController.jumpToPage(pageController.page.toInt() + 1);
                },
              ))
        ],
      ),
      Container(height: 16.0),
      calendarro,
      Align(
        alignment: FractionalOffset(0.98, 0.0),
        child: getLegendButton(),
      ),
      Container(height: 24.0,),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child: Text("Points added: "), margin: EdgeInsets.only(bottom: 3.0),),
          Text(pointsCounted.toString(), style: TextStyle(fontSize: 24.0, color: Colors.amber))
        ],)

    ]);
  }

  Widget getLegendButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            color: Colors.orange),
        child: Text("LEGEND", style: TextStyle(fontSize: 12.0, color: Colors.white),)
      ),
      onTap: () {
        var dialog = AlertDialog(
          title: new Text("Legend"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[
                CircleView(color: Colors.red, radius: 4.0),
//                  Container(width: 12.0),
                Text("   parking full")
              ]),
              Row(children: <Widget>[
                CircleView(color: Colors.amber, radius: 4.0),
//                  Container(width: 12.0),
                Text("   points added to you")
              ]),
              Row(children: <Widget>[
                CircleView(color: Colors.blue, radius: 4.0),
//                  Container(width: 12.0),
                Text("   you have reservation")
              ]),
              Row(children: <Widget>[
                CircleView(color: DateTileDecorator.LIGHTBLUE, radius: 4.0),
//                  Container(width: 12.0),
                Text("   your demand for parking")
              ]),
              Row(children: <Widget>[
                CircleView(color: Colors.grey, radius: 4.0),
//                  Container(width: 12.0),
                Text("   your past reservation")
              ]),
            ],
//                "Would you like to drop the reservation for ${DatePrinter.printNiceDate(date)}"
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        showDialog(context: context, builder: (_) => dialog);
    });
  }
}
