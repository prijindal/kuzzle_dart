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
  });

  test('last staticstics', () async {
    final stat = await kuzzleTestHelper.kuzzle.getLastStatistics();
    expect(stat.timestamp, lessThan(DateTime.now().millisecondsSinceEpoch));
  });

  test('get config', () async {
    final config = await kuzzleTestHelper.kuzzle.getConfig();
    expect(config['services']['internalCache']['backend'], 'redis');
  });
  test('get server info', () async {
    final info = await kuzzleTestHelper.kuzzle.getServerInfo();
    expect(info.info.containsKey('api'), true);
  });

  test('get current time', () async {
    final now = await kuzzleTestHelper.kuzzle.now();
    expect(now, lessThanOrEqualTo(DateTime.now().millisecondsSinceEpoch));
  });

  test('test for security constructor', () async {
    kuzzleTestHelper.kuzzle.security.role('id', <String, dynamic>{});
  });

  tearDownAll(kuzzleTestHelper.end);
}
