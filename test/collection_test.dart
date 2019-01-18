import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:kuzzle/kuzzle.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = Kuzzle(WebSocketProtocol('localhost'));
  String defaultIndex;
  String defaultCollection;
  setUpAll(() async {
    await connectKuzzle(kuzzle);
    await kuzzle.auth.login('local', adminCredentials);
    defaultIndex = Uuid().v1() as String;
    defaultCollection = 'posts';
  });

  group('collection', () {
    setUpAll(() async {
      await kuzzle.index.create(defaultIndex);
    });
    test('creation', () async {
      final createdResponse = await kuzzle.collection
          .create(defaultIndex, defaultCollection, mapping: {'title': {}});
      expect(createdResponse['acknowledged'], true);
    });

    test('delete specification', () async {
      final deleteSpecificationsResponse = await kuzzle.collection
          .deleteSpecifications(defaultIndex, defaultCollection);
      expect(deleteSpecificationsResponse['acknowledged'], true);
    });

    test('exists', () async {
      final existsCollection =
          await kuzzle.collection.exists(defaultIndex, defaultCollection);
      expect(existsCollection, true);
    });

    test('get mapping', () async {
      final collectionMapping =
          await kuzzle.collection.getMapping(defaultIndex, defaultCollection);
      expect(
          collectionMapping[defaultIndex]['mappings'][defaultCollection]
              ['properties'],
          <String, dynamic>{});
    });
    test('list all collections', () async {
      final listCollectionResponse = await kuzzle.collection.list(defaultIndex);
      print(listCollectionResponse);
      expect(listCollectionResponse['collections'].length,
          greaterThanOrEqualTo(1));
      expect(
          listCollectionResponse['collections'][0]['name'], defaultCollection);
    });

    test('search specifications', () async {
      final searchSpecifications =
          await kuzzle.collection.searchSpecifications(defaultIndex);
      expect(searchSpecifications.hits.length, greaterThanOrEqualTo(0));
    });

    test('truncate', () async {
      final ids =
          await kuzzle.collection.truncate(defaultIndex, defaultCollection);
      expect(ids.length, 1);
    });

    test('update specifications', () async {
      final specifications = await kuzzle.collection
          .updateSpecifications(defaultIndex, defaultCollection, {});
      expect(specifications, <String, dynamic>{});
    });

    test('get specifications', () async {
      final collectionSpecifications = await kuzzle.collection
          .getSpecifications(defaultIndex, defaultCollection);
      expect(collectionSpecifications, {
        'validation': {},
        'index': defaultIndex,
        'collection': defaultCollection,
      });
      expect(collectionSpecifications['validation'], <String, dynamic>{});
    });
    test('validate specifications', () async {
      final isValid = await kuzzle.collection
          .validateSpecifications(defaultIndex, defaultCollection, {});
      expect(isValid['valid'], true);
    });

    tearDownAll(() async {
      await kuzzle.index.delete(defaultIndex);
    });
  });

  tearDownAll(kuzzle.disconnect);
}
