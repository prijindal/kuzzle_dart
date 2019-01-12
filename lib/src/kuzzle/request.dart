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
    this.stopTime,
    this.strategy,
    this.expiresIn,
    this.from,
    this.size,
    this.type,
    this.scroll,
    this.scrollId,
    this.sort,
    this.searchAfter,
  }) {
    requestId ??= _uuid.v4() as String;
  }

  KuzzleRequest.clone(KuzzleRequest request) {
    action = request.action;
    body = request.body;
    collection = request.collection;
    controller = request.controller;
    index = request.index;
    jwt = request.jwt;
    // requestId = request.requestId;
    refresh = request.refresh;
    uid = request.uid;
    volatile = request.volatile;
    startTime = request.startTime;
    stopTime = request.stopTime;
    strategy = request.strategy;
    expiresIn = request.expiresIn;
    from = request.from;
    size = request.size;
    type = request.type;
    scroll = request.scroll;
    scrollId = request.scrollId;
    sort = request.sort;
    searchAfter = request.searchAfter;
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
    stopTime = data['stopTime'] == null
        ? null
        : DateTime.parse(data['stopTime'] as String);
    strategy = data['strategy'] as String;
    expiresIn = data['expiresIn'] as String;
    from = data['from'] as int;
    size = data['size'] as int;
    type = data['type'] as String;
    scroll = data['scroll'] as String;
    scrollId = data['scrollId'] as String;
    sort = data['sort'] as List<dynamic>;
    searchAfter = data['search_after'] as List<dynamic>;
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
    if (stopTime != null) {
      map['stopTime'] = stopTime.millisecondsSinceEpoch;
    }
    if (strategy != null) {
      map['strategy'] = strategy;
    }
    if (expiresIn != null) {
      map['expiresIn'] = expiresIn;
    }
    if (from != null) {
      map['from'] = from;
    }
    if (size != null) {
      map['size'] = size;
    }
    if (type != null) {
      map['type'] = type;
    }
    if (scroll != null) {
      map['scroll'] = scroll;
    }
    if (scrollId != null) {
      map['scrollId'] = scrollId;
    }
    if (sort != null) {
      map['sort'] = sort;
    }
    if (searchAfter != null) {
      map['search_after'] = searchAfter;
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
  DateTime stopTime;
  String strategy;
  String expiresIn;
  int from;
  int size;
  String type;
  String scroll;
  String scrollId;
  List<dynamic> sort;
  List<dynamic> searchAfter;
}
