import 'package:json_annotation/json_annotation.dart';

part 'credential.g.dart';

@JsonSerializable()
class Credential {
  final String username;
  final String password;

  Credential(this.username, this.password);

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);
  Map<String, dynamic> toJson() => _$CredentialToJson(this);
}
