import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';

import '../search_result/documents.dart';

import 'abstract.dart';

class DocumentController extends KuzzleController {
  DocumentController(Kuzzle kuzzle) : super(kuzzle, name: 'document');

  /// Counts documents in a data [collection].
  ///
  /// A [query] can be provided to alter the count result,
  /// otherwise returns the total number of documents in the data collection.
  Future<int> count(String index, String collection,
      {Map<String, dynamic> query, bool includeTrash}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'count',
      index: index,
      collection: collection,
      body: query,
      includeTrash: includeTrash,
    ));

    return response.result['count'] as int;
  }

  /// Creates a new document in the persistent data storage.
  Future<Map<String, dynamic>> create(
      String index, String collection, Map<String, dynamic> document,
      {String uid, String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'create',
      index: index,
      collection: collection,
      uid: uid,
      body: document,
      refresh: refresh,
    ));

    return response.result;
  }

  /// Creates a new document in the persistent data storage,
  /// or replaces its content if it already exists.
  Future<Map<String, dynamic>> createOrReplace(String index, String collection,
      String uid, Map<String, dynamic> document,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'createOrReplace',
      index: index,
      collection: collection,
      uid: uid,
      body: document,
      refresh: refresh,
    ));

    return response.result;
  }

  /// Deletes a document.
  Future<Map<String, dynamic>> delete(
      String index, String collection, String uid,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'delete',
      index: index,
      collection: collection,
      uid: uid,
      refresh: refresh,
    ));

    return response.result;
  }

  /// Deletes documents matching the provided search query.
  Future<List<String>> deleteByQuery(
      String index, String collection, Map<String, dynamic> query,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'deleteByQuery',
      index: index,
      collection: collection,
      body: query,
      refresh: refresh,
    ));

    return response.result['hits'] as List<String>;
  }

  /// Check if a document exists
  Future<bool> exists(String index, String collection, String uid) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'exists',
      index: index,
      collection: collection,
      uid: uid,
    ));

    if (response.result is bool) {
      return response.result as bool;
    }

    throw BadResponseFormatError('$name.exists: bad response format', response);
  }

  /// Get a document
  Future<Map<String, dynamic>> get(String index, String collection, String uid,
      {bool includeTrash}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'get',
      index: index,
      collection: collection,
      uid: uid,
      includeTrash: includeTrash,
    ));

    return response.result;
  }

  /// Creates multiple documents.
  Future<Map<String, dynamic>> mCreate(
      String index, String collection, List<Map<String, dynamic>> documents,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mCreate',
      index: index,
      collection: collection,
      body: <String, dynamic>{'documents': documents},
      refresh: refresh,
    ));

    return response.result;
  }

  /// Creates or replaces multiple documents.
  Future<Map<String, dynamic>> mCreateOrReplace(
      String index, String collection, List<Map<String, dynamic>> documents,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mCreateOrReplace',
      index: index,
      collection: collection,
      body: <String, dynamic>{'documents': documents},
      refresh: refresh,
    ));

    return response.result;
  }

  /// Deletes multiple documents.
  Future<Map<String, dynamic>> mDelete(
      String index, String collection, List<String> ids,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mDelete',
      index: index,
      collection: collection,
      body: <String, dynamic>{'ids': ids},
      refresh: refresh,
    ));

    return response.result;
  }

  /// Gets multiple documents.
  Future<Map<String, dynamic>> mGet(
      String index, String collection, List<String> ids,
      {bool includeTrash}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mGet',
      index: index,
      collection: collection,
      body: <String, dynamic>{'ids': ids},
      includeTrash: includeTrash,
    ));

    return response.result;
  }

  /// Replaces multiple documents.
  Future<Map<String, dynamic>> mReplace(
      String index, String collection, List<Map<String, dynamic>> documents,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mReplace',
      index: index,
      collection: collection,
      body: <String, dynamic>{'documents': documents},
      refresh: refresh,
    ));

    return response.result;
  }

  /// Updates multiple documents.
  Future<Map<String, dynamic>> mUpdate(
      String index, String collection, List<Map<String, dynamic>> documents,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mUpdate',
      index: index,
      collection: collection,
      body: <String, dynamic>{'documents': documents},
      refresh: refresh,
    ));

    return response.result;
  }

  /// Replaces the content of an existing document.
  Future<Map<String, dynamic>> replace(String index, String collection,
      String uid, Map<String, dynamic> document,
      {String refresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'replace',
      index: index,
      collection: collection,
      uid: uid,
      body: document,
      refresh: refresh,
    ));

    return response.result;
  }

  /// Searches documents.
  ///
  /// There is a limit to how many documents
  /// can be returned by a single search query.
  ///
  /// That limit is by default set at 10000 documents,
  /// and you can't get over it even with the from and size pagination options.
  ///
  /// To handle larger result sets, you have to either create a cursor
  /// by providing a value to the scroll option or,
  /// if you sort the results, by using the Elasticsearch search_after command.
  Future<DocumentsSearchResult> search(String index, String collection,
      {Map<String, dynamic> query,
      int from,
      int size,
      String scroll,
      bool includeTrash}) async {
    final request = KuzzleRequest(
      controller: name,
      action: 'search',
      index: index,
      collection: collection,
      body: query,
      from: from,
      size: size,
      scroll: scroll,
      includeTrash: includeTrash,
    );
    final response = await kuzzle.query(request);

    return DocumentsSearchResult(kuzzle, request: request, response: response);
  }

  /// Updates a document content.
  Future<Map<String, dynamic>> update(String index, String collection,
      String uid, Map<String, dynamic> document,
      {String refresh, int retryOnConflict}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'update',
      index: index,
      collection: collection,
      uid: uid,
      body: document,
      refresh: refresh,
      retryOnConflict: retryOnConflict,
    ));

    return response.result;
  }

  /// Validates data against existing validation rules.
  ///
  /// Documents are always valid if no validation rules are defined
  /// on the provided index and collection.
  ///
  /// This request does not store the document.
  Future<Map<String, dynamic>> validate(
      String index, String collection, Map<String, dynamic> document) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'validate',
      index: index,
      collection: collection,
      body: document,
    ));

    return response.result;
  }
}
