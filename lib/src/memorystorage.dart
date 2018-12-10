import 'error.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';

class MemoryStorage extends KuzzleObject {
  MemoryStorage(Kuzzle kuzzle) : super(null, kuzzle);
  static const String controller = 'ms';

  @override
  String getController() => controller;

  Future<int> append(String key, String value, {bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> bitcount(String key,
          {bool queuable = true, int start, int end}) =>
      addNetworkQuery(
        'bitcount',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> bitop(
          String destinationKey, String operation, List<String> sourceKeys,
          {bool queuable = true}) =>
      addNetworkQuery(
        'bitop',
        body: {
          'operation': operation,
          'keys': sourceKeys,
        },
        optionalParams: {
          '_id': destinationKey,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> bitpos({bool queuable = true}) => addNetworkQuery(
        'bitpos',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> dbsize({bool queuable = true}) => addNetworkQuery(
        'dbsize',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> decr({bool queuable = true}) => addNetworkQuery(
        'decr',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> decrby({bool queuable = true}) => addNetworkQuery(
        'decrby',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> del({bool queuable = true}) => addNetworkQuery(
        'del',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> exists({bool queuable = true}) => addNetworkQuery(
        'exists',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> expire({bool queuable = true}) => addNetworkQuery(
        'expire',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> expireat({bool queuable = true}) => addNetworkQuery(
        'expireat',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<String> flushdb({bool queuable = true}) => addNetworkQuery(
        'flushdb',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result as String);
  Future<int> geoadd({bool queuable = true}) => addNetworkQuery(
        'geoadd',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> geodist({bool queuable = true}) => addNetworkQuery(
        'geodist',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> geohash({bool queuable = true}) => addNetworkQuery(
        'geohash',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> geopos({bool queuable = true}) => addNetworkQuery(
        'geopos',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> georadius({bool queuable = true}) => addNetworkQuery(
        'append',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> georadiusbymember({bool queuable = true}) => addNetworkQuery(
        'append',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<String> get(String key, {bool queuable = true}) => addNetworkQuery(
        'get',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> getbit({bool queuable = true}) => addNetworkQuery(
        'getbit',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> getrange({bool queuable = true}) => addNetworkQuery(
        'getrange',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> getset({bool queuable = true}) => addNetworkQuery(
        'getset',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hdel({bool queuable = true}) => addNetworkQuery(
        'hdel',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hexists({bool queuable = true}) => addNetworkQuery(
        'hexists',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hget({bool queuable = true}) => addNetworkQuery(
        'hget',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hgetall({bool queuable = true}) => addNetworkQuery(
        'hgetall',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hincrby({bool queuable = true}) => addNetworkQuery(
        'hincrby',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hincrbyfloat({bool queuable = true}) => addNetworkQuery(
        'append',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hkeys({bool queuable = true}) => addNetworkQuery(
        'hkeys',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hlen({bool queuable = true}) => addNetworkQuery(
        'hlen',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hmget({bool queuable = true}) => addNetworkQuery(
        'hmget',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hmset({bool queuable = true}) => addNetworkQuery(
        'hmset',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hscan({bool queuable = true}) => addNetworkQuery(
        'hscan',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hset({bool queuable = true}) => addNetworkQuery(
        'hset',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hsetnx({bool queuable = true}) => addNetworkQuery(
        'hsetnx',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hstrlen({bool queuable = true}) => addNetworkQuery(
        'hstrlen',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> hvals({bool queuable = true}) => addNetworkQuery(
        'hvals',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> incr({bool queuable = true}) => addNetworkQuery(
        'incr',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> incrby({bool queuable = true}) => addNetworkQuery(
        'incrby',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> incrbyfloat({bool queuable = true}) => addNetworkQuery(
        'append',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> keys({bool queuable = true}) => addNetworkQuery(
        'keys',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lindex({bool queuable = true}) => addNetworkQuery(
        'lindex',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> linsert({bool queuable = true}) => addNetworkQuery(
        'linsert',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> llen({bool queuable = true}) => addNetworkQuery(
        'llen',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lpop({bool queuable = true}) => addNetworkQuery(
        'lpop',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lpush({bool queuable = true}) => addNetworkQuery(
        'lpush',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lpushx({bool queuable = true}) => addNetworkQuery(
        'lpushx',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lrange({bool queuable = true}) => addNetworkQuery(
        'lrange',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lrem({bool queuable = true}) => addNetworkQuery(
        'lrem',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lset({bool queuable = true}) => addNetworkQuery(
        'lset',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> ltrim({bool queuable = true}) => addNetworkQuery(
        'ltrim',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> mget({bool queuable = true}) => addNetworkQuery(
        'mget',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> mset({bool queuable = true}) => addNetworkQuery(
        'mset',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> msetnx({bool queuable = true}) => addNetworkQuery(
        'msetnx',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> object({bool queuable = true}) => addNetworkQuery(
        'object',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> persist({bool queuable = true}) => addNetworkQuery(
        'persist',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pexpire({bool queuable = true}) => addNetworkQuery(
        'pexpire',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pexpireat({bool queuable = true}) => addNetworkQuery(
        'pexpireat',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pfadd({bool queuable = true}) => addNetworkQuery(
        'pfadd',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pfcount({bool queuable = true}) => addNetworkQuery(
        'pfcount',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pfmerge({bool queuable = true}) => addNetworkQuery(
        'pfmerge',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> ping({bool queuable = true}) => addNetworkQuery(
        'ping',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> psetex({bool queuable = true}) => addNetworkQuery(
        'psetex',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pttl({bool queuable = true}) => addNetworkQuery(
        'pttl',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> randomkey({bool queuable = true}) => addNetworkQuery(
        'append',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rename({bool queuable = true}) => addNetworkQuery(
        'rename',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> renamenx({bool queuable = true}) => addNetworkQuery(
        'renamenx',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpop({bool queuable = true}) => addNetworkQuery(
        'rpop',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpoplpush({bool queuable = true}) => addNetworkQuery(
        'rpoplpush',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpush({bool queuable = true}) => addNetworkQuery(
        'rpush',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpushx({bool queuable = true}) => addNetworkQuery(
        'rpushx',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sadd({bool queuable = true}) => addNetworkQuery(
        'sadd',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> scan({bool queuable = true}) => addNetworkQuery(
        'scan',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> scard({bool queuable = true}) => addNetworkQuery(
        'scard',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sdiff({bool queuable = true}) => addNetworkQuery(
        'sdiff',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sdiffstore({bool queuable = true}) => addNetworkQuery(
        'sdiffstore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<String> set(String key, String value,
          {int ex, int px, bool nx, bool xx, bool queuable = true}) =>
      addNetworkQuery(
        'set',
        body: {
          'value': value,
          // 'ex': ex,
          // 'px': px,
          // 'nx': nx,
          // 'xx': xx,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> setex({bool queuable = true}) => addNetworkQuery(
        'setex',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> setnx({bool queuable = true}) => addNetworkQuery(
        'setnx',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sinter({bool queuable = true}) => addNetworkQuery(
        'sinter',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sinterstore({bool queuable = true}) => addNetworkQuery(
        'sinterstore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sismember({bool queuable = true}) => addNetworkQuery(
        'sismember',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> smembers({bool queuable = true}) => addNetworkQuery(
        'smembers',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> smove({bool queuable = true}) => addNetworkQuery(
        'smove',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sort({bool queuable = true}) => addNetworkQuery(
        'sort',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> spop({bool queuable = true}) => addNetworkQuery(
        'spop',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> srandmember({bool queuable = true}) => addNetworkQuery(
        'srandmember',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> srem({bool queuable = true}) => addNetworkQuery(
        'srem',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sscan({bool queuable = true}) => addNetworkQuery(
        'sscan',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> strlen({bool queuable = true}) => addNetworkQuery(
        'strlen',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sunion({bool queuable = true}) => addNetworkQuery(
        'sunion',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sunionstore({bool queuable = true}) => addNetworkQuery(
        'sunionstore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> time({bool queuable = true}) => addNetworkQuery(
        'time',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> touch({bool queuable = true}) => addNetworkQuery(
        'touch',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> ttl({bool queuable = true}) => addNetworkQuery(
        'ttl',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> type({bool queuable = true}) => addNetworkQuery(
        'type',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zadd({bool queuable = true}) => addNetworkQuery(
        'zadd',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zcard({bool queuable = true}) => addNetworkQuery(
        'zcard',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zcount({bool queuable = true}) => addNetworkQuery(
        'zcount',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zincrby({bool queuable = true}) => addNetworkQuery(
        'zincrby',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zinterstore({bool queuable = true}) => addNetworkQuery(
        'zinterstore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zlexcount({bool queuable = true}) => addNetworkQuery(
        'zlexcount',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrange({bool queuable = true}) => addNetworkQuery(
        'zrange',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrangebylex({bool queuable = true}) => addNetworkQuery(
        'zrangebylex',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrangebyscore({bool queuable = true}) => addNetworkQuery(
        'zrangebyscore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrank({bool queuable = true}) => addNetworkQuery(
        'zrank',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrem({bool queuable = true}) => addNetworkQuery(
        'zrem',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zremrangebylex({bool queuable = true}) => addNetworkQuery(
        'zremrangebylex',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zremrangebyrank({bool queuable = true}) => addNetworkQuery(
        'zremrangebyrank',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zremrangebyscore({bool queuable = true}) => addNetworkQuery(
        'zremrangebyscore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrange({bool queuable = true}) => addNetworkQuery(
        'zrevrange',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrangebylex({bool queuable = true}) => addNetworkQuery(
        'zrevrangebylex',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrangebyscore({bool queuable = true}) => addNetworkQuery(
        'zrevrangebyscore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrank({bool queuable = true}) => addNetworkQuery(
        'zrevrank',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zscan({bool queuable = true}) => addNetworkQuery(
        'zscan',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zscore({bool queuable = true}) => addNetworkQuery(
        'zscore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zunionstore({bool queuable = true}) => addNetworkQuery(
        'zunionstore',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);
}
