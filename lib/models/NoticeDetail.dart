import 'package:json_annotation/json_annotation.dart';

part 'NoticeDetail.g.dart';

@JsonSerializable()
class NoticeDetail {
  final int id;
  final String title;
  final String content;
  final int member_id;
  final String member_name;
  final String login_id;
  final String created;
  NoticeDetail(
    this.id, 
    this.title, 
    this.content, 
    this.member_id,
    this.member_name, 
    this.login_id, 
    this.created);
  factory NoticeDetail.fromJson(Map<String, dynamic> json) => _$NoticeDetailFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeDetailToJson(this);
}
