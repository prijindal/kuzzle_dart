import 'dart:convert';
import 'package:uuid/uuid.dart';

class ImitationServer {
  Future<String> transform(String data) async {
    final dynamic jsonRequest = json.decode(data);
    Map<String, dynamic> response = <String, dynamic>{};
    switch (jsonRequest['controller']) {
      case 'admin':
      case 'auth':
      case 'bulk':
      case 'collection':
        response = await _collection(jsonRequest);
        break;
      case 'document':
      case 'index':
      case 'ms':
      case 'realtime':
      case 'security':
      case 'server':
      default:
        break;
    }
    response['requestId'] = jsonRequest['requestId'];
    response['controller'] = jsonRequest['controller'];
    return json.encode(response);
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
          'hits': <Map<String, dynamic>>[
            <String, dynamic>{},
          ]
        };
        break;
      case 'searchSpecifications':
      case 'truncate':
      case 'updateMapping':
      case 'updateSpecifications':
      case 'validateSpecifications':
      default:
        response['status'] = 200;
        response['error'] = null;
        break;
    }
    response['index'] = jsonRequest['index'];
    response['collection'] = jsonRequest['collection'];
    return response;
  }
}
