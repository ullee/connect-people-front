import 'package:json_annotation/json_annotation.dart';

part 'MyBoards.g.dart';

@JsonSerializable()
class MyBoards {
  final int boardID;
  final String brandName;
  final int memberID;
  final String title;
  final String subTitle;
  final String content;
  final String imageUrl;
  final String created;
  MyBoards({this.boardID, this.brandName, this.memberID, this.title, this.subTitle, this.content, this.imageUrl, this.created});
  factory MyBoards.fromJson(Map<String, dynamic> json) => _$MyBoardsFromJson(json);
  Map<String, dynamic> toJson() => _$MyBoardsToJson(this);
}
