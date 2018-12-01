import 'profile.dart';
import 'response.dart';
import 'security.dart';

class User extends Object {
  User(this.security, {this.id, this.meta, this.name, List<dynamic> profileIds})
      : profileIds = profileIds == null
            ? <String>[]
            : profileIds.map<String>((dynamic id) => id as String).toList();
  User.fromMap(this.security, Map<String, dynamic> map)
      : id = map['_id'],
        profileIds = map['_source']['profileIds'] == null
            ? <String>[]
            : map['_source']['profileIds']
                .map<String>((dynamic id) => id as String)
                .toList(),
        name = map['_source']['name'],
        meta = map['_meta'];

  final Security security;
  final String id;
  final Map<String, dynamic> meta;
  final String name;
  final List<String> profileIds;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'name': name,
        'profileIds': profileIds,
      };

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
