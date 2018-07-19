import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/ui/PlannerDateTileBuilder.dart';
import 'package:mobileoffice/ui/PlannerNextMonthTileBuilder.dart';
import 'package:mobileoffice/ui/ProgressButton.dart';

import '../Calendarro.dart';

class PlannerView extends StatelessWidget {
  Calendarro calendarro;
  Calendarro nextMonthCalendarro;

  var nextMonthCalendarroStateKey = GlobalKey<CalendarroState>();

  @override
  Widget build(BuildContext context) {
    calendarro = Calendarro(
      startDate: DateUtils.getFirstDayOfCurrentMonth(),
      endDate: DateUtils.getLastDayOfCurrentMonth(),
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: new PlannerDateTileBuilder(),
    );

    buildNextMonthCalendar();

    var monthsPageView = PageView.builder(
        itemBuilder: (context, position) {
          if (position == 0) {
            return buildCurrentMonthPlanner();
          } else {
            return buildNextMonthPlanner();
          }
        },
        itemCount: 2,
        controller: new PageController(),
        onPageChanged: (position) {});

    return Column(children: <Widget>[
      Container(
        height: 16.0,
      ),
      Container(
        height: 400.0,
        child: monthsPageView,
      )
    ]);
  }

  void buildNextMonthCalendar() {
    var futureReservationsController = NextMonthReservationsController.get();

    var nextMonthGranted = futureReservationsController.isNextMonthGranted();
    nextMonthCalendarro = Calendarro(
      key: nextMonthCalendarroStateKey,
      startDate: DateUtils.getFirstDayOfNextMonth(),
      endDate: DateUtils.getLastDayOfNextMonth(),
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: PlannerNextMonthTileBuilder(),
      selectionMode: nextMonthGranted ? SelectionMode.SINGLE : SelectionMode.MULTI,
      selectedDates: futureReservationsController.getSelectedDates(),
    );
  }

  Column buildCurrentMonthPlanner() {
    return Column(children: <Widget>[
      Text(
          DatePrinter.printNiceMonthYear(
              DateUtils.getFirstDayOfCurrentMonth()),
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
      Container(height: 16.0),
      calendarro,
    ]);
  }

  Column buildNextMonthPlanner() {
    var columnChildren = <Widget>[
      Text(
          DatePrinter
              .printNiceMonthYear(DateUtils.getFirstDayOfNextMonth()),
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
      Container(height: 16.0),
      nextMonthCalendarro,
    ];

    if (!NextMonthReservationsController.get().isNextMonthGranted()) {
      ProgressButton progressButton = prepareSaveButton();
      columnChildren.add(progressButton);
    }

    return Column(children: columnChildren);
  }

  ProgressButton prepareSaveButton() {
    var progressButtonKey = GlobalKey<ProgressButtonState>();
    var progressButton = ProgressButton(
          key: progressButtonKey,
          onPressed: () {
            NextMonthReservationsController
                .get()
                .syncReservations(nextMonthCalendarro.selectedDates)
                .then((r) {
              nextMonthCalendarroStateKey.currentState.update();
              progressButtonKey.currentState.setProgress(false);
            }).catchError((e) {
              progressButtonKey.currentState.setProgress(false);
            });
          },
      text: Text("SAVE"),);
    return progressButton;
  }
}
