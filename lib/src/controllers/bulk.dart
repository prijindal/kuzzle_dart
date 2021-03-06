import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';

import 'abstract.dart';

class BulkController extends KuzzleController {
  BulkController(Kuzzle kuzzle) : super(kuzzle, name: 'bulk');

  /// Creates, updates or deletes
  /// large amounts of [documents] as fast as possible.
  Future<Map<String, dynamic>> import(
      String index, String collection, Map<String, dynamic> documents) async {
    final response = await kuzzle.query(KuzzleRequest(
      action: 'import',
      collection: collection,
      controller: name,
      index: index,
      body: <String, dynamic>{
        'bulkData': documents,
      },
    ));

    final result = response.result as Map<String, dynamic>;
    if (result['successes'] is List && result['errors'] is List) {
      return result;
    }

    throw BadResponseFormatError('$name.exists: bad response format', response);
  }
}
