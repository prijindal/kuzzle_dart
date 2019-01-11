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
    action = json['action'];
    collection = json['collection'];
    controller = json['controller'];
    error = json['error'] == null ? null : KuzzleError.fromJson(json);
    index = json['index'];
    room = json['room'];
    result = json['result'] as Map<String, dynamic>;
    status = json['status'];
    volatile = json['volatile'] as Map<String, dynamic>;
  }

  Map toJson() {
    final map = {};

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
      map['error'] = error;
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
  Map<String, dynamic> result;
  int status;
  Map<String, dynamic> volatile;
}