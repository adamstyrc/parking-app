class MyUser {
  Points points;

  MyUser({this.points});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    var points = json['points'] as Map<String, dynamic>;
    return MyUser(
      points: Points.fromJson(points),
    );
  }
}

class Points {
  double current;
  int ranking;

  Points({this.current, this.ranking});

  factory Points.fromJson(Map<String, dynamic> json) {
    double current;
    int ranking;
    try {
      current = json['current'] as double;
      ranking = json['ranking'] as int;
    } catch (e) {
      current = (json['current'] as int).toDouble();
    }

    return Points(current: current, ranking: ranking);
  }
}