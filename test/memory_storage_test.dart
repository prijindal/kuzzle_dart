import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = TestKuzzle();
  setUpAll(() async {
    await kuzzle.connect();
    kuzzle.defaultIndex = Uuid().v1();
  });

  group('memory storage', () {
    MemoryStorage memoryStorage;
    setUpAll(() async {
      memoryStorage = kuzzle.memoryStorage;
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
        expect(
            await memoryStorage.bitop('num3', 'AND', <String>['num1', 'num2']),
            equals(1));
        expect(await memoryStorage.get('num3'), equals('0'));
      });

      test('OR', () async {
        expect(
            await memoryStorage.bitop('num3', 'OR', <String>['num1', 'num2']),
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
      expect(await memoryStorage.del(<String>['num1', 'num2']), equals(2));
    });

    test('exists', () async {
      expect(await memoryStorage.exists(<String>['num1', 'num2']), equals(0));
      expect(await memoryStorage.set('num2', '4'), 'OK');
      expect(await memoryStorage.exists(<String>['num1', 'num2']), equals(1));
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
        expect(
            await memoryStorage
                .geoadd('num1', <GeoPositionPoint>[point1, point2]),
            2);
      });

      test('geodist', () async {
        expect(await memoryStorage.geodist('num1', point1.name, point2.name),
            equals(458444.3246));
      });

      test('geohash', () async {
        expect(
            (await memoryStorage
                    .geohash('num1', <String>[point1.name, point2.name]))
                .length,
            2);
      });

      test('geopos', () async {
        final gepositions = await memoryStorage
            .geopos('num1', <String>[point1.name, point2.name]);
        expect(gepositions.length, equals(2));
      });

      test('georadius', () async {
        expect(await memoryStorage.georadius('num1', point1.lat, point2.lon, 5),
            <int>[]);
      });

      test('georadiusbymember', () async {
        expect(await memoryStorage.georadiusbymember('num1', point1.name, 5),
            <String>[point1.name]);
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
        expect(
            await memoryStorage.hgetall('hash1'), <String, dynamic>{'h1': '5'});
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
        expect(await memoryStorage.hkeys('hash1'), <String>['h1', 'h2']);
      });

      test('hlen', () async {
        expect(await memoryStorage.hlen('hash1'), 2);
      });

      test('hdel', () async {
        expect(await memoryStorage.hdel('hash1', <String>['h2']), 1);
      });

      test('hmget', () async {
        expect(
            await memoryStorage.hmget('hash1', <String>['h1']), <String>['6']);
      });

      test('hmset', () async {
        expect(await memoryStorage.hmset('hash1', <String, dynamic>{'h1': 2}),
            'OK');
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
        expect(await memoryStorage.hvals('hash1'), <String>['2', '5']);
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
      final keys = await memoryStorage.keys();
      expect(
          keys, containsAll(<String>['foo', 'hash1', 'hello', 'num1', 'num3']));
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
        expect(await memoryStorage.lset('list1', 2, 4), 'OK');
      });

      test('ltrim', () async {
        expect(await memoryStorage.ltrim('list1', 1, 2), 'OK');
      });

      test('rpop', () async {
        expect(await memoryStorage.rpop('list1'), '4');
      });

      test('rpoplpush', () async {
        expect(await memoryStorage.rpoplpush('list1', 'list2'), '55');
      });

      test('rpush', () async {
        expect(await memoryStorage.rpush('list1', [2, 3]), 2);
      });

      test('rpushx', () async {
        expect(await memoryStorage.rpushx('list1', 4), 3);
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
      expect(
          await memoryStorage.object('num1', 'idletime'), lessThanOrEqualTo(1));
    });

    test('ping', () async {
      expect(await memoryStorage.ping(), 'PONG');
    });

    group('persist', () {
      test('pexpire', () async {
        expect(await memoryStorage.pexpire('num1', 200), 1);
      });

      test('pexpireat', () async {
        expect(await memoryStorage.pexpireat('num1', 100201210), 1);
      });

      test('psetex', () async {
        expect(await memoryStorage.psetex('num1', 4, 200), 'OK');
      });

      test('pttl', () async {
        expect(await memoryStorage.pttl('num1'), lessThanOrEqualTo(200));
      });

      test('persist', () async {
        expect(await memoryStorage.persist('num1'), 1);
      });
    });

    group('HyperLogLog', () {
      test('pfadd', () async {
        expect(await memoryStorage.pfadd('hyperlog1', ['hlog1', 'hlog2']), 1);
      });

      test('pfcount', () async {
        expect(await memoryStorage.pfcount(['hyperlog1']), 2);
      });

      test('pfmerge', () async {
        expect(await memoryStorage.pfmerge('hyperlog1', ['hyperlog2']), 'OK');
      });
    });
    test('randomkey', () async {
      final keys = await memoryStorage.keys();
      final randomKey = await memoryStorage.randomkey();
      expect(keys.indexOf(randomKey), greaterThanOrEqualTo(0));
    });

    test('rename', () async {
      expect(await memoryStorage.rename('num1', 'number1'), 'OK');
    });

    test('renamenx', () async {
      expect(await memoryStorage.renamenx('number1', 'num1'), 1);
    });
    test('setex', () async {
      expect(await memoryStorage.setex('temp1', 2, 300), 'OK');
    });

    test('setnx', () async {
      expect(await memoryStorage.setnx('num1', 4), 0);
      expect(await memoryStorage.setnx('num7', 4), 1);
    });
    group('sets', () {
      test('sadd', () async {
        expect(await memoryStorage.sadd('set1', ['svalue1', 'svalue2']), 2);
      });

      test('scan', () async {
        expect(await memoryStorage.scan('num1'), 1);
      }, skip: 'Not implemented yet');

      test('scard', () async {
        expect(await memoryStorage.scard('set1'), 2);
      });

      test('sdiff', () async {
        expect(await memoryStorage.sadd('set2', ['svalue3', 'svalue4']), 2);
        expect(await memoryStorage.sadd('set3', ['svalue1', 'svalue3']), 2);
        expect(await memoryStorage.sdiff('set1', ['set2']),
            containsAll(['svalue1', 'svalue2']));
        expect(await memoryStorage.sdiff('set1', ['set3']),
            containsAll(['svalue2']));
      });

      test('sdiffstore', () async {
        expect(await memoryStorage.sdiffstore('set1', ['set3'], 'set4'), 1);
      });

      test('sinter', () async {
        expect(await memoryStorage.sinter(['set1', 'set2']), []);
        expect(await memoryStorage.sinter(['set1', 'set3']), ['svalue1']);
      });

      test('sinterstore', () async {
        expect(await memoryStorage.sinterstore(['set1', 'set2'], 'set5'), 0);
      });

      test('sismember', () async {
        expect(await memoryStorage.sismember('set1', 'svalue3'), 0);
        expect(await memoryStorage.sismember('set1', 'svalue1'), 1);
      });

      test('smembers', () async {
        expect(await memoryStorage.smembers('set1'),
            containsAll(['svalue1', 'svalue2']));
      });

      test('smove', () async {
        expect(await memoryStorage.smove('set4', 'svalue2', 'set5'), 1);
      });

      test('sort', () async {
        expect(await memoryStorage.sort('set1', direction: 'DESC'),
            ['svalue2', 'svalue1']);
      });

      test('spop', () async {
        final value = await memoryStorage.spop('set1');
        expect(
            ['svalue1', 'svalue2'].indexOf(value[0]), greaterThanOrEqualTo(0));
      });

      test('srandmember', () async {
        final value = await memoryStorage.srandmember('set1');
        expect(['svalue1', 'svalue2'].indexOf(value), greaterThanOrEqualTo(0));
      });

      test('srem', () async {
        expect(await memoryStorage.srem('set5', ['svalue2']), 1);
      });

      test('sscan', () async {
        expect(await memoryStorage.sscan('set1'), 1);
      }, skip: 'Not implemented yet');

      test('strlen', () async {
        expect(await memoryStorage.strlen('num1'), 1);
      });

      test('sunion', () async {
        expect(await memoryStorage.sadd('set1', ['svalue1', 'svalue2']), 1);
        expect(await memoryStorage.sadd('set2', ['svalue3', 'svalue4']), 0);
        expect(await memoryStorage.sadd('set3', ['svalue1', 'svalue3']), 0);
        expect(await memoryStorage.sunion(['set1', 'set3']),
            containsAll(['svalue1', 'svalue3', 'svalue2']));
      });

      test('sunionstore', () async {
        expect(await memoryStorage.sunionstore(['set1', 'set3'], 'set6'), 3);
      });
    });
    test('time', () async {
      final time = await memoryStorage.time();
      expect(time[0],
          (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString());
    });

    test('touch', () async {
      expect(await memoryStorage.touch(['num1', 'num2', 'set1']), 2);
    });

    test('ttl', () async {
      expect(await memoryStorage.ttl('num1'), -1);
    });

    test('type', () async {
      expect(await memoryStorage.type('num1'), 'string');
      expect(await memoryStorage.type('set1'), 'set');
      expect(await memoryStorage.type('hash1'), 'hash');
    });

    group('Sorted Set', () {
      test('zadd', () async {
        expect(
            await memoryStorage.zadd<String>(
              'zset1',
              <String, double>{
                'zvalue1': 1,
                'zvalue2': 4,
                'zvalue3': 3,
              },
            ),
            3);
      });

      test('zcard', () async {
        expect(await memoryStorage.zcard('zset1'), 3);
      });

      test('zcount', () async {
        expect(await memoryStorage.zcount('zset1', 0, 3), 2);
        expect(await memoryStorage.zcount('zset1', 1, 2), 1);
        expect(await memoryStorage.zcount('zset1', 4, 5), 1);
        expect(await memoryStorage.zcount('zset1', 6, 8), 0);
      });

      test('zincrby', () async {
        expect(await memoryStorage.zincrby<String>('zset1', 'zvalue1'), 2);
      });

      test('zinterstore', () async {
        expect(await memoryStorage.zinterstore('zset2', ['zset1']), 3);
      });

      test('zlexcount', () async {
        expect(
            await memoryStorage.zlexcount<String>(
                'zset1', '[zvalue1', '[zvalue5'),
            3);
        expect(
            await memoryStorage.zadd<String>('zset1', {
              'zvalue4': 1,
            }),
            1);
        expect(
            await memoryStorage.zlexcount<String>(
                'zset1', '[zvalue1', '[zvalue5'),
            4);
      });

      test('zrange', () async {
        expect(await memoryStorage.zrange<String>('zset1', 1, 2),
            ['zvalue1', 'zvalue3']);
        expect(await memoryStorage.zrange('zset1', 0, 2),
            ['zvalue4', 'zvalue1', 'zvalue3']);
      });

      test('zrangebylex', () async {
        expect(
            await memoryStorage.zrangebylex<String>(
                'zset1', '[zvalue1', '[zvalue4'),
            ['zvalue4', 'zvalue1', 'zvalue3', 'zvalue2']);
        expect(
            await memoryStorage.zrangebylex<String>('zset1', '[a', '[w'), []);
      });

      test('zrangebyscore', () async {
        expect(await memoryStorage.zrangebyscore<String>('zset1', 1, 2),
            ['zvalue4', 'zvalue1']);
      });

      test('zrank', () async {
        expect(await memoryStorage.zrank<String>('zset1', 'zvalue4'), 0);
        expect(await memoryStorage.zrank<String>('zset1', 'zvalue1'), 1);
        expect(await memoryStorage.zrank<String>('zset1', 'zvalue3'), 2);
        expect(await memoryStorage.zrank<String>('zset1', 'zvalue2'), 3);
      });

      test('zrem', () async {
        expect(
            await memoryStorage.zrem<String>('zset1', ['zvalue4', 'zvalue3']),
            2);
        expect(await memoryStorage.zrange<String>('zset1', 0, 5),
            ['zvalue1', 'zvalue2']);
      });

      test('zremrangebylex', () async {
        expect(
            await memoryStorage.zremrangebylex<String>(
                'zset1', '[zvalue1', '[zvalue5'),
            2);
        expect(await memoryStorage.zrange<String>('zset1', 0, 5), []);
      });

      test('zremrangebyrank', () async {
        expect(
            await memoryStorage.zadd<String>('zset1', {
              'zvalue1': 2,
              'zvalue4': 1,
              'zvalue6': 50,
              'zvalue8': 12,
            }),
            4);
        expect(await memoryStorage.zremrangebyrank('zset1', 1, 2), 2);
        expect(await memoryStorage.zrange('zset1', 0, 100),
            ['zvalue4', 'zvalue6']);
      });

      test('zremrangebyscore', () async {
        expect(await memoryStorage.zremrangebyscore('zset1', 1, 2), 1);
        expect(await memoryStorage.zrange('zset1', 0, 100), ['zvalue6']);
      });

      test('zrevrange', () async {
        expect(
            await memoryStorage.zadd<String>('zset1', {
              'zvalue2': 5,
              'zvalue4': 2,
              'zvalue8': 1,
            }),
            3);
        expect(await memoryStorage.zrevrange<String>('zset1', 1, 2),
            ['zvalue2', 'zvalue4']);
      });

      test('zrevrangebylex', () async {
        expect(await memoryStorage.zrevrangebylex<String>('zset1', '[a', '[w'),
            []);
      });

      test('zrevrangebyscore', () async {
        expect(await memoryStorage.zrevrangebyscore('zset1', 1, 2),
            ['zvalue4', 'zvalue8']);
      });

      test('zrevrank', () async {
        expect(await memoryStorage.zrevrank<String>('zset1', 'zvalue8'), 3);
        expect(await memoryStorage.zrevrank<String>('zset1', 'zvalue4'), 2);
        expect(await memoryStorage.zrevrank<String>('zset1', 'zvalue2'), 1);
        expect(await memoryStorage.zrevrank<String>('zset1', 'zvalue6'), 0);
      });

      test('zscan', () async {
        expect(await memoryStorage.zscan('zset1'), 1);
      }, skip: 'Not implemented yet');

      test('zscore', () async {
        expect(await memoryStorage.zscore<String>('zset1', 'zvalue2'), 5);
        expect(await memoryStorage.zscore<String>('zset1', 'zvalue8'), 1);
        expect(await memoryStorage.zscore<String>('zset1', 'zvalue6'), 50);
      });

      test('zunionstore', () async {
        expect(await memoryStorage.zunionstore('zset3', ['zset1', 'zset2']), 6);
      });
    });

    tearDownAll(() async {
      await memoryStorage.flushdb();
    });
  });

  tearDownAll(kuzzle.disconnect);
}
