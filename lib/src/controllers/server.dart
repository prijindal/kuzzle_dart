import '../kuzzle.dart';

import 'abstract.dart';

class ServerController extends KuzzleController {
  ServerController(Kuzzle kuzzle)
      : super(kuzzle, name: 'server', accessor: 'server');

  Future<Map<String, dynamic>> info() async {
    final response = await kuzzle.query({
      'controller': name,
      'action': 'info'
    });

    return response.result;
  }

  Future<Map<String, dynamic>> now() async {
    final response = await kuzzle.query({
      'controller': name,
      'action': 'now'
    });

    return response.result;
  }
}