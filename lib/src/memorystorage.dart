import 'package:meta/meta.dart';
import 'helpers.dart';
import 'kuzzle.dart';

class GeoPositionPoint {
  GeoPositionPoint({
    @required this.lon,
    @required this.lat,
    @required this.name,
  });
  GeoPositionPoint.fromMap(Map<String, dynamic> map)
      : lon = map['lon'],
        lat = map['lat'],
        name = map['name'];

  final double lon;
  final double lat;
  final String name;

  Map<String, dynamic> toMap() => {
        'lon': lon,
        'lat': lat,
        'name': name,
      };
}

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

  Future<int> bitpos(String key,
          {int bit = 1, int start, int end, bool queuable = true}) =>
      addNetworkQuery(
        'bitpos',
        body: {},
        optionalParams: {
          '_id': key,
          'bit': bit,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> dbsize({bool queuable = true}) => addNetworkQuery(
        'dbsize',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> decr(String key, {bool queuable = true}) => addNetworkQuery(
        'decr',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> decrby(String key, int value, {bool queuable = true}) =>
      addNetworkQuery(
        'decrby',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> del(List<String> keys, {bool queuable = true}) => addNetworkQuery(
        'del',
        body: {
          'keys': keys,
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> exists(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'exists',
        body: {},
        optionalParams: {
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> expire(String key, int seconds, {bool queuable = true}) =>
      addNetworkQuery(
        'expire',
        body: {
          'seconds': seconds,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> expireat(String key, int timestamp, {bool queuable = true}) =>
      addNetworkQuery(
        'expireat',
        body: {
          'timestamp': timestamp,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<String> flushdb({bool queuable = true}) => addNetworkQuery(
        'flushdb',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result as String);

  Future<int> geoadd(String key, List<GeoPositionPoint> points,
          {bool queuable = true}) =>
      addNetworkQuery(
        'geoadd',
        body: {'points': points.map((point) => point.toMap()).toList()},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<double> geodist(String key, String member1, String member2,
          {String unit = 'm', bool queuable = true}) =>
      addNetworkQuery(
        'geodist',
        body: {},
        optionalParams: {
          '_id': key,
          'member1': member1,
          'member2': member2,
          'unit': unit,
        },
        queuable: queuable,
      ).then((response) => double.parse(response.result));

  Future<List<String>> geohash(String key, List<String> members,
          {bool queuable = true}) =>
      addNetworkQuery(
        'geohash',
        body: {},
        optionalParams: {
          '_id': key,
          'members': members,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((hash) => hash as String).toList());

  Future<List<GeoPositionPoint>> geopos(String key, List<String> members,
          {bool queuable = true}) =>
      addNetworkQuery(
        'geopos',
        body: {},
        optionalParams: {
          '_id': key,
          'members': members,
        },
        queuable: queuable,
      ).then((response) => response.result
          .map<GeoPositionPoint>((point) => GeoPositionPoint(
                name: members[0],
                lon: double.parse(point[0]),
                lat: double.parse(point[1]),
              ))
          .toList());

  Future<List<int>> georadius(
    String key,
    double lon,
    double lat,
    double distance, {
    String unit = 'm',
    List<String> options,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'georadius',
        body: {},
        optionalParams: {
          '_id': key,
          'lon': lon,
          'lat': lat,
          'distance': distance,
          'unit': unit,
          'options': options == null ? [] : options,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<int>((hash) => hash as int).toList());

  Future<List<String>> georadiusbymember(
    String key,
    String member,
    double distance, {
    String unit = 'm',
    List<String> options,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'georadiusbymember',
        body: {},
        optionalParams: {
          '_id': key,
          'member': member,
          'distance': distance,
          'unit': unit,
          'options': options == null ? [] : options,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((hash) => hash as String).toList());

  /// Returns the value of a key, or null if the key doesn't exist.
  Future<String> get(String key, {bool queuable = true}) => addNetworkQuery(
        'get',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the bit value at offset, in the string value stored in a key.
  Future<int> getbit(String key, int offset, {bool queuable = true}) =>
      addNetworkQuery(
        'getbit',
        body: {},
        optionalParams: {
          '_id': key,
          'offset': offset,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns a substring of a key's value.
  Future<String> getrange(String key, int start, int end,
          {bool queuable = true}) =>
      addNetworkQuery(
        'getrange',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a new value for a key and returns the previous stored value.
  Future<String> getset(String key, String value, {bool queuable = true}) =>
      addNetworkQuery(
        'getset',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes fields from a hash.
  ///
  /// returns number of removed fields
  Future<int> hdel(String key, List<String> fields, {bool queuable = true}) =>
      addNetworkQuery(
        'hdel',
        body: {
          'fields': fields,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Checks if a field exists in a hash.
  Future<int> hexists(String key, String field, {bool queuable = true}) =>
      addNetworkQuery(
        'hexists',
        body: {},
        optionalParams: {
          '_id': key,
          'field': field,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the field's value of a hash.
  Future<dynamic> hget(String key, String field, {bool queuable = true}) =>
      addNetworkQuery(
        'hget',
        body: {},
        optionalParams: {
          '_id': key,
          'field': field,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns all fields and values of a hash.
  Future<Map<String, dynamic>> hgetall(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'hgetall',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored in a hash field
  /// by the provided integer value.
  Future<int> hincrby(String key, String field,
          {int value = 1, bool queuable = true}) =>
      addNetworkQuery(
        'hincrby',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored in a hash field
  /// by the provided float value.
  Future<String> hincrbyfloat(String key, String field,
          {double value = 1.0, bool queuable = true}) =>
      addNetworkQuery(
        'hincrbyfloat',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  // Returns all field names contained in a hash.
  Future<List<String>> hkeys(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'hkeys',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((key) => key as String).toList());

  /// Returns the number of fields contained in a hash.
  Future<int> hlen(String key, {bool queuable = true}) => addNetworkQuery(
        'hlen',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the values of the specified hash's fields.
  Future<List<dynamic>> hmget(String key, List<String> fields,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hmget',
        body: {},
        optionalParams: {
          '_id': key,
          'fields': fields,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets multiple fields at once in a hash.
  ///
  /// returns OK
  Future<String> hmset(String key, Map<String, dynamic> entries,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hmset',
        body: {
          'entries': entries.keys
              .map((key) => {
                    'field': key,
                    'value': entries[key],
                  })
              .toList(),
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Identical to [scan], except that hscan
  /// iterates the fields contained in a hash.
  Future<List<dynamic>> hscan(
          String key, String cursor, String match, String count,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hscan',
        body: {},
        optionalParams: {
          '_id': key,
          'cursor': cursor,
          'match': match,
          'count': count,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a field and its value in a hash.
  ///
  /// If the key does not exist, a new key holding a hash is created.
  /// If the field already exists, its value is overwritten.
  Future<int> hset(String key, String field, dynamic value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hset',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a field and its value in a hash,
  /// only if the field does not already exist.
  Future<int> hsetnx(String key, String field, String value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hsetnx',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the string length of a field's value in a hash.
  Future<int> hstrlen(String key, String field, {bool queuable = true}) =>
      addNetworkQuery(
        'hstrlen',
        body: {},
        optionalParams: {
          'field': field,
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns all values contained in a hash.
  Future<List<dynamic>> hvals(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'hvals',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored at key by 1.
  ///
  /// If the key does not exist, it is set to 0 before performing the operation.
  /// returns updated key value
  Future<int> incr(String key, {bool queuable = true}) => addNetworkQuery(
        'incr',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored at key by the provided integer value.
  ///
  /// If the key does not exist, it is set to 0 before performing the operation.
  /// returns updated key value
  Future<int> incrby(String key, int value, {bool queuable = true}) =>
      addNetworkQuery(
        'incrby',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored at key by the provided float value.
  ///
  /// If the key does not exist, it is set to 0 before performing the operation.
  /// returns updated key value
  Future<double> incrbyfloat(String key, double value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'incrbyfloat',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => double.parse(response.result));

  /// Returns all keys matching the provided pattern.
  Future<List<String>> keys({String pattern = '*', bool queuable = true}) =>
      addNetworkQuery(
        'keys',
        body: {},
        optionalParams: {
          'pattern': pattern,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((key) => key as String).toList());

  /// Returns the element at the provided index in a list.
  Future<dynamic> lindex(String key, int index, {bool queuable = true}) =>
      addNetworkQuery(
        'lindex',
        body: {},
        optionalParams: {
          'index': index.toString(),
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Inserts a value in a list,
  ///
  /// either before or after the reference pivot value.
  /// returns updated number of items in the list
  /// ```redis
  /// redis> LINSERT mylist BEFORE "World" "There"
  /// (integer) 3
  /// ```
  /// returns updated number of items in the list>
  Future<int> linsert(String key, dynamic pivot, dynamic value,
          {String position = 'before', bool queuable = true}) =>
      addNetworkQuery(
        'linsert',
        body: {
          'pivot': pivot,
          'value': value,
          'position': position,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the length of a list.
  Future<int> llen(String key, {bool queuable = true}) => addNetworkQuery(
        'llen',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes and returns the first element of a list.
  Future<dynamic> lpop(String key, {bool queuable = true}) => addNetworkQuery(
        'lpop',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Prepends the specified values to a list.
  ///
  /// If the key does not exist, it is created holding an
  /// empty listbefore performing the operation.
  /// returns updated number of elements in the list
  Future<int> lpush(String key, List<dynamic> values, {bool queuable = true}) =>
      addNetworkQuery(
        'lpush',
        body: {
          'values': values,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Prepends the specified value to a list,
  ///
  /// only if the key already exists and if it holds a list.
  Future<int> lpushx(String key, dynamic value, {bool queuable = true}) =>
      addNetworkQuery(
        'lpushx',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the list elements between the start and stop positions.
  Future<List<dynamic>> lrange(String key, int start, int stop,
          {bool queuable = true}) =>
      addNetworkQuery(
        'lrange',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'stop': stop,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes the first count occurences of elements equal to value from a list.
  ///
  /// The count argument influences the operation in the following ways:
  ///   * count > 0: Remove elements equal to value moving from head to tail.
  ///   * count < 0: Remove elements equal to value moving from tail to head.
  ///   * count = 0: Remove all elements equal to value.
  /// For example, LREM list -2 "hello" will
  /// remove the last two occurrences of "hello" in the list stored at list.
  /// Note that non-existing keys are treated like empty lists,
  /// so when key does not exist, the command will always return 0.
  /// returns number of removed elements
  Future<int> lrem(String key, dynamic value, int count,
          {bool queuable = true}) =>
      addNetworkQuery(
        'lrem',
        body: {
          'value': value,
          'count': count,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets the list element at index with the provided value.
  ///
  /// An error is returned for out of range indexes.
  Future<String> lset(String key, int index, dynamic value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'lset',
        body: {
          'index': index,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Trims an existing list
  ///
  /// so that it will contain only the specified range of elements specified.
  Future<String> ltrim(String key, int start, int stop,
          {bool queuable = true}) =>
      addNetworkQuery(
        'ltrim',
        body: {
          'start': start,
          'stop': stop,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the values of the provided keys.
  Future<List<dynamic>> mget(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'mget',
        body: {},
        optionalParams: {
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets the provided keys to their respective values.
  ///
  /// If a key does not exist, it is created.
  /// Otherwise, the key's value is overwritten.
  Future<String> mset(Map<String, dynamic> entries, {bool queuable = true}) =>
      addNetworkQuery(
        'mset',
        body: {
          'entries': entries.keys
              .map((key) => {
                    'key': key,
                    'value': entries[key],
                  })
              .toList(),
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets the provided keys to their respective values,
  ///
  /// only if they do not exist.
  /// If a key exists, then the whole operation is aborted and no key is set.
  Future<int> msetnx(Map<String, dynamic> entries, {bool queuable = true}) =>
      addNetworkQuery(
        'msetnx',
        body: {
          'entries': entries.keys
              .map((key) => {
                    'key': key,
                    'value': entries[key],
                  })
              .toList(),
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  /// Inspects the low-level properties of a key.
  ///
  /// /// [subcommand] can be one of refcount|encoding|idletime
  /// returns object inspection result
  Future<dynamic> object(String key, String subcommand,
          {bool queuable = true}) =>
      addNetworkQuery(
        'object',
        body: {},
        optionalParams: {
          '_id': key,
          'subcommand': subcommand,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes the expiration delay or timestamp from a key,
  ///
  /// making it persistent.
  Future<int> persist(String key, {bool queuable = true}) => addNetworkQuery(
        'persist',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a timeout (in milliseconds) on a key.
  ///
  /// After the timeout has expired, the key will automatically be deleted.
  Future<int> pexpire(String key, int milliseconds, {bool queuable = true}) =>
      addNetworkQuery(
        'pexpire',
        body: {
          'milliseconds': milliseconds,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets an expiration timestamp on a key.
  ///
  /// After the timestamp has been reached,
  /// the key will automatically be deleted.
  /// The timestamp parameter accepts an Epoch [timestamp], in milliseconds.
  Future<int> pexpireat(String key, int timestamp, {bool queuable = true}) =>
      addNetworkQuery(
        'pexpireat',
        body: {
          'timestamp': timestamp,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Adds elements to a HyperLogLog data structure.
  Future<int> pfadd(String key, List<dynamic> elements,
          {bool queuable = true}) =>
      addNetworkQuery(
        'pfadd',
        body: {
          'elements': elements,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the probabilistic cardinality of a HyperLogLog data structure,
  ///
  /// or of the merged HyperLogLog structures if more than 1 is provided
  /// (see pfadd).
  Future<int> pfcount(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'pfcount',
        body: {},
        optionalParams: {
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Merges multiple HyperLogLog data structures into an unique HyperLogLog
  ///
  /// approximating the cardinality of the union of the source structures.
  Future<String> pfmerge(String key, List<String> sources,
          {bool queuable = true}) =>
      addNetworkQuery(
        'pfmerge',
        body: {
          'sources': sources,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Pings the memory storage database.
  Future<String> ping({bool queuable = true}) => addNetworkQuery(
        'ping',
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a key with the provided value,and an expiration delay
  ///
  /// expressed in milliseconds.
  /// If the key does not exist, it is created beforehand.
  Future<String> psetex(String key, dynamic value, int milliseconds,
          {bool queuable = true}) =>
      addNetworkQuery(
        'psetex',
        body: {
          'value': value,
          'milliseconds': milliseconds,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the remaining time to live of a key, in milliseconds.
  Future<int> pttl(String key, {bool queuable = true}) => addNetworkQuery(
        'pttl',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns a random key from the memory storage.
  Future<String> randomkey({bool queuable = true}) => addNetworkQuery(
        'randomkey',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  /// Renames a key to newkey. If newkey already exists, it is overwritten.
  Future<String> rename(String key, String newkey, {bool queuable = true}) =>
      addNetworkQuery(
        'rename',
        body: {
          'newkey': newkey,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Renames a key to newkey, only if newkey does not already exist.
  Future<int> renamenx(String key, String newkey, {bool queuable = true}) =>
      addNetworkQuery(
        'renamenx',
        body: {
          'newkey': newkey,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes the last element of a list and returns it.
  Future<String> rpop(String key, {bool queuable = true}) => addNetworkQuery(
        'rpop',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes the last element of the list at source and
  ///
  /// pushes it back at the start of the list at destination.
  Future<dynamic> rpoplpush(String source, String destination,
          {bool queuable = true}) =>
      addNetworkQuery(
        'rpoplpush',
        body: {
          'source': source,
          'destination': destination,
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  /// Appends the specified values at the end of a list.
  ///
  /// If the key does not exist, it is created holding an empty list
  /// before performing the operation.
  /// returns updated number of elements in the list
  Future<int> rpush(String key, List<dynamic> values, {bool queuable = true}) =>
      addNetworkQuery(
        'rpush',
        body: {
          'values': values,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Appends the specified value at the end of a list,
  ///
  /// only if the key already exists and if it holds a list.
  Future<int> rpushx(String key, dynamic value, {bool queuable = true}) =>
      addNetworkQuery(
        'rpushx',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Adds members to a set of unique values stored at key.
  ///
  /// If the key does not exist, it is created beforehand.
  Future<int> sadd(String key, List<dynamic> members, {bool queuable = true}) =>
      addNetworkQuery(
        'sadd',
        body: {
          'members': members,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> scan(String key, {bool queuable = true}) => addNetworkQuery(
        'scan',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the number of members stored in a set of unique values.
  Future<int> scard(String key, {bool queuable = true}) => addNetworkQuery(
        'scard',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the difference between the set of unique values
  /// stored at key and the other provided sets.
  Future<List<dynamic>> sdiff(String key, List<String> keys,
          {bool queuable = true}) =>
      addNetworkQuery(
        'sdiff',
        body: {},
        optionalParams: {
          '_id': key,
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Computes the difference between the set of unique values stored at key and
  ///
  /// the other provided sets, and stores the result in the
  /// key stored at destination.
  ///If the destination key already exists, it is overwritten.
  Future<int> sdiffstore(String key, List<String> keys, String destination,
          {bool queuable = true}) =>
      addNetworkQuery(
        'sdiffstore',
        body: {
          'keys': keys,
          'destination': destination,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Creates a key holding the provided value,
  ///
  /// or overwrites it if it already exists.
  /// Additional options can be provided:
  ///   * ex: set the specified expire time, in seconds
  ///   * px: set the specified expire time, in milliseconds
  ///   * nx: only set the key if it does not already exist
  ///   * xx: only set the key if it already exists
  /// Note: setting ex and px options lead to a BadRequestError as
  /// these options are mutually exclusive. Same thing goes for nx and xx.
  Future<String> set(String key, dynamic value,
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

  /// Sets a value and a time to live (in seconds) on a key.
  /// If the key already exists, it is overwritten.
  Future<String> setex(String key, dynamic value, int seconds,
          {bool queuable = true}) =>
      addNetworkQuery(
        'setex',
        body: {
          'value': value,
          'seconds': seconds,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a value on a key, only if it does not already exist.
  Future<int> setnx(String key, dynamic value, {bool queuable = true}) =>
      addNetworkQuery(
        'setnx',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the intersection of the provided sets of unique values.
  Future<List<dynamic>> sinter(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'sinter',
        body: {},
        optionalParams: {
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Computes the intersection of the provided sets of unique values
  ///
  /// and stores the result in the destination key.
  /// If the destination key already exists, it is overwritten.
  Future<int> sinterstore(List<String> keys, String destination,
          {bool queuable = true}) =>
      addNetworkQuery(
        'sinterstore',
        body: {
          'keys': keys,
          'destination': destination,
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  /// Checks if member is a member of the set of unique values stored at key.
  Future<int> sismember(String key, dynamic member, {bool queuable = true}) =>
      addNetworkQuery(
        'sismember',
        body: {},
        optionalParams: {
          '_id': key,
          'member': member,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the members of a set of unique values.
  Future<List<dynamic>> smembers(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'smembers',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Moves a member from a set of unique values to another.
  Future<int> smove(String key, dynamic member, String destination,
          {bool queuable = true}) =>
      addNetworkQuery(
        'smove',
        body: {
          'member': member,
          'destination': destination,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sorts and returns elements contained in a list,
  /// a set of unique values or a sorted set.
  /// By default, sorting is numeric and elements are compared
  /// by their value interpreted as double precision floating point number.
  ///
  /// Optional arguments may be provided:
  ///
  ///   * alpha: performs an alphanumerical sort instead of a numeric one
  ///   * by: instead of sorting by values directly, sorts by values contained in external keys, using a pattern completed by values of the list/set/sorted set to sort
  ///   * direction: sort in ascendant or descendant order
  ///   * get: instead of returning the sorted values directly, returns the
  ///    values contained in external keys, using patterns
  ///   completed by the sorted values
  ///   * limit: limits the result set to a range of matching elements
  ///    (similar to SELECT LIMIT offset, count in SQL).
  ///    Format: [<offset(int)>, <count(int)>]
  ///   * store: instead of returning the result set,
  ///    stores it in a list at destination key
  Future<List<dynamic>> sort(
    String key, {
    String alpha = 'false',
    String direction = 'ASC',
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'sort',
        body: {
          'alpha': alpha,
          'direction': direction,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes and returns one or more elements at random
  /// from a set of unique values.
  /// If multiple elements are removed, the
  /// result set will be an array of removed elements, instead of a string.
  Future<List<dynamic>> spop(String key,
          {int count = 1, bool queuable = true}) =>
      addNetworkQuery(
        'spop',
        body: {
          'count': count,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns one or more members of a set of unique values, at random.
  ///
  /// If count is provided and is positive, the returned values are unique.
  /// If count is negative, a set member can be returned multiple times.
  ///
  /// If more than 1 member is returned,
  /// the result set will be an array of values instead of a string.
  Future<String> srandmember(String key,
          {int count = 1, bool queuable = true}) =>
      addNetworkQuery(
        'srandmember',
        body: {
          'count': count,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes members from a set of unique values.
  ///
  /// returns number of removed members
  Future<int> srem(String key, List<String> members, {bool queuable = true}) =>
      addNetworkQuery(
        'srem',
        body: {
          'members': members,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sscan(String key, {bool queuable = true}) => addNetworkQuery(
        'sscan',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the length of a value stored at key.
  Future<int> strlen(String key, {bool queuable = true}) => addNetworkQuery(
        'strlen',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the union of sets of unique values.
  Future<List<dynamic>> sunion(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'sunion',
        body: {},
        optionalParams: {
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Computes the union of multiple sets of unique values and
  /// stores it in a new set at destination key.
  /// If the destination key already exists, it is overwritten.
  Future<int> sunionstore(List<String> keys, String destination,
          {bool queuable = true}) =>
      addNetworkQuery(
        'sunionstore',
        body: {
          'keys': keys,
          'destination': destination,
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the current server time as a two items list:a timestamp in Epochs
  ///
  /// and the number of microseconds already elapsed in the current second.
  Future<List<String>> time({bool queuable = true}) => addNetworkQuery(
        'time',
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((a) => a as String).toList());

  /// Alters the last access time of one or multiple keys.
  ///
  /// A key is ignored if it does not exist.
  Future<int> touch(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'touch',
        body: {'keys': keys},
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the remaining time to live of a key, in seconds,
  ///
  /// or a negative value if the key does not exist or if it is persistent.
  Future<int> ttl(String key, {bool queuable = true}) => addNetworkQuery(
        'ttl',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the type of the value held by a key.
  Future<String> type(String key, {bool queuable = true}) => addNetworkQuery(
        'type',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Adds the specified elements to the sorted set stored at [key].
  ///
  /// If the key does not exist, it is created, holding an empty sorted set.
  /// If it already exists and does not hold a sorted set, an error is returned.
  /// Scores are expressed as floating point numbers.
  ///
  /// If a member to insert is already in the sorted set, its score is updated
  /// and the member is reinserted at the right position in the set.
  /// Optional parameters may be provided to change the default behavior:
  ///   * [nx]: only add new elements, do not update existing ones
  ///   * [xx]: never add new elements, update only existing ones
  ///   * [ch]: instead of returning the number of added elements,
  ///    returns the number of changes performed
  ///   * [incr]: instead of adding elements,
  ///    increments the existing member with the provided score.
  ///    Only one score/element pair can be specified if this option is set
  /// returns number of added elements
  Future<int> zadd<T>(
    String key,
    Map<T, double> elements, {
    bool nx = false,
    bool xx = false,
    bool ch = false,
    bool incr = false,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'zadd',
        body: {
          'elements': elements.keys
              .map((key) => {
                    'member': key,
                    'score': elements[key],
                  })
              .toList(),
          'nx': nx,
          'xx': xx,
          'ch': ch,
          'incr': incr,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the number of elements held by a sorted set.
  Future<int> zcard(String key, {bool queuable = true}) => addNetworkQuery(
        'zcard',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the number of elements held by a sorted set with a
  /// score between the provided min and max values.
  ///
  /// By default, the provided min and max values are inclusive.
  /// This behavior can be changed using the syntax in [zrangebyscore].
  Future<int> zcount(String key, double min, double max,
          {bool queuable = true}) =>
      addNetworkQuery(
        'zcount',
        body: {},
        optionalParams: {
          '_id': key,
          'min': min,
          'max': max,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the score of a member in a sorted set by the provided value.
  ///
  /// returns new score value
  Future<double> zincrby<T>(String key, T member,
          {double value = 1, bool queuable = true}) =>
      addNetworkQuery(
        'zincrby',
        body: {
          'member': member,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => double.parse(response.result));

  /// Computes the intersection of the provided sorted sets given by
  /// the specified keys,and stores the result in a new sorted set at key.
  ///
  /// Optional Parameters:
  ///   * [weights]: specifies a multiplication factor for each input sorted set
  ///   * [aggregate] (default: sum): specifies how
  ///    members' scores are aggregated during the intersection
  /// returns the number of elements in the new sorted set>
  Future<int> zinterstore(
    String key,
    List<String> keys, {
    List<String> weights,
    String aggregate,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'zinterstore',
        body: {
          'keys': keys,
          'weights': weights,
          'aggregate': aggregate,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Counts elements in a sorted set where all members have equal score,
  /// using lexicographical ordering.
  ///
  /// The min and max values are inclusive by default.
  Future<int> zlexcount<T>(String key, T min, T max, {bool queuable = true}) =>
      addNetworkQuery(
        'zlexcount',
        body: {},
        optionalParams: {
          '_id': key,
          'min': min,
          'max': max,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns elements from a sorted set depending on their position,
  /// from a start position index to a stop position index (inclusive).
  ///
  /// The withscores option includes the respective elements' scores
  Future<List<T>> zrange<T>(String key, int start, int stop,
          {bool queuable = true}) =>
      addNetworkQuery(
        'zrange',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'stop': stop,
        },
        queuable: queuable,
      ).then((response) => (response.result as List<dynamic>)
          .map<T>((dynamic element) => element as T)
          .toList());

  /// Returns elements in a sorted set where all members have equal score,
  /// using lexicographical ordering.
  ///
  /// The min and max values are inclusive by default.
  /// The optional [limit] argument can be used to only get a range
  /// of the matching elements (similar to SELECT LIMIT offset, count in SQL).
  Future<List<T>> zrangebylex<T>(String key, T min, T max,
          {List<String> limit, bool queuable = true}) =>
      addNetworkQuery(
        'zrangebylex',
        body: {},
        optionalParams: {
          '_id': key,
          'min': min,
          'max': max,
          'limit': limit,
        },
        queuable: queuable,
      ).then((response) => (response.result as List<dynamic>)
          .map<T>((dynamic element) => element as T)
          .toList());

  /// Returns all the elements in the sorted set at key with a
  /// score between min and max (inclusive).
  /// The elements are considered to be ordered from low to high scores.
  ///
  /// The optional [limit] argument can be used to only get a range
  /// of the matching elements (similar to SELECT LIMIT offset, count in SQL).
  Future<List<T>> zrangebyscore<T>(String key, double min, double max,
          {List<String> limit, bool queuable = true}) =>
      addNetworkQuery(
        'zrangebyscore',
        body: {},
        optionalParams: {
          '_id': key,
          'min': min,
          'max': max,
          'limit': limit,
        },
        queuable: queuable,
      ).then((response) => (response.result as List<dynamic>)
          .map<T>((dynamic element) => element as T)
          .toList());

  /// Returns the position of an element in a sorted set,
  /// with scores in ascending order.
  /// The index returned is 0-based (the lowest score member has an index of 0).
  Future<int> zrank<T>(String key, T member, {bool queuable = true}) =>
      addNetworkQuery(
        'zrank',
        body: {},
        optionalParams: {
          '_id': key,
          'member': member,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes members from a sorted set.
  Future<int> zrem<T>(String key, List<T> members, {bool queuable = true}) =>
      addNetworkQuery(
        'zrem',
        body: {
          'members': members,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes members from a sorted set where all elements have the same score,
  /// using lexicographical ordering.
  ///
  /// The min and max interval are inclusive.
  /// returns no. of removed members
  Future<int> zremrangebylex<T>(String key, T min, T max,
          {bool queuable = true}) =>
      addNetworkQuery(
        'zremrangebylex',
        body: {
          'min': min,
          'max': max,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes members from a sorted set with their
  /// position in the set between start and stop (inclusive).
  ///
  /// Positions are 0-based, meaning the first member has a position of 0.
  Future<int> zremrangebyrank(String key, int start, int stop,
          {bool queuable = true}) =>
      addNetworkQuery(
        'zremrangebyrank',
        body: {
          'start': start,
          'stop': stop,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes members from a sorted set with a score between min and max.
  ///The min and max values are inclusive
  Future<int> zremrangebyscore(String key, double min, double max,
          {bool queuable = true}) =>
      addNetworkQuery(
        'zremrangebyscore',
        body: {
          'min': min,
          'max': max,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Identical to [zrange],
  /// except that the sorted set is traversed in descending order.
  Future<List<T>> zrevrange<T>(String key, int start, int stop,
          {bool queuable = true}) =>
      addNetworkQuery(
        'zrevrange',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'stop': stop,
        },
        queuable: queuable,
      ).then((response) => (response.result as List<dynamic>)
          .map<T>((dynamic element) => element as T)
          .toList());

  /// Identical to [zrangebylex],
  /// except that the sorted set is traversed in descending order.
  Future<List<T>> zrevrangebylex<T>(String key, T min, T max,
          {List<String> limit, bool queuable = true}) =>
      addNetworkQuery(
        'zrevrangebylex',
        body: {},
        optionalParams: {
          '_id': key,
          'min': min,
          'max': max,
          'limit': limit,
        },
        queuable: queuable,
      ).then((response) => (response.result as List<dynamic>)
          .map<T>((dynamic element) => element as T)
          .toList());

  /// Identical to [zrangebyscore],
  /// except that the sorted set is traversed in descending order.
  Future<List<T>> zrevrangebyscore<T>(String key, double min, double max,
          {List<String> limit, bool queuable = true}) =>
      addNetworkQuery(
        'zrevrangebyscore',
        body: {},
        optionalParams: {
          '_id': key,
          'min': min,
          'max': max,
          'limit': limit,
        },
        queuable: queuable,
      ).then((response) => (response.result as List<dynamic>)
          .map<T>((dynamic element) => element as T)
          .toList());

  /// Returns the position of an element in a sorted set,
  /// with scores in descending order.
  ///
  /// The index returned is 0-based (the lowest score member has an index of 0).
  Future<int> zrevrank<T>(String key, T member, {bool queuable = true}) =>
      addNetworkQuery(
        'zrevrank',
        body: {},
        optionalParams: {
          '_id': key,
          'member': member,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zscan(String key, {bool queuable = true}) => addNetworkQuery(
        'zscan',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the score of an element in a sorted set.
  Future<double> zscore<T>(String key, T member, {bool queuable = true}) =>
      addNetworkQuery(
        'zscore',
        body: {},
        optionalParams: {
          '_id': key,
          'member': member,
        },
        queuable: queuable,
      ).then((response) => double.parse(response.result));

  /// Computes the union of the provided sorted sets given by the
  /// specified keys, and stores the result in a new sorted set at key.
  Future<int> zunionstore(
    String key,
    List<String> keys, {
    List<String> weights,
    String aggregate,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'zunionstore',
        body: {
          'keys': keys,
          'weights': weights,
          'aggregate': aggregate,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
}
