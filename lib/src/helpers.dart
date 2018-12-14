import 'dart:async';
import 'package:meta/meta.dart';
import 'collection.dart';
import 'kuzzle.dart';
import 'response.dart';

const Map<String, dynamic> emptyMap = <String, dynamic>{};

// T should be an enum
String enumToString<T>(T A) => A.toString().split('.')[1];

typedef NotificationCallback = void Function(RawKuzzleResponse response);

abstract class KuzzleObject extends Object {
  KuzzleObject([this.collection, this.kuzzle])
      : assert(collection != null || kuzzle != null);

  final Collection collection;
  final Kuzzle kuzzle;

  String getController();

  // Map<String, dynamic> get headers {
  //   Map<String, dynamic> headers;
  //   if (collection != null) {
  //     headers = collection.headers;
  //   } else if (kuzzle != null) {
  //     headers = kuzzle.headers;
  //   } else {
  //     headers = <String, dynamic>{};
  //   }
  //   headers.addAll(_headers);
  //   return headers;
  // }

  // Map<String, dynamic> _headers = emptyMap;

  @mustCallSuper
  Map<String, dynamic> getPartialQuery() {
    final query = <String, dynamic>{
      'controller': getController(),
    };
    if (collection != null) {
      query.addAll(<String, dynamic>{
        'index': collection.index,
        'collection': collection.collectionName,
      });
    } else if (kuzzle != null) {
      query.addAll(<String, dynamic>{
        'index': kuzzle.defaultIndex,
      });
    }
    return query;
  }

  Future<RawKuzzleResponse> addNetworkQuery(
    String action, {
    Map<String, dynamic> body,
    Map<String, dynamic> optionalParams,
    bool queuable = true,
  }) async {
    final query = getPartialQuery();
    query['action'] = action;
    if (body != null) {
      query['body'] = body;
    }
    if (optionalParams != null) {
      query.addAll(optionalParams);
    }
    if (collection == null && kuzzle != null) {
      return kuzzle.addNetworkQuery(query, queuable: queuable);
    } else if (collection != null && kuzzle == null) {
      return collection.kuzzle.addNetworkQuery(query, queuable: queuable);
    }
    return RawKuzzleResponse.fromMap(null, <String, dynamic>{});
  }

  // void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
  //     _headers = newheaders;
}
