import 'helpers.dart';
import 'kuzzle.dart';
import 'profile.dart';
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
      User(this, id, content, meta: meta);
}
