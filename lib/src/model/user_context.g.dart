// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserContext _$UserContextFromJson(Map<String, dynamic> json) {
  return UserContext(
    lang: json['lang'] as String,
    tz: json['tz'] as String,
    uid: json['uid'] as int,
  );
}

Map<String, dynamic> _$UserContextToJson(UserContext instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'tz': instance.tz,
      'uid': instance.uid,
    };
