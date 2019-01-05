import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = TestKuzzle();
  setUpAll(() async {
    await kuzzle.connect();
    kuzzle.defaultIndex = Uuid().v1();
  });

  group('index', () {
    test('create', () async {
      final sharedAcknowledgedResponse =
          await kuzzle.createIndex('justatestindex');
      expect(sharedAcknowledgedResponse.acknowledged, true);
    });

    test('exists', () async {
      expect(await kuzzle.existsIndex('justatestindex'), true);
    });

    test('get auto refresh', () async {
      expect(await kuzzle.getAutoRefresh(index: 'justatestindex'), false);
    });

    test('list', () async {
      expect(await kuzzle.listIndexes(), contains('justatestindex'));
    });

    test('refresh index', () async {
      final shards = await kuzzle.refreshIndex('justatestindex');
      expect(shards.total, 10);
    });

    test('set auto refresh', () async {
      expect(
          await kuzzle.setAutoRefresh(
              autoRefresh: false, index: 'justatestindex'),
          false);
    });

    test('delete', () async {
      final acknowledgedResponse = await kuzzle.deleteIndex('justatestindex');
      expect(acknowledgedResponse.acknowledged, true);
    });
  });

  tearDownAll(kuzzle.disconnect);
}
