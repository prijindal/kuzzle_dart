import 'package:meta/meta.dart';

import '../kuzzle.dart';

import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

abstract class SearchResult {
  SearchResult(
    this.kuzzle, {
    this.request,
    this.response,
    Map<String, dynamic> options,
  }) : _options = options {
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

  Map<String, dynamic> _options;

  @protected
  Kuzzle kuzzle;

  @protected
  KuzzleRequest request;

  @protected
  KuzzleResponse response;

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

  Future<List<dynamic>> next() async {
    if (fetched >= total) {
      return <dynamic>[];
    }

    if (request.scroll != null && request.scroll.isNotEmpty) {
      return await kuzzle
          .query(KuzzleRequest(
        controller: controller,
        action: scrollAction,
        scrollId: response.result['scrollId'] as String,
      ))
          .then((_response) {
        response = _response;

        if (_response.result.containsKey('aggregations')) {
          aggregations =
              _response.result['aggregations'] as Map<String, dynamic>;
        }
        if (_response.result.containsKey('hits')) {
          hits = _response.result['hits'] as List<dynamic>;
          fetched += hits.length;
        }

        return hits;
      });
    } else if (request.size != null && request.sort != null) {
      final _request = KuzzleRequest.clone(request)..action = searchAction;

      _request.body ??= <String, dynamic>{};
      _request.body['search_after'] ??= <dynamic>[];

      final hit = hits.last;

      for (var sort in request.sort) {
        final key =
            (sort is String) ? sort : (sort as Map<String, dynamic>).keys.first;
        final value = (key == '_uid')
            ? '${request.collection}#${hit['_id']}'
            : _get(hit['_source'] as Map<String, dynamic>, key.split('.'));

        _request.body['search_after'].add(value);
      }

      return await kuzzle.query(_request).then((_response) {
        response = _response;

        if (_response.result.containsKey('aggregations')) {
          aggregations =
              _response.result['aggregations'] as Map<String, dynamic>;
        }
        if (_response.result.containsKey('hits')) {
          hits = _response.result['hits'] as List<dynamic>;
          fetched += hits.length;
        }

        return hits;
      });
    } else if (request.size != null) {
      if (request.from >= total) {
        return <dynamic>[];
      }

      return await kuzzle
          .query(KuzzleRequest.clone(request)
            ..action = searchAction
            ..from = fetched)
          .then((_response) {
        response = _response;

        if (_response.result.containsKey('aggregations')) {
          aggregations =
              _response.result['aggregations'] as Map<String, dynamic>;
        }
        if (_response.result.containsKey('hits')) {
          hits = _response.result['hits'] as List<dynamic>;
          fetched += hits.length;
        }

        return hits;
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
