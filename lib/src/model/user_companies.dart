import 'package:json_annotation/json_annotation.dart';

part 'user_companies.g.dart';

@JsonSerializable()
class UserCompanies {
  final List<dynamic> current_company;
  final List<List<dynamic>> allowed_companies;

  UserCompanies(
      {required this.current_company, required this.allowed_companies});

  factory UserCompanies.fromJson(Map<String, dynamic> json) =>
      _$UserCompaniesFromJson(json);
  Map<String, dynamic> toJson() => _$UserCompaniesToJson(this);
}
