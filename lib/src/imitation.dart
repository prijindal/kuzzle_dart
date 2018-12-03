import 'dart:convert';

class ImitationServer {
  Future<String> transform(String data) async {
    final dynamic jsonRequest = json.decode(data);
    print(jsonRequest);
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
        response['status'] = 200;
        response['error'] = null;
        break;
      case 'deleteSpecifications':
      case 'exists':
      case 'getMapping':
      case 'getSpecifications':
      case 'list':
      case 'scrollSpecifications':
      case 'searchSpecifications':
      case 'truncate':
      case 'updateMapping':
      case 'updateSpecifications':
      case 'validateSpecifications':
      default:
        break;
    }
    response['index'] = jsonRequest['index'];
    response['collection'] = jsonRequest['collection'];
    return response;
  }
}
