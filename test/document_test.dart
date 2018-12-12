import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('document', () {
    Collection collection;
    Document document;
    setUpAll(() async {
      await kuzzleTestHelper.kuzzle
          .createIndex(kuzzleTestHelper.kuzzle.defaultIndex);
      collection = kuzzleTestHelper.kuzzle.collection('posts');
      await collection.create();
    });

    test('count', () async {
      final count = await collection.count();
      expect(count, 0);
    });

    test('create', () async {
      document = await collection.createDocument(<String, dynamic>{
        'title': 'This is a test post',
      });
      expect(document.content, <String, dynamic>{
        'title': 'This is a test post',
      });
    });

    test('get', () async {
      final doc = await collection.fetchDocument(document.id);
      expect(doc.toMap(), document.toMap());
      expect(await collection.count(), equals(1));
    });

    test('update', () async {
      final isUpdated =
          await collection.updateDocument(document.id, <String, dynamic>{
        'foo': 'bar',
      });
      expect(isUpdated, true);
      expect(
          (await collection.fetchDocument(document.id)).content['foo'], 'bar');
    });

    test('exists', () async {
      expect(await document.exists(), true);
    });

    test('refresh', () async {
      expect(
          await collection.updateDocument(document.id, <String, dynamic>{
            'hello': 'world',
          }),
          true);
      await document.refresh();
      expect(document.content.containsKey('hello'), true);
    });

    test('save', () async {
      document.setContent(<String, dynamic>{
        'hello': 'bye',
      });
      await document.save();
    });

    test('publish', () async {
      expect(await document.publish(), true);
    });

    test('delete', () async {
      final documentId = await document.delete();
      expect(documentId, document.id);
    });

    test('delete by id', () async {
      final doc = await collection.createDocument(<String, dynamic>{
        'title': 'This is a test post',
      });
      final docId = await collection.deleteDocument(doc.id);
      expect(docId, doc.id);
    });

    test('search documents', () async {
      await collection.search();
    });

    test('scroll documents', () async {
      final scrollDocument = await collection.scroll('1');
      expect(scrollDocument.hits.length, 0);
    }, skip: 'Have to understand its working');

    test('validate document', () async {
      final isValid = await collection.validateDocument(<String, dynamic>{});
      expect(isValid, true);
      expect(await collection.count(), equals(0));
    });

    tearDownAll(() async {
      await kuzzleTestHelper.kuzzle
          .deleteIndex(kuzzleTestHelper.kuzzle.defaultIndex);
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
