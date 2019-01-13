import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';
import '../kuzzle/user.dart';

import 'abstract.dart';

class UserSearchResult extends SearchResult {
  UserSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
    Map<String, dynamic> options,
  }) : super(kuzzle, request: request, response: response, options: options) {
    controller = null;
    searchAction = 'searchUsers';
    scrollAction = 'scrollUsers';

    hits = (response.result['hits'] as List).map((hit) => User(kuzzle,
        uid: hit['_id'] as String,
        content: hit['_source'] as Map<String, dynamic>,
        meta: hit['_meta'] as Map<String, dynamic>)) as List<User>;
  }

  @override
  Future<List<User>> next() => super.next().then((_) => hits =
      (response.result['hits'] as List).map((hit) => User(kuzzle,
          uid: hit['_id'] as String,
          content: hit['_source'] as Map<String, dynamic>,
          meta: hit['_meta'] as Map<String, dynamic>)) as List<User>);
}
