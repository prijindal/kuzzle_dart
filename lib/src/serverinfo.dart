class ServerInfo {
  ServerInfo.fromMap(Map<String, dynamic> map)
      : info = map['serverInfo']['kuzzle'];

  final Map<String, dynamic> info;
}
