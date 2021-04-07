import 'package:json_annotation/json_annotation.dart';

part 'Profile.g.dart';

@JsonSerializable()
class Profile {
  final int id;
  final String login_id;
  final String name;
  final String phone;
  Profile({this.id, this.login_id, this.name, this.phone});
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
