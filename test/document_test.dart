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
    Document document;
    setUpAll(() {
      collection = kuzzleTestHelper.kuzzle.collection('posts');
      document = collection.document();
    });

    test('count', () async {
      final int count = await collection.count();
      expect(count, 1);
    });
  });

  tearDownAll(() {
    kuzzleTestHelper.end();
  });
}
