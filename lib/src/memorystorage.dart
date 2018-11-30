import 'error.dart';
import 'helpers.dart';
import 'kuzzle.dart';
import 'response.dart';

class MemoryStorage extends KuzzleObject {
  MemoryStorage(Kuzzle kuzzle) : super(null, kuzzle);
  static const String controller = 'ms';

  @override
  String getController() => controller;

  Future<RawKuzzleResponse> append(String key, String value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{
          'value': value,
        },
        optionalParams: <String, dynamic>{
          '_id': key,
        },
        queuable: queuable,
      ).then((RawKuzzleResponse response) => response.result);

  Future<int> bitcount(String key,
          {bool queuable = true, int start, int end}) =>
      addNetworkQuery(
        'bitcount',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{
          '_id': key,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((RawKuzzleResponse response) => response.result);

  Future<RawKuzzleResponse> bitop(
          String destinationKey, String operation, List<String> sourceKeys,
          {bool queuable = true}) =>
      addNetworkQuery(
        'bitop',
        body: <String, dynamic>{
          'operation': operation,
          'keys': sourceKeys,
        },
        optionalParams: <String, dynamic>{
          '_id': destinationKey,
        },
        queuable: queuable,
      ).then((RawKuzzleResponse response) => response.result);

  Future<RawKuzzleResponse> bitpos({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> dbsize({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> decr({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> decrby({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> del({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> exists({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> expire({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> expireat({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> flushdb({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> geoadd({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> geodist({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> geohash({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> geopos({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> georadius({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> georadiusbymember({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> get({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> getbit({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> getrange({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> getset({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hdel({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hexists({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hget({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hgetall({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hincrby({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hincrbyfloat({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hkeys({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hlen({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hmget({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hmset({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hscan({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hset({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hsetnx({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hstrlen({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> hvals({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> incr({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> incrby({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> incrbyfloat({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> keys({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lindex({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> linsert({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> llen({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lpop({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lpush({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lpushx({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lrange({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lrem({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> lset({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> ltrim({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> mget({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> mset({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> msetnx({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> object({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> persist({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> pexpire({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> pexpireat({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> pfadd({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> pfcount({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> pfmerge({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> ping({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> psetex({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> pttl({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> randomkey({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> rename({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> renamenx({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> rpop({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> rpoplpush({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> rpush({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> rpushx({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sadd({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> scan({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> scard({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sdiff({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sdiffstore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> set({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> setex({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> setnx({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sinter({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sinterstore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sismember({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> smembers({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> smove({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sort({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> spop({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> srandmember({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> srem({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sscan({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> strlen({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sunion({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> sunionstore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> time({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> touch({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> ttl({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> type({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zadd({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zcard({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zcount({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zincrby({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zinterstore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zlexcount({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrange({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrangebylex({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrangebyscore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrank({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrem({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zremrangebylex({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zremrangebyrank({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zremrangebyscore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrevrange({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrevrangebylex({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrevrangebyscore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zrevrank({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zscan({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zscore({bool queuable = true}) => addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
  Future<RawKuzzleResponse> zunionstore({bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: <String, dynamic>{},
        optionalParams: <String, dynamic>{},
        queuable: queuable,
      ).then((RawKuzzleResponse response) => throw ResponseError());
}
