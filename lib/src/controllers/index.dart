import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';

import 'abstract.dart';

class IndexController extends KuzzleController {
  IndexController(Kuzzle kuzzle) : super(kuzzle, name: 'index');

  /// Creates a new data [index] in Kuzzle.
  Future<Map<String, dynamic>> create(String index) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'create',
      index: index,
    ));

    return response.result as Map<String, dynamic>;
  }

  /// Delete an [index] from Kuzzle.
  Future<Map<String, dynamic>> delete(String index) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'delete',
      index: index,
    ));

    return response.result as Map<String, dynamic>;
  }

  /// Checks if the given [index] exists in Kuzzle.
  Future<bool> exists(String index) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'exists',
      index: index,
    ));

    final result = response.result as Map<String, dynamic>;

    if (result != null && result.containsKey('exists')) {
      if (result['exists'] is bool) {
        return result['exists'] as bool;
      }
    }

    throw BadResponseFormatError('$name.exists: bad response format', response);
  }

  /// Returns the current autoRefresh status for the given [index].
  ///
  /// The autoRefresh flag, when set to true, forces Kuzzle to
  /// perform a refresh request immediately after each change in the storage,
  /// causing documents to be immediately visible in a search
  Future<bool> getAutoRefresh(String index) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'getAutoRefresh',
      index: index,
    ));

    if (response.result is bool) {
      return response.result as bool;
    }

    throw BadResponseFormatError(
        '$name.getAutoRefresh: bad response format', response);
  }

  /// Returns the complete list of data indexes.
  Future<List<String>> list() async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'list',
    ));

    final result = response.result as Map<String, dynamic>;

    if (result != null && result.containsKey('indexes')) {
      if (result['indexes'] is List<String>) {
        return (result['indexes'] as List<dynamic>)
            .map<String>((a) => a as String)
            .toList();
      }
    }

    throw BadResponseFormatError('$name.list: bad response format', response);
  }

  /// Deletes multiple indexes.
  Future<List<String>> mDelete(List<String> indexes) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'mDelete',
      body: <String, dynamic>{'indexes': indexes},
    ));

    final result = response.result as Map<String, dynamic>;

    if (result != null && result.containsKey('deleted')) {
      if (result['deleted'] is List<String>) {
        return result['deleted'] as List<String>;
      }
    }

    throw BadResponseFormatError(
        '$name.mDelete: bad response format', response);
  }

  /// Forces an immediate re-indexation of the provided [index].
  ///
  /// When writing or deleting documents in Kuzzle,
  /// the changes need to be indexed before being reflected
  /// in the search results.
  ///
  /// By default, this operation can take up to 1 second.
  /// Note: forcing immediate refreshes comes with performance costs,
  /// and should only performed when absolutely necessary.
  Future<Map<String, dynamic>> refresh(String index) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'refresh',
      index: index,
    ));

    final result = response.result as Map<String, dynamic>;

    return result['_shards'] as Map<String, dynamic>;
  }

  /// Forces an immediate re-indexation of Kuzzle internal storage.
  ///
  /// When writing or deleting security documents in Kuzzle
  /// (users, profiles, roles, and so on),
  /// the changes need to be indexed before being reflected
  /// in the search results.
  ///
  /// By default, this operation can take up to 1 second.
  /// Note: forcing immediate refreshes comes with performance costs,
  /// and should only performed when absolutely necessary.
  Future<bool> refreshInternal() async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'refreshInternal',
    ));

    final result = response.result as Map<String, dynamic>;

    if (result != null && result.containsKey('acknowledged')) {
      if (result['acknowledged'] is bool) {
        return result['acknowledged'] as bool;
      }
    }

    throw BadResponseFormatError(
        '$name.refreshInternal: bad response format', response);
  }

  /// Changes the [autoRefresh] configuration of an [index].
  ///
  /// The autoRefresh flag, when set to true,
  /// tells Kuzzle to perform an immediate refresh request
  /// after each write request,
  /// instead of waiting the regular refreshes occurring every seconds.
  ///
  /// Note: refreshes come with performance costs.
  /// Set the autoRefresh flag to true only for indexes needing changes
  /// to be immediately available through searches,
  /// and only for slowly changing indexes.
  Future<bool> setAutoRefresh(String index, {bool autoRefresh}) async {
    final response = await kuzzle.query(KuzzleRequest(
        controller: name,
        action: 'setAutoRefresh',
        index: index,
        body: <String, dynamic>{
          'autoRefresh': autoRefresh,
        }));

    final result = response.result as Map<String, dynamic>;

    if (result != null && result.containsKey('response')) {
      if (result['response'] is bool) {
        return result['response'] as bool;
      }
    }

    throw BadResponseFormatError(
        '$name.setAutoRefresh: bad response format', response);
  }
}
