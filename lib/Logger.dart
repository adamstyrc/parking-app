
class Logger {

  static void log(String log) {
    String logLeftToPrint = log;

    while (logLeftToPrint.length > 200) {
      print(logLeftToPrint.substring(0, 200));
      logLeftToPrint = logLeftToPrint.substring(200, logLeftToPrint.length);
    }

    print(logLeftToPrint);
  }
}