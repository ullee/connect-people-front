// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) {
  return Board(
      ID: json['ID'] as int,
      brandName: json['brandName'] as String,
      memberID: json['memberID'] as int,
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      created: json['created'] as String);
}

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'ID': instance.ID,
      'brandName': instance.brandName,
      'memberID': instance.memberID,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'created': instance.created
    };
