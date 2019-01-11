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
    this.startTime,
    this.endTime,
    this.strategy,
    this.expiresIn,
  }) {
    requestId ??= _uuid.v4() as String;
  }

  KuzzleRequest.fromMap(Map data) {
    action = data['action'] as String;
    body = data['body'] as Map<String, dynamic>;
    collection = data['collection'] as String;
    controller = data['controller'] as String;
    index = data['index'] as String;
    jwt = data['jwt'] as String;
    requestId = data['requestId'] as String;
    requestId ??= _uuid.v4() as String;
    refresh = data['refresh'] as String;
    uid = data['_id'] as String;
    volatile = data['volatile'] as Map<String, dynamic>;
    startTime = data['startTime'] == null
        ? null
        : DateTime.parse(data['startTime'] as String);
    endTime = data['endTime'] == null
        ? null
        : DateTime.parse(data['endTime'] as String);
    strategy = data['strategy'] as String;
    expiresIn = data['expiresIn'] as String;
  }

  Map toJson() {
    final map = <String, dynamic>{};

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
    if (startTime != null) {
      map['startTime'] = startTime.millisecondsSinceEpoch;
    }
    if (endTime != null) {
      map['endTime'] = endTime.millisecondsSinceEpoch;
    }
    if (strategy != null) {
      map['strategy'] = strategy;
    }
    if (expiresIn != null) {
      map['expiresIn'] = expiresIn;
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
  DateTime startTime;
  DateTime endTime;
  String strategy;
  String expiresIn;
}
