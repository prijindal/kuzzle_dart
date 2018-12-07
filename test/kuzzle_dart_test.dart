import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  final KuzzleTestHelper kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
  });

  test('create index', () async {
    await kuzzleTestHelper.kuzzle
        .createIndex(kuzzleTestHelper.kuzzle.defaultIndex);
  });

  test('test for security constructor', () async {
    kuzzleTestHelper.kuzzle.security.role('id', <String, dynamic>{});
  });

  tearDownAll(() {
    kuzzleTestHelper.end();
  });
}
