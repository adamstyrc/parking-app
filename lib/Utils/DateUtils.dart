class DateUtils {
  static DateTime toMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static DateTime getFirstDayOfCurrentMonth() {
    var dateTime = DateTime.now();
    dateTime = getFirstDayOfMonth(dateTime.month);
    return dateTime;
  }


  static DateTime getFirstDayOfMonth(int month) {
    var dateTime = DateTime.now();
    dateTime = DateTime(dateTime.year, month, 1);
    return dateTime;
  }

  static DateTime getFirstDayOfNextMonth() {
    var dateTime = getFirstDayOfCurrentMonth();
    dateTime = dateTime.add(Duration(days: 31));
    dateTime = DateTime(dateTime.year, dateTime.month, 1);
    return dateTime;
  }

  static DateTime getLastDayOfCurrentMonth() {
    return getFirstDayOfNextMonth().subtract(Duration(days: 1));
  }
}