import 'package:json_annotation/json_annotation.dart';

part 'Banners.g.dart';

@JsonSerializable()
class Banners {
  final int ID;
  final String imageUrl;
  final String description;
  final String created;
  Banners({this.ID, this.imageUrl, this.description, this.created});
  factory Banners.fromJson(Map<String, dynamic> json) => _$BannersFromJson(json);
  Map<String, dynamic> toJson() => _$BannersToJson(this);
}
