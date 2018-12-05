import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;
  Kuzzle kuzzle;

  setUpAll(() async {
    server = await HttpServer.bind('localhost', 0);
    streamSubscription =
        server.transform(WebSocketTransformer()).listen(onServerTransformData);
    kuzzle = Kuzzle('localhost', port: server.port, defaultIndex: 'testindex');
  });

  test('Simple test for kuzzle connection', () async {
    await kuzzle.connect();
  });

  group('collection', () {
    Collection collection;
    setUpAll(() {
      collection = kuzzle.collection('posts');
    });
    test('creation', () async {
      final CreatedResponse createdResponse =
          await collection.create(mapping: <String, MappingDefinition>{
        'title': MappingDefinition('', 'text', <String, dynamic>{}),
      });
      expect(createdResponse.acknowledged, true);
    });

    test('delete specification', () async {
      final bool deleteSpecificationsResponse =
          await collection.deleteSpecifications();
      expect(deleteSpecificationsResponse, true);
    });

    test('exists', () async {
      final bool existsCollection = await collection.exists();
      expect(existsCollection, true);
    });

    test('get mapping', () async {
      final CollectionMapping collectionMapping = await collection.getMapping();
      expect(collectionMapping.mappings, <String, dynamic>{});
    });

    test('get specifications', () async {
      final Specifications collectionSpecifications =
          await collection.getSpecifications();
      expect(collectionSpecifications.validation, <String, dynamic>{});
    });

    test('list all collections', () async {
      final List<ListCollectionResponse> listCollectionResponse =
          await kuzzle.listCollections(kuzzle.defaultIndex);
      expect(listCollectionResponse.length, greaterThanOrEqualTo(1));
      expect(listCollectionResponse[0].name, 'posts');
    });

    test('scroll specifications', () async {
      final ScrollResponse<Map<String, dynamic>> scrollSpecifications =
          await collection.scrollSpecifications('abc');
      expect(scrollSpecifications.hits.length, greaterThanOrEqualTo(1));
      // expect(scrollSpecifications.hits[0], <String, dynamic>{
      //   '_index': kuzzle.defaultIndex,
      // });
    });
  });

  test('test for security constructor', () async {
    kuzzle.security.role('id', <String, dynamic>{});
  });

  test('test for disconnection', () {
    kuzzle.disconect();
  });

  tearDownAll(() {
    kuzzle.disconect();
    streamSubscription.cancel();
    server.close(force: true);
  });
}
