import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('document', () {
    MemoryStorage memoryStorage;
    setUpAll(() async {
      memoryStorage = kuzzleTestHelper.kuzzle.memoryStorage;
    });

    test('append', () async {
      expect(await memoryStorage.append('foo', 'bar'), equals(3));
      expect(await memoryStorage.append('hello', 'world'), equals(5));
    });

    test('bitcount', () async {
      expect(await memoryStorage.bitcount('foo'), equals(10));
    });

    group('bitop operations', () {
      setUpAll(() async {
        expect(await memoryStorage.set('num1', '2'), equals('OK'));
        expect(await memoryStorage.set('num2', '4'), equals('OK'));
      });

      test('AND', () async {
        expect(await memoryStorage.bitop('num3', 'AND', ['num1', 'num2']),
            equals(1));
        expect(await memoryStorage.get('num3'), equals('0'));
      });

      test('OR', () async {
        expect(await memoryStorage.bitop('num3', 'OR', ['num1', 'num2']),
            equals(1));
        expect(await memoryStorage.get('num3'), equals('6'));
      });
    });

    test('bitpos', () async {
      expect(await memoryStorage.bitpos('foo'), equals(1));
    });

    test('dbsize', () async {
      expect(await memoryStorage.dbsize(), equals(5));
    });

    test('decr', () async {
      expect(await memoryStorage.set('num2', '4'), 'OK');
      expect(await memoryStorage.decr('num2'), equals(3));
    });

    test('decrby', () async {
      expect(await memoryStorage.set('num2', '4'), 'OK');
      expect(await memoryStorage.decrby('num2', 5), equals(-1));
    });

    test('del', () async {
      expect(await memoryStorage.del(['num1', 'num2']), equals(2));
    });

    test('exists', () async {
      expect(await memoryStorage.exists(['num1', 'num2']), equals(0));
      expect(await memoryStorage.set('num2', '4'), 'OK');
      expect(await memoryStorage.exists(['num1', 'num2']), equals(1));
    });

    test('expire', () async {
      expect(await memoryStorage.expire('num2', 200), 1);
    });

    test('expexpireatire', () async {
      expect(await memoryStorage.expireat('num2', 200), 1);
    });

    tearDownAll(() async {
      await memoryStorage.flushdb();
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
