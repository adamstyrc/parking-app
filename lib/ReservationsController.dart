import 'package:mobileoffice/Models/MonthReservations.dart';
import 'package:mobileoffice/WebService.dart';
import 'dart:async';

class ReservationsController {

  MonthReservations currentMonthReservations;
  WebService webService = WebService();

  //SINGLETON
  static final ReservationsController _singleton = new ReservationsController._internal();

  factory ReservationsController() {
    return _singleton;
  }

  static ReservationsController get() {
    return _singleton;
  }

  ReservationsController._internal();
  //!SINGLETON

  Future<MonthReservations> updateReservations() async {
    currentMonthReservations = await webService.getParkingMonth(getCurrentYearMonth());
    return currentMonthReservations;
  }

  List<String> getReservationsForDay(int day) {
    for (var reservation in currentMonthReservations.reservations) {
      if (reservation.day == day) {
        return reservation.reservations;
      }
    }

    return null;
  }

  bool isDayFullyReserved(int day) {
    for (var reservation  in currentMonthReservations.reservations) {
      if (reservation.day == day) {
        return reservation.reservations.length >= currentMonthReservations.spots;
      }
    }

    return false;
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