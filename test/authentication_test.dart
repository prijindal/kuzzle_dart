import 'package:uuid/uuid.dart';
import 'package:test/test.dart';

import 'helpers/kuzzle_test.dart';

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
  }, skip: 'Not implemented yet');

  tearDownAll(kuzzleTestHelper.end);
}
