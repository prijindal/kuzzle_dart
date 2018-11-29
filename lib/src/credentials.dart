class Credentials {
  Credentials(this.username, this.password);

  Credentials.fromMap(Map<String, dynamic> map)
      : username = map['username'],
        kuid = map['kuid'];

  final String username;
  String password;
  String kuid;
}
