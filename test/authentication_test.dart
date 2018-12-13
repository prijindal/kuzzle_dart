import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  Credentials credentials;
  User user;
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    final uuid = Uuid();
    kuzzleTestHelper.kuzzle.defaultIndex = uuid.v1();
    credentials = Credentials(
      LoginStrategy.local,
      username: uuid.v1(),
      password: uuid.v1(),
    );
    user = User(kuzzleTestHelper.kuzzle.security, name: 'Test User');
  });

  group('authentication', () {
    group('user auth', () {
      test('register', () async {
        final saveduser =
            await kuzzleTestHelper.kuzzle.register(user, credentials);
        expect(saveduser.name, user.name);
        user = saveduser;
      });

      test('login', () async {
        final response = await kuzzleTestHelper.kuzzle.login(credentials);
        expect(response.id, user.id);
      });

      test('signout', () async {
        await kuzzleTestHelper.kuzzle.logout();
      });

      test('admin login', () async {
        await kuzzleTestHelper.kuzzle.login(adminCredentials);
      });
    });
    test('roles crud', () {});
    test('profiles crud', () {});
    test('login/logout', () {});

    tearDownAll(() async {
      await user.delete();
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
