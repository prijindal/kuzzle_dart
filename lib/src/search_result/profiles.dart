import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';
import '../kuzzle/profile.dart';

import 'abstract.dart';

class ProfileSearchResult extends SearchResult {
  ProfileSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
    Map<String, dynamic> options,
  }) : super(kuzzle, request: request, response: response, options: options) {
    controller = null;
    searchAction = 'searchProfiles';
    scrollAction = 'scrollProfiles';

    hits = (response.result['hits'] as List).map((hit) => Profile(kuzzle,
        uid: hit['_id'] as String,
        policies: hit['_source']['policies'] as List)) as List<Profile>;
  }

  @override
  Future<List<Profile>> next() => super.next().then((_) => hits =
      (response.result['hits'] as List).map((hit) => Profile(kuzzle,
          uid: hit['_id'] as String,
          policies: hit['_source']['policies'] as List)) as List<Profile>);
}
