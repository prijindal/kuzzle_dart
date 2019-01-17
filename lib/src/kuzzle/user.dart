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

  final Kuzzle kuzzle;
  String uid;
  Map<String, dynamic> content;
  Map<String, dynamic> meta;

  List<String> get profileIds => content.containsKey('profileIds')
      ? (content['profileIds'] as List<dynamic>)
          .map<String>((a) => a as String)
          .toList()
      : <String>[];

  Future<List<Profile>> getProfiles() async {
    if (profileIds == null || profileIds.isEmpty) {
      return <Profile>[];
    }

    return kuzzle.security.mGetProfiles(profileIds);
  }
}
