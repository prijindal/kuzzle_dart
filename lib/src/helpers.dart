import 'collection.dart';
import 'response.dart';

const Map<String, dynamic> emptyMap = <String, dynamic>{};

// T should be an enum
String enumToString<T>(T A) => A.toString().split('.')[1];

typedef NotificationCallback = void Function(RawKuzzleResponse response);

abstract class KuzzleObject extends Object {
  KuzzleObject(this.collection);

  final Collection collection;
  static String controller;

  Map<String, dynamic> get headers {
    final Map<String, dynamic> headers = collection.headers;
    headers.addAll(_headers);
    return headers;
  }

  Map<String, dynamic> _headers = emptyMap;

  Map<String, dynamic> _getPartialQuery() => <String, dynamic>{
        'index': collection.index,
        'collection': collection.collection,
        'controller': controller,
      };

  Future<RawKuzzleResponse> addNetworkQuery(
    Map<String, dynamic> body, {
    bool queuable = true,
  }) {
    final Map<String, dynamic> query = _getPartialQuery();
    query.addAll(body);
    return collection.kuzzle.addNetworkQuery(query, queuable: queuable);
  }

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      _headers = newheaders;
}
