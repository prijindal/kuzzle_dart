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
          name: content['name'],
          profileIds: content['profileIds']);

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
        },
      ).then((response) => User.fromMap(this, response.result));

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
