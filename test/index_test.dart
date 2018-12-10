import 'package:test/test.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final KuzzleTestHelper kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
  });

  group('index', () {
    test('create', () async {
      final SharedAcknowledgedResponse sharedAcknowledgedResponse =
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
          <String>['justatestindex']);
    });

    test('refresh index', () async {
      final Shards shards =
          await kuzzleTestHelper.kuzzle.refreshIndex('justatestindex');
      expect(shards.total, 10);
    });

    test('set auto refresh', () async {
      expect(
          await kuzzleTestHelper.kuzzle
              .setAutoRefresh(false, index: 'justatestindex'),
          false);
    });

    test('delete', () async {
      final AcknowledgedResponse acknowledgedResponse =
          await kuzzleTestHelper.kuzzle.deleteIndex('justatestindex');
      expect(acknowledgedResponse.acknowledged, true);
    });
  });

  tearDownAll(() {
    kuzzleTestHelper.end();
  });
}
