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
    user =
        User(kuzzleTestHelper.kuzzle.security, source: {'name': 'Test User'});
  });

  group('authentication', () {
    group('user auth', () {
      test('register', () async {
        final saveduser =
            await kuzzleTestHelper.kuzzle.register(user, credentials);
        expect(saveduser.source['name'], user.source['name']);
        user = saveduser;
      });

      test('login', () async {
        final response = await kuzzleTestHelper.kuzzle.login(credentials);
        expect(response.id, user.id);
      });

      test('check token', () async {
        final checkToken = await kuzzleTestHelper.kuzzle
            .checkToken(kuzzleTestHelper.kuzzle.getJwtToken());
        expect(checkToken.valid, true);
        final prevToken = kuzzleTestHelper.kuzzle.getJwtToken();
        await kuzzleTestHelper.kuzzle.logout();
        final newCheckToken =
            await kuzzleTestHelper.kuzzle.checkToken(prevToken);
        expect(newCheckToken.valid, false);
        expect((await kuzzleTestHelper.kuzzle.login(credentials)).id, user.id);
      });

      test('check if credentials exists', () async {
        expect(
            await kuzzleTestHelper.kuzzle.credentialsExist(LoginStrategy.local),
            true);
      });

      test('delete credentials', () async {
        expect(
            (await kuzzleTestHelper.kuzzle
                    .deleteMyCredentials(LoginStrategy.local))
                .acknowledged,
            true);
      });

      test('create credentials', () async {
        final credentialsResponse =
            await kuzzleTestHelper.kuzzle.createMyCredentials(credentials);
        expect(credentialsResponse.username, credentials.username);
      });

      test('get credentials', () async {
        final currentUser =
            await kuzzleTestHelper.kuzzle.getMyCredentials(LoginStrategy.local);
        expect(currentUser.username, credentials.username);
        expect(currentUser.kuid, user.id);
      });

      test('update credentials', () async {
        final credentialsResponse =
            await kuzzleTestHelper.kuzzle.updateMyCredentials(credentials);
        expect(credentialsResponse.username, credentials.username);
      });

      test('get all strategies', () async {
        expect(await kuzzleTestHelper.kuzzle.getStrategies(), ['local']);
      });

      test('get current user', () async {
        final currentUser = await kuzzleTestHelper.kuzzle.getCurrentUser();
        expect(currentUser.id, user.id);
        expect(currentUser.profileIds, ['default']);
        expect(currentUser.source['name'], user.source['name']);
      });

      test('update self', () async {
        user.source.addAll({'lastname': 'Some last name'});
        final updatedUser = await user.update();
        expect(updatedUser.id, user.id);
        expect(updatedUser.source['name'], user.source['name']);
        expect(updatedUser.source['lastname'], 'Some last name');
      });

      test('whoami', () async {
        final iAm = await kuzzleTestHelper.kuzzle.whoAmI();
        expect(iAm.id, user.id);
      });

      test('signout', () async {
        await kuzzleTestHelper.kuzzle.logout();
      });

      test('admin login', () async {
        await kuzzleTestHelper.kuzzle.login(adminCredentials);
      });

      test('search users', () async {
        final searchUsers = await kuzzleTestHelper.kuzzle.searchUsers({
          'bool': {
            'must': [
              {
                'in': {
                  'profileIds': ['anonymous', 'default']
                }
              }
            ]
          }
        });
        expect(searchUsers.total, 1);
        expect(searchUsers.hits[0].id, user.id);
      });
    });
    test('roles crud', () {});
    test('profiles crud', () {});
    test('login/logout', () {});

    tearDownAll(() async {
      await user.delete(refresh: 'wait_for_refresh');
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
