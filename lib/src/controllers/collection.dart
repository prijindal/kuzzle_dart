import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';

import '../search_result/specifications.dart';

import 'abstract.dart';

class CollectionController extends KuzzleController {
  CollectionController(Kuzzle kuzzle) : super(kuzzle, name: 'collection');

  /// Creates a new [collection], in the provided [index].
  ///
  /// You can also provide an optional [mapping]
  /// that allow you to exploit the full capabilities
  /// of our persistent data storage layer.
  Future<Map<String, dynamic>> create(String index, String collection,
      {Map<String, dynamic> mapping}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'create',
      index: index,
      collection: collection,
      body: mapping,
    ));

    return response.result;
  }

  /// Deletes validation specifications for a data collection.
  ///
  /// The request succeeds even if no specification
  /// exist for that data collection.
  ///
  /// Note: an empty specification is implicitly applied to all collections.
  /// In a way, "no specification set" means "all documents are valid".
  Future<Map<String, dynamic>> deleteSpecifications(
      String index, String collection) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'deleteSpecifications',
      index: index,
      collection: collection,
    ));

    return response.result;
  }

  /// Checks whether a [collection] exists in the [index].
  Future<bool> exists(String index, String collection) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'exists',
      index: index,
      collection: collection,
    ));

    if (response.result is bool) {
      return response.result as bool;
    }

    throw BadResponseFormatError('$name.exists: bad response format', response);
  }

  /// Returns a data [collection] mapping.
  Future<Map<String, dynamic>> getMapping(
      String index, String collection) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'getMapping',
      index: index,
      collection: collection,
    ));

    return response.result;
  }

  /// Returns the validation specifications associated to the [collection].
  Future<Map<String, dynamic>> getSpecifications(
      String index, String collection) async {
    final request = KuzzleRequest(
      controller: name,
      action: 'getSpecifications',
      index: index,
      collection: collection,
    );
    final response = await kuzzle.query(request);

    return response.result;
  }

  /// Returns the list of data collections associated to a provided data index.
  ///
  /// The returned list is sorted in alphanumerical order.
  Future<Map<String, dynamic>> list(String index,
      {int from, int size, String type}) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'list',
      from: from,
      size: size,
      type: type,
    ));

    return response.result;
  }

  /// Searches collection specifications.
  Future<SpecificationSearchResult> searchSpecifications(String index,
      {Map<String, dynamic> query, int from, int size, String scroll}) async {
    final request = KuzzleRequest(
      controller: name,
      action: 'searchSpecifications',
      body: query,
      from: from,
      size: size,
      scroll: scroll,
    );
    final response = await kuzzle.query(request);

    return SpecificationSearchResult(kuzzle,
        request: request, response: response);
  }

  /// Empties a [collection] by removing all its documents,
  /// while keeping any associated mapping
  Future<Map<String, dynamic>> truncate(String index, String collection) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'truncate',
      index: index,
      collection: collection,
    ));

    return response.result;
  }

  /// Updates a data [collection] data [mapping].
  Future<Map<String, dynamic>> updateMapping(
      String index, String collection, Map<String, dynamic> mapping) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'updateMapping',
      index: index,
      collection: collection,
      body: mapping,
    ));

    return response.result;
  }

  /// The updateSpecifications method allows you to create or update
  /// the validation [specifications] for one or more index/collection pairs.
  ///
  /// You can specify validation specifications in order to enforce
  /// your own rules over documents and real-time messages.
  /// Whenever a document is stored or updated, or a message is published,
  /// Kuzzle applies these specifications to check if
  /// the new data complies to the defined rules.
  /// If not, the document or message will be rejected
  /// and the request will return an error message.
  Future<Map<String, dynamic>> updateSpecifications(String index,
      String collection, Map<String, dynamic> specifications) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'updateSpecifications',
      body: <String, dynamic>{
        index: <String, dynamic>{collection: specifications}
      },
    ));

    return response.result[index][collection] as Map<String, dynamic>;
  }

  /// The validateSpecifications method checks
  /// if a validation specification is well formatted.
  /// It does not store nor modify the existing specification.
  Future<Map<String, dynamic>> validateSpecifications(String index,
      String collection, Map<String, dynamic> specifications) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'validateSpecifications',
      body: <String, dynamic>{
        index: <String, dynamic>{collection: specifications}
      },
    ));

    return response.result;
  }
}
