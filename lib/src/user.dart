import 'security.dart';

class User {
  User(this.security, this.id, this.content, {this.meta});
  User.fromMap(this.security, Map<String, dynamic> map)
      : id = map['_id'],
        content = map['_source'],
        meta = map['_meta'];

  final Security security;
  final String id;
  final Map<String, dynamic> content; // Profile Definition
  final Map<String, dynamic> meta;
}
