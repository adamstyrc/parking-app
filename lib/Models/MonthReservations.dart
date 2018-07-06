import 'User2.dart';

class MonthReservations {

  List<User> users;
  List<Reservation> reservations;
  int spots;

  MonthReservations({this.users, this.reservations, this.spots});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var users = json['users'] as List<dynamic>;

    var reservationsMap = json['reservations'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return Reservation.fromJson(entry);
    });

    return MonthReservations(
        users: users.cast<User>(),
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