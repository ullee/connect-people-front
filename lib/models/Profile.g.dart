// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    ID: json['ID'] as int,
    loginId: json['loginId'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'ID': instance.ID,
      'loginId': instance.loginId,
      'name': instance.name,
      'phone': instance.phone,
    };
