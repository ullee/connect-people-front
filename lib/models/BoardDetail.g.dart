// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardDetail _$BoardDetailFromJson(Map<String, dynamic> json) {
  return BoardDetail(
    json['ID'] as int,
    json['brandName'] as String,
    json['memberID'] as int,
    json['title'] as String,
    json['subTitle'] as String,
    json['content'] as String,
    (json['imageUrls'] as List)?.map((e) => e as String)?.toList(),
    json['created'] as String,
  );
}

Map<String, dynamic> _$BoardDetailToJson(BoardDetail instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'brandName': instance.brandName,
      'memberID': instance.memberID,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'created': instance.created,
    };
