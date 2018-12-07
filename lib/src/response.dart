import 'collection.dart';
import 'document.dart';
import 'error.dart';
import 'kuzzle.dart';
import 'room.dart';

class RawKuzzleResponse {
  RawKuzzleResponse.fromMap(this.kuzzle, Map<String, dynamic> map)
      : status = map['status'],
        error =
            map['error'] == null ? null : ResponseError.fromMap(map['error']),
        action = map['action'],
        controller = map['controller'],
        index = map['index'],
        collection = map['collection'],
        room = map['room'],
        requestId = map['requestId'],
        state = map['state'],
        result = map['result'];

  final Kuzzle kuzzle;
  final int status;
  final ResponseError error;
  final String action;
  final String controller;
  final String index;
  final String collection;
  final String room;
  final String requestId;
  final String state;
  final dynamic result; // Usually Map<String, dynamic> result;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'status': status,
        'error': error,
        'action': action,
        'controller': controller,
        'index': index,
        'collection': collection,
        'room': room,
        'requestId': requestId,
        'state': state,
        'result': result,
      };

  dynamic toObject() {
    // if (state == 'pending') {
    //   return this;
    // }
    switch (controller) {
      case Document.controller:
        return _toDocumentObject();
      case Room.controller:
        return _toRealtimeObject();
      default:
        return this;
    }
  }

  dynamic _toDocumentObject() {
    switch (action) {
      case 'create':
      case 'replace':
      case 'update':
        return Document.fromMap(Collection(kuzzle, collection, index), result);
      case 'delete':
        return result['_id'];
      default:
        return this;
    }
  }

  dynamic _toRealtimeObject() {
    switch (action) {
      case 'publish':
        return result;
      default:
        return this;
    }
  }
}

class ScrollResponse<T extends Object> {
  ScrollResponse.fromMap(
      Map<String, dynamic> map, T Function(dynamic hitmap) hitTransform)
      : scrollId = map['scrollId'],
        hits = map['hits'].map<T>(hitTransform).toList(),
        total = map['total'];

  final String scrollId;
  final List<T> hits;
  final int total;
}

class SharedAcknowledgedResponse {
  SharedAcknowledgedResponse.fromMap(Map<String, dynamic> map)
      : acknowledged = map['acknowledged'],
        shardsAcknowledged = map['shards_acknowledged'];

  final bool acknowledged;
  final bool shardsAcknowledged;
}

class AcknowledgedResponse {
  AcknowledgedResponse(this.acknowledged);
  AcknowledgedResponse.fromMap(dynamic map)
      : acknowledged = map['acknowledged'];

  final bool acknowledged;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'acknowledged': acknowledged,
      };
}

class SearchResponse<T extends Object> {
  SearchResponse.fromMap(
      Map<String, dynamic> map, T Function(dynamic hitmap) hitTransform)
      : shards = Shards.fromMap(map['_shards']),
        hits = map['hits'].map<T>(hitTransform).toList(),
        total = map['total'];

  final List<T> hits;
  final int total;
  final Shards shards;
}

class Shards {
  Shards.fromMap(Map<String, dynamic> map)
      : failed = map['failed'],
        successful = map['successful'],
        total = map['total'];

  final int failed;
  final int successful;
  final int total;
}
