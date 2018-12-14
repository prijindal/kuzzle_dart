import 'dart:async';
import 'profile.dart';
import 'security.dart';

class User extends Object {
  User(this.security,
      {this.id, this.meta, this.source, List<dynamic> profileIds})
      : profileIds = profileIds == null
            ? <String>[]
            : profileIds.map<String>((id) => id as String).toList();
  User.fromMap(this.security, Map<String, dynamic> map)
      : id = map['_id'],
        profileIds = map['_source']['profileIds'] == null
            ? <String>[]
            : map['_source']['profileIds']
                .map<String>((id) => id as String)
                .toList(),
        source = map['_source'],
        meta = map['_meta'] {
    source.remove('profileIds');
    source.remove('_kuzzle_info');
  }

  final Security security;
  final String id;
  final Map<String, dynamic> meta;
  final Map<String, dynamic> source;
  final List<String> profileIds;

  @override
  String toString() => <String, dynamic>{
        '_id': id,
        '_source': source,
        'meta': meta,
        'profileIds': profileIds,
      }.toString();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'profileIds': profileIds,
    }..addAll(source);
    return map;
  }

  Future<List<Profile>> getProfiles() => Future.wait<Profile>(profileIds
      .map((profileId) => security.addNetworkQuery(
            'getProfile',
            optionalParams: <String, dynamic>{
              '_id': profileId,
            },
          ).then<Profile>(
              (response) => Profile.fromMap(security, response.result)))
      .toList());

  Future<String> delete({String refresh = 'false'}) =>
      security.deleteUser(id, refresh: refresh);

  Future<User> update({bool queuable = true}) =>
      security.kuzzle.updateSelf(source);
}
