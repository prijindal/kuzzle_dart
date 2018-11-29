import 'dart:async';
import 'collectionmapping.dart';
import 'document.dart';
import 'error.dart';
import 'kuzzle.dart';
import 'response.dart';
import 'room.dart';
import 'specifications.dart';
import 'subscription.dart';

const Map<String, dynamic> emptyMap = <String, dynamic>{};

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

  Map<String, dynamic> get headers => kuzzle.headers;

  Future<CollectionMapping> collectionMapping(
          Map<String, MappingDefinition> mapping) async =>
      CollectionMapping(this, mapping);

  // filters is elasticsearch dsl format
  Future<int> count(
          {Map<String, dynamic> filter = emptyMap,
          bool queuable = true}) async =>
      kuzzle.addNetworkQuery(<String, dynamic>{
        'index': index,
        'collection': collection,
        'controller': Document.controller,
        'action': 'count',
        'filters': filter,
        'body': <String, dynamic>{},
      }, queuable: queuable).then(
          (RawKuzzleResponse response) => response.result['count']);

  FutureOr<RawKuzzleResponse> create(Map<String, MappingDefinition> mapping,
          {bool queuable = true}) async =>
      kuzzle.addNetworkQuery(<String, dynamic>{
        'index': index,
        'collection': collection,
        'controller': controller,
        'action': 'create',
        'body': mapping,
      }, queuable: queuable);

  FutureOr<Document> createDocument(
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
    String ifExist,
  }) async =>
      kuzzle.addNetworkQuery(<String, dynamic>{
        'index': index,
        'collection': collection,
        'controller': Document.controller,
        'action': 'create',
        'body': content,
      }, queuable: queuable).then((RawKuzzleResponse onValue) =>
          Document.fromMap(this, onValue.result));

  /* TODO: There are two types of deleteDocument, one with id
  * And other with filter, both should be implemented */
  Future<List<String>> deleteDocument(
    String documentId, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  // TODO: replace void with response
  Future<void> deleteSpecifications({
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  Document document({String id, Map<String, dynamic> content}) =>
      throw ResponseError();

  Future<Document> fetchDocument(String documentId,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<CollectionMapping> getMapping({bool queuable = true}) async =>
      kuzzle.addNetworkQuery(<String, dynamic>{
        'index': index,
        'collection': collection,
        'controller': controller,
        'action': 'getMapping',
      }, queuable: queuable).then((RawKuzzleResponse onValue) =>
          CollectionMapping.fromMap(this,
              onValue.result[index]['mappings'][collection]['properties']));

  Future<Specifications> getSpecifications({bool queuable = true}) async =>
      throw ResponseError();

  Future<Document> mCreateDocument(List<Document> documents,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> mCreateOrReplaceDocument(List<Document> documents,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> mDeleteDocument(List<String> documentIds,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> mGetDocument(String documentIds,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> mReplaceDocument(List<Document> documents,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> mUpdateDocument(List<Document> documents,
          {bool queuable = true}) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> publishMessage(Document document,
          {Map<String, dynamic> volatile, bool queuable = true}) async =>
      throw ResponseError();

  Future<Document> replaceDocument(
    String documentId,
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  Room room(Map<String, dynamic> options) => throw ResponseError();

  // TODO: Define types
  void scroll() => throw ResponseError();
  // TODO: Define types
  void scrollSpecifications() => throw ResponseError();
  // TODO: Define types
  void search() => throw ResponseError();
  // TODO: Define types
  void searchSpecifications() => throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  Subscription subscribe(
    void Function(NotificationResponse response) notificationCallback, {
    final Map<String, dynamic> volatile,
    bool subscribeToSelf,
    RoomScope scope,
    RoomState state,
    RoomUsersScope users,
  }) =>
      Subscription(
        Room(
          this,
          volatile: volatile,
          subscribeToSelf: subscribeToSelf,
          scope: scope,
          state: state,
          users: users,
        ),
      );

  Future<RawKuzzleResponse> truncate({
    bool queuable = true,
    String refresh = 'false',
  }) =>
      kuzzle.addNetworkQuery(<String, dynamic>{
        'index': index,
        'collection': collection,
        'controller': controller,
        'action': 'truncate',
      }, queuable: queuable);

  Future<Document> updateDocument(
    String documentId,
    Map<String, dynamic> content, {
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
    int retryOnConflict = 0,
  }) async =>
      throw ResponseError();

  Future<RawKuzzleResponse> updateSpecifications({
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  Future<bool> validateSpecifications(
    Specifications specifications, {
    bool queuable = true,
  }) async =>
      throw ResponseError();
}
