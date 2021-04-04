// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NoticeDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeDetail _$NoticeDetailFromJson(Map<String, dynamic> json) {
  return NoticeDetail(
    json['id'] as int,
    json['title'] as String,
    json['content'] as String,
    json['member_id'] as int,
    json['member_name'] as String,
    json['login_id'] as String,
    json['created'] as String,
  );
}

Map<String, dynamic> _$NoticeDetailToJson(NoticeDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'member_id': instance.member_id,
      'member_name': instance.member_name,
      'login_id': instance.login_id,
      'created': instance.created,
    };
