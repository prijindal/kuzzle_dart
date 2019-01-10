import 'dart:async';
import 'credentials.dart';
import 'error.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';
import 'rights.dart';
import 'user.dart';

class Authentication extends KuzzleObject {
  Authentication(Kuzzle kuzzle) : super(null, kuzzle);

  static String controller = 'auth';

  @override
  String getController() => controller;

  Future<CheckTokenResponse> checkToken(String token) async => addNetworkQuery(
        'checkToken',
        body: {
          'token': token,
        },
      ).then((response) => CheckTokenResponse.fromMap(response.result));

  Future<CredentialsResponse> createMyCredentials(Credentials credentials,
          {bool queuable = true}) async =>
      addNetworkQuery('createMyCredentials',
              body: {
                'username': credentials.username,
                'password': credentials.password,
              },
              optionalParams: {
                'strategy': enumToString<LoginStrategy>(credentials.strategy),
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => CredentialsResponse.fromMap(response.result));

  Future<bool> credentialsExist(LoginStrategy strategy) async =>
      addNetworkQuery('credentialsExist', optionalParams: {
        'strategy': enumToString<LoginStrategy>(strategy),
      }).then((response) => response.result as bool);

  Future<AcknowledgedResponse> deleteMyCredentials(LoginStrategy strategy,
          {bool queuable = true}) async =>
      addNetworkQuery('deleteMyCredentials',
              optionalParams: {
                'strategy': enumToString<LoginStrategy>(strategy),
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => AcknowledgedResponse.fromMap(response.result));

  Future<User> getCurrentUser({bool queuable = true}) async =>
      addNetworkQuery('getCurrentUser', queuable: queuable)
          .then((response) => User.fromMap(kuzzle.security, response.result));

  Future<CredentialsResponse> getMyCredentials(LoginStrategy strategy,
          {bool queuable = true}) async =>
      addNetworkQuery('getMyCredentials',
              optionalParams: {
                'strategy': enumToString<LoginStrategy>(strategy),
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => CredentialsResponse.fromMap(response.result));

  Future<List<Rights>> getMyRights({bool queuable = true}) async =>
      addNetworkQuery('getMyRights',
              optionalParams: {
                'controller': 'auth',
                'action': 'getMyRights',
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => (response.result['hits'] as List<dynamic>)
              .map<Rights>((stats) => Rights.fromMap(stats))
              .toList());

  /// Get all authentication strategies registered in Kuzzle
  Future<List<String>> getStrategies({bool queuable = true}) =>
      addNetworkQuery('getStrategies', queuable: queuable).then((response) =>
          (response.result as List<dynamic>)
              .map<String>((res) => res as String)
              .toList());

  Future<AuthResponse> login(
    Credentials credentials, {
    String expiresIn,
  }) async =>
      addNetworkQuery(
        'login',
        body: <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        },
        optionalParams: {
          'strategy': enumToString<LoginStrategy>(credentials.strategy),
          'expiresIn': expiresIn,
        },
      )
          .then((response) => AuthResponse.fromMap(response.result))
          .then((response) {
        if (response.id == '-1') {
          throw ResponseError(
              message: 'wrong username or password', status: 401);
        } else {
          kuzzle.jwtToken = response.jwt;
        }
        return response;
      });

  Future<void> logout() async => addNetworkQuery('logout', optionalParams: {
        'controller': 'auth',
        'action': 'logout',
        'jwt': kuzzle.jwtToken,
      }).then((response) {
        kuzzle.jwtToken = null;
      });

  Future<CredentialsResponse> updateMyCredentials(
    Credentials credentials, {
    bool queuable = true,
  }) =>
      addNetworkQuery('updateMyCredentials',
              body: <String, dynamic>{
                'username': credentials.username,
                'password': credentials.password,
              },
              optionalParams: {
                'strategy': enumToString<LoginStrategy>(credentials.strategy),
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => CredentialsResponse.fromMap(response.result));

  Future<User> updateSelf(Map<String, dynamic> content,
          {bool queuable = true}) async =>
      addNetworkQuery('updateSelf',
              body: content,
              optionalParams: {
                'controller': 'auth',
                'action': 'updateSelf',
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => User.fromMap(kuzzle.security, response.result));

  Future<bool> validateMyCredentials(
    LoginStrategy strategy,
    Credentials credentials, {
    bool queuable = true,
  }) async =>
      addNetworkQuery('validateMyCredentials',
              body: <String, dynamic>{
                'username': credentials.username,
                'password': credentials.password,
              },
              optionalParams: {
                'strategy': enumToString<LoginStrategy>(strategy),
                'jwt': kuzzle.jwtToken,
              },
              queuable: queuable)
          .then((response) => response.result);
}
