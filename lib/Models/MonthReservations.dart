import 'User2.dart';


class MonthReservations {

  List<User> users;

  MonthReservations({this.users});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    return MonthReservations(users: json['users']);
  }
}