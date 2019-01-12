import '../kuzzle.dart';

import 'role.dart';

class Profile {
  Profile(
    this.kuzzle, {
    this.uid,
    this.policies,
  });

  final Kuzzle kuzzle;
  String uid;
  List<Map<String, dynamic>> policies;

  // todo: implement this after kuzzle.security.mGetRoles
  Future<List<Role>> getRoles() async => <Role>[];
}
