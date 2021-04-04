import 'package:json_annotation/json_annotation.dart';

part 'Notice.g.dart';

@JsonSerializable()
class Notice {
  final int id;
  final String title;
  final String content;
  final int member_id;
  final String member_name;
  final String login_id;
  final String created;
  Notice(
      {this.id,
      this.title,
      this.content,
      this.member_id,
      this.member_name,
      this.login_id,
      this.created});
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
