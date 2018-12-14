import 'dart:async';
import 'collection.dart';
import 'helpers.dart';

class CollectionMapping extends KuzzleObject {
  CollectionMapping(Collection collection, this.mappings) : super(collection);
  CollectionMapping.fromMap(Collection collection, Map<String, dynamic> map)
      : mappings = map.map<String, MappingDefinition>((key, mapValue) =>
            MapEntry<String, MappingDefinition>(
                key,
                MappingDefinition(
                    mapValue['index'], mapValue['type'], mapValue['fields']))),
        super(collection);

  Map<String, MappingDefinition> mappings;
  static const String controller = 'collection';

  @override
  String getController() => controller;

  @override
  String toString() => mappings.toString();

  Future<void> apply({bool queuable = true}) =>
      addNetworkQuery('updateMapping', body: <String, dynamic>{
        'properties': mappings,
      });

  Future<CollectionMapping> refresh({bool queuable = true}) async {
    final collectionMapping = await collection.getMapping(queuable: queuable);
    mappings = collectionMapping.mappings;
    return this;
  }

  void set(String field, MappingDefinition mapping) =>
      mappings[field] = mapping;
}
