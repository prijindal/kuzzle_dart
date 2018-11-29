import 'error.dart';

class RawKuzzleResponse {
  RawKuzzleResponse.fromMap(Map<String, dynamic> map)
      : status = map['status'],
        error =
            map['error'] == null ? null : ResponseError.fromMap(map['error']),
        action = map['action'],
        controller = map['controller'],
        index = map['index'],
        collection = map['collection'],
        requestId = map['requestId'],
        result = map['result'];
  final int status;
  final ResponseError error;
  final String action;
  final String controller;
  final String index;
  final String collection;
  final String requestId;
  final Map<String, dynamic> result;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'status': status,
        'error': error,
        'action': action,
        'controller': controller,
        'index': index,
        'collection': collection,
        'requestId': requestId,
        'result': result,
      };
}

class NotificationResponse {}
