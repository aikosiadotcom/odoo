import 'package:json_annotation/json_annotation.dart';
import 'user_companies.dart';
import 'user_context.dart';

part 'user_logged_in.g.dart';

@JsonSerializable()
class UserLoggedIn {
  final int uid;
  final bool is_system;
  final bool is_admin;
  final UserContext user_context;
  final String db;
  final String server_version;
  final String name;
  final String username;
  final UserCompanies user_companies;
  final Map<String, dynamic> currencies;

  UserLoggedIn(
      {required this.uid,
      required this.is_system,
      required this.is_admin,
      required this.user_context,
      required this.db,
      required this.server_version,
      required this.name,
      required this.username,
      required this.user_companies,
      required this.currencies});
  factory UserLoggedIn.fromJson(Map<String, dynamic> json) =>
      _$UserLoggedInFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoggedInToJson(this);
}
