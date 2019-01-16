import '../kuzzle.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'abstract.dart';

class SpecificationSearchResult extends KuzzleSearchResult {
  SpecificationSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
  }) : super(kuzzle, request: request, response: response) {
    controller = 'collection';
    searchAction = 'searchSpecifications';
    scrollAction = 'scrollSpecifications';
  }
}
