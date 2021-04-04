// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) {
  return Notice(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    member_id: json['member_id'] as int,
    member_name: json['member_name'] as String,
    login_id: json['login_id'] as String,
    created: json['created'] as String,
  );
}

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'member_id': instance.member_id,
      'member_name': instance.member_name,
      'login_id': instance.login_id,
      'created': instance.created,
    };
