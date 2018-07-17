import 'dart:async';

import 'package:mobileoffice/Models/MonthReservations.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/api/WebService.dart';

class FutureReservationsController {

  MonthReservations nextMonthReservations;
  WebService webService = WebService();

  //SINGLETON
  static final FutureReservationsController _singleton = new FutureReservationsController._internal();

  factory FutureReservationsController() {
    return _singleton;
  }

  static FutureReservationsController get() {
    return _singleton;
  }

  FutureReservationsController._internal();
//!SINGLETON

  Future<MonthReservations> updateReservations() async {
    nextMonthReservations = await webService.getParkingMonth(getYearMonth());
    return nextMonthReservations;
  }

  Future<MonthReservations> syncReservations(List<DateTime> dates) async {
    await webService.postParkingNextReservations(getYearMonth(), selectedDatesToDays(dates));
    return await updateReservations();
  }

  String getYearMonth() {
    var nextMonth = DateUtils.getFirstDayOfNextMonth();
    return DatePrinter.printServerYearMonth(nextMonth);
  }

  List<DateTime> getSelectedDates() {
    var nextMonth = DateUtils.getFirstDayOfNextMonth();
    var selectedDates = List<DateTime>();
    nextMonthReservations.days.forEach((r) {
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
}