import '../kuzzle.dart';
import '../kuzzle/response.dart';

import 'profile.dart';

class User {
  User(
    this.kuzzle, {
    this.uid,
    this.content,
    this.meta,
  });

  User.fromKuzzleResponse(this.kuzzle, KuzzleResponse response) {
    uid = response.result['_id'] as String;
    content = response.result['_source'] as Map<String, dynamic>;
    meta = response.result['_meta'] as Map<String, dynamic>;
  }

  @override
  String toString() => '$uid $content $meta';

  final Kuzzle kuzzle;
  String uid;
  Map<String, dynamic> content;
  Map<String, dynamic> meta;

  List<String> get profileIds => content.containsKey('profileIds')
      ? content['profileIds'] as List<String>
      : <String>[];

  // todo: implement this after kuzzle.security.mGetRoles
  Future<List<Profile>> getProfiles() async => <Profile>[];
}
