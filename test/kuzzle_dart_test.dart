import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:kuzzle/kuzzle_dart.dart' as kuzzle_dart;

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = TestKuzzle();
  var isConnectedEventCalled = false;

  setUpAll(() async {
    kuzzle.on<kuzzle_dart.ConnectedEvent>().listen((event) {
      isConnectedEventCalled = true;
    });
    
    await kuzzle.connect();
    kuzzle.defaultIndex = Uuid().v1();
  });

  test('check admin', () async {
    expect(await kuzzle.adminExists(), true);
  });

  test('check ConnectedEvent called', () {
    expect(isConnectedEventCalled, true);
  });

  test('get all statistics', () async {
    final stats = await kuzzle.getAllStatistics();
    expect(stats.total, greaterThanOrEqualTo(1));
  });

  test('last staticstics', () async {
    final stat = await kuzzle.getLastStatistics();
    expect(stat.timestamp, lessThan(DateTime.now().millisecondsSinceEpoch));
  });

  test('get config', () async {
    final config = await kuzzle.getConfig();
    expect(config['services']['internalCache']['backend'], 'redis');
  });

  test('get server info', () async {
    final info = await kuzzle.getServerInfo();
    expect(info.info.containsKey('api'), true);
  });

  test('get current time', () async {
    final now = await kuzzle.now();
    expect(now, lessThanOrEqualTo(DateTime.now().millisecondsSinceEpoch));
  });

  test('test for security constructor', () async {
    kuzzle.security.role('id', <String, dynamic>{});
  });

  tearDownAll(kuzzle.disconnect);
}
