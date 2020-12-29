import 'package:json_annotation/json_annotation.dart';

part 'Profile.g.dart';

@JsonSerializable()
class Profile {
  final int ID;
  final String loginId;
  final String name;
  final String phone;
  Profile({this.ID, this.loginId, this.name, this.phone});
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
