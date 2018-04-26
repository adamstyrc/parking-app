

import 'package:json_annotation/json_annotation.dart';
 
part 'User.g.dart'; 
 
@JsonSerializable()

class User extends Object with _$UserSerializerMixin {

  User(this.firstName, this.lastName, this.email, this.plate, this.points);

  String firstName;
  String lastName;
  String email;
  String plate;
  double points;
  

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

}
