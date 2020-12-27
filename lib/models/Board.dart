import 'package:json_annotation/json_annotation.dart';

part 'Board.g.dart';

@JsonSerializable()
class Board {
  final int ID;
  final String brandName;
  final int memberID;
  final String title;
  final String subTitle;
  final String content;
  final String imageUrl;
  final String created;
  Board({this.ID, this.brandName, this.memberID, this.title, this.subTitle, this.content, this.imageUrl, this.created});
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}
