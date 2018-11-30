import 'package:test/test.dart';

import 'package:kuzzle_dart/kuzzle_dart.dart';

void main() {
  test('Simple test for kuzzle constructor', () {
    final Kuzzle kuzzle = Kuzzle('localhost');
    kuzzle.security.role('id', <String, dynamic>{});
  });
}
