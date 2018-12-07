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
    setUpAll(() {
      collection = kuzzleTestHelper.kuzzle.collection('posts');
    });

    test('count', () async {
      final int count = await collection.count();
      expect(count, 1);
    });

    test('create', () async {
      final Document document =
          await collection.createDocument(<String, dynamic>{
        'title': 'This is a test post',
      });
      expect(document.content, <String, dynamic>{
        'title': 'This is a test post',
      });
    });
  });

  tearDownAll(() {
    kuzzleTestHelper.end();
  });
}
