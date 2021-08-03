import 'package:json_annotation/json_annotation.dart';

part 'connection.g.dart';

enum Protocol { http, https }

@JsonSerializable()
class Url {
  final Protocol protocol;
  final String host;
  final int port;

  Url(this.protocol, this.host, this.port);

  @override
  String toString() {
    return "${_$ProtocolEnumMap[this.protocol]}://$host:$port";
  }

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);
  Map<String, dynamic> toJson() => _$UrlToJson(this);
}

@JsonSerializable()
class Connection {
  final Url url;
  final String db;

  Connection({required this.url, required this.db});

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);
}
