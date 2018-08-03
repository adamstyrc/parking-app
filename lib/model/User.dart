class User {
  double points;

  User({this.points});

  factory User.fromJson(Map<String, dynamic> json) {
    var points = json['points'] as double;
    return User(
      points: points,
    );
  }
}