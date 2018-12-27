import 'dart:async';
import 'collectionmapping.dart';
import 'document.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';
import 'room.dart';
import 'specifications.dart';

class MappingDefinition extends Object {
  MappingDefinition(this.index, this.type, this.fields);

  final String type; // long or text
  final String index;
  final Map<String, dynamic> fields;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
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

class Collection extends KuzzleObject {
  Collection(Kuzzle kuzzle, this.collectionName, this.index)
      : super(null, kuzzle);

  final String collectionName;
  final String index;
  static String controller = 'collection';

  static const Map<String, MappingDefinition> emptyDefinition =
      <String, MappingDefinition>{};

  @override
  String getController() => controller;

  @override
  Map<String, dynamic> getPartialQuery() {
    final prevMap = super.getPartialQuery()
      ..addAll(<String, dynamic>{
        'collection': collectionName,
        'index': index,
      });
    return prevMap;
  }

  Future<CollectionMapping> collectionMapping(
          Map<String, MappingDefinition> mapping) async =>
      CollectionMapping(this, mapping);

  // filters is elasticsearch dsl format
  Future<int> count(
          {Map<String, dynamic> filter = emptyMap,
          bool queuable = true}) async =>
      addNetworkQuery(
        'count',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'filters': filter,
        },
        queuable: queuable,
      ).then((response) => response.result['count']);

  FutureOr<AcknowledgedResponse> create(
          {Map<String, MappingDefinition> mapping = emptyDefinition,
          bool queuable = true}) async =>
      addNetworkQuery(
        'create',
        body: mapping.map<String, dynamic>((key, definition) =>
                MapEntry<String, dynamic>(key, definition.toMap())) ??
            emptyMap,
        queuable: queuable,
      ).then((response) => AcknowledgedResponse.fromMap(response.result));

  FutureOr<Document> createDocument(
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
    String ifExist,
  }) async =>
      addNetworkQuery(
        'create',
        body: content,
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
        },
        queuable: queuable,
      ).then((response) => Document.fromMap(this, response.result));

  Future<String> deleteDocument(
    String documentId, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'delete',
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
          '_id': documentId,
        },
        queuable: queuable,
      ).then((response) => response.result['_id']);

  Future<bool> deleteSpecifications({
    bool queuable = true,
    String refresh,
  }) async =>
      addNetworkQuery(
        'deleteSpecifications',
        optionalParams: <String, dynamic>{
          'refresh': refresh,
        },
        queuable: queuable,
      ).then((response) => response.result['acknowledged'] as bool);

  Document document({String id, Map<String, dynamic> content}) =>
      Document(this, id, content);

  Future<bool> exists({
    Map<String, dynamic> volatile,
    bool queuable = true,
  }) async =>
      addNetworkQuery(
        'exists',
        queuable: queuable,
      ).then((response) => response.result as bool);

  Future<Document> fetchDocument(
    String documentId, {
    bool queuable = true,
    bool includeTrash = false,
  }) async =>
      addNetworkQuery(
        'get',
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          '_id': documentId,
          'includeTrash': includeTrash,
        },
      ).then((response) => Document.fromMap(this, response.result));

  Future<CollectionMapping> getMapping({bool queuable = true}) async =>
      addNetworkQuery('getMapping', queuable: queuable).then((response) =>
          CollectionMapping.fromMap(
              this,
              response.result[index]['mappings'][collectionName]
                  ['properties']));

  Future<Specifications> getSpecifications({bool queuable = true}) async =>
      addNetworkQuery('getSpecifications', queuable: queuable)
          .then((response) => Specifications.fromMap(this, response.result));

  Future<List<Document>> mCreateDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'mCreate',
        body: <String, dynamic>{
          'documents': documents
              .map((document) => <String, dynamic>{
                    '_id': document.id,
                    'body': document.content,
                  })
              .toList(),
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
        },
      ).then((response) => response.result['hits']
          .map<Document>((document) => Document.fromMap(this, document))
          .toList() as List<Document>);

  Future<List<Document>> mCreateOrReplaceDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'mCreateOrReplace',
        body: <String, dynamic>{
          'documents': documents
              .map((document) => <String, dynamic>{
                    '_id': document.id,
                    'body': document.content,
                  })
              .toList(),
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
        },
      ).then((response) => response.result['hits']
          .map<Document>((document) => Document.fromMap(this, document))
          .toList() as List<Document>);

  Future<List<String>> mDeleteDocument(
    List<String> documentIds, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'mDelete',
        body: <String, dynamic>{
          'ids': documentIds,
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
        },
      ).then((response) => response.result
          .map<String>((documentId) => documentId as String)
          .toList() as List<String>);

  Future<List<Document>> mGetDocument(List<String> documentIds,
          {bool queuable = true}) async =>
      addNetworkQuery(
        'mGet',
        body: <String, dynamic>{
          'ids': documentIds,
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
        },
      ).then((response) => response.result['hits']
          .map<Document>((document) => Document.fromMap(this, document))
          .toList() as List<Document>);

  Future<List<Document>> mReplaceDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'mReplace',
        body: <String, dynamic>{
          'documents': documents
              .map((document) => <String, dynamic>{
                    '_id': document.id,
                    'body': document.content,
                  })
              .toList(),
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
        },
      ).then((response) => response.result['hits']
          .map<Document>((document) => Document.fromMap(this, document))
          .toList() as List<Document>);

  Future<RawKuzzleResponse> mUpdateDocument(
    List<Document> documents, {
    bool queuable = true,
    String refresh = 'false',
  }) async =>
      addNetworkQuery(
        'mUpdate',
        body: <String, dynamic>{
          'documents': documents.map((document) => <String, dynamic>{
                '_id': document.id,
                'body': document.content,
              }),
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
        },
      );

  Future<bool> publishMessage(Map<String, dynamic> message,
          {Map<String, dynamic> volatile, bool queuable = true}) async =>
      addNetworkQuery(
        'publish',
        body: message,
        optionalParams: <String, dynamic>{
          'controller': Room.controller,
          'volatile': volatile,
        },
      ).then((response) => response.result['published']);

  Future<Document> replaceDocument(
    String documentId,
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      addNetworkQuery(
        'replace',
        body: content,
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
          '_id': documentId,
        },
      ).then((response) => Document.fromMap(this, response.result));

  Room room(Map<String, dynamic> options) => Room(this);

  Future<ScrollResponse<Document>> scroll(
    String scrollId, {
    bool queuable = true,
    String scroll,
  }) =>
      addNetworkQuery('scroll', optionalParams: <String, dynamic>{
        'scrollId': scrollId,
        'scroll': scroll,
        'controller': Document.controller,
      }).then((response) => ScrollResponse<Document>.fromMap(response.result,
          (map) => Document.fromMap(this, map as Map<String, dynamic>)));

  Future<ScrollResponse<ScrollSpecificationHit>> scrollSpecifications(
    String scrollId, {
    bool queuable = true,
    String scroll,
  }) =>
      addNetworkQuery('scrollSpecifications', optionalParams: <String, dynamic>{
        'scrollId': scrollId,
        'scroll': scroll
      }).then((response) => ScrollResponse<ScrollSpecificationHit>.fromMap(
          response.result,
          (map) => ScrollSpecificationHit.fromMap(
              this, map as Map<String, dynamic>)));

  Future<ScrollResponse<Document>> search({
    Map<String, dynamic> query = emptyMap,
    Map<String, dynamic> aggregations = emptyMap,
    Map<String, dynamic> sort = emptyMap,
    bool queuable = true,
    String scroll,
    int from = 0,
    int size = 10,
    bool includeTrash = false,
  }) async =>
      addNetworkQuery(
        'search',
        body: <String, dynamic>{
          'query': query,
          'aggregations': aggregations,
          'sort': sort
        },
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'scroll': scroll,
          'from': from,
          'size': size,
          'includeTrash': includeTrash
        },
      ).then((response) => ScrollResponse<Document>.fromMap(response.result,
          (map) => Document.fromMap(this, map as Map<String, dynamic>)));

  Future<SearchResponse<ScrollSpecificationHit>> searchSpecifications({
    Map<String, dynamic> query = emptyMap,
    bool queuable = true,
    String scroll,
    int from = 0,
    int size = 10,
  }) =>
      addNetworkQuery(
        'searchSpecifications',
        body: <String, dynamic>{
          'query': query,
        },
        optionalParams: <String, dynamic>{
          'from': from,
          'size': size,
          'scroll': scroll,
        },
      ).then((response) => SearchResponse<ScrollSpecificationHit>.fromMap(
          response.result,
          (map) => ScrollSpecificationHit.fromMap(
              this, map as Map<String, dynamic>)));

  Future<Room> subscribe(
    NotificationCallback notificationCallback, {
    Map<String, dynamic> query = emptyMap,
    Map<String, dynamic> volatile = emptyMap,
    bool subscribeToSelf,
    RoomScope scope = RoomScope.all,
    RoomState state = RoomState.done,
    RoomUsersScope users = RoomUsersScope.none,
  }) async {
    final streamController = StreamController<RawKuzzleResponse>.broadcast();
    final room = await addNetworkQuery(
      'subscribe',
      body: query,
      optionalParams: <String, dynamic>{
        'controller': Room.controller,
        'volatile': volatile,
        'scope': enumToString<RoomScope>(scope),
        'state': enumToString<RoomState>(state),
        'users': enumToString<RoomUsersScope>(users),
      },
    ).then((response) => Room(
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
      addNetworkQuery('truncate', queuable: queuable).then((response) =>
          (response.result['ids'] as List<dynamic>)
              .map((index) => index as String)
              .toList());

  Future<bool> updateDocument(
    String documentId,
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh = 'false',
    int retryOnConflict = 0,
  }) async =>
      addNetworkQuery(
        'update',
        body: content,
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
          'refresh': refresh,
          '_id': documentId
        },
      ).then((response) => response.result['result'] == 'updated');

  Future<Specifications> updateSpecifications(
    Specifications specifications, {
    bool queuable = true,
  }) async =>
      addNetworkQuery('updateSpecifications', body: <String, dynamic>{
        index: <String, dynamic>{
          collectionName: <String, dynamic>{
            'fields': specifications.validation,
          },
        },
      }).then((response) =>
          Specifications(this, response.result[index][collectionName]));

  Future<bool> validateDocument(
    Map<String, dynamic> body, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(
        'validate',
        body: body,
        optionalParams: <String, dynamic>{
          'controller': Document.controller,
        },
      ).then((response) => response.result['valid'] as bool);

  Future<ValidResponse> validateSpecifications(
    Specifications specifications, {
    bool queuable = true,
  }) async =>
      addNetworkQuery('validateSpecifications', body: <String, dynamic>{
        index: <String, dynamic>{
          collectionName: <String, dynamic>{
            'fields': specifications.validation,
          },
        },
      }).then((response) => ValidResponse.fromMap(response.result));
}

class ListCollectionResponse {
  ListCollectionResponse.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        type = map['type'] == 'realtime'
            ? CollectionType.realtime
            : CollectionType.stored;
  final String name;
  final CollectionType type;
}

enum CollectionType { realtime, stored }
