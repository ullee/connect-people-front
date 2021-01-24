// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Banners.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banners _$BannersFromJson(Map<String, dynamic> json) {
  return Banners(
      ID: json['ID'] as int,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      created: json['created'] as String);
}

Map<String, dynamic> _$BannersToJson(Banners instance) => <String, dynamic>{
      'ID': instance.ID,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'created': instance.created
    };
