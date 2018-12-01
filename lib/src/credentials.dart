import 'helpers.dart';

class Credentials {
  Credentials(this.strategy, {this.username, this.password});

  final LoginStrategy strategy;
  final String username;
  String password;

  Map<String, dynamic> toMap() => <String, dynamic>{
        enumToString<LoginStrategy>(strategy): <String, dynamic>{
          'username': username,
          'password': password,
        },
      };
}

class CredentialsResponse {
  CredentialsResponse.fromMap(Map<String, dynamic> map)
      : username = map['username'],
        kuid = map['kuid'];

  final String username;
  final String kuid;
}

// After login
class AuthResponse {
  AuthResponse.fromMap(Map<String, dynamic> map)
      : jwt = map['jwt'],
        id = map['_id'],
        expiresAt = DateTime.fromMillisecondsSinceEpoch(map['expiresAt']),
        ttl = Duration(milliseconds: map['ttl']);

  final String id;
  final String jwt;
  final DateTime expiresAt;
  final Duration ttl;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'jwt': jwt,
        'expiresAt': expiresAt,
        'ttl': ttl.inHours,
      };
}

enum LoginStrategy {
  local,
}
