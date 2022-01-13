
part of 'user_logged_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoggedIn _$UserLoggedInFromJson(Map<String, dynamic> json) {
  return UserLoggedIn(
    uid: json['uid'] as int,
    is_system: json['is_system'] as bool,
    is_admin: json['is_admin'] as bool,
    user_context:
        UserContext.fromJson(json['user_context'] as Map<String, dynamic>),
    db: json['db'] as String,
    server_version: json['server_version'] as String,
    name: json['name'] as String,
    username: json['username'] as String,
    currencies: json['currencies'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$UserLoggedInToJson(UserLoggedIn instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'is_system': instance.is_system,
      'is_admin': instance.is_admin,
      'user_context': instance.user_context.toJson(),
      'db': instance.db,
      'server_version': instance.server_version,
      'name': instance.name,
      'username': instance.username,
      'currencies': instance.currencies,
    };
