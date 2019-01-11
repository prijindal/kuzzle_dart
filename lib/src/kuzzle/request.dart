import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class KuzzleRequest {
  KuzzleRequest({
    this.action,
    this.body,
    this.collection,
    this.controller,
    this.index,
    this.jwt,
    this.requestId,
    this.refresh,
    this.uid,
    this.volatile,
  }) {
    requestId ??= _uuid.v4();
  }

  KuzzleRequest.fromMap(Map data) {
    action = data['action'];
    body = data['body'] as Map<String, dynamic>;
    collection = data['collection'];
    controller = data['controller'];
    index = data['index'];
    jwt = data['jwt'];
    requestId = data['requestId'] ?? _uuid.v4();
    refresh = data['refresh'];
    uid = data['_id'];
    volatile = data['volatile'] as Map<String, dynamic>;
  }

  Map toJson() {
    final map = {};

    if (action != null) {
      map['action'] = action;
    }
    if (body != null) {
      map['body'] = body;
    }
    if (collection != null) {
      map['collection'] = collection;
    }
    if (controller != null) {
      map['controller'] = controller;
    }
    if (index != null) {
      map['index'] = index;
    }
    if (jwt != null) {
      map['jwt'] = jwt;
    }
    if (requestId != null) {
      map['requestId'] = requestId;
    }
    if (refresh != null) {
      map['refresh'] = refresh;
    }
    if (uid != null) {
      map['_id'] = uid;
    }
    if (volatile != null) {
      map['volatile'] = volatile;
    }

    return map;
  }

  @override
  String toString() => toJson().toString();

  String action;
  Map<String, dynamic> body;
  String collection;
  String controller;
  String index;
  String jwt;
  String requestId;
  String refresh;
  String uid;
  Map<String, dynamic> volatile;
}