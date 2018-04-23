// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => new User(
    json['firstName'] as String,
    json['lastName'] as String,
    json['email'] as String,
    json['plate'] as String,
    (json['points'] as num)?.toDouble());

abstract class _$UserSerializerMixin {
  String get firstName;
  String get lastName;
  String get email;
  String get plate;
  double get points;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'plate': plate,
        'points': points
      };
}
