import 'package:calendarro/date_utils.dart';
import 'package:mobileoffice/controller/UserController.dart';
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/api/WebService.dart';
import 'dart:async';

import 'package:mobileoffice/events.dart';
import 'package:mobileoffice/model/MonthReservations.dart';

abstract class ReservationsController {

  String monthYear;

  MonthReservations monthReservations;
  WebService webService = WebService();

  ReservationsController({this.monthYear});

  Future<MonthReservations> updateReservations() async {
    monthReservations = await webService.getParkingMonth(monthYear);
    eventBus.fire(ReservationsUpdatedEvent());
    return monthReservations;
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
    for (var reservation in monthReservations.days) {
      if (reservation.day == day) {
        return reservation.granted;
      }
    }

    return null;
  }

  int getFreeSpacesCountForDay(int day) {
    return monthReservations.spots - getReservationsForDay(day).length;
  }

  bool isDayFullyReserved(int day) {
    for (var reservation  in monthReservations.days) {
      if (reservation.day == day) {
        return reservation.granted.length >= monthReservations.spots;
      }
    }

    return false;
  }

  bool isDayOff(DateTime date) {
    if (DateUtils.isWeekend(date)) {
      return true;
    }

    return isHoliday(date.day);
  }

  bool isHoliday(int day) {
    var reservationDay = monthReservations.days.firstWhere((currentDay) => currentDay.day == day);
    return reservationDay.holiday != null ? reservationDay.holiday : false;
  }

  bool isEmailReservationInDay(int day, String email) {
    for (var reservation  in monthReservations.days) {
      if (reservation.day == day) {
        return reservation.granted.contains(email);
      }
    }

    return false;
  }

  bool isMineReservationInDay(int day) {
    return isEmailReservationInDay(day, UserController.get().userEmail);
  }
}