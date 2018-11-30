import 'dart:async';
import 'collectionmapping.dart';
import 'document.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';
import 'room.dart';
import 'specifications.dart';

enum MappingDefinitionTypes {
  long,
  text,
}

class MappingDefinition extends Object {
  MappingDefinition(this.index, String type, this.fields)
      : type = type == 'long'
            ? MappingDefinitionTypes.long
            : MappingDefinitionTypes.text;

  final MappingDefinitionTypes type;
  final String index;
  final Map<String, dynamic> fields;

  @override
  String toString() => toMap().toString();

  Map<String, String> toMap() {
    final Map<String, String> map = <String, String>{
      'type': type.toString(),
    };
    if (index != null) {
      map['index'] = index;
    }
    if (fields != null) {
      map['fields'] = fields.toString();
    }
    return map;
  }
}

class Collection {
  Collection(this.kuzzle, this.collection, this.index);

  final String collection;
  final String index;
  final Kuzzle kuzzle;
  static String controller = 'collection';

  Map<String, dynamic> get headers {
    final Map<String, dynamic> headers = kuzzle.headers;
    headers.addAll(_headers);
    return headers;
  }

  Map<String, dynamic> _headers = emptyMap;

  Map<String, dynamic> _getPartialQuery() => <String, dynamic>{
        'index': index,
        'collection': collection,
        'controller': controller,
      };

  Future<RawKuzzleResponse> addNetworkQuery(
    Map<String, dynamic> body, {
    bool queuable = true,
  }) {
    final Map<String, dynamic> query = _getPartialQuery();
    query.addAll(body);
    return kuzzle.addNetworkQuery(query, queuable: queuable);
  }

  Future<CollectionMapping> collectionMapping(
          Map<String, MappingDefinition> mapping) async =>
      CollectionMapping(this, mapping);

  // filters is elasticsearch dsl format
  Future<int> count(
          {Map<String, dynamic> filter = emptyMap,
          bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'count',
        'filters': filter,
        'body': <String, dynamic>{},
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['count']);

  FutureOr<RawKuzzleResponse> create(
          {Map<String, MappingDefinition> mapping,
          bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'create',
        'body': mapping ?? emptyMap,
      }, queuable: queuable);

  FutureOr<Document> createDocument(
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
    String ifExist,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'create',
        'body': content,
      }, queuable: queuable)
          .then((RawKuzzleResponse onValue) =>
              Document.fromMap(this, onValue.result));

  Future<String> deleteDocument(
    String documentId, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'delete',
        'refresh': refresh,
        '_id': documentId,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['_id']);

  Future<RawKuzzleResponse> deleteSpecifications({
    bool queuable = true,
    String refresh,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'deleteSpecifications',
        'refresh': refresh,
      }, queuable: queuable);

  Document document({String id, Map<String, dynamic> content}) =>
      Document(this, id, content);

  Future<Document> fetchDocument(
    String documentId, {
    bool queuable = true,
    bool includeTrash = false,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'get',
        '_id': documentId,
        'includeTrash': includeTrash,
      }).then((RawKuzzleResponse response) =>
          Document.fromMap(this, response.result));

  Future<CollectionMapping> getMapping({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'getMapping',
      }, queuable: queuable)
          .then((RawKuzzleResponse onValue) => CollectionMapping.fromMap(this,
              onValue.result[index]['mappings'][collection]['properties']));

  Future<Specifications> getSpecifications({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'getSpecifications',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => Specifications());

  Future<List<Document>> mCreateDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'mCreate',
        'refresh': refresh,
        'body': <String, dynamic>{
          'documents': documents.map((Document document) => <String, dynamic>{
                '_id': document.id,
                'body': document.content,
              }),
        }
      }).then((RawKuzzleResponse response) => response.result['hits'].map(
          (Map<String, dynamic> document) => Document.fromMap(this, document)));

  Future<List<Document>> mCreateOrReplaceDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'mCreateOrReplace',
        'refresh': refresh,
        'body': <String, dynamic>{
          'documents': documents.map((Document document) => <String, dynamic>{
                '_id': document.id,
                'body': document.content,
              }),
        }
      }).then((RawKuzzleResponse response) => response.result['hits'].map(
          (Map<String, dynamic> document) => Document.fromMap(this, document)));

  Future<RawKuzzleResponse> mDeleteDocument(
    List<String> documentIds, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'mDelete',
        'refresh': refresh,
        'body': <String, dynamic>{
          'ids': documentIds,
        }
      });

  Future<RawKuzzleResponse> mGetDocument(List<String> documentIds,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'mGet',
        'body': <String, dynamic>{
          'ids': documentIds,
        }
      });

  Future<RawKuzzleResponse> mReplaceDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'mReplace',
        'refresh': refresh,
        'body': <String, dynamic>{
          'documents': documents.map((Document document) => <String, dynamic>{
                '_id': document.id,
                'body': document.content,
              }),
        }
      }).then((RawKuzzleResponse response) => response.result['hits'].map(
          (Map<String, dynamic> document) => Document.fromMap(this, document)));

  Future<RawKuzzleResponse> mUpdateDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'mUpdate',
        'refresh': refresh,
        'body': <String, dynamic>{
          'documents': documents.map((Document document) => <String, dynamic>{
                '_id': document.id,
                'body': document.content,
              }),
        }
      });

  Future<bool> publishMessage(Map<String, dynamic> message,
          {Map<String, dynamic> volatile, bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Room.controller,
        'action': 'publish',
        'body': message,
        'volatile': volatile,
      }).then((RawKuzzleResponse response) => response.result['published']);

  Future<Document> replaceDocument(
    String documentId,
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'replace',
        'refresh': refresh,
        'body': content,
        '_id': documentId,
      }).then((RawKuzzleResponse response) =>
          Document.fromMap(this, response.result));

  Room room(Map<String, dynamic> options) => Room(this);

  Future<RawKuzzleResponse> scroll(
    String scrollId, {
    bool queuable = true,
    String scroll,
  }) =>
      addNetworkQuery(<String, dynamic>{
        'action': 'scroll',
        'scrollId': scrollId,
        'scroll': scroll,
      });

  void scrollSpecifications(
    String scrollId, {
    bool queuable = true,
    String scroll,
  }) =>
      addNetworkQuery(<String, dynamic>{
        'action': 'scrollSpecifications',
        'scrollId': scrollId,
        'scroll': scroll,
      });

  Future<RawKuzzleResponse> search({
    Map<String, dynamic> query = emptyMap,
    Map<String, dynamic> aggregations = emptyMap,
    Map<String, dynamic> sort = emptyMap,
    bool queuable = true,
    String scroll,
    int from = 0,
    int size = 10,
    bool includeTrash = false,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'search',
        'body': <String, dynamic>{
          'query': query,
          'aggregations': aggregations,
          'sort': sort,
        },
        'scroll': scroll,
        'from': from,
        'size': size,
        'includeTrash': includeTrash,
      });

  void searchSpecifications({
    Map<String, dynamic> query = emptyMap,
    bool queuable = true,
    String scroll,
    int from = 0,
    int size = 10,
  }) =>
      addNetworkQuery(<String, dynamic>{
        'action': 'searchSpecifications',
        'body': <String, dynamic>{
          'query': query,
        },
        'from': from,
        'size': size,
        'scroll': scroll,
      });

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      _headers = newheaders;

  Future<Room> subscribe(
    NotificationCallback notificationCallback, {
    Map<String, dynamic> query = emptyMap,
    Map<String, dynamic> volatile = emptyMap,
    bool subscribeToSelf,
    RoomScope scope = RoomScope.all,
    RoomState state = RoomState.done,
    RoomUsersScope users = RoomUsersScope.none,
  }) async {
    final StreamController<RawKuzzleResponse> streamController =
        StreamController<RawKuzzleResponse>.broadcast();
    final Room room = await addNetworkQuery(<String, dynamic>{
      'controller': Room.controller,
      'action': 'subscribe',
      'body': query,
      'volatile': volatile,
      'scope': enumToString<RoomScope>(scope),
      'state': enumToString<RoomState>(state),
      'users': enumToString<RoomUsersScope>(users),
    }).then((RawKuzzleResponse response) => Room(
          this,
          id: response.result['roomId'],
          channel: response.result['channel'],
          subscribeToSelf: subscribeToSelf,
          scope: scope,
          state: state,
          users: users,
          volatile: volatile,
        ));
    kuzzle.roomMaps[room.channel] = streamController;
    room.subscription = streamController.stream.listen(notificationCallback);
    return room;
  }

  Future<List<String>> truncate({
    bool queuable = true,
    String refresh = 'false',
  }) =>
      addNetworkQuery(<String, dynamic>{
        'action': 'truncate',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) =>
              (response.result['ids'] as List<dynamic>)
                  .map((dynamic id) => id as String)
                  .toList());

  Future<RawKuzzleResponse> updateDocument(
    String documentId,
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh = 'false',
    int retryOnConflict = 0,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': Document.controller,
        'action': 'update',
        'refresh': refresh,
        '_id': documentId,
        'body': content,
      });

  Future<RawKuzzleResponse> updateSpecifications(
    Specifications specifications, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'updateSpecifications',
        'body': specifications.toMap(),
      });

  Future<RawKuzzleResponse> validateSpecifications(
    Specifications specifications, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'validateSpecifications',
        'body': specifications.toMap(),
      });
}
