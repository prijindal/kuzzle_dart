import 'collection.dart';
import 'helpers.dart';
import 'response.dart';

class CollectionMapping extends KuzzleObject {
  CollectionMapping(Collection collection, this.mappings) : super(collection);
  CollectionMapping.fromMap(Collection collection, Map<String, dynamic> map)
      : mappings = map.map<String, MappingDefinition>((String key,
                dynamic mapValue) =>
            MapEntry<String, MappingDefinition>(
                key,
                MappingDefinition(
                    mapValue['index'], mapValue['type'], mapValue['fields']))),
        super(collection);

  Map<String, MappingDefinition> mappings;
  static const String controller = 'collection';

  @override
  String toString() => mappings.toString();

  Future<void> apply({bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'action': 'updateMapping',
        'body': {
          'properties': mappings,
        }
      });

  Future<CollectionMapping> refresh({bool queuable = true}) async {
    final CollectionMapping collectionMapping =
        await collection.getMapping(queuable: queuable);
    mappings = collectionMapping.mappings;
    return this;
  }

  void set(String field, MappingDefinition mapping) =>
      mappings[field] = mapping;
}
