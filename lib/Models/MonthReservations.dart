import 'User2.dart';
import 'dart:collection';

class MonthReservations {

  List<User> users;
  List<Reservation> reservations;
  int spots;

  MonthReservations({this.users, this.reservations, this.spots});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var users = json['users'] as List<dynamic>;


    var reservations2 = json['reservations'] as List<dynamic>;
    var list = reservations2;
    var r4 = list.map((entry) {
      return Reservation.fromJson(entry);
    });

    var reservations = List<Reservation>();
    var reservationReservations = List<String>();
    reservationReservations.add("aa");
    reservations.add(Reservation(day: 1, reservations: reservationReservations));
    return MonthReservations(
        users: users.cast<User>(),
//        reservations: reservations.map((json) => Reservation.fromJson(json)),
        reservations: r4.toList(),
//        reservations: reservations.map((json) => Reservation(json['day'], json['reservations'])),
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