import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'test_helpers.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('index', () {
    test('create', () async {
      final sharedAcknowledgedResponse =
          await kuzzleTestHelper.kuzzle.createIndex('justatestindex');
      expect(sharedAcknowledgedResponse.acknowledged, true);
    });

    test('exists', () async {
      expect(await kuzzleTestHelper.kuzzle.existsIndex('justatestindex'), true);
    });

    test('get auto refresh', () async {
      expect(
          await kuzzleTestHelper.kuzzle.getAutoRefresh(index: 'justatestindex'),
          false);
    });

    test('list', () async {
      expect(await kuzzleTestHelper.kuzzle.listIndexes(),
          contains('justatestindex'));
    });

    test('refresh index', () async {
      final shards =
          await kuzzleTestHelper.kuzzle.refreshIndex('justatestindex');
      expect(shards.total, 10);
    });

    test('set auto refresh', () async {
      expect(
          await kuzzleTestHelper.kuzzle
              .setAutoRefresh(autoRefresh: false, index: 'justatestindex'),
          false);
    });

    test('delete', () async {
      final acknowledgedResponse =
          await kuzzleTestHelper.kuzzle.deleteIndex('justatestindex');
      expect(acknowledgedResponse.acknowledged, true);
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
