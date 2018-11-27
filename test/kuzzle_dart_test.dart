import 'package:flutter_test/flutter_test.dart';

import 'package:kuzzle_dart/kuzzle.dart';
import 'package:kuzzle_dart/document.dart';

void main() {
  test('adds one to input values', () async {
    final Kuzzle kuzzle = Kuzzle('localhost', defaultIndex: 'playground');

    await kuzzle.createIndex('playground', queuable: true);

    await kuzzle.collection('collection').create({}, queuable: true);

    const Map<String, dynamic> message = <String, dynamic>{
      'message': 'Hello World'
    };
    try {
      final Document document =
          kuzzle.collection('collection').createDocument(message);
      print(document.toString());
    } catch (e) {
      print(e.toString());
    }
    await Future<dynamic>.delayed(Duration(seconds: 2));
    // await kuzzle.queue.first;
  });
}
