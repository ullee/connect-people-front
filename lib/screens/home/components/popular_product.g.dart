// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) {
  return Board(
      ID: json['ID'] as int,
      brandName: json['brandName'],
      memberID: json['memberID'] as int,
      title: json['title'],
      subTitle: json['subTitle'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      created: json['created']);
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
