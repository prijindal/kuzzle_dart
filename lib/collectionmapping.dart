import 'collection.dart';
import 'error.dart';

class CollectionMapping {
  CollectionMapping(this.collection, this.mapping);

  final Collection collection;
  final Map<String, MappingDefinition> mapping;

  Map<String, dynamic> get headers => collection.headers;

  Future<CollectionMapping> apply({bool queuable = true}) =>
      throw ResponseError();

  Future<CollectionMapping> refresh({bool queuable = true}) =>
      throw ResponseError();

  Future<void> set(String filed, MappingDefinition mapping) =>
      throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();
}
