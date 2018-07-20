
class MonthReservations {

  List<Reservation> days;
  int spots;
  bool granted;

  MonthReservations({this.days, this.spots, this.granted});

  factory MonthReservations.fromJson(Map<String, dynamic> json) {
    var spots = json['spots'] as int;
    var granted = json['granted'] as bool;
    var reservationsMap = json['days'] as List<dynamic>;
    var reservations = reservationsMap.map((entry) {
      return Reservation.fromJson(entry);
    });

    return MonthReservations(
        days: reservations.toList(),
        spots: spots,
    granted: granted);
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