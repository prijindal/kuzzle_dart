import 'collection.dart';

class Specifications {
  Specifications.fromMap(this.collection, Map<String, dynamic> map)
      : validation = map['validation'];

  final Collection collection;
  final Map<String, dynamic> validation;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'index': collection.collectionName,
        'validation': validation,
      };
}

class ScrollSpecificationHit {
  ScrollSpecificationHit.fromMap(
      Collection collection, Map<String, dynamic> map)
      : source = Specifications.fromMap(collection, map['_source']),
        score = map['_score'],
        id = map['id'],
        index = map['index'];

  final String id;
  final String index;
  final Specifications source;
  final int score;
}
