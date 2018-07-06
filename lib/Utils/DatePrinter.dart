
class DatePrinter {

  static String printServerDate(DateTime date) {
    return "${date.year}-${print2Digits(date.month)}-${print2Digits(date.day)}";
  }

  static String printServerYearMonth(DateTime date) {
    return "${date.year}-${print2Digits(date.month)}";
  }

  static String print2Digits(int number) {
    if (number >= 10) {
      return number.toString();
    } else {
      return "0${number.toString()}";
    }
  }
}