import 'dart:async';

import '../kuzzle.dart';
import '../kuzzle/request.dart';
import '../kuzzle/user.dart';

import 'abstract.dart';

class AuthController extends KuzzleController {
  AuthController(Kuzzle kuzzle) : super(kuzzle, name: 'auth');

  /// Checks whether a given jwt token still
  /// represents a valid session in Kuzzle.
  Future<Map<String, dynamic>> checkToken() async {
    final response = await kuzzle.query(
        KuzzleRequest(controller: name, action: 'checkToken'),
        {'queueable': false});

    return response.result;
  }

  /// Create [credentials] of the specified [strategy] for the current user.
  Future<Map<String, dynamic>> createMyCredentials(
      String strategy, Map<String, dynamic> credentials) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'createMyCredentials',
      strategy: strategy,
      body: credentials,
    ));

    return response.result;
  }

  /// Check the existence of the specified [strategy]'s
  /// credentials for the current user.
  Future<Map<String, dynamic>> credentialsExist(String strategy) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'credentialsExist',
      strategy: strategy,
    ));

    return response.result;
  }

  /// Delete credentials of the specified [strategy] for the current user.
  Future<Map<String, dynamic>> deleteMyCredentials(String strategy) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'deleteMyCredentials',
      strategy: strategy,
    ));

    return response.result;
  }

  /// Fetches the current user.
  Future<User> getCurrentUser() async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'getCurrentUser',
    ));

    return User.fromKuzzleResponse(kuzzle, response);
  }

  /// Get credential information of
  /// the specified [strategy] for the current user.
  Future<Map<String, dynamic>> getMyCredentials(String strategy) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'getMyCredentials',
      strategy: strategy,
    ));

    return response.result;
  }

  /// Gets the rights array of the currently logged user
  Future<Map<String, dynamic>> getMyRights() async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'getMyRights',
    ));

    return response.result['hits'] as Map<String, dynamic>;
  }

  /// Get all the strategies registered in Kuzzle by all auth plugins
  Future<Map<String, dynamic>> getStrategies() async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'getStrategies',
    ));

    return response.result;
  }

  /// Send login request to kuzzle with credentials
  ///
  /// If login success, store the jwt into kuzzle object
  Future<String> login(String strategy, Map<String, dynamic> credentials,
          [String expiresIn]) async =>
      kuzzle
          .query(KuzzleRequest(
        controller: name,
        action: 'login',
        strategy: strategy,
        expiresIn: expiresIn,
        body: credentials,
      ))
          .then((response) {
        try {
          kuzzle.jwt = response.result['jwt'] as String;
          kuzzle.emit('loginAttempt', [], {
            const Symbol('success'): true,
          });

          return kuzzle.jwt;
        } on Exception {
          rethrow;
        }
      }).catchError((error) {
        kuzzle.emit('loginAttempt', [], {
          const Symbol('success'): false,
          const Symbol('error'): error,
        });

        throw error;
      });

  /// Send logout request to kuzzle with jwt.
  Future<void> logout() async => kuzzle
          .query(KuzzleRequest(
        controller: name,
        action: 'logout',
      ))
          .then((response) {
        kuzzle.jwt = null;
      });

  /// Update [credentials] of the specified [strategy] for the current user.
  Future<Map<String, dynamic>> updateMyCredentials(
      String strategy, Map<String, dynamic> credentials) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'updateMyCredentials',
      strategy: strategy,
      body: credentials,
    ));

    return response.result;
  }

  /// Fetches the current user.
  Future<User> updateSelf(Map<String, dynamic> body) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'updateSelf',
      body: body,
    ));

    return User.fromKuzzleResponse(kuzzle, response);
  }

  /// Validate [credentials] of the specified [strategy] for the current user.
  Future<Map<String, dynamic>> validateMyCredentials(
      String strategy, Map<String, dynamic> credentials) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'validateMyCredentials',
      strategy: strategy,
      body: credentials,
    ));

    return response.result;
  }
}
