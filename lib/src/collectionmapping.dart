import 'collection.dart';
import 'error.dart';

class CollectionMapping extends Object {
  CollectionMapping(this.collection, this.mapping);
  CollectionMapping.fromMap(this.collection, Map<String, dynamic> map)
      : mapping = map.map<String, MappingDefinition>((String key,
                dynamic mapValue) =>
            MapEntry<String, MappingDefinition>(
                key,
                MappingDefinition(
                    mapValue['index'], mapValue['type'], mapValue['fields'])));

  final Collection collection;
  final Map<String, MappingDefinition> mapping;

  @override
  String toString() => mapping.toString();

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
