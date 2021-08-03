import 'package:json_annotation/json_annotation.dart';
import 'user_logged_in.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  final String id;
  final UserLoggedIn user;

  Session(this.id, this.user);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
