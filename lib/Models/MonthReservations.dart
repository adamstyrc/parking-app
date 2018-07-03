import 'User2.dart';


class MonthReservations {

  List<User> users;
  List<Reservation> reservations;

  MonthReservations({this.users});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    return MonthReservations(users: json['users']);
  }
}

class Reservation {
  int day;
  List<String> reservations;

  Reservation({this.day, this.reservations});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(day: json['day'], reservations: json['reservations']);
  }
}