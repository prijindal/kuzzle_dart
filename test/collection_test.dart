import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('collection', () {
    Collection collection;
    setUpAll(() async {
      await kuzzleTestHelper.kuzzle
          .createIndex(kuzzleTestHelper.kuzzle.defaultIndex);
      collection = kuzzleTestHelper.kuzzle.collection('posts');
    });
    test('creation', () async {
      final createdResponse =
          await collection.create(mapping: <String, MappingDefinition>{
        'title': MappingDefinition('', 'text', <String, dynamic>{}),
      });
      expect(createdResponse.acknowledged, true);
    });

    test('delete specification', () async {
      final deleteSpecificationsResponse =
          await collection.deleteSpecifications();
      expect(deleteSpecificationsResponse, true);
    });

    test('exists', () async {
      final existsCollection = await collection.exists();
      expect(existsCollection, true);
    });

    test('get mapping', () async {
      final collectionMapping = await collection.getMapping();
      expect(collectionMapping.mappings, <String, dynamic>{});
    });
    test('list all collections', () async {
      final listCollectionResponse = await kuzzleTestHelper.kuzzle
          .listCollections(kuzzleTestHelper.kuzzle.defaultIndex);
      expect(listCollectionResponse.length, greaterThanOrEqualTo(1));
      expect(listCollectionResponse[0].name, 'posts');
    });

    test('search specifications', () async {
      final searchSpecifications = await collection.searchSpecifications();
      expect(searchSpecifications.hits.length, greaterThanOrEqualTo(0));
      expect(searchSpecifications.shards.total, greaterThanOrEqualTo(0));
    });

    test('scroll specifications', () async {
      final scrollSpecifications = await collection.scrollSpecifications('abc');
      expect(scrollSpecifications.hits.length, greaterThanOrEqualTo(1));
      expect(
          scrollSpecifications.hits[0].source.validation, <String, dynamic>{});
    }, skip: 'Have to understand its working');

    test('truncate', () async {
      final ids = await collection.truncate();
      expect(ids.length, 0);
    });

    test('update specifications', () async {
      final oldSpecifications = Specifications(collection, <String, dynamic>{});
      final specifications =
          await collection.updateSpecifications(oldSpecifications);
      expect(specifications.validation, <String, dynamic>{'fields': {}});
    });

    test('get specifications', () async {
      final collectionSpecifications = await collection.getSpecifications();
      expect(collectionSpecifications.toMap(), {
        'index': collection.collectionName,
        'validation': {'fields': {}},
      });
      expect(
          collectionSpecifications.validation, <String, dynamic>{'fields': {}});
    });
    test('validate specifications', () async {
      final oldSpecifications = Specifications(collection);
      final isValid =
          await collection.validateSpecifications(oldSpecifications);
      expect(isValid.valid, true);
    });

    group('multiple crud', () {
      List<String> ids;

      test('multiple create', () async {
        final document1 = collection.document(content: {
          'hello': '1st document',
        });
        final document2 = collection.document(content: {
          'hello': '2nd document',
        });
        final documents =
            await collection.mCreateDocument([document1, document2]);
        expect(documents.length, equals(2));
        expect(documents[0].content, equals(document1.content));
        ids = documents.map((document) => document.id).toList();
      });
      test('multiple create or replace', () async {
        final document1 = collection.document(content: {
          'hello': '1st document',
        });
        final document2 = collection.document(content: {
          'hello': '2nd document',
        });
        final documents =
            await collection.mCreateOrReplaceDocument([document1, document2]);
        expect(documents.length, equals(2));
        expect(documents[0].content, equals(document1.content));
      });

      test('multiple replace', () async {
        final document1 = await collection.fetchDocument(ids[0]);
        final document2 = await collection.fetchDocument(ids[1]);
        final documents =
            await collection.mReplaceDocument([document1, document2]);
        expect(documents.length, equals(2));
        expect(documents[0].content, equals(document1.content));
      });

      test('multiple get and delete', () async {
        final document1 = collection.document(content: {
          'hello': '1st document',
        });
        final document2 = collection.document(content: {
          'hello': '2nd document',
        });
        final savedDocuments =
            await collection.mCreateDocument([document1, document2]);
        final documents = await collection.mGetDocument(
            savedDocuments.map((document) => document.id).toList());
        expect(documents.length, 2);
        expect(documents[0].content, equals(document1.content));

        final documentIds = await collection
            .mDeleteDocument(documents.map((document) => document.id).toList());
        expect(documentIds,
            equals(savedDocuments.map((document) => document.id).toList()));
      });
    });

    tearDownAll(() async {
      await kuzzleTestHelper.kuzzle
          .deleteIndex(kuzzleTestHelper.kuzzle.defaultIndex);
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
