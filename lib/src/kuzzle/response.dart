import 'errors.dart';

class KuzzleResponse {
  KuzzleResponse({
    this.action,
    this.collection,
    this.controller,
    this.error,
    this.index,
    this.room,
    this.result,
    this.status,
    this.volatile,
  });

  KuzzleResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'] as String;
    collection = json['collection'] as String;
    controller = json['controller'] as String;
    error = json['error'] == null ? null : KuzzleError.fromJson(json);
    index = json['index'] as String;
    room = json['room'] as String;
    result = json['result'] as dynamic;
    status = json['status'] as int;
    volatile = json['volatile'] as Map<String, dynamic>;
  }

  Map toJson() {
    final map = <String, dynamic>{};

    if (action != null) {
      map['action'] = action;
    }
    if (collection != null) {
      map['collection'] = collection;
    }
    if (controller != null) {
      map['controller'] = controller;
    }
    if (error != null) {
      map['error'] = error.toJson();
    }
    if (index != null) {
      map['index'] = index;
    }
    if (room != null) {
      map['room'] = room;
    }
    if (result != null) {
      map['result'] = result;
    }
    if (status != null) {
      map['status'] = status;
    }
    if (volatile != null) {
      map['volatile'] = volatile;
    }

    return map;
  }

  @override
  String toString() => toJson().toString();

  String action;
  String collection;
  String controller;
  KuzzleError error;
  String index;
  String room;
  dynamic result;
  int status;
  Map<String, dynamic> volatile;
}
