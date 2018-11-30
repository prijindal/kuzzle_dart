import 'profile.dart';
import 'response.dart';
import 'security.dart';

class User extends Object {
  User(this.security, this.id, this.content, {this.meta});
  User.fromMap(this.security, Map<String, dynamic> map)
      : id = map['_id'],
        content = map['_source'],
        meta = map['_meta'];

  final Security security;
  final String id;
  final Map<String, dynamic> content; // Profile Definition
  final Map<String, dynamic> meta;

  List<String> profileIds = <String>[];

  Future<List<Profile>> getProfiles() {
    return Future.wait<Profile>(profileIds
        .map((String profileId) => security.addNetworkQuery(
              'getProfile',
              optionalParams: <String, dynamic>{
                '_id': profileId,
              },
            ).then<Profile>((RawKuzzleResponse response) =>
                Profile.fromMap(security, response.result)))
        .toList());
  }
}
