import 'package:mobileoffice/Models/MonthReservations.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
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

  Future<MonthReservations> makeReservation(DateTime date) async {
    String serverDate = DatePrinter.printServerDate(date);
    await webService.putParking(serverDate);
    return await updateReservations();
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
    return DatePrinter.printServerYearMonth(now);
  }
}