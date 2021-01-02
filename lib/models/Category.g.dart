// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
      ID: json['ID'] as int,
      parentID: json['parentID'] as int,
      depth: json['depth'] as int,
      name: json['name'] as String,
      minorData: (json['minorData'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList());
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'ID': instance.ID,
      'parentID': instance.parentID,
      'depth': instance.depth,
      'name': instance.name,
      'minorData': instance.minorData
    };
