import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:geohash/geohash.dart';

String stringToBytes(String str) {
  String finalString;
  try {
    finalString = int.parse(str).toRadixString(2);
  } on Exception {
    finalString = utf8
        .encode(str)
        .map((a) => a.toRadixString(2))
        .fold('', (initValue, value) => '$initValue$value');
  }
  return finalString;
}

class ImitationRedis {
  final Map<String, dynamic> cache = <String, dynamic>{};

  dynamic run(String operation, Map<String, dynamic> parameters) {
    switch (operation) {
      case 'append':
        cache[parameters['_id']] = parameters['value'];
        return cache[parameters['_id']].length;
      case 'bitcount':
        final byteString = stringToBytes(cache[parameters['_id']] as String);
        final count = '1'.allMatches(byteString).length;
        return count;
      case 'bitop':
        final keys = parameters['keys'];
        final List<dynamic> byteValues =
            keys.map((key) => int.parse(cache[key])).toList();
        int value;
        switch (parameters['operation']) {
          case 'AND':
            value = byteValues.fold(
                0, (prevValue, curValue) => prevValue & curValue);
            break;
          case 'OR':
            value = byteValues.fold(
                0, (prevValue, curValue) => prevValue | curValue);
            break;
        }
        cache[parameters['_id']] = value.toString();
        return value.toString().length;
      case 'bitpos':
        final bytesStr = stringToBytes(cache[parameters['_id']]);
        return bytesStr.indexOf(parameters['bit'].toString()) + 1;
      case 'dbsize':
        return cache.keys.length;
      case 'decr':
        final String value = cache[parameters['_id']];
        final valueInt = int.parse(value) - 1;
        cache[parameters['_id']] = valueInt.toString();
        return valueInt;
      case 'decrby':
        final String value = cache[parameters['_id']];
        final valueInt = int.parse(value) - parameters['value'];
        cache[parameters['_id']] = valueInt.toString();
        return valueInt;
      case 'del':
        var deletedCount = 0;
        parameters['keys'].forEach((key) {
          if (cache.containsKey(key)) {
            cache.remove(key);
            deletedCount += 1;
          }
        });
        return deletedCount;
      case 'exists':
        var existsCount = 0;
        parameters['keys'].forEach((key) {
          if (cache.containsKey(key)) {
            existsCount += 1;
          }
        });
        return existsCount;
      case 'expire':
        Future.delayed(
            Duration(
              seconds: parameters['seconds'],
            ), () {
          cache.remove(parameters['_id']);
        });
        return 1;
      case 'expireat':
        cache.remove(parameters['_id']);
        return 1;
      case 'flushdb':
        cache.removeWhere((key, value) => true);
        return 'OK';
      case 'geoadd':
        cache[parameters['_id']] = parameters['points'];
        return cache[parameters['_id']].length;
      case 'geodist':
        final points = cache[parameters['_id']] as List<dynamic>;
        final point1 = points
            .where((point) => point['name'] == parameters['member1'])
            .elementAt(0);
        final point2 = points
            .where((point) => point['name'] == parameters['member2'])
            .elementAt(0);
        var distance = pow(point1['lat'] - point2['lat'], 2) +
            pow(point1['lon'] - point2['lon'], 2);
        distance = sqrt(distance);
        return (distance * 111189.08081122051).toString();
      case 'geohash':
        final points = cache[parameters['_id']] as List<dynamic>;
        final hashes = parameters['members'].map((member) {
          final point =
              points.where((point) => point['name'] == member).elementAt(0);
          return Geohash.encode(point['lat'], point['lon']);
        }).toList();
        return hashes;
      case 'geopos':
        final points = cache[parameters['_id']] as List<dynamic>;
        final geopositions = parameters['members'].map((member) {
          final point =
              points.where((point) => point['name'] == member).elementAt(0);
          return [point['lon'].toString(), point['lat'].toString()];
        }).toList();
        return geopositions;
      case 'georadius':
        return [];
      case 'georadiusbymember':
        final points = cache[parameters['_id']] as List<dynamic>;
        return [points[0]['name']];
      case 'get':
        return cache[parameters['_id']];
      case 'getbit':
        final bytesStr = stringToBytes(cache[parameters['_id']]);
        return int.parse(bytesStr[parameters['offset']]);
      case 'getrange':
        final String str = cache[parameters['_id']];
        return str.substring(parameters['start'], parameters['end'] + 1);
      case 'getset':
        final String prevValue = cache[parameters['_id']];
        cache[parameters['_id']] = parameters['value'];
        return prevValue;
      case 'hdel':
        var deletedField = 0;
        parameters['fields'].forEach((field) {
          deletedField += 1;
          (cache[parameters['_id']] as Map<String, dynamic>).remove(field);
        });
        return deletedField;
      case 'hexists':
        final doesContains = cache.containsKey(parameters['_id']) &&
            cache[parameters['_id']].containsKey(parameters['field']);
        return doesContains ? 1 : 0;
      case 'hget':
        if (!cache.containsKey(parameters['_id'])) {
          return null;
        }
        return cache[parameters['_id']][parameters['field']];
      case 'hgetall':
        return cache[parameters['_id']];
      case 'hincrby':
        if (!cache.containsKey(parameters['_id'])) {
          cache[parameters['_id']] = {};
        }
        final String prevValue = cache[parameters['_id']][parameters['field']];
        var prevIntValue = int.parse(prevValue);
        prevIntValue += parameters['value'];
        cache[parameters['_id']][parameters['field']] = prevIntValue.toString();
        return prevIntValue;
      case 'hincrbyfloat':
        if (!cache.containsKey(parameters['_id'])) {
          cache[parameters['_id']] = {};
        }
        final String prevValue = cache[parameters['_id']][parameters['field']];
        var prevIntValue = double.parse(prevValue);
        prevIntValue += parameters['value'];
        cache[parameters['_id']][parameters['field']] = prevIntValue.toString();
        return prevIntValue.toString();
      case 'hkeys':
        return cache[parameters['_id']].keys.toList();
      case 'hlen':
        return cache[parameters['_id']].keys.length;
      case 'hmget':
        final result = parameters['fields']
            .map((field) =>
                (cache[parameters['_id']] as Map<String, dynamic>)[field])
            .toList();
        return result;
      case 'hmset':
        parameters['entries']
            .map((entry) => (cache[parameters['_id']]
                    as Map<String, dynamic>)[entry['field']] =
                entry['value'].toString())
            .toList();
        return 'OK';
      case 'hscan':
      case 'hset':
        if (!cache.containsKey(parameters['_id'])) {
          cache[parameters['_id']] = <String, dynamic>{};
        }
        cache[parameters['_id']][parameters['field']] =
            parameters['value'].toString();
        return 1;
      case 'hsetnx':
        if (!cache.containsKey(parameters['_id'])) {
          cache[parameters['_id']] = <String, dynamic>{};
        }
        if (cache[parameters['_id']].containsKey(parameters['field'])) {
          return 0;
        }
        cache[parameters['_id']][parameters['field']] =
            parameters['value'].toString();
        return 1;
      case 'hstrlen':
        return (cache[parameters['_id']][parameters['field']])
            .toString()
            .length;
      case 'hvals':
        return (cache[parameters['_id']] as Map<String, dynamic>)
            .values
            .toList();
      case 'incr':
        final String prevValue = cache[parameters['_id']];
        var prevValueInt = int.parse(prevValue);
        prevValueInt += 1;
        cache[parameters['_id']] = prevValueInt.toString();
        return prevValueInt;
      case 'incrby':
        final String prevValue = cache[parameters['_id']];
        var prevValueInt = int.parse(prevValue);
        prevValueInt += parameters['value'];
        cache[parameters['_id']] = prevValueInt.toString();
        return prevValueInt;
      case 'incrbyfloat':
        final String prevValue = cache[parameters['_id']];
        var prevValueDouble = double.parse(prevValue);
        prevValueDouble += parameters['value'];
        cache[parameters['_id']] = prevValueDouble.toString();
        return prevValueDouble.toString();
      case 'keys':
        return cache.keys.toList();
      case 'lindex':
        final List<dynamic> list = cache[parameters['_id']];
        return list[parameters['index']];
      case 'linsert':
        final List<dynamic> list = cache[parameters['_id']];
        final index = list.indexOf(parameters['pivot']);
        list.insert(index, parameters['value']);
        cache[parameters['_id']] = list;
        return list.length;
      case 'llen':
        final List<dynamic> list = cache[parameters['_id']];
        return list.length;
      case 'lpop':
        final List<dynamic> list = cache[parameters['_id']];
        cache[parameters['_id']] = list;
        return list.removeAt(0).toString();
      case 'lpush':
        List<dynamic> list;
        if (cache.containsKey(parameters['_id'])) {
          list = cache[parameters['_id']];
        } else {
          list = <dynamic>[];
        }
        list.insertAll(
            0, (parameters['values'] as List<dynamic>).reversed.toList());
        cache[parameters['_id']] = list;
        return list.length;
      case 'lpushx':
        if (!cache.containsKey(parameters['_id'])) {
          return 0;
        }
        final List<dynamic> list = cache[parameters['_id']];
        list.insert(0, parameters['value']);
        cache[parameters['_id']] = list;
        return list.length;
      case 'lrange':
        final List<dynamic> list = cache[parameters['_id']];
        return list
            .getRange(parameters['start'], parameters['stop'] + 1)
            .toList()
            .map((dynamic a) => a.toString())
            .toList();
      case 'lrem':
        final List<dynamic> list = cache[parameters['_id']];
        bool condFn(dynamic value) =>
            value.toString() == parameters['value'].toString();
        final length = list.where(condFn).length;
        list.removeWhere(condFn);
        cache[parameters['_id']] = list;
        return length;
      case 'lset':
        final List<dynamic> list = cache[parameters['_id']];
        list[parameters['index']] = parameters['value'];
        return 'OK';
      case 'ltrim':
        final List<dynamic> list = cache[parameters['_id']];
        list.removeRange(parameters['start'] - 1, parameters['stop'] - 1);
        return 'OK';
      case 'mget':
        final List<dynamic> keys = parameters['keys'];
        return keys.map((key) => cache[key].toString()).toList();
      case 'mset':
        final List<dynamic> entries = parameters['entries'];
        for (var entry in entries) {
          cache[entry['key']] = entry['value'];
        }
        return 'OK';
      case 'msetnx':
        final List<dynamic> entries = parameters['entries'];
        for (var entry in entries) {
          if (cache.containsKey(entry['key'])) {
            return 0;
          } else {
            cache[entry['key']] = entry['value'];
          }
        }
        return 1;
      case 'object':
        switch (parameters['subcommand']) {
          case 'refcount':
            return 1;
            break;
          case 'encoding':
            return 'embstr';
            break;
          case 'idletime':
            return 0;
            break;
        }
        return 1;
      case 'persist':
      case 'pexpire':
      case 'pexpireat':
        return 1;
      case 'pfadd':
        cache[parameters['_id']] = parameters['elements'];
        return 1;
      case 'pfcount':
        var length = 0;
        for (var key in parameters['keys']) {
          length += cache[key].length;
        }
        return length;
      case 'pfmerge':
        return 'OK';
      case 'ping':
        return 'PONG';
      case 'psetex':
        return 'OK';
      case 'pttl':
        return 147;
      case 'randomkey':
        final randKey = Random().nextInt(cache.length);
        return cache.keys.elementAt(randKey);
      case 'rename':
        final value = cache[parameters['_id']];
        cache[parameters['newkey']] = value;
        cache.remove(parameters['_id']);
        return 'OK';
      case 'renamenx':
        final value = cache[parameters['_id']];
        cache[parameters['newkey']] = value;
        cache.remove(parameters['_id']);
        return 1;
      case 'rpop':
        final List<dynamic> list = cache[parameters['_id']];
        cache[parameters['_id']] = list;
        return list.removeLast().toString();
      case 'rpoplpush':
        final List<dynamic> list = cache[parameters['source']];
        final last = list.removeLast();
        if (!cache.containsKey(parameters['destination'])) {
          cache[parameters['destination']] = [];
        }
        (cache[parameters['destination']] as List<dynamic>).insert(0, last);
        return last.toString();
      case 'rpush':
        List<dynamic> list;
        if (cache.containsKey(parameters['_id'])) {
          list = cache[parameters['_id']];
        } else {
          list = <dynamic>[];
        }
        list.insertAll(list.length, parameters['values']);
        cache[parameters['_id']] = list;
        return list.length;
      case 'rpushx':
        final List<dynamic> list = cache[parameters['_id']];
        list.insert(list.length, parameters['value']);
        cache[parameters['_id']] = list;
        return list.length;
      case 'sadd':
        HashSet set;
        if (cache.containsKey(parameters['_id']) &&
            cache[parameters['_id']] != null) {
          set = cache[parameters['_id']];
        } else {
          set = HashSet();
        }
        var count = 0;
        for (var member in parameters['members']) {
          if (!set.contains(member)) {
            set.add(member);
            count += 1;
          }
        }
        cache[parameters['_id']] = set;
        return count;
      case 'scan':
      case 'scard':
        return (cache[parameters['_id']] as HashSet).length;
      case 'sdiff':
        var mainHashSet = cache[parameters['_id']] as HashSet;
        for (var key in parameters['keys']) {
          mainHashSet = mainHashSet.difference(cache[key] as HashSet);
        }
        return mainHashSet.toList();
      case 'sdiffstore':
        var mainHashSet = cache[parameters['_id']] as HashSet;
        for (var key in parameters['keys']) {
          mainHashSet = mainHashSet.difference(cache[key] as HashSet);
        }
        cache[parameters['destination']] = mainHashSet;
        return mainHashSet.length;
      case 'set':
        cache[parameters['_id']] = parameters['value'];
        return 'OK';
      case 'setex':
        cache[parameters['_id']] = parameters['value'];
        return 'OK';
      case 'setnx':
        if (cache.containsKey(parameters['_id'])) {
          return 0;
        }
        cache[parameters['_id']] = parameters['value'];
        return 1;
      case 'sinter':
        HashSet mainHashSet;
        for (var key in parameters['keys']) {
          mainHashSet ??= cache[key];
          mainHashSet = mainHashSet.intersection(cache[key] as HashSet);
        }
        return mainHashSet.toList();
      case 'sinterstore':
        HashSet mainHashSet;
        for (var key in parameters['keys']) {
          mainHashSet ??= cache[key];
          mainHashSet = mainHashSet.intersection(cache[key] as HashSet);
        }
        cache[parameters['destination']] = mainHashSet;
        return mainHashSet.length;
      case 'sismember':
        final mainHashSet = cache[parameters['_id']] as HashSet;
        final doesContains = mainHashSet.contains(parameters['member']);
        return doesContains ? 1 : 0;
      case 'smembers':
        final mainHashSet = cache[parameters['_id']] as HashSet;
        return mainHashSet.toList();
      case 'smove':
        (cache[parameters['_id']] as HashSet).remove(parameters['member']);
        (cache[parameters['destination']] as HashSet).add(parameters['member']);
        return 1;
      case 'sort':
        final mainHashSet = cache[parameters['_id']] as HashSet;
        var mainList = mainHashSet.toList();
        mainList.sort();
        if (parameters['direction'] == 'DESC') {
          mainList = mainList.reversed.toList();
        }
        return mainList;
      case 'spop':
        final removedList = [];
        for (var i = 0; i < parameters['count']; i++) {
          final randKey =
              Random().nextInt((cache[parameters['_id']] as HashSet).length);
          final deleteValue =
              (cache[parameters['_id']] as HashSet).toList()[randKey];
          removedList.add(deleteValue);
          (cache[parameters['_id']] as HashSet).remove(deleteValue);
        }
        return removedList;
      case 'srandmember':
        final randKey =
            Random().nextInt((cache[parameters['_id']] as HashSet).length);
        return (cache[parameters['_id']] as HashSet).toList()[randKey];
      case 'srem':
        var count = 0;
        for (var member in parameters['members']) {
          (cache[parameters['_id']] as HashSet).remove(member);
          count += 1;
        }
        return count;
      case 'sscan':
      case 'strlen':
        return 1;
      case 'sunion':
        HashSet mainHashSet;
        for (var key in parameters['keys']) {
          mainHashSet ??= cache[key];
          mainHashSet = mainHashSet.union(cache[key] as HashSet);
        }
        return mainHashSet.toList();
      case 'sunionstore':
        HashSet mainHashSet;
        for (var key in parameters['keys']) {
          mainHashSet ??= cache[key];
          mainHashSet = mainHashSet.union(cache[key] as HashSet);
        }
        cache[parameters['destination']] = mainHashSet;
        return mainHashSet.length;
      case 'time':
        final now = DateTime.now();
        return [
          (now.millisecondsSinceEpoch / 1000).floor().toString(),
          now.microsecond.toString()
        ];
      case 'touch':
        var count = 0;
        for (var key in parameters['keys']) {
          if (cache.containsKey(key)) {
            count += 1;
          }
        }
        return count;
      case 'ttl':
        return -1;
      case 'type':
        final data = cache[parameters['_id']];
        String type;
        if (data is String) {
          type = 'string';
        } else if (data is HashSet) {
          type = 'set';
        } else if (data is Map) {
          type = 'hash';
        }
        return type;
      case 'zadd':
        LinkedHashSet<ZElement> linkedHashSet;
        final String key = parameters['_id'];
        final List<dynamic> elements = parameters['elements'];
        if (cache.containsKey(key)) {
          linkedHashSet = cache[key];
        } else {
          linkedHashSet = LinkedHashSet<ZElement>();
        }
        var count = 0;
        for (var element in elements) {
          final member = element['member'];
          final double score = element['score'];
          if (!linkedHashSet.contains(member)) {
            linkedHashSet.add(ZElement(member, score));
            count += 1;
          }
        }
        cache[key] = linkedHashSet;
        return count;
      case 'zcard':
        final String key = parameters['_id'];
        final LinkedHashSet<ZElement> linkedHashSet = cache[key];
        return linkedHashSet.length;
      case 'zcount':
        final String key = parameters['_id'];
        final double min = parameters['min'];
        final double max = parameters['max'];
        final LinkedHashSet<ZElement> linkedHashSet = cache[key];
        var count = 0;
        for (var element in linkedHashSet) {
          if (element.compareScore(min, max)) {
            count += 1;
          }
        }
        return count;
      case 'zincrby':
        final String key = parameters['_id'];
        final member = parameters['member'];
        final double value = parameters['value'];
        (cache[key] as LinkedHashSet<ZElement>)
            .where((element) => element.value == member)
            .first
            .score += value;
        return (cache[key] as LinkedHashSet<ZElement>)
            .where((element) => element.value == member)
            .first
            .score
            .toString();
      case 'zinterstore':
        final String key = parameters['_id'];
        final List<dynamic> keys = parameters['keys'];
        LinkedHashSet<ZElement> tempIntersection;
        for (var keyu in keys) {
          tempIntersection ??= cache[keyu] as LinkedHashSet<ZElement>;
          tempIntersection = tempIntersection
              .intersection(cache[keyu] as LinkedHashSet<ZElement>);
        }
        cache[key] = tempIntersection;
        return tempIntersection.length;
      case 'zlexcount':
        final String key = parameters['_id'];
        final String min = parameters['min'];
        final String max = parameters['max'];
        var count = 0;
        for (var element in cache[key] as LinkedHashSet<ZElement>) {
          if (element.compareLex(min, max)) {
            count += 1;
          }
        }
        return count;
      case 'zrange':
        final String key = parameters['_id'];
        final int start = parameters['start'];
        int stop = parameters['stop'];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        if (stop >= elements.length) {
          stop = elements.length - 1;
        }
        return elements
            .sublist(start, stop + 1)
            .map((element) => element.value)
            .toList();
      case 'zrangebylex':
        final String key = parameters['_id'];
        final String min = parameters['min'];
        final String max = parameters['max'];
        final rlements = [];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        for (var element in elements) {
          if (element.compareLex(min, max)) {
            rlements.add(element.value);
          }
        }
        return rlements.toList();
      case 'zrangebyscore':
        final String key = parameters['_id'];
        final double min = parameters['min'];
        final double max = parameters['max'];
        final rlements = [];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        for (var element in elements) {
          if (element.compareScore(min, max)) {
            rlements.add(element.value);
          }
        }
        return rlements.toList();
      case 'zrank':
        final String key = parameters['_id'];
        final member = parameters['member'];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        return elements
            .map((element) => element.value)
            .toList()
            .indexOf(member);
      case 'zrem':
        final String key = parameters['_id'];
        final List<dynamic> members = parameters['members'];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        var count = 0;
        for (var element in elements) {
          for (var member in members) {
            if (element.value == member) {
              (cache[key] as LinkedHashSet<ZElement>).remove(element);
              count += 1;
            }
          }
        }
        return count;
      case 'zremrangebylex':
        final String key = parameters['_id'];
        final String min = parameters['min'];
        final String max = parameters['max'];
        var count = 0;
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        for (var element in elements) {
          if (element.compareLex(min, max)) {
            (cache[key] as LinkedHashSet<ZElement>).remove(element);
            count += 1;
          }
        }
        return count;
      case 'zremrangebyrank':
        final String key = parameters['_id'];
        final int start = parameters['start'];
        int stop = parameters['stop'];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        if (stop >= elements.length) {
          stop = elements.length - 1;
        }
        var count = 0;
        for (var element in elements.sublist(start, stop + 1)) {
          (cache[key] as LinkedHashSet<ZElement>).remove(element);
          count += 1;
        }
        return count;
      case 'zremrangebyscore':
        final String key = parameters['_id'];
        final double min = parameters['min'];
        final double max = parameters['max'];
        var count = 0;
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        for (var element in elements) {
          if (element.compareScore(min, max)) {
            (cache[key] as LinkedHashSet<ZElement>).remove(element);
            count += 1;
          }
        }
        return count;
      case 'zrevrange':
        final String key = parameters['_id'];
        final int start = parameters['start'];
        int stop = parameters['stop'];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        if (stop >= elements.length) {
          stop = elements.length - 1;
        }
        return elements.reversed
            .toList()
            .sublist(start, stop + 1)
            .map((element) => element.value)
            .toList();
      case 'zrevrangebylex':
        final String key = parameters['_id'];
        final String min = parameters['min'];
        final String max = parameters['max'];
        final rlements = [];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        for (var element in elements.reversed) {
          if (element.compareLex(min, max)) {
            rlements.add(element.value);
          }
        }
        return rlements.toList();
      case 'zrevrangebyscore':
        final String key = parameters['_id'];
        final double min = parameters['min'];
        final double max = parameters['max'];
        final rlements = [];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        for (var element in elements.reversed) {
          if (element.compareScore(min, max)) {
            rlements.add(element.value);
          }
        }
        return rlements.toList();
      case 'zrevrank':
        final String key = parameters['_id'];
        final member = parameters['member'];
        final elements = (cache[key] as LinkedHashSet<ZElement>).toList();
        elements.sort(ZElement.compare);
        return elements.reversed
            .map((element) => element.value)
            .toList()
            .indexOf(member);
      case 'zscan':
        break;
      case 'zscore':
        final String key = parameters['_id'];
        final member = parameters['member'];
        return (cache[key] as LinkedHashSet<ZElement>)
            .where((element) => element.value == member)
            .first
            .score
            .toString();
        break;
      case 'zunionstore':
        final String key = parameters['_id'];
        final List<dynamic> keys = parameters['keys'];
        LinkedHashSet<ZElement> tempIntersection;
        for (var keyu in keys) {
          tempIntersection ??= cache[keyu] as LinkedHashSet<ZElement>;
          tempIntersection =
              tempIntersection.union(cache[keyu] as LinkedHashSet<ZElement>);
        }
        cache[key] = tempIntersection;
        return tempIntersection.length;
      default:
        return null;
    }
  }
}

class ZElement {
  ZElement(this.value, this.score);
  double score;
  dynamic value;

  @override
  bool operator ==(dynamic other) => other is ZElement && other.value == value;

  @override
  int get hashCode => value.hashCode;

  bool compareScore(double min, double max) => min <= score && score <= max;

  bool compareLex(String min, String max) {
    var shouldInclude = false;
    if (min[0] == '[' || max[0] == '[') {
      if (value == min.substring(1) || value == max.substring(1)) {
        shouldInclude = true;
      }
    }
    if ((value as String).compareTo(min.substring(1)) > 0 &&
        (value as String).compareTo(max.substring(1)) < 0) {
      shouldInclude = true;
    }
    return shouldInclude;
  }

  static int compare(ZElement el1, ZElement el2) =>
      (el1.score - el2.score).ceil();
}
