
import 'package:mobileoffice/Utils/DatePrinter.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';

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
}