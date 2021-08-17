// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Url _$UrlFromJson(Map<String, dynamic> json) {
  return Url(
    _$enumDecode(_$ProtocolEnumMap, json['protocol']),
    json['host'] as String,
    json['port'] as int,
  );
}

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'protocol': _$ProtocolEnumMap[instance.protocol],
      'host': instance.host,
      'port': instance.port,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ProtocolEnumMap = {
  Protocol.http: 'http',
  Protocol.https: 'https',
};

Connection _$ConnectionFromJson(Map<String, dynamic> json) {
  return Connection(
    url: Url.fromJson(json['url'] as Map<String, dynamic>),
    db: json['db'] as String,
  );
}

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'url': instance.url.toJson(),
      'db': instance.db,
    };
