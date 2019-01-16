import '../kuzzle.dart';
import '../kuzzle/response.dart';

import 'role.dart';

class Profile {
  Profile(
    this.kuzzle, {
    this.uid,
    this.policies,
  });

  Profile.fromKuzzleResponse(this.kuzzle, KuzzleResponse response) {
    uid = response.result['_id'] as String;
    policies = response.result['_source']['policies'] as List<dynamic>;
  }

  final Kuzzle kuzzle;
  String uid;
  List<dynamic> policies;

  Future<List<Role>> getRoles() async {
    if (policies == null || policies.isEmpty) {
      return <Role>[];
    }

    return kuzzle.security
        .mGetRoles(policies.map((policy) => policy['roleId']) as List<String>);
  }
}
