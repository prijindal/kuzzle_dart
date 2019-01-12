import 'package:meta/meta.dart';

import '../kuzzle.dart';

import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

abstract class SearchResult {
  SearchResult(
    this._kuzzle, {
    KuzzleRequest request,
    KuzzleResponse response,
    Map<String, dynamic> options,
  })  : _request = request,
        _response = response,
        _options = options {
    controller = request.controller;
    searchAction = 'search';
    scrollAction = 'scroll';

    if (response.result.containsKey('aggregations')) {
      aggregations = response.result['aggregations'] as Map<String, dynamic>;
    }
    if (response.result.containsKey('hits')) {
      hits = response.result['hits'] as List<dynamic>;
      fetched = hits.length;
    }
    if (response.result.containsKey('total')) {
      total = response.result['total'] as int;
    }
  }

  Kuzzle _kuzzle;
  KuzzleRequest _request;
  KuzzleResponse _response;
  Map<String, dynamic> _options;

  @protected
  String controller;

  @protected
  String searchAction;

  @protected
  String scrollAction;

  Map<String, dynamic> aggregations = <String, dynamic>{};
  List<dynamic> hits = <dynamic>[];
  int fetched = 0;
  int total = 0;

  Future<void> next() async {
    if (fetched >= total) {
      return;
    }

    if (_request.scroll != null && _request.scroll.isNotEmpty) {
      await _kuzzle
          .query(KuzzleRequest(
        controller: controller,
        action: scrollAction,
        scrollId: _response.result['scrollId'] as String,
      ))
          .then((response) {
        _response = response;

        if (response.result.containsKey('aggregations')) {
          aggregations =
              response.result['aggregations'] as Map<String, dynamic>;
        }
        if (response.result.containsKey('hits')) {
          hits = response.result['hits'] as List<dynamic>;
          fetched += hits.length;
        }
      });
    } else if (_request.size != null && _request.sort != null) {
      final request = KuzzleRequest.clone(_request)..action = searchAction;

      request.body ??= <String, dynamic>{};
      request.body['search_after'] ??= <dynamic>[];

      final hit = hits.last;

      for (var sort in _request.sort) {
        final key =
            (sort is String) ? sort : (sort as Map<String, dynamic>).keys.first;
        final value = (key == '_uid')
            ? '${_request.collection}#${hit['_id']}'
            : _get(hit['_source'] as Map<String, dynamic>, key.split('.'));

        request.body['search_after'].add(value);
      }

      await _kuzzle.query(request).then((response) {
        _response = response;

        if (response.result.containsKey('aggregations')) {
          aggregations =
              response.result['aggregations'] as Map<String, dynamic>;
        }
        if (response.result.containsKey('hits')) {
          hits = response.result['hits'] as List<dynamic>;
          fetched += hits.length;
        }
      });
    } else if (_request.size != null) {
      if (_request.from >= total) {
        return;
      }

      await _kuzzle
          .query(KuzzleRequest.clone(_request)
            ..action = searchAction
            ..from = fetched)
          .then((response) {
        _response = response;

        if (response.result.containsKey('aggregations')) {
          aggregations =
              response.result['aggregations'] as Map<String, dynamic>;
        }
        if (response.result.containsKey('hits')) {
          hits = response.result['hits'] as List<dynamic>;
          fetched += hits.length;
        }
      });
    }

    throw KuzzleError('Unable to retrieve next results from search: '
        'missing scrollId, from/sort, or from/size params');
  }

  dynamic _get(Map<String, dynamic> object, List<String> path) {
    if (object == null) {
      return <String>[];
    }

    if (path.length == 1) {
      return object[path.first];
    }

    final key = path.first;
    path.removeAt(0);

    return _get(object[key] as Map<String, dynamic>, path);
  }
}
