import '../kuzzle.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'abstract.dart';

class DocumentsSearchResult extends SearchResult {
  DocumentsSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
    Map<String, dynamic> options,
  }) : super(kuzzle, request: request, response: response, options: options) {
    controller = 'documents';
    searchAction = 'search';
    scrollAction = 'scroll';
  }
}
