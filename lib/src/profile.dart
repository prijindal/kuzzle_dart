import 'security.dart';

class Profile extends Object {
  Profile(this.security, this.id, this.content, {this.meta});
  Profile.fromMap(this.security, Map<String, dynamic> map)
      : id = map['_id'],
        content = map['_source'],
        meta = map['_meta'];

  final Security security;
  final String id;
  final Map<String, dynamic> content; // Profile Definition
  final Map<String, dynamic> meta;
}
