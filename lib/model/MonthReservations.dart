enum MonthType {
  GRANTED,
  PLANNING,
  PAST,
  FUTURE
}

MonthType getMonthTypeFromString(String type) {
  var upperCaseType = type.toUpperCase();

  MonthType monthType = MonthType.values.firstWhere((MonthType e) {
    return e.toString() == "MonthType.$upperCaseType";
  }, orElse: null);
  return monthType;
}

class MonthReservations {

  List<Reservation> days;
  int spots;
  MonthType type;

  MonthReservations({this.days, this.spots, this.type, });

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var spots = json['spots'] as int;
    var type = json['type'] as String;

    var monthType = getMonthTypeFromString(type.toUpperCase());
    var reservationsMap = json['days'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return Reservation.fromJson(entry);
    });


    return MonthReservations(
        days: reservations.toList(),
        spots: spots,
        type: monthType);
  }
}

class Reservation {
  int day;
  bool holiday;
  List<String> booked;
  List<String> followed;
  List<String> granted;

  Reservation({this.day, this.holiday, this.booked, this.followed, this.granted});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    var booked = json['booked'] as List<dynamic>;
    var followed = json['followed'] as List<dynamic>;
    var granted = json['granted'] as List<dynamic>;
    return Reservation(day: json['day'], holiday: json['holiday'],
        booked: booked.cast<String>(), granted: granted.cast<String>(), followed: followed.cast<String>());
  }
}