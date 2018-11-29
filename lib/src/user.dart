class User {
  User.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        source = map['_source'];

  final String id;
  final Map<String, dynamic> source;
}
