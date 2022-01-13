// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_companies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCompanies _$UserCompaniesFromJson(Map<String, dynamic> json) {
  return UserCompanies(
    allowed_companies: (json['allowed_companies'] as List<dynamic>)
        .map((e) => e as List<dynamic>)
        .toList(),
  );
}

Map<String, dynamic> _$UserCompaniesToJson(UserCompanies instance) =>
    <String, dynamic>{
      'allowed_companies': instance.allowed_companies,
    };
