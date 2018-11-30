import 'security.dart';

class Role extends Object {
  Role(this.security, this.id, this.content, {this.meta});

  final Security security;
  final String id;
  final Map<String, dynamic> content; // Profile Definition
  final Map<String, dynamic> meta;
}
