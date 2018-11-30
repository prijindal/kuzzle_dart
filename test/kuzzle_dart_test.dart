import 'package:test/test.dart';

import 'package:kuzzle_dart/kuzzle_dart.dart';

void main() {
  test('Check if index can be created', () async {
    final Kuzzle kuzzle = Kuzzle('localhost', defaultIndex: 'playground');

    try {
      await kuzzle.createIndex('playground');
    } catch (err) {
      if (err is ResponseError) {
        print(err.status);
      }
    }
  });
}
