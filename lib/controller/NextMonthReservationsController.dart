import 'dart:async';

import 'package:mobileoffice/model/MonthReservations.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/controller/UserController.dart';

class NextMonthReservationsController extends ReservationsController {

  //SINGLETON
  static NextMonthReservationsController _singleton;

  factory NextMonthReservationsController() {
    return get();
  }

  static NextMonthReservationsController get() {
    if (_singleton == null) {
      _singleton = NextMonthReservationsController._internal();
      _singleton.monthYear = getYearMonth();
    }
    return _singleton;
  }

  NextMonthReservationsController._internal();
  //!SINGLETON

  static String getYearMonth() {
    var nextMonth = DateUtils.getFirstDayOfNextMonth();
    return DatePrinter.printServerYearMonth(nextMonth);
  }

  Future<MonthReservations> syncReservations(List<DateTime> dates) async {
    await webService.postParkingNextReservations(monthYear, selectedDatesToDays(dates));
    return await updateReservations();
  }


  List<DateTime> getSelectedDates() {
    var nextMonth = DateUtils.getFirstDayOfNextMonth();
    var selectedDates = List<DateTime>();
    monthReservations.days.forEach((r) {
      if (r.booked.contains(UserController.get().userEmail)) {
        selectedDates.add(DateTime(nextMonth.year, nextMonth.month, r.day));
      }
    });

    return selectedDates;
  }

  List<int> selectedDatesToDays(List<DateTime> dateTimes) {
    var daysList = List<int>();

    dateTimes.forEach((it) {
      daysList.add(it.day);
    });

    return daysList;
  }

  bool isNextMonthGranted() => monthReservations.type == MonthType.GRANTED;

}