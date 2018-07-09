import 'User2.dart';

class MonthReservations {

  List<Reservation> reservations;
  int spots;

  MonthReservations({this.reservations, this.spots});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var reservationsMap = json['reservations'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return Reservation.fromJson(entry);
    });

    return MonthReservations(
        reservations: reservations.toList(),
        spots: 2);
  }
}

class Reservation {
  int day;
  List<String> reservations;

  Reservation({this.day, this.reservations});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    var reservations = json['reservations'] as List<dynamic>;
    return Reservation(day: json['day'], reservations: reservations.cast<String>());
  }
}