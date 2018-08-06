class User {
  Points points;

  User({this.points});

  factory User.fromJson(Map<String, dynamic> json) {
    var points = json['points'] as Map<String, dynamic>;
    return User(
      points: Points.fromJson(points),
    );
  }
}

class Points {
  double current;

  Points({this.current});

  factory Points.fromJson(Map<String, dynamic> json) {
    double current;
    try {
      current = json['current'] as double;
    } catch (e) {
      current = (json['current'] as int).toDouble();
    }

    return Points(current: current);
  }
}