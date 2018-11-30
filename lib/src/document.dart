import 'dart:async';
import 'collection.dart';
import 'error.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';
import 'room.dart';

class Document extends Object {
  Document(
    this.collection,
    this.id,
    this.content, {
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.active,
  });

  Document.fromMap(this.collection, Map<String, dynamic> map)
      : assert(map['meta'] != null),
        assert(map['_id'] != null),
        assert(map['_source'] != null),
        id = map['_id'],
        content = map['_source'] {
    content.remove('_kuzzle_info');
    final Map<String, dynamic> mapMeta = extractMeta(map);
    createdAt = mapMeta['createdAt'] == null
        ? mapMeta['createdAt']
        : DateTime.fromMillisecondsSinceEpoch(mapMeta['createdAt']);
    updatedAt = mapMeta['updatedAt'] == null
        ? mapMeta['updatedAt']
        : DateTime.fromMillisecondsSinceEpoch(mapMeta['updatedAt']);
    deletedAt = mapMeta['deletedAt'] == null
        ? mapMeta['deletedAt']
        : DateTime.fromMillisecondsSinceEpoch(mapMeta['deletedAt']);
    active = mapMeta['active'];
  }

  static Map<String, dynamic> extractMeta(Map<String, dynamic> map) {
    if (map.containsKey('_meta')) {
      return map['_meta'];
    } else if (map.containsKey('_source') &&
        map['_source'].containsKey('_kuzzle_info')) {
      return map['_source']['_kuzzle_info'];
    } else {
      return <String, dynamic>{
        'createdAt': null,
        'updatedAt': null,
        'deletedAt': null,
        'active': null,
      };
    }
  }

  final Collection collection;
  final String id;
  final Map<String, dynamic> content;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime deletedAt;
  bool active;

  static String controller = 'document';

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'content': content,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'active': active,
      };

  Map<String, dynamic> get headers => collection.headers;

  Map<String, dynamic> _getPartialQuery() => <String, dynamic>{
        'index': collection.index,
        'collection': collection.collection,
        'controller': controller,
      };

  Future<RawKuzzleResponse> _addNetworkQuery(
    Map<String, dynamic> body, {
    bool queuable = true,
  }) {
    final Map<String, dynamic> query = _getPartialQuery();
    query.addAll(body);
    return collection.kuzzle.addNetworkQuery(query, queuable: queuable);
  }

  Map<String, dynamic> get meta => <String, dynamic>{};
  int get version => 0;

  Future<String> delete({
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      _addNetworkQuery(<String, dynamic>{
        'action': 'delete',
        'refresh': refresh,
        '_id': id,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['_id']);

  Future<bool> exists({
    Map<String, dynamic> volatile,
    bool queuable = true,
  }) async =>
      throw ResponseError();

  Future<void> publish({
    Map<String, dynamic> volatile,
    bool queuable = true,
  }) async =>
      throw ResponseError();

  Future<Document> refresh({
    bool queuable = true,
  }) async =>
      throw ResponseError();

  Future<Document> save({
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  Future<void> setContent(
    Map<String, dynamic> content, {
    bool replace = false,
  }) async =>
      throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  Future<Room> subscribe(
    NotificationCallback notificationCallback, {
    Map<String, dynamic> query = emptyMap,
    final Map<String, dynamic> volatile = emptyMap,
    bool subscribeToSelf,
    RoomScope scope = RoomScope.all,
    RoomState state = RoomState.done,
    RoomUsersScope users = RoomUsersScope.none,
  }) async =>
      collection.subscribe(
        notificationCallback,
        query: query,
        volatile: volatile,
        subscribeToSelf: subscribeToSelf,
        scope: scope,
        state: state,
        users: users,
      );
}
