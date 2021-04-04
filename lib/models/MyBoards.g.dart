// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyBoards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBoards _$MyBoardsFromJson(Map<String, dynamic> json) {
  return MyBoards(
    boardID: json['boardID'] as int,
    brandName: json['brandName'] as String,
    memberID: json['memberID'] as int,
    title: json['title'] as String,
    subTitle: json['subTitle'] as String,
    content: json['content'] as String,
    imageUrl: json['imageUrl'] as String,
    created: json['created'] as String,
  );
}

Map<String, dynamic> _$MyBoardsToJson(MyBoards instance) => <String, dynamic>{
      'boardID': instance.boardID,
      'brandName': instance.brandName,
      'memberID': instance.memberID,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'created': instance.created,
    };
