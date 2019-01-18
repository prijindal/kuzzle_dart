import 'package:test/test.dart';
import 'package:kuzzle/kuzzle.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = Kuzzle(WebSocketProtocol('localhost'));
  setUpAll(() async {
    await connectKuzzle(kuzzle);
  });

  group('index', () {
    test('create', () async {
      final sharedAcknowledgedResponse =
          await kuzzle.index.create('justatestindex');
      expect(sharedAcknowledgedResponse['acknowledged'], true);
    });

    test('exists', () async {
      expect(await kuzzle.index.exists('justatestindex'), true);
    });

    test('get auto refresh', () async {
      expect(await kuzzle.index.getAutoRefresh('justatestindex'), false);
    });

    test('list', () async {
      expect(await kuzzle.index.list(), contains('justatestindex'));
    });

    test('refresh index', () async {
      final shards = await kuzzle.index.refresh('justatestindex');
      expect(shards['total'], 10);
    });

    test('set auto refresh', () async {
      expect(
          await kuzzle.index
              .setAutoRefresh('justatestindex', autoRefresh: false),
          false);
    });

    test('delete', () async {
      final acknowledgedResponse = await kuzzle.index.delete('justatestindex');
      expect(acknowledgedResponse['acknowledged'], true);
    });
  });

  tearDownAll(kuzzle.disconnect);
}
