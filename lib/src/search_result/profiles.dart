import '../kuzzle.dart';
import '../kuzzle/profile.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'abstract.dart';

class ProfileSearchResult extends KuzzleSearchResult {
  ProfileSearchResult(
    Kuzzle kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
  }) : super(kuzzle, request: request, response: response) {
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
