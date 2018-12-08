import 'package:test/test.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final KuzzleTestHelper kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
  });

  group('collection', () {
    Collection collection;
    setUpAll(() async {
      await kuzzleTestHelper.kuzzle
          .createIndex(kuzzleTestHelper.kuzzle.defaultIndex);
      collection = kuzzleTestHelper.kuzzle.collection('posts');
    });
    test('creation', () async {
      final AcknowledgedResponse createdResponse =
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
          await kuzzleTestHelper.kuzzle
              .listCollections(kuzzleTestHelper.kuzzle.defaultIndex);
      expect(listCollectionResponse.length, greaterThanOrEqualTo(1));
      expect(listCollectionResponse[0].name, 'posts');
    });

    test('scroll specifications', () async {
      final ScrollResponse<ScrollSpecificationHit> scrollSpecifications =
          await collection.scrollSpecifications('abc');
      expect(scrollSpecifications.hits.length, greaterThanOrEqualTo(1));
      expect(
          scrollSpecifications.hits[0].source.validation, <String, dynamic>{});
    });

    test('search specifications', () async {
      final SearchResponse<ScrollSpecificationHit> searchSpecifications =
          await collection.searchSpecifications();
      expect(searchSpecifications.hits.length, greaterThanOrEqualTo(1));
      expect(searchSpecifications.shards.total, greaterThanOrEqualTo(1));
      expect(
          searchSpecifications.hits[0].source.validation, <String, dynamic>{});
    });

    test('truncate', () async {
      final AcknowledgedResponse acknowledgedResponse =
          await collection.truncate();
      expect(acknowledgedResponse.acknowledged, true);
    });

    test('update specifications', () async {
      final Specifications oldSpecifications = Specifications(collection);
      final Specifications specifications =
          await collection.updateSpecifications(oldSpecifications);
      expect(specifications.validation, <String, dynamic>{});
    });

    test('validate specifications', () async {
      final Specifications oldSpecifications = Specifications(collection);
      final ValidResponse isValid =
          await collection.validateSpecifications(oldSpecifications);
      expect(isValid.valid, true);
    });

    tearDownAll(() async {
      await kuzzleTestHelper.kuzzle
          .deleteIndex(kuzzleTestHelper.kuzzle.defaultIndex);
    });
  });

  tearDownAll(() {
    kuzzleTestHelper.end();
  });
}
