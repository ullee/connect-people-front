import 'package:json_annotation/json_annotation.dart';

part 'Category.g.dart';

@JsonSerializable()
class Category {
  final int ID;
  final int parentID;
  final int depth;
  final String name;
  final List<Map<String, dynamic>> minorData;
  Category({this.ID, this.parentID, this.depth, this.name, this.minorData});
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
