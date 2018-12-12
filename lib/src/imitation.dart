import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:geohash/geohash.dart';
import 'helpers.dart';
import 'imitation_databse.dart';

class ImitationServer {
  final ImitationDatabase imitationDatabase = ImitationDatabase();

  String transform(String data) {
    final jsonRequest = json.decode(data);
    // print(jsonRequest);
    var response = <String, dynamic>{};
    switch (jsonRequest['controller']) {
      case 'admin':
        response = _admin(jsonRequest);
        break;
      case 'auth':
        response = _auth(jsonRequest);
        break;
      case 'bulk':
        response = _bulk(jsonRequest);
        break;
      case 'collection':
        response = _collection(jsonRequest);
        break;
      case 'document':
        response = _document(jsonRequest);
        break;
      case 'index':
        response = _index(jsonRequest);
        break;
      case 'ms':
        response = _ms(jsonRequest);
        break;
      case 'realtime':
        response = _realtime(jsonRequest);
        break;
      case 'security':
        response = _security(jsonRequest);
        break;
      case 'server':
        response = _server(jsonRequest);
        break;
      default:
        break;
    }
    response['requestId'] = jsonRequest['requestId'];
    response['controller'] = jsonRequest['controller'];
    // print(imitationDatabase.db);
    return json.encode(response);
  }

  Map<String, dynamic> _admin(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'dump':
      case 'resetCache':
      case 'resetDatabase':
      case 'resetKuzzleData':
      case 'resetSecurity':
      case 'shutdowndefault:':
        response['result'] = <String, dynamic>{};
        break;
    }
    return response;
  }

  Map<String, dynamic> _auth(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'checkToken':
      case 'createMyCredentials':
      case 'credentialsExist':
      case 'deleteMyCredentials':
      case 'getCurrentUser':
      case 'getMyCredentials':
      case 'getMyRights':
      case 'getStrategies':
      case 'login':
        response['result'] = <String, dynamic>{
          'uuid': Uuid().v1(),
          'jwt': Uuid().v1(),
          'expiresAt': 1321085955000,
          'ttl': 360000
        };
        break;
      case 'logout':
      case 'updateMyCredentials':
      case 'updateSelf':
      case 'validateMyCredentials':
      default:
        response['result'] = <String, dynamic>{};
        break;
    }

    return response;
  }

  Map<String, dynamic> _bulk(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'import':
      default:
        break;
    }

    return response;
  }

  /// takes in json and returns a string
  Map<String, dynamic> _collection(jsonRequest) {
    final doesIndexExist =
        imitationDatabase.doesIndexExist(jsonRequest['index']);
    final doesCollectionExist =
        imitationDatabase.doesCollectionExist(jsonRequest);

    final response = <String, dynamic>{};
    switch (jsonRequest['action']) {
      case 'create':
        if (!doesIndexExist) {
          response['result'] = <String, dynamic>{'acknowledged': false};
        } else {
          imitationDatabase.db[jsonRequest['index']]
              [jsonRequest['collection']] = <String, dynamic>{};
          response['result'] = <String, dynamic>{'acknowledged': true};
        }
        break;
      case 'deleteSpecifications':
        response['result'] = <String, dynamic>{
          'acknowledged': true,
        };
        break;
      case 'exists':
        response['result'] = doesCollectionExist;
        break;
      case 'getMapping':
        response['result'] = <String, dynamic>{
          jsonRequest['index']: <String, dynamic>{
            'mappings': <String, dynamic>{
              jsonRequest['collection']: <String, dynamic>{
                'properties': <String, dynamic>{}
              }
            }
          }
        };
        break;
      case 'getSpecifications':
        response['result'] = <String, dynamic>{
          'collection': jsonRequest['collection'],
          'index': jsonRequest['index'],
          'validation': <String, dynamic>{'fields': {}},
        };
        break;
      case 'list':
        response['result'] = <String, dynamic>{
          'collections': <Map<String, dynamic>>[
            <String, dynamic>{
              'name': 'posts',
              'type': 'realtime',
            },
          ]
        };
        break;
      case 'scrollSpecifications':
        response['result'] = <String, dynamic>{
          'scrollId': Uuid().v1(),
          'total': 1,
          'hits': <Map<String, dynamic>>[
            <String, dynamic>{
              '_id': '${jsonRequest['index']}#posts',
              'index': jsonRequest['index'],
              '_score': 1,
              '_source': <String, dynamic>{
                'collection': 'posts',
                'index': jsonRequest['index'],
                'validation': <String, dynamic>{}
              }
            },
          ]
        };
        break;
      case 'searchSpecifications':
        response['result'] = <String, dynamic>{
          '_shards': <String, dynamic>{
            'failed': 0,
            'successful': 5,
            'total': 5,
          },
          'total': 5,
          'hits': <Map<String, dynamic>>[
            <String, dynamic>{
              '_id': '${jsonRequest['index']}#posts',
              'index': jsonRequest['index'],
              '_score': 1,
              '_source': <String, dynamic>{
                'collection': 'posts',
                'index': jsonRequest['index'],
                'validation': <String, dynamic>{}
              }
            },
          ]
        };
        break;
      case 'truncate':
        response['result'] = {
          'ids': (imitationDatabase.db[jsonRequest['index']]
                  [jsonRequest['collection']] as Map<String, dynamic>)
              .keys
              .toList(),
        };
        break;
      case 'updateMapping':
        response['result'] = <String, dynamic>{};
        break;
      case 'updateSpecifications':
        response['result'] = <String, dynamic>{
          jsonRequest['index']: <String, dynamic>{
            jsonRequest['collection']: <String, dynamic>{
              'fields': {}
            } // This is a validation
          },
        };
        break;
      case 'validateSpecifications':
        response['result'] = <String, dynamic>{
          'valid': true,
          'details': <dynamic>[],
          'description': '',
        };
        break;
      default:
        response['result'] = <String, dynamic>{};
        break;
    }
    response['status'] = 200;
    response['error'] = null;
    response['index'] = jsonRequest['index'];
    response['collection'] = jsonRequest['collection'];
    return response;
  }

  Map<String, dynamic> _document(jsonRequest) {
    final response = <String, dynamic>{};
    switch (jsonRequest['action']) {
      case 'count':
        if (imitationDatabase.doesCollectionExist(jsonRequest)) {
          response['result'] = <String, dynamic>{
            'count': imitationDatabase.getCollection(jsonRequest).length,
          };
        }
        break;
      case 'create':
        if (imitationDatabase.doesCollectionExist(jsonRequest)) {
          final String id = Uuid().v1();
          (imitationDatabase.db[jsonRequest['index']][jsonRequest['collection']]
                  as Map<String, dynamic>)
              .addAll(<String, dynamic>{
            id: jsonRequest['body'],
          });
          response['result'] = <String, dynamic>{
            '_id': id,
            '_version': 1,
            '_source': jsonRequest['body'],
          };
        }
        break;
      case 'delete':
        if (imitationDatabase.doesCollectionExist(jsonRequest)) {
          (imitationDatabase.db[jsonRequest['index']][jsonRequest['collection']]
                  as Map<String, dynamic>)
              .remove(jsonRequest['_id']);
          response['result'] = <String, dynamic>{
            '_id': jsonRequest['_id'],
          };
        }
        break;
      case 'deleteByQuery':
      case 'exists':
        response['result'] =
            imitationDatabase.doesCollectionExist(jsonRequest) &&
                (imitationDatabase.db[jsonRequest['index']]
                        [jsonRequest['collection']] as Map<String, dynamic>)
                    .containsKey(jsonRequest['_id']);
        break;
      case 'get':
        if (imitationDatabase.doesCollectionExist(jsonRequest)) {
          final Map<String, dynamic> documentBody = (imitationDatabase
                  .db[jsonRequest['index']][jsonRequest['collection']]
              as Map<String, dynamic>)[jsonRequest['_id']];
          response['result'] = <String, dynamic>{
            '_id': jsonRequest['_id'],
            '_source': documentBody,
            '_version': 1,
          };
        }
        break;
      case 'mDelete':
        final List<dynamic> ids = jsonRequest['body']['ids'];
        final deletedIds = ids.map((id) {
          (imitationDatabase.db[jsonRequest['index']][jsonRequest['collection']]
                  as Map<String, dynamic>)
              .remove(id);
          return id;
        }).toList();
        response['result'] = deletedIds;
        break;
      case 'mGet':
        final List<dynamic> ids = jsonRequest['body']['ids'];
        final hits = ids.map((id) {
          final body = (imitationDatabase.db[jsonRequest['index']]
              [jsonRequest['collection']] as Map<String, dynamic>)[id];
          return {
            '_id': id,
            '_source': body,
          };
        }).toList();
        response['result'] = {
          'hits': hits,
        };
        break;
      case 'mCreate':
      case 'mCreateOrReplace':
      case 'mReplace':
        final List<dynamic> documents = jsonRequest['body']['documents'];
        final hits = documents.map((document) {
          String id;
          if (document.containsKey('_id') &&
              (imitationDatabase.db[jsonRequest['index']]
                      [jsonRequest['collection']] as Map<String, dynamic>)
                  .containsKey(document['_id'])) {
            id = document['_id'];
          } else {
            id = Uuid().v1();
          }
          (imitationDatabase.db[jsonRequest['index']][jsonRequest['collection']]
              as Map<String, dynamic>)[id] = document['body'];
          return {
            '_id': id,
            '_source': document['body'],
          };
        }).toList();
        response['result'] = {
          'hits': hits,
        };
        break;
      case 'mUpdate':
      case 'createOrReplace':
      case 'replace':
        if (imitationDatabase.doesCollectionExist(jsonRequest) &&
            (imitationDatabase.db[jsonRequest['index']]
                    [jsonRequest['collection']] as Map<String, dynamic>)
                .containsKey(jsonRequest['_id'])) {
          (imitationDatabase.db[jsonRequest['index']][jsonRequest['collection']]
                  as Map<String, dynamic>)[jsonRequest['_id']] =
              jsonRequest['body'];
          response['result'] = <String, dynamic>{
            '_id': jsonRequest['_id'],
            '_source': jsonRequest['body'],
            '_version': 1,
          };
        }
        break;
      case 'scroll':
        response['result'] = <String, dynamic>{
          'hits': <Map<String, dynamic>>[],
        };
        break;
      case 'search':
        response['result'] = <String, dynamic>{
          'hits': <Map<String, dynamic>>[],
        };
        break;
      case 'update':
        if (imitationDatabase.doesCollectionExist(jsonRequest)) {
          (imitationDatabase.db[jsonRequest['index']][jsonRequest['collection']]
                  as Map<String, dynamic>)[jsonRequest['_id']]
              .addAll(jsonRequest['body']);
          response['result'] = <String, dynamic>{
            '_id': jsonRequest['_id'],
            'created': false,
            'result': 'updated',
            '_version': 1,
          };
        }
        break;
      case 'validate':
        response['result'] = <String, dynamic>{
          'errorMessages': emptyMap,
          'valid': true,
        };
        break;
      default:
        response['result'] = <String, dynamic>{};
        break;
    }
    response['status'] = 200;
    response['error'] = null;
    response['index'] = jsonRequest['index'];
    response['collection'] = jsonRequest['collection'];
    return response;
  }

  Map<String, dynamic> _index(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'create':
        imitationDatabase.db[jsonRequest['index']] = <String, dynamic>{};
        response['result'] = <String, dynamic>{
          'acknowledged': true,
          'shards_acknowledged': true,
        };
        break;
      case 'delete':
        imitationDatabase.db.remove(jsonRequest['index']);
        response['result'] = <String, dynamic>{
          'acknowledged': true,
        };
        break;
      case 'exists':
        response['result'] =
            imitationDatabase.doesIndexExist(jsonRequest['index']);
        break;
      case 'getAutoRefresh':
        response['result'] = false;
        break;
      case 'list':
        response['result'] = <String, dynamic>{
          'indexes': imitationDatabase.db.keys.toList(),
        };
        break;
      case 'mDelete':
      case 'refresh':
        response['result'] = <String, dynamic>{
          '_shards': <String, dynamic>{
            'failed': 0,
            'successful': 10,
            'total': 10,
          },
        };
        break;
      case 'refreshInternal':
      case 'setAutoRefresh':
        response['result'] = <String, dynamic>{
          'response': jsonRequest['body']['autoRefresh'],
        };
        break;
      default:
        response['result'] = <String, dynamic>{};
        break;
    }

    return response;
  }

  Map<String, dynamic> _ms(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'append':
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['value'];
        response['result'] = imitationDatabase.cache[jsonRequest['_id']].length;
        break;
      case 'bitcount':
        final byteString = stringToBytes(
            imitationDatabase.cache[jsonRequest['_id']] as String);
        final count = '1'.allMatches(byteString).length;
        response['result'] = count;
        break;
      case 'bitop':
        final keys = jsonRequest['body']['keys'];
        final List<dynamic> byteValues =
            keys.map((key) => int.parse(imitationDatabase.cache[key])).toList();
        int value;
        switch (jsonRequest['body']['operation']) {
          case 'AND':
            value = byteValues.fold(
                0, (prevValue, curValue) => prevValue & curValue);
            break;
          case 'OR':
            value = byteValues.fold(
                0, (prevValue, curValue) => prevValue | curValue);
            break;
        }
        imitationDatabase.cache[jsonRequest['_id']] = value.toString();
        response['result'] = value.toString().length;
        break;
      case 'bitpos':
        final bytesStr =
            stringToBytes(imitationDatabase.cache[jsonRequest['_id']]);
        response['result'] =
            bytesStr.indexOf(jsonRequest['bit'].toString()) + 1;
        break;
      case 'dbsize':
        response['result'] = imitationDatabase.cache.keys.length;
        break;
      case 'decr':
        final String value = imitationDatabase.cache[jsonRequest['_id']];
        final valueInt = int.parse(value) - 1;
        response['result'] = valueInt;
        imitationDatabase.cache[jsonRequest['_id']] = valueInt.toString();
        break;
      case 'decrby':
        final String value = imitationDatabase.cache[jsonRequest['_id']];
        final valueInt = int.parse(value) - jsonRequest['body']['value'];
        response['result'] = valueInt;
        imitationDatabase.cache[jsonRequest['_id']] = valueInt.toString();
        break;
      case 'del':
        var deletedCount = 0;
        jsonRequest['body']['keys'].forEach((key) {
          if (imitationDatabase.cache.containsKey(key)) {
            imitationDatabase.cache.remove(key);
            deletedCount += 1;
          }
        });
        response['result'] = deletedCount;
        break;
      case 'exists':
        var existsCount = 0;
        jsonRequest['keys'].forEach((key) {
          if (imitationDatabase.cache.containsKey(key)) {
            existsCount += 1;
          }
        });
        response['result'] = existsCount;
        break;
      case 'expire':
        Future.delayed(
            Duration(
              seconds: jsonRequest['body']['seconds'],
            ), () {
          imitationDatabase.cache.remove(jsonRequest['_id']);
        });
        response['result'] = 1;
        break;
      case 'expireat':
        imitationDatabase.cache.remove(jsonRequest['_id']);
        response['result'] = 1;
        break;
      case 'flushdb':
        imitationDatabase.cache.removeWhere((key, value) => true);
        response['result'] = 'OK';
        break;
      case 'geoadd':
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['points'];
        response['result'] = imitationDatabase.cache[jsonRequest['_id']].length;
        break;
      case 'geodist':
        final points =
            imitationDatabase.cache[jsonRequest['_id']] as List<dynamic>;
        final point1 = points
            .where((point) => point['name'] == jsonRequest['member1'])
            .elementAt(0);
        final point2 = points
            .where((point) => point['name'] == jsonRequest['member2'])
            .elementAt(0);
        var distance = pow(point1['lat'] - point2['lat'], 2) +
            pow(point1['lon'] - point2['lon'], 2);
        distance = sqrt(distance);
        response['result'] = (distance * 111189.08081122051).toString();
        break;
      case 'geohash':
        final points =
            imitationDatabase.cache[jsonRequest['_id']] as List<dynamic>;
        final hashes = jsonRequest['members'].map((member) {
          final point =
              points.where((point) => point['name'] == member).elementAt(0);
          return Geohash.encode(point['lat'], point['lon']);
        }).toList();
        response['result'] = hashes;
        break;
      case 'geopos':
        final points =
            imitationDatabase.cache[jsonRequest['_id']] as List<dynamic>;
        final geopositions = jsonRequest['members'].map((member) {
          final point =
              points.where((point) => point['name'] == member).elementAt(0);
          return [point['lon'].toString(), point['lat'].toString()];
        }).toList();
        response['result'] = geopositions;
        break;
      case 'georadius':
        response['result'] = [];
        break;
      case 'georadiusbymember':
        final points =
            imitationDatabase.cache[jsonRequest['_id']] as List<dynamic>;
        response['result'] = [points[0]['name']];
        break;
      case 'get':
        response['result'] = imitationDatabase.cache[jsonRequest['_id']];
        break;
      case 'getbit':
        final bytesStr =
            stringToBytes(imitationDatabase.cache[jsonRequest['_id']]);
        response['result'] = int.parse(bytesStr[jsonRequest['offset']]);
        break;
      case 'getrange':
        final String str = imitationDatabase.cache[jsonRequest['_id']];
        response['result'] =
            str.substring(jsonRequest['start'], jsonRequest['end'] + 1);
        break;
      case 'getset':
        final String prevValue = imitationDatabase.cache[jsonRequest['_id']];
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['value'];
        response['result'] = prevValue;
        break;
      case 'hdel':
        var deletedField = 0;
        jsonRequest['body']['fields'].forEach((field) {
          deletedField += 1;
          (imitationDatabase.cache[jsonRequest['_id']] as Map<String, dynamic>)
              .remove(field);
        });
        response['result'] = deletedField;
        break;
      case 'hexists':
        final doesContains =
            imitationDatabase.cache.containsKey(jsonRequest['_id']) &&
                imitationDatabase.cache[jsonRequest['_id']]
                    .containsKey(jsonRequest['field']);
        response['result'] = doesContains ? 1 : 0;
        break;
      case 'hget':
        if (!imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          response['result'] = null;
          break;
        }
        response['result'] =
            imitationDatabase.cache[jsonRequest['_id']][jsonRequest['field']];
        break;
      case 'hgetall':
        response['result'] = imitationDatabase.cache[jsonRequest['_id']];
        break;
      case 'hincrby':
        if (!imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          imitationDatabase.cache[jsonRequest['_id']] = {};
        }
        final String prevValue = imitationDatabase.cache[jsonRequest['_id']]
            [jsonRequest['body']['field']];
        var prevIntValue = int.parse(prevValue);
        prevIntValue += jsonRequest['body']['value'];
        imitationDatabase.cache[jsonRequest['_id']]
            [jsonRequest['body']['field']] = prevIntValue.toString();
        response['result'] = prevIntValue;
        break;
      case 'hincrbyfloat':
        if (!imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          imitationDatabase.cache[jsonRequest['_id']] = {};
        }
        final String prevValue = imitationDatabase.cache[jsonRequest['_id']]
            [jsonRequest['body']['field']];
        var prevIntValue = double.parse(prevValue);
        prevIntValue += jsonRequest['body']['value'];
        imitationDatabase.cache[jsonRequest['_id']]
            [jsonRequest['body']['field']] = prevIntValue.toString();
        response['result'] = prevIntValue.toString();
        break;
      case 'hkeys':
        response['result'] =
            imitationDatabase.cache[jsonRequest['_id']].keys.toList();
        break;
      case 'hlen':
        response['result'] =
            imitationDatabase.cache[jsonRequest['_id']].keys.length;
        break;
      case 'hmget':
        final result = jsonRequest['fields']
            .map((field) => (imitationDatabase.cache[jsonRequest['_id']]
                as Map<String, dynamic>)[field])
            .toList();
        response['result'] = result;
        break;
      case 'hmset':
        jsonRequest['body']['entries']
            .map((entry) => (imitationDatabase.cache[jsonRequest['_id']]
                    as Map<String, dynamic>)[entry['field']] =
                entry['value'].toString())
            .toList();
        response['result'] = 'OK';
        break;
      case 'hscan':
        break;
      case 'hset':
        if (!imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          imitationDatabase.cache[jsonRequest['_id']] = <String, dynamic>{};
        }
        imitationDatabase.cache[jsonRequest['_id']]
                [jsonRequest['body']['field']] =
            jsonRequest['body']['value'].toString();
        response['result'] = 1;
        break;
      case 'hsetnx':
        if (!imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          imitationDatabase.cache[jsonRequest['_id']] = <String, dynamic>{};
        }
        if (imitationDatabase.cache[jsonRequest['_id']]
            .containsKey(jsonRequest['body']['field'])) {
          response['result'] = 0;
          break;
        }
        imitationDatabase.cache[jsonRequest['_id']]
                [jsonRequest['body']['field']] =
            jsonRequest['body']['value'].toString();
        response['result'] = 1;
        break;
      case 'hstrlen':
        response['result'] = (imitationDatabase.cache[jsonRequest['_id']]
                [jsonRequest['field']])
            .toString()
            .length;
        break;
      case 'hvals':
        response['result'] = (imitationDatabase.cache[jsonRequest['_id']]
                as Map<String, dynamic>)
            .values
            .toList();
        break;
        break;
      case 'incr':
        final String prevValue = imitationDatabase.cache[jsonRequest['_id']];
        var prevValueInt = int.parse(prevValue);
        prevValueInt += 1;
        imitationDatabase.cache[jsonRequest['_id']] = prevValueInt.toString();
        response['result'] = prevValueInt;
        break;
      case 'incrby':
        final String prevValue = imitationDatabase.cache[jsonRequest['_id']];
        var prevValueInt = int.parse(prevValue);
        prevValueInt += jsonRequest['body']['value'];
        imitationDatabase.cache[jsonRequest['_id']] = prevValueInt.toString();
        response['result'] = prevValueInt;
        break;
      case 'incrbyfloat':
        final String prevValue = imitationDatabase.cache[jsonRequest['_id']];
        var prevValueDouble = double.parse(prevValue);
        prevValueDouble += jsonRequest['body']['value'];
        imitationDatabase.cache[jsonRequest['_id']] =
            prevValueDouble.toString();
        response['result'] = prevValueDouble.toString();
        break;
      case 'keys':
        response['result'] = imitationDatabase.cache.keys.toList();
        break;
      case 'lindex':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        response['result'] = list[jsonRequest['index']];
        break;
      case 'linsert':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        final index = list.indexOf(jsonRequest['body']['pivot']);
        list.insert(index, jsonRequest['body']['value']);
        imitationDatabase.cache[jsonRequest['_id']] = list;
        response['result'] = list.length;
        break;
      case 'llen':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        response['result'] = list.length;
        break;
      case 'lpop':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        response['result'] = list.removeAt(0).toString();
        imitationDatabase.cache[jsonRequest['_id']] = list;
        break;
      case 'lpush':
        List<dynamic> list;
        if (imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          list = imitationDatabase.cache[jsonRequest['_id']];
        } else {
          list = <dynamic>[];
        }
        list.insertAll(0,
            (jsonRequest['body']['values'] as List<dynamic>).reversed.toList());
        imitationDatabase.cache[jsonRequest['_id']] = list;
        response['result'] = list.length;
        break;
      case 'lpushx':
        if (!imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          response['result'] = 0;
          break;
        }
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        list.insert(0, jsonRequest['body']['value']);
        imitationDatabase.cache[jsonRequest['_id']] = list;
        response['result'] = list.length;
        break;
      case 'lrange':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        response['result'] = list
            .getRange(jsonRequest['start'], jsonRequest['stop'] + 1)
            .toList()
            .map((dynamic a) => a.toString())
            .toList();
        break;
      case 'lrem':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        bool condFn(dynamic value) =>
            value.toString() == jsonRequest['body']['value'].toString();
        final length = list.where(condFn).length;
        list.removeWhere(condFn);
        imitationDatabase.cache[jsonRequest['_id']] = list;
        response['result'] = length;
        break;
      case 'lset':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        list[jsonRequest['body']['index']] = jsonRequest['body']['value'];
        response['result'] = 'OK';
        break;
      case 'ltrim':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        list.removeRange(
            jsonRequest['body']['start'] - 1, jsonRequest['body']['stop'] - 1);
        response['result'] = 'OK';
        break;
      case 'mget':
        final List<dynamic> keys = jsonRequest['keys'];
        response['result'] =
            keys.map((key) => imitationDatabase.cache[key].toString()).toList();
        break;
      case 'mset':
        final List<dynamic> entries = jsonRequest['body']['entries'];
        for (var entry in entries) {
          imitationDatabase.cache[entry['key']] = entry['value'];
        }
        response['result'] = 'OK';
        break;
      case 'msetnx':
        final List<dynamic> entries = jsonRequest['body']['entries'];
        for (var entry in entries) {
          if (imitationDatabase.cache.containsKey(entry['key'])) {
            response['result'] = 0;
            return response;
          } else {
            imitationDatabase.cache[entry['key']] = entry['value'];
          }
        }
        response['result'] = 1;
        break;
      case 'object':
        switch (jsonRequest['subcommand']) {
          case 'refcount':
            response['result'] = 1;
            break;
          case 'encoding':
            response['result'] = 'embstr';
            break;
          case 'idletime':
            response['result'] = 0;
            break;
        }
        break;
      case 'persist':
      case 'pexpire':
      case 'pexpireat':
        response['result'] = 1;
        break;
      case 'pfadd':
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['elements'];
        response['result'] = 1;
        break;
      case 'pfcount':
        var length = 0;
        for (var key in jsonRequest['keys']) {
          length += imitationDatabase.cache[key].length;
        }
        response['result'] = length;
        break;
      case 'pfmerge':
        response['result'] = 'OK';
        break;
      case 'ping':
        response['result'] = 'PONG';
        break;
      case 'psetex':
        response['result'] = 'OK';
        break;
      case 'pttl':
      case 'psetex':
        response['result'] = 147;
        break;
      case 'randomkey':
        final randKey = Random().nextInt(imitationDatabase.cache.length);
        response['result'] = imitationDatabase.cache.keys.elementAt(randKey);
        break;
      case 'rename':
        final value = imitationDatabase.cache[jsonRequest['_id']];
        imitationDatabase.cache[jsonRequest['body']['newkey']] = value;
        imitationDatabase.cache.remove(jsonRequest['_id']);
        response['result'] = 'OK';
        break;
      case 'renamenx':
        final value = imitationDatabase.cache[jsonRequest['_id']];
        imitationDatabase.cache[jsonRequest['body']['newkey']] = value;
        imitationDatabase.cache.remove(jsonRequest['_id']);
        response['result'] = 1;
        break;
      case 'rpop':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        response['result'] = list.removeLast().toString();
        imitationDatabase.cache[jsonRequest['_id']] = list;
        break;
      case 'rpoplpush':
        final List<dynamic> list =
            imitationDatabase.cache[jsonRequest['body']['source']];
        final last = list.removeLast();
        if (!imitationDatabase.cache
            .containsKey(jsonRequest['body']['destination'])) {
          imitationDatabase.cache[jsonRequest['body']['destination']] = [];
        }
        (imitationDatabase.cache[jsonRequest['body']['destination']]
                as List<dynamic>)
            .insert(0, last);
        response['result'] = last.toString();
        break;
      case 'rpush':
        List<dynamic> list;
        if (imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          list = imitationDatabase.cache[jsonRequest['_id']];
        } else {
          list = <dynamic>[];
        }
        list.insertAll(list.length, jsonRequest['body']['values']);
        imitationDatabase.cache[jsonRequest['_id']] = list;
        response['result'] = list.length;
        break;
      case 'rpushx':
        final List<dynamic> list = imitationDatabase.cache[jsonRequest['_id']];
        list.insert(list.length, jsonRequest['body']['value']);
        imitationDatabase.cache[jsonRequest['_id']] = list;
        response['result'] = list.length;
        break;
      case 'sadd':
        Set set;
        if (imitationDatabase.cache.containsKey(jsonRequest['_id']) &&
            imitationDatabase.cache[jsonRequest['_id']] != null) {
          set = imitationDatabase.cache[jsonRequest['_id']];
        } else {
          set = Set();
        }
        var count = 0;
        for (var member in jsonRequest['body']['members']) {
          if (!set.contains(member)) {
            set.add(member);
            count += 1;
          }
        }
        imitationDatabase.cache[jsonRequest['_id']] = set;
        response['result'] = count;
        break;
      case 'scan':
      case 'scard':
        response['result'] =
            (imitationDatabase.cache[jsonRequest['_id']] as Set).length;
        break;
      case 'sdiff':
        var mainSet = imitationDatabase.cache[jsonRequest['_id']] as Set;
        for (var key in jsonRequest['keys']) {
          mainSet = mainSet.difference(imitationDatabase.cache[key] as Set);
        }
        response['result'] = mainSet.toList();
        break;
      case 'sdiffstore':
        var mainSet = imitationDatabase.cache[jsonRequest['_id']] as Set;
        for (var key in jsonRequest['body']['keys']) {
          mainSet = mainSet.difference(imitationDatabase.cache[key] as Set);
        }
        imitationDatabase.cache[jsonRequest['body']['destination']] = mainSet;
        response['result'] = mainSet.length;
        break;
      case 'set':
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['value'];
        response['result'] = 'OK';
        break;
      case 'setex':
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['value'];
        response['result'] = 'OK';
        break;
      case 'setnx':
        if (imitationDatabase.cache.containsKey(jsonRequest['_id'])) {
          response['result'] = 0;
          break;
        }
        imitationDatabase.cache[jsonRequest['_id']] =
            jsonRequest['body']['value'];
        response['result'] = 1;
        break;
      case 'sinter':
        Set mainSet;
        for (var key in jsonRequest['keys']) {
          mainSet ??= imitationDatabase.cache[key];
          mainSet = mainSet.intersection(imitationDatabase.cache[key] as Set);
        }
        response['result'] = mainSet.toList();
        break;
      case 'sinterstore':
        Set mainSet;
        for (var key in jsonRequest['body']['keys']) {
          mainSet ??= imitationDatabase.cache[key];
          mainSet = mainSet.intersection(imitationDatabase.cache[key] as Set);
        }
        imitationDatabase.cache[jsonRequest['body']['destination']] = mainSet;
        response['result'] = mainSet.length;
        break;
      case 'sismember':
        final mainSet = imitationDatabase.cache[jsonRequest['_id']] as Set;
        final doesContains = mainSet.contains(jsonRequest['member']);
        response['result'] = doesContains ? 1 : 0;
        break;
      case 'smembers':
        final mainSet = imitationDatabase.cache[jsonRequest['_id']] as Set;
        response['result'] = mainSet.toList();
        break;
      case 'smove':
        (imitationDatabase.cache[jsonRequest['_id']] as Set)
            .remove(jsonRequest['body']['member']);
        (imitationDatabase.cache[jsonRequest['body']['destination']] as Set)
            .add(jsonRequest['body']['member']);
        response['result'] = 1;
        break;
      case 'sort':
        final mainSet = imitationDatabase.cache[jsonRequest['_id']] as Set;
        var mainList = mainSet.toList();
        mainList.sort();
        if (jsonRequest['body']['direction'] == 'DESC') {
          mainList = mainList.reversed.toList();
        }
        response['result'] = mainList;
        break;
      case 'spop':
        final removedList = [];
        for (var i = 0; i < jsonRequest['body']['count']; i++) {
          final randKey = Random().nextInt(
              (imitationDatabase.cache[jsonRequest['_id']] as Set).length);
          final deleteValue =
              (imitationDatabase.cache[jsonRequest['_id']] as Set)
                  .toList()[randKey];
          removedList.add(deleteValue);
          (imitationDatabase.cache[jsonRequest['_id']] as Set)
              .remove(deleteValue);
        }
        response['result'] = removedList;
        break;
      case 'srandmember':
        final randKey = Random().nextInt(
            (imitationDatabase.cache[jsonRequest['_id']] as Set).length);
        response['result'] =
            (imitationDatabase.cache[jsonRequest['_id']] as Set)
                .toList()[randKey];
        break;
      case 'srem':
        var count = 0;
        for (var member in jsonRequest['body']['members']) {
          (imitationDatabase.cache[jsonRequest['_id']] as Set).remove(member);
          count += 1;
        }
        response['result'] = count;
        break;
      case 'sscan':
      case 'strlen':
        response['result'] = 1;
        break;
      case 'sunion':
        Set mainSet;
        for (var key in jsonRequest['keys']) {
          mainSet ??= imitationDatabase.cache[key];
          mainSet = mainSet.union(imitationDatabase.cache[key] as Set);
        }
        response['result'] = mainSet.toList();
        break;
      case 'sunionstore':
        Set mainSet;
        for (var key in jsonRequest['body']['keys']) {
          mainSet ??= imitationDatabase.cache[key];
          mainSet = mainSet.union(imitationDatabase.cache[key] as Set);
        }
        imitationDatabase.cache[jsonRequest['body']['destination']] = mainSet;
        response['result'] = mainSet.length;
        break;
      case 'time':
        final now = DateTime.now();
        response['result'] = [
          (now.millisecondsSinceEpoch / 1000).floor().toString(),
          now.microsecond.toString()
        ];
        break;
      case 'touch':
      case 'ttl':
      case 'type':
      case 'zadd':
      case 'zcard':
      case 'zcount':
      case 'zincrby':
      case 'zinterstore':
      case 'zlexcount':
      case 'zrange':
      case 'zrangebylex':
      case 'zrangebyscore':
      case 'zrank':
      case 'zrem':
      case 'zremrangebylex':
      case 'zremrangebyrank':
      case 'zremrangebyscore':
      case 'zrevrange':
      case 'zrevrangebylex':
      case 'zrevrangebyscore':
      case 'zrevrank':
      case 'zscan':
      case 'zscore':
      case 'zunionstore':
      default:
        break;
    }

    return response;
  }

  Map<String, dynamic> _realtime(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'count':
      case 'join':
      case 'list':
      case 'publish':
        // var body = jsonRequest['body'];
        response['result'] = {
          'published': true,
        };
        break;
      case 'subscribe':
      case 'unsubscribe':
      case 'validate':
      default:
        break;
    }

    return response;
  }

  Map<String, dynamic> _security(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'createCredentials':
      case 'createFirstAdmin':
      case 'createOrReplaceProfile':
      case 'createOrReplaceRole':
      case 'createProfile':
      case 'createRestrictedUser':
      case 'createRole':
      case 'createUser':
      case 'deleteCredentials':
      case 'deleteProfile':
      case 'deleteRole':
      case 'deleteUser':
      case 'getAllCredentialFields':
      case 'getCredentialFields':
      case 'getCredentials':
      case 'getCredentialsById':
      case 'getProfile':
      case 'getProfileMapping':
      case 'getProfileRights':
      case 'getRole':
      case 'getRoleMapping':
      case 'getUser':
      case 'getUserMapping':
      case 'getUserRights':
      case 'hasCredentials':
      case 'mDeleteProfiles':
      case 'mDeleteRoles':
      case 'mDeleteUsers':
      case 'mGetProfiles':
      case 'mGetRoles':
      case 'replaceUser':
      case 'scrollProfiles':
      case 'scrollUsers':
      case 'searchProfiles':
      case 'searchRoles':
      case 'searchUsers':
      case 'updateCredentials':
      case 'updateProfile':
      case 'updateProfileMapping':
      case 'updateRole':
      case 'updateRoleMapping':
      case 'updateUser':
      case 'updateUserMapping':
      case 'validateCredentials':
      default:
        break;
    }

    return response;
  }

  Map<String, dynamic> _server(jsonRequest) {
    final response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'adminExists':
      case 'getAllStats':
      case 'getConfig':
      case 'getLastStats':
      case 'getStats':
      case 'info':
      case 'now':
      default:
        break;
    }

    return response;
  }
}
