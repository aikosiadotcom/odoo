import 'package:json_annotation/json_annotation.dart';

part 'user_context.g.dart';

@JsonSerializable()
class UserContext {
  final String lang;
  final String tz;
  final int uid;
  UserContext({required this.lang, required this.tz, required this.uid});

  factory UserContext.fromJson(Map<String, dynamic> json) =>
      _$UserContextFromJson(json);
  Map<String, dynamic> toJson() => _$UserContextToJson(this);
}
