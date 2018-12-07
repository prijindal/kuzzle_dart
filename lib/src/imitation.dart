import 'dart:convert';
import 'package:uuid/uuid.dart';

class ImitationServer {
  Future<String> transform(String data) async {
    final dynamic jsonRequest = json.decode(data);
    Map<String, dynamic> response = <String, dynamic>{};
    switch (jsonRequest['controller']) {
      case 'admin':
        response = await _admin(jsonRequest);
        break;
      case 'auth':
        response = await _auth(jsonRequest);
        break;
      case 'bulk':
        response = await _bulk(jsonRequest);
        break;
      case 'collection':
        response = await _collection(jsonRequest);
        break;
      case 'document':
        response = await _document(jsonRequest);
        break;
      case 'index':
        response = await _index(jsonRequest);
        break;
      case 'ms':
        response = await _ms(jsonRequest);
        break;
      case 'realtime':
        response = await _realtime(jsonRequest);
        break;
      case 'security':
        response = await _security(jsonRequest);
        break;
      case 'server':
        response = await _server(jsonRequest);
        break;
      default:
        break;
    }
    response['requestId'] = jsonRequest['requestId'];
    response['controller'] = jsonRequest['controller'];
    return json.encode(response);
  }

  Future<Map<String, dynamic>> _admin(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'dump':
      case 'resetCache':
      case 'resetDatabase':
      case 'resetKuzzleData':
      case 'resetSecurity':
      case 'shutdowndefault:':
        break;
    }
    return response;
  }

  Future<Map<String, dynamic>> _auth(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

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
      case 'logout':
      case 'updateMyCredentials':
      case 'updateSelf':
      case 'validateMyCredentials':
      default:
        break;
    }

    return response;
  }

  Future<Map<String, dynamic>> _bulk(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'import':
      default:
        break;
    }

    return response;
  }

  /// takes in json and returns a string
  Future<Map<String, dynamic>> _collection(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};
    switch (jsonRequest['action']) {
      case 'create':
        response['result'] = <String, dynamic>{'acknowledged': true};
        break;
      case 'deleteSpecifications':
        response['result'] = true;
        break;
      case 'exists':
        response['result'] = true;
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
          'validation': <String, dynamic>{},
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
        response['result'] = <String, dynamic>{
          'acknowledged': true,
        };
        break;
      case 'updateMapping':
        response['result'] = <String, dynamic>{};
        break;
      case 'updateSpecifications':
        response['result'] = <String, dynamic>{
          jsonRequest['index']: <String, dynamic>{
            jsonRequest['collection']:
                <String, dynamic>{} // This is a validation
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

  Future<Map<String, dynamic>> _document(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};
    switch (jsonRequest['action']) {
      case 'count':
        response['result'] = <String, dynamic>{
          'count': 1,
        };
        break;
      case 'create':
        response['result'] = <String, dynamic>{
          '_id': '1',
          '_version': 1,
          '_source': jsonRequest['body'],
        };
        break;
      case 'createOrReplace':
      case 'delete':
      case 'deleteByQuery':
      case 'get':
      case 'mCreate':
      case 'mCreateOrReplace':
      case 'mDelete':
      case 'mGet':
      case 'mReplace':
      case 'mUpdate':
      case 'replace':
      case 'scroll':
      case 'search':
      case 'update':
      case 'validate':
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

  Future<Map<String, dynamic>> _index(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'create':
      case 'delete':
      case 'exists':
      case 'getAutoRefresh':
      case 'list':
      case 'mDelete':
      case 'refresh':
      case 'refreshInternal':
      case 'setAutoRefresh':
      default:
        break;
    }

    return response;
  }

  Future<Map<String, dynamic>> _ms(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'append':
      case 'bitcount':
      case 'bitop':
      case 'bitpos':
      case 'dbsize':
      case 'decr':
      case 'decrby':
      case 'del':
      case 'exists':
      case 'expire':
      case 'expireat':
      case 'flushdb':
      case 'geoadd':
      case 'geodist':
      case 'geohash':
      case 'geopos':
      case 'georadius':
      case 'georadiusbymember':
      case 'get':
      case 'getbit':
      case 'getrange':
      case 'getset':
      case 'hdel':
      case 'hexists':
      case 'hget':
      case 'hgetall':
      case 'hincrby':
      case 'hincrbyfloat':
      case 'hkeys':
      case 'hlen':
      case 'hmget':
      case 'hmset':
      case 'hscan':
      case 'hset':
      case 'hsetnx':
      case 'hstrlen':
      case 'hvals':
      case 'incr':
      case 'incrby':
      case 'incrbyfloat':
      case 'keys':
      case 'lindex':
      case 'linsert':
      case 'llen':
      case 'lpop':
      case 'lpush':
      case 'lpushx':
      case 'lrange':
      case 'lrem':
      case 'lset':
      case 'ltrim':
      case 'mget':
      case 'mset':
      case 'msetnx':
      case 'object':
      case 'persist':
      case 'pexpire':
      case 'pexpireat':
      case 'pfadd':
      case 'pfcount':
      case 'pfmerge':
      case 'ping':
      case 'psetex':
      case 'pttl':
      case 'randomkey':
      case 'rename':
      case 'renamenx':
      case 'rpop':
      case 'rpoplpush':
      case 'rpush':
      case 'rpushx':
      case 'sadd':
      case 'scan':
      case 'scard':
      case 'sdiff':
      case 'sdiffstore':
      case 'set':
      case 'setex':
      case 'setnx':
      case 'sinter':
      case 'sinterstore':
      case 'sismember':
      case 'smembers':
      case 'smove':
      case 'sort':
      case 'spop':
      case 'srandmember':
      case 'srem':
      case 'sscan':
      case 'strlen':
      case 'sunion':
      case 'sunionstore':
      case 'time':
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

  Future<Map<String, dynamic>> _realtime(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

    switch (jsonRequest['action']) {
      case 'count':
      case 'join':
      case 'list':
      case 'publish':
      case 'subscribe':
      case 'unsubscribe':
      case 'validate':
      default:
        break;
    }

    return response;
  }

  Future<Map<String, dynamic>> _security(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

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

  Future<Map<String, dynamic>> _server(dynamic jsonRequest) async {
    final Map<String, dynamic> response = <String, dynamic>{};

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
