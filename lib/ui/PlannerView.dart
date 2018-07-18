import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/FutureReservationsController.dart';
import 'package:mobileoffice/ui/PlannerNextMonthTileBuilder.dart';
import 'package:mobileoffice/ui/ProgressButton.dart';
import '../Calendarro.dart';
import 'DateTileView.dart';
import 'PlannerDateTileView.dart';

class PlannerView extends StatelessWidget {
  Calendarro calendarro;
  Calendarro nextMonthCalendarro;

  var nextMonthCalendarroStateKey = GlobalKey<CalendarroState>();

  @override
  Widget build(BuildContext context) {
//    calendarro = new Calendarro(
//      startDate: DateUtils.getFirstDayOfCurrentMonth(),
//      endDate: DateUtils.getLastDayOfCurrentMonth(),
//      displayMode: DisplayMode.MONTHS,
//      dayTileBuilder: new DaysViewTileBuilder(),
//    );

    calendarro = Calendarro(
      startDate: DateUtils.getFirstDayOfCurrentMonth(),
      endDate: DateUtils.getLastDayOfCurrentMonth(),
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: new DaysViewTileBuilder(),
    );

    nextMonthCalendarro = Calendarro(
      key: nextMonthCalendarroStateKey,
      startDate: DateUtils.getFirstDayOfNextMonth(),
      endDate: DateUtils.getLastDayOfNextMonth(),
      displayMode: DisplayMode.MONTHS,
      dayTileBuilder: PlannerNextMonthTileBuilder(),
      selectionMode: SelectionMode.MULTI,
      selectedDates: FutureReservationsController.get().getSelectedDates(),
    );

    var monthsPageView = PageView.builder(
        itemBuilder: (context, position) {
          if (position == 0) {
            return Column(children: <Widget>[
              Text(
                  DatePrinter.printNiceMonthYear(
                      DateUtils.getFirstDayOfCurrentMonth()),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Container(height: 16.0),
              calendarro,
            ]);
          } else {
            var progressButtonKey = GlobalKey<ProgressButtonState>();
            return Column(children: <Widget>[
              Text(
                  DatePrinter
                      .printNiceMonthYear(DateUtils.getFirstDayOfNextMonth()),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Container(height: 16.0),
              nextMonthCalendarro,
              ProgressButton(
                  key: progressButtonKey,
                  onPressed: () {
                    FutureReservationsController
                        .get()
                        .syncReservations(nextMonthCalendarro.selectedDates)
                        .then((r) {
                      nextMonthCalendarroStateKey.currentState.update();
                      progressButtonKey.currentState.setProgress(false);
                    }).catchError((e) {
                      progressButtonKey.currentState.setProgress(false);
                    });
                  },
              text: Text("SAVE"),),
            ]);
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
}

class DaysViewTileBuilder extends DayTileBuilder {
  CalendarroState calendarro;

  DaysViewTileBuilder({this.calendarro});

  @override
  Widget build(BuildContext context, DateTime tileDate) {
    return new PlannerDateTileView(date: tileDate, calendarro: calendarro);
  }
}
