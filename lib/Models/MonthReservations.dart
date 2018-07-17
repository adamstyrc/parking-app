import 'User2.dart';

class MonthReservations {

  List<Reservation> days;
  int spots;

  MonthReservations({this.days, this.spots});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var reservationsMap = json['days'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return Reservation.fromJson(entry);
    });

    return MonthReservations(
        days: reservations.toList(),
        spots: 2);
  }
}

class Reservation {
  int day;
  List<String> booked;
  List<String> followed;
  List<String> granted;

  Reservation({this.day, this.booked, this.followed, this.granted});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    var booked = json['booked'] as List<dynamic>;
    var followed = json['followed'] as List<dynamic>;
    var granted = json['granted'] as List<dynamic>;
    return Reservation(day: json['day'], booked: booked.cast<String>(), granted: granted.cast<String>(), followed: followed.cast<String>());
  }
}