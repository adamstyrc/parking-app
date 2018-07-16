
class DatePrinter {

  static String printServerDate(DateTime date) {
    return "${date.year}-${print2Digits(date.month)}-${print2Digits(date.day)}";
  }

  static String printServerYearMonth(DateTime date) {
    return "${date.year}-${print2Digits(date.month)}";
  }

  static String printPrettyDate(DateTime date) {
    return "${print2Digits(date.day)}-${print2Digits(date.month)}-${date.year}";
  }

  static String print2Digits(int number) {
    if (number >= 10) {
      return number.toString();
    } else {
      return "0${number.toString()}";
    }
  }

  static String printMonthName(DateTime date) {
    switch (date.month) {
      case 1:
        return "January";
      case 2:
        return "Febuary";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      default:
        return "December";
    }
  }

  static String printNiceMonthYear(DateTime date) {
      return "${printMonthName(date)} ${date.year}";
    }
}