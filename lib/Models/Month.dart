
import 'package:json_annotation/json_annotation.dart';
 
part 'Month.g.dart'; 
 
@JsonSerializable()

class Month extends Object with _$MonthSerializerMixin {

  Month(this.id);

  int id;

  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);

}