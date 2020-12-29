import 'package:json_annotation/json_annotation.dart';

part 'BoardDetail.g.dart';

@JsonSerializable()
class BoardDetail {
  final int ID;
  final String brandName;
  final int memberID;
  final String title;
  final String subTitle;
  final String content;
  final List<String> imageUrls;
  final String created;
  BoardDetail(this.ID, this.brandName, this.memberID, this.title, this.subTitle, this.content, this.imageUrls, this.created);
  factory BoardDetail.fromJson(Map<String, dynamic> json) => _$BoardDetailFromJson(json);
  Map<String, dynamic> toJson() => _$BoardDetailToJson(this);
}
