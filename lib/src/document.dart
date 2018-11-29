import 'collection.dart';
import 'error.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';
import 'room.dart';

class Document extends Object {
  Document.fromMap(this.collection, Map<String, dynamic> map)
      : assert(map['meta'] != null),
        assert(map['_id'] != null),
        assert(map['_source'] != null),
        id = map['_id'],
        content = map['_source'],
        createdAt = map['_meta']['createdAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['_meta']['createdAt']),
        updatedAt = map['_meta']['updatedAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['_meta']['updatedAt']),
        deletedAt = map['_meta']['deletedAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['_meta']['deletedAt']),
        active = map['_meta']['active'] {
    content.remove('_kuzzle_info');
  }

  final Collection collection;
  final String id;
  final Map<String, dynamic> content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final bool active;

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
  }) async {
    final Room room = await _addNetworkQuery(<String, dynamic>{
      'controller': 'realtime',
      'action': 'subscribe',
      'body': query,
      'volatile': volatile,
      'scope': enumToString<RoomScope>(scope),
      'state': enumToString<RoomState>(state),
      'users': enumToString<RoomUsersScope>(users),
    }).then((RawKuzzleResponse response) => Room(
          collection,
          id: response.result['roomId'],
          channel: response.result['channel'],
          subscribeToSelf: subscribeToSelf,
          scope: scope,
          state: state,
          users: users,
        ));
    collection.kuzzle.roomMaps[room.channel] = notificationCallback;
    return room;
  }
}
