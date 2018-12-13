import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  test('create index', () async {
    await kuzzleTestHelper.kuzzle
        .createIndex(kuzzleTestHelper.kuzzle.defaultIndex);
  });

  test('test for security constructor', () async {
    kuzzleTestHelper.kuzzle.security.role('id', <String, dynamic>{});
  });

  tearDownAll(kuzzleTestHelper.end);
}
