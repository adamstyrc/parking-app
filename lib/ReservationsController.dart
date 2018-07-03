import 'package:mobileoffice/Models/MonthReservations.dart';
import 'package:mobileoffice/WebService.dart';
import 'dart:async';

class ReservationsController {

  MonthReservations currentMonthReservations;
  WebService webService = WebService();

  Future<MonthReservations> updateReservations() async {
    currentMonthReservations = await webService.getParkingMonth(getCurrentYearMonth());
    return currentMonthReservations;
  }

  int getCurrentMonth() {
    return DateTime.now().month;
  }

  String getCurrentYearMonth() {
    var now = DateTime.now();
    if (now.month >= 10) {
      return now.year.toString() + "-" + now.month.toString();
    } else {
      return now.year.toString() + "-0" + now.month.toString();
    }
  }
}