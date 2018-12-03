import 'package:test/test.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  final TestKuzzle kuzzle = TestKuzzle('localhost');
  test('Simple test for kuzzle connection', () async {
    await kuzzle.connect();
  });

  test('test for collection constructor', () async {
    final Collection collection = kuzzle.collection('collection');
    await collection.create();
  });

  test('test for security constructor', () async {
    kuzzle.security.role('id', <String, dynamic>{});
  });

  test('test for disconnection', () {
    kuzzle.disconect();
  });
}
