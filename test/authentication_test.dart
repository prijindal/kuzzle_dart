import 'package:uuid/uuid.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('authentication', () {
    test('user crud', () {});
    test('roles crud', () {});
    test('profiles crud', () {});
    test('login/logout', () {});
  });

  tearDownAll(kuzzleTestHelper.end);
}
