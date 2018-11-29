import 'package:flutter_test/flutter_test.dart';

import 'package:kuzzle_dart/kuzzle_dart.dart';

void main() {
  test('adds one to input values', () async {
    final Kuzzle kuzzle = Kuzzle('localhost', defaultIndex: 'playground');

    try {
      await kuzzle.createIndex('playground');
    } catch (err) {
      if (err is ResponseError) {
        print(err.status);
      }
    }

    Collection collection = kuzzle.collection('collection');

    await collection.create({});

    const Map<String, dynamic> message = <String, dynamic>{
      'message': 'Hello World',
      'echoing': 1
    };
    final Document document = await collection.createDocument(message);
    print(document.toString());

    final int count = await collection.count();
    print(count);

    final CollectionMapping collectionMapping = await collection.getMapping();
    print(collectionMapping);

    final String documentId = await document.delete();

    final response = await collection.truncate();
    print(response);
  });
}
