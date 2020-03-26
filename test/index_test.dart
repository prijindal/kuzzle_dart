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
      final response = await kuzzle.index.create('justatestindex');
      expect(response['acknowledged'], true);
    });

    test('exists', () async {
      expect(await kuzzle.index.exists('justatestindex'), true);
    });

    test('list', () async {
      expect(await kuzzle.index.list(), contains('justatestindex'));
    });

    test('delete', () async {
      final response = await kuzzle.index.delete('justatestindex');
      expect(response, true);
    });
  });

  tearDownAll(kuzzle.disconnect);
}
