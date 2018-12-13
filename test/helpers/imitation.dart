import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:kuzzle/src/helpers.dart';
import 'imitation_databse.dart';
import 'imitation_redis.dart';

class ImitationServer {
  final ImitationDatabase imitationDatabase = ImitationDatabase();
  final ImitationRedis redis = ImitationRedis();

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
        final body = jsonRequest['body'];
        if (body != null &&
            body['username'] == 'admin' &&
            body['password'] == 'admin') {
          response['result'] = <String, dynamic>{
            'uuid': Uuid().v1(),
            'jwt': Uuid().v1(),
            'expiresAt': 1321085955000,
            'ttl': 360000
          };
        }
        if (!imitationDatabase.insiderdb.containsKey('users')) {
          imitationDatabase.insiderdb['users'] = <String, dynamic>{};
        }
        if ((imitationDatabase.insiderdb['users'] as Map<String, dynamic>)
            .containsKey(body['username'])) {
          final userInfo = (imitationDatabase.insiderdb['users']
              as Map<String, dynamic>)[body['username']];
          if (userInfo['password'] == body['password']) {
            response['result'] = <String, dynamic>{
              '_id': userInfo['_id'],
              'jwt': Uuid().v1(),
              'expiresAt': 1321085955000,
              'ttl': 360000
            };
          } else {
            response['status'] = 401;
            response['id'] = -1;
          }
        } else {
          response['status'] = 401;
          response['id'] = -1;
        }
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

    final jsonBody = jsonRequest['body'];
    final String action = jsonRequest['action'];
    jsonRequest.remove('body');
    jsonRequest.remove('action');
    jsonRequest.remove('jwt');
    jsonRequest.remove('index');
    jsonRequest.remove('controller');
    final Map<String, dynamic> parameters = jsonRequest;
    if (jsonBody != null) {
      parameters.addAll(jsonBody);
    }
    response['result'] = redis.run(action, parameters);
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
        final body = jsonRequest['body'];
        final content = body['content'];
        final credentials = body['credentials']['local'];
        if (!imitationDatabase.insiderdb.containsKey('users')) {
          imitationDatabase.insiderdb['users'] = <String, dynamic>{};
        }
        (imitationDatabase.insiderdb['users']
                as Map<String, dynamic>)[credentials['username']] =
            <String, dynamic>{
          '_id': Uuid().v1(),
          '_source': content,
          'password': credentials['password'],
          '_version': 1,
        };
        response['result'] = (imitationDatabase.insiderdb['users']
            as Map<String, dynamic>)[credentials['username']];
        break;
      case 'deleteCredentials':
      case 'deleteProfile':
      case 'deleteRole':
      case 'deleteUser':
        final id = jsonRequest['_id'];
        if (!imitationDatabase.insiderdb.containsKey('users')) {
          imitationDatabase.insiderdb['users'] = <String, dynamic>{};
        }
        (imitationDatabase.insiderdb['users'] as Map<String, dynamic>)
            .removeWhere((username, content) => content['_id'] == id);
        response['result'] = {
          '_id': id,
        };
        break;
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
