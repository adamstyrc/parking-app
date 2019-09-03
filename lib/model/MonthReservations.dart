enum MonthType {
  GRANTED,
  PLANNING,
  PAST,
  FUTURE
}

enum ReservationType {
  BOOKED,
  FOLLOWED,
  GRANTED,
  FREED
}

MonthType getMonthTypeFromString(String type) {
  var upperCaseType = type.toUpperCase();

  MonthType monthType = MonthType.values.firstWhere((MonthType e) {
    return e.toString() == "MonthType.$upperCaseType";
  }, orElse: null);
  return monthType;
}

ReservationType getReservationTypeFromString(String type) {
  var upperCaseType = type.toUpperCase();

  ReservationType monthType = ReservationType.values.firstWhere((ReservationType e) {
    return e.toString() == "ReservationType.$upperCaseType";
  }, orElse: null);
  return monthType;
}

class MonthReservations {

  List<ReservationDay> days;
  int spots ;
  MonthType type;

  MonthReservations({
    this.days,
    this.spots,
    this.type
  });

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var spots = 52;
    if (json['spots'] != null) {
      spots = json['spots'] as int;
    }
    var type = json['type'] as String;

    var monthType = getMonthTypeFromString(type.toUpperCase());
    var reservationsMap = json['days'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return ReservationDay.fromJson(entry);
    });

    return MonthReservations(
        days: reservations.toList(),
        spots: spots,
        type: monthType);
  }
}

class ReservationDay {
  int day;
  bool holiday;
  List<Reservation> reservations;

  ReservationDay({this.day, this.holiday, this.reservations});

  factory ReservationDay.fromJson(Map<String, dynamic> json) {
    var reservationsMap = json['reservations'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return Reservation.fromJson(entry);
    });
    return ReservationDay(day: json['day'], holiday: json['holiday'],
        reservations: reservations.toList());
  }

  List<String> get(ReservationType reservationType) {
    return reservations.where((r) => r.type == reservationType)
        .map((r) => r.email)
        .toList(growable: true);
  }
}

class Reservation {
  String email;
  ReservationType type;

  Reservation({this.email, this.type});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    var reservationType = getReservationTypeFromString(json['type']);
    return Reservation(email: json['email'], type: reservationType);
  }
}