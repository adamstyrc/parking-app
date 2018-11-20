
import 'dart:async';

import 'package:mobileoffice/utils/DatePrinter.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/model/MonthReservations.dart';

class CurrentMonthReservationsController extends ReservationsController {

  //SINGLETON
  static CurrentMonthReservationsController _singleton;

  factory CurrentMonthReservationsController() {
    return get();
  }

  static CurrentMonthReservationsController get() {
    if (_singleton == null) {
      _singleton = CurrentMonthReservationsController._internal();
      _singleton.monthYear = getCurrentYearMonth();
    }
    return _singleton;
  }

  CurrentMonthReservationsController._internal();
  //!SINGLETON

  static String getCurrentYearMonth() {
    var now = DateTime.now();
    return DatePrinter.printServerYearMonth(now);
  }

  Future<MonthReservations> addGuestReservation(DateTime date, String guestName) async {
    String serverDate = DatePrinter.printServerDate(date);
    await webService.postParkingGuest(serverDate, guestName);
    return await updateReservations();
  }
}