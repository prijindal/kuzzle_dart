import '../kuzzle.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'abstract.dart';

class SpecificationSearchResult extends SearchResult {
  SpecificationSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
    Map<String, dynamic> options,
  }) : super(kuzzle, request: request, response: response, options: options) {
    controller = 'collection';
    searchAction = 'searchSpecifications';
    scrollAction = 'scrollSpecifications';
  }
}
