import 'package:mobileoffice/Models/MonthReservations.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/api/WebService.dart';
import 'dart:async';

import 'package:mobileoffice/events.dart';

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
    eventBus.fire(ReservationsUpdatedEvent());
    return currentMonthReservations;
  }

  Future<MonthReservations> makeReservation(DateTime date) async {
    String serverDate = DatePrinter.printServerDate(date);
    await webService.postParking(serverDate);
    return await updateReservations();
  }

  Future<MonthReservations> dropReservation(DateTime date) async {
    String serverDate = DatePrinter.printServerDate(date);
    await webService.deleteParking(serverDate);
    return await updateReservations();
  }

  List<String> getReservationsForDay(int day) {
    for (var reservation in currentMonthReservations.days) {
      if (reservation.day == day) {
        return reservation.granted;
      }
    }

    return null;
  }

  int getFreeSpacesCountForDay(int day) {
    return currentMonthReservations.spots - getReservationsForDay(day).length;
  }

  bool isDayFullyReserved(int day) {
    for (var reservation  in currentMonthReservations.days) {
      if (reservation.day == day) {
        return reservation.granted.length >= currentMonthReservations.spots;
      }
    }

    return false;
  }

  bool isEmailReservationInDay(int day, String email) {
    for (var reservation  in currentMonthReservations.days) {
      if (reservation.day == day) {
        return reservation.granted.contains(email);
      }
    }

    return false;
  }

  bool isMineReservationInDay(int day) {
    return isEmailReservationInDay(day, UserController.get().userEmail);
  }

  int getCurrentMonth() {
    return DateTime.now().month;
  }

  String getCurrentYearMonth() {
    var now = DateTime.now();
    return DatePrinter.printServerYearMonth(now);
  }
}