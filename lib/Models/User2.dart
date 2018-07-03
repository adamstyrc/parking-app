
class User {
  String email;
  String name;

  User({this.email, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
    );
  }
}