import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('memory storage', () {
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

    test('expireat', () async {
      expect(await memoryStorage.expireat('num2', 200), 1);
    });

    group('geoposition', () {
      GeoPositionPoint point1;
      GeoPositionPoint point2;
      test('geoadd', () async {
        point1 = GeoPositionPoint(lon: 1, lat: 2, name: 'First position');
        point2 = GeoPositionPoint(lon: 5, lat: 1, name: 'Second position');
        expect(await memoryStorage.geoadd('num1', [point1, point2]), 2);
      });

      test('geodist', () async {
        expect(await memoryStorage.geodist('num1', point1.name, point2.name),
            equals(458444.3246));
      });

      test('geohash', () async {
        expect(
            (await memoryStorage.geohash('num1', [point1.name, point2.name]))
                .length,
            2);
      });

      test('geopos', () async {
        final gepositions =
            await memoryStorage.geopos('num1', [point1.name, point2.name]);
        expect(gepositions.length, equals(2));
      });

      test('georadius', () async {
        expect(await memoryStorage.georadius('num1', point1.lat, point2.lon, 5),
            []);
      });

      test('georadiusbymember', () async {
        expect(await memoryStorage.georadiusbymember('num1', point1.name, 5),
            [point1.name]);
      });
    });

    test('getbit', () async {
      expect(await memoryStorage.getbit('foo', 1), 1);
    });

    test('getrange', () async {
      expect(await memoryStorage.getrange('foo', 1, 2), 'ar');
    });

    test('getset', () async {
      expect(await memoryStorage.getset('foo', 'newbar'), 'bar');
    });

    group('hash', () {
      test('hset', () async {
        expect(await memoryStorage.hset('hash1', 'h1', 5), 1);
      });

      test('hexists', () async {
        expect(await memoryStorage.hexists('hash1', 'h1'), 1);
      });
      test('hget', () async {
        expect(await memoryStorage.hget('hash1', 'h1'), '5');
      });

      test('hgetall', () async {
        expect(await memoryStorage.hgetall('hash1'), {'h1': '5'});
      });

      test('hincrby', () async {
        expect(await memoryStorage.hincrby('hash1', 'h1'), 6);
      });

      test('hincrbyfloat', () async {
        expect(await memoryStorage.hset('hash1', 'h2', 5.5), 1);
        expect(
            await memoryStorage.hincrbyfloat('hash1', 'h2', value: 0.1), '5.6');
      });

      test('hkeys', () async {
        expect(await memoryStorage.hkeys('hash1'), ['h1', 'h2']);
      });

      test('hlen', () async {
        expect(await memoryStorage.hlen('hash1'), 2);
      });

      test('hdel', () async {
        expect(await memoryStorage.hdel('hash1', ['h2']), 1);
      });

      test('hmget', () async {
        expect(await memoryStorage.hmget('hash1', ['h1']), ['6']);
      });

      test('hmset', () async {
        expect(await memoryStorage.hmset('hash1', {'h1': 2}), 'OK');
      });

      test('hscan', () async {
        expect(await memoryStorage.hscan('hash1', '', '', ''), 1);
      }, skip: 'Have to understand the implementation');

      test('hsetnx', () async {
        expect(await memoryStorage.hsetnx('hash1', 'h1', ''), 0);
        expect(await memoryStorage.hsetnx('hash1', 'h2', '5'), 1);
      });

      test('hstrlen', () async {
        expect(await memoryStorage.hstrlen('hash1', 'h1'), 1);
      });

      test('hvals', () async {
        expect(await memoryStorage.hvals('hash1'), ['2', '5']);
      });
    });
    test('incr', () async {
      expect(await memoryStorage.set('num1', '2'), 'OK');
      expect(await memoryStorage.incr('num1'), 3);
      expect(await memoryStorage.get('num1'), '3');
    });

    test('incrby', () async {
      expect(await memoryStorage.set('num1', '2'), 'OK');
      expect(await memoryStorage.incrby('num1', 4), 6);
      expect(await memoryStorage.get('num1'), '6');
    });

    test('incrbyfloat', () async {
      expect(await memoryStorage.set('num1', '2'), 'OK');
      expect(await memoryStorage.incrbyfloat('num1', 0.1), 2.1);
      expect(await memoryStorage.get('num1'), '2.1');
    });

    test('keys', () async {
      final keys = await memoryStorage.keys()
        ..sort();
      expect(keys, ['foo', 'hash1', 'hello', 'num1', 'num3']);
    });

    group('list', () {
      setUpAll(() async {
        expect(await memoryStorage.lpush('list1', [1]), 1);
      });
      test('lindex', () async {
        expect(await memoryStorage.lindex('list1', 0), 1);
      }, skip: 'Maybe an issue with kuzzle?');

      test('linsert', () async {
        expect(await memoryStorage.linsert('list1', 1, 2), 2);
      });

      test('llen', () async {
        expect(await memoryStorage.llen('list1'), 2);
      });

      test('lpop', () async {
        expect(await memoryStorage.lpop('list1'), '2');
      });

      test('lpush', () async {
        expect(await memoryStorage.lpush('list1', [55, 89]), 3);
      });

      test('lpushx', () async {
        expect(await memoryStorage.lpushx('list2', 3), 0);
        expect(await memoryStorage.lpushx('list1', 2), 4);
      });

      test('lrange', () async {
        expect(await memoryStorage.lrange('list1', 1, 2), ['89', '55']);
      });

      test('lrem', () async {
        expect(await memoryStorage.lrem('list1', '2', 0), 1);
      });

      test('lset', () async {
        expect(await memoryStorage.lset('list1', 4, 2), 'OK');
      });

      test('ltrim', () async {
        expect(await memoryStorage.ltrim('list1', 1, 2), 'OK');
      });
    });
    group('multiple', () {
      test('mset', () async {
        expect(await memoryStorage.mset({'mul1': 4, 'mul2': 5}), 'OK');
      });
      test('mget', () async {
        expect(await memoryStorage.mget(['mul1', 'mul2']), ['4', '5']);
      });

      test('msetnx', () async {
        expect(await memoryStorage.msetnx({'mul2': 8, 'mul3': 3}), 0);
        expect(await memoryStorage.msetnx({'mul3': 3}), 1);
      });
    });
    test('object', () async {
      expect(await memoryStorage.object('num1', 'refcount'), 1);
      expect(await memoryStorage.object('num1', 'encoding'), 'embstr');
      expect(await memoryStorage.object('num1', 'idletime'), 0);
    });

    test('ping', () async {
      expect(await memoryStorage.ping(), 'PONG');
    });

    group('persist', () {
      test('persist', () async {
        expect(await memoryStorage.persist('num1'), 1);
      });

      test('pexpire', () async {
        expect(await memoryStorage.pexpire('num1'), 1);
      });

      test('pexpireat', () async {
        expect(await memoryStorage.pexpireat('num1'), 1);
      });

      test('pfadd', () async {
        expect(await memoryStorage.pfadd('num1'), 1);
      });

      test('pfcount', () async {
        expect(await memoryStorage.pfcount('num1'), 1);
      });

      test('pfmerge', () async {
        expect(await memoryStorage.pfmerge('num1'), 1);
      });

      test('psetex', () async {
        expect(await memoryStorage.psetex('num1'), 1);
      });

      test('pttl', () async {
        expect(await memoryStorage.pttl('num1'), 1);
      });
    }, skip: 'Not implemented yet');
    group('skip', () {
      test('randomkey', () async {
        expect(await memoryStorage.randomkey('num1'), 1);
      });

      test('rename', () async {
        expect(await memoryStorage.rename('num1'), 1);
      });

      test('renamenx', () async {
        expect(await memoryStorage.renamenx('num1'), 1);
      });

      test('rpop', () async {
        expect(await memoryStorage.rpop('num1'), 1);
      });

      test('rpoplpush', () async {
        expect(await memoryStorage.rpoplpush('num1'), 1);
      });

      test('rpush', () async {
        expect(await memoryStorage.rpush('num1'), 1);
      });

      test('rpushx', () async {
        expect(await memoryStorage.rpushx('num1'), 1);
      });

      test('sadd', () async {
        expect(await memoryStorage.sadd('num1'), 1);
      });

      test('scan', () async {
        expect(await memoryStorage.scan('num1'), 1);
      });

      test('scard', () async {
        expect(await memoryStorage.scard('num1'), 1);
      });

      test('sdiff', () async {
        expect(await memoryStorage.sdiff('num1'), 1);
      });

      test('sdiffstore', () async {
        expect(await memoryStorage.sdiffstore('num1'), 1);
      });

      test('setex', () async {
        expect(await memoryStorage.setex('num1'), 1);
      });

      test('setnx', () async {
        expect(await memoryStorage.setnx('num1'), 1);
      });

      test('sinter', () async {
        expect(await memoryStorage.sinter('num1'), 1);
      });

      test('sinterstore', () async {
        expect(await memoryStorage.sinterstore('num1'), 1);
      });

      test('sismember', () async {
        expect(await memoryStorage.sismember('num1'), 1);
      });

      test('smembers', () async {
        expect(await memoryStorage.smembers('num1'), 1);
      });

      test('smove', () async {
        expect(await memoryStorage.smove('num1'), 1);
      });

      test('sort', () async {
        expect(await memoryStorage.sort('num1'), 1);
      });

      test('spop', () async {
        expect(await memoryStorage.spop('num1'), 1);
      });

      test('srandmember', () async {
        expect(await memoryStorage.srandmember('num1'), 1);
      });

      test('srem', () async {
        expect(await memoryStorage.srem('num1'), 1);
      });

      test('sscan', () async {
        expect(await memoryStorage.sscan('num1'), 1);
      });

      test('strlen', () async {
        expect(await memoryStorage.strlen('num1'), 1);
      });

      test('sunion', () async {
        expect(await memoryStorage.sunion('num1'), 1);
      });

      test('sunionstore', () async {
        expect(await memoryStorage.sunionstore('num1'), 1);
      });

      test('time', () async {
        expect(await memoryStorage.time('num1'), 1);
      });

      test('touch', () async {
        expect(await memoryStorage.touch('num1'), 1);
      });

      test('ttl', () async {
        expect(await memoryStorage.ttl('num1'), 1);
      });

      test('type', () async {
        expect(await memoryStorage.type('num1'), 1);
      });

      test('zadd', () async {
        expect(await memoryStorage.zadd('num1'), 1);
      });

      test('zcard', () async {
        expect(await memoryStorage.zcard('num1'), 1);
      });

      test('zcount', () async {
        expect(await memoryStorage.zcount('num1'), 1);
      });

      test('zincrby', () async {
        expect(await memoryStorage.zincrby('num1'), 1);
      });

      test('zinterstore', () async {
        expect(await memoryStorage.zinterstore('num1'), 1);
      });

      test('zlexcount', () async {
        expect(await memoryStorage.zlexcount('num1'), 1);
      });

      test('zrange', () async {
        expect(await memoryStorage.zrange('num1'), 1);
      });

      test('zrangebylex', () async {
        expect(await memoryStorage.zrangebylex('num1'), 1);
      });

      test('zrangebyscore', () async {
        expect(await memoryStorage.zrangebyscore('num1'), 1);
      });

      test('zrank', () async {
        expect(await memoryStorage.zrank('num1'), 1);
      });

      test('zrem', () async {
        expect(await memoryStorage.zrem('num1'), 1);
      });

      test('zremrangebylex', () async {
        expect(await memoryStorage.zremrangebylex('num1'), 1);
      });

      test('zremrangebyrank', () async {
        expect(await memoryStorage.zremrangebyrank('num1'), 1);
      });

      test('zremrangebyscore', () async {
        expect(await memoryStorage.zremrangebyscore('num1'), 1);
      });

      test('zrevrange', () async {
        expect(await memoryStorage.zrevrange('num1'), 1);
      });

      test('zrevrangebylex', () async {
        expect(await memoryStorage.zrevrangebylex('num1'), 1);
      });

      test('zrevrangebyscore', () async {
        expect(await memoryStorage.zrevrangebyscore('num1'), 1);
      });

      test('zrevrank', () async {
        expect(await memoryStorage.zrevrank('num1'), 1);
      });

      test('zscan', () async {
        expect(await memoryStorage.zscan('num1'), 1);
      });

      test('zscore', () async {
        expect(await memoryStorage.zscore('num1'), 1);
      });

      test('zunionstore', () async {
        expect(await memoryStorage.zunionstore('num1'), 1);
      });
    }, skip: 'Not implemented yet');

    tearDownAll(() async {
      await memoryStorage.flushdb();
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
