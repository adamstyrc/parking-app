import 'dart:async';

import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/events.dart';
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
    ]);
  }
}
