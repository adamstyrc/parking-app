import 'package:flutter/material.dart';
import 'package:mobileoffice/Calendarro.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/NextMonthReservationsController.dart';
import 'package:mobileoffice/ui/widget/ProgressButton.dart';
import 'package:mobileoffice/ui/PlannerNextMonthTileBuilder.dart';

class NextMonthPlannerPage extends StatelessWidget {

  Calendarro nextMonthCalendarro;
  var nextMonthCalendarroStateKey = GlobalKey<CalendarroState>();

  @override
  Widget build(BuildContext context) {
    buildNextMonthCalendar();

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