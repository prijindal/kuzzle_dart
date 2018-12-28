import 'dart:async';
import 'credentials.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'profile.dart';
import 'response.dart';
import 'role.dart';
import 'user.dart';

class Security extends KuzzleObject {
  Security(Kuzzle kuzzle) : super(null, kuzzle);

  static const String controller = 'security';

  @override
  String getController() => controller;

  Profile profile(String id, Map<String, dynamic> content,
          {Map<String, dynamic> meta}) =>
      Profile(this, id, content, meta: meta);

  Role role(String id, Map<String, dynamic> content,
          {Map<String, dynamic> meta}) =>
      Role(this, id, content, meta: meta);

  User user(String id, Map<String, dynamic> content,
          {Map<String, dynamic> meta}) =>
      User(this,
          id: id,
          meta: meta,
          source: content,
          profileIds: content['profileIds']);

  Future<RawKuzzleResponse> createFirstAdmin(Credentials credentials) =>
      addNetworkQuery(
        'createFirstAdmin',
        body: {'credentials': credentials.toMap()},
      );

  Future<User> createUser(
    User user,
    Credentials credentials, {
    String refresh = 'false',
  }) =>
      addNetworkQuery(
        'createUser',
        body: <String, dynamic>{
          'content': user.toMap(),
          'credentials': credentials.toMap(),
        },
        optionalParams: <String, dynamic>{
          'refresh': refresh,
          '_id': user.id,
        },
      ).then((response) => User.fromMap(this, response.result));

  /// Given a user [id], deletes the corresponding user from Kuzzle.
  ///
  /// The optional parameter [refresh] can be used with the value
  /// wait_for in order to wait for the user's deletion to be indexed.
  Future<String> deleteUser(
    String id, {
    String refresh = 'false',
  }) =>
      addNetworkQuery(
        'deleteUser',
        body: {},
        optionalParams: {
          '_id': id,
          'refresh': refresh,
        },
      ).then((response) => response.result['_id']);

  Future<RawKuzzleResponse> updateUser(
    String id,
    Map<String, dynamic> body, {
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'updateUser',
        body: body,
        optionalParams: <String, dynamic>{
          'refresh': refresh,
          '_id': id,
        },
      );
}
