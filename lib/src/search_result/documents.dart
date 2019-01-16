import '../kuzzle.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'abstract.dart';

class DocumentsSearchResult extends KuzzleSearchResult {
  DocumentsSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
  }) : super(kuzzle, request: request, response: response) {
    controller = 'documents';
    searchAction = 'search';
    scrollAction = 'scroll';
  }
}
