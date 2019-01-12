import '../kuzzle.dart';

import 'abstract.dart';

class BulkController extends KuzzleController {
  BulkController(Kuzzle kuzzle) : super(kuzzle, name: 'bulk');

  /// Creates, updates or deletes
  /// large amounts of [documents] as fast as possible.
  Future<Map<String, dynamic>> import(Map<String, dynamic> documents) async {
    final response = await kuzzle.query({
      'controller': name,
      'action': 'import',
      'body': <String, dynamic>{
        'bulkData': documents,
      },
    });

    return response.result['items'] as Map<String, dynamic>;
  }
}
