import 'package:flutter_test/flutter_test.dart';

import 'package:kuzzle_dart/error.dart';
import 'package:kuzzle_dart/kuzzle.dart';
import 'package:kuzzle_dart/document.dart';

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

    await kuzzle.collection('collection').create({});

    const Map<String, dynamic> message = <String, dynamic>{
      'message': 'Hello World'
    };
    try {
      final Document document =
          await kuzzle.collection('collection').createDocument(message);
      print(document.toString());
    } catch (e) {
      print(e.toString());
    }
  });
}
