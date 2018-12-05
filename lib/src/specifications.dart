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
