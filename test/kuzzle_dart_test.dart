import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  test('check admin', () async {
    expect(await kuzzleTestHelper.kuzzle.adminExists(), true);
  });

  test('get all statistics', () async {
    final stats = await kuzzleTestHelper.kuzzle.getAllStatistics();
    expect(stats.total, greaterThanOrEqualTo(1));
    expect(stats.hits[stats.total - 1].completedRequests.websocket,
        greaterThanOrEqualTo(1));
  });

  test('test for security constructor', () async {
    kuzzleTestHelper.kuzzle.security.role('id', <String, dynamic>{});
  });

  tearDownAll(kuzzleTestHelper.end);
}
