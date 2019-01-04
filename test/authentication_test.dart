import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = TestKuzzle();
  Credentials credentials;
  User user;
  setUpAll(() async {
    await kuzzle.connect();
    final uuid = Uuid();
    kuzzle.defaultIndex = uuid.v1();
    credentials = Credentials(
      LoginStrategy.local,
      username: uuid.v1(),
      password: uuid.v1(),
    );
    user = User(kuzzle.security, source: {'name': 'Test User'});
  });

  group('authentication', () {
    group('user auth', () {
      test('register', () async {
        final saveduser = await kuzzle.register(user, credentials);
        expect(saveduser.source['name'], user.source['name']);
        user = saveduser;
      });

      test('login', () async {
        final response = await kuzzle.login(credentials);
        expect(response.id, user.id);
      });

      test('check token', () async {
        final checkToken = await kuzzle.checkToken(kuzzle.getJwtToken());
        expect(checkToken.valid, true);
        final prevToken = kuzzle.getJwtToken();
        await kuzzle.logout();
        final newCheckToken = await kuzzle.checkToken(prevToken);
        expect(newCheckToken.valid, false);
        expect((await kuzzle.login(credentials)).id, user.id);
      });

      test('check if credentials exists', () async {
        expect(await kuzzle.credentialsExist(LoginStrategy.local), true);
      });

      test('delete credentials', () async {
        expect(
            (await kuzzle.deleteMyCredentials(LoginStrategy.local))
                .acknowledged,
            true);
      });

      test('create credentials', () async {
        final credentialsResponse =
            await kuzzle.createMyCredentials(credentials);
        expect(credentialsResponse.username, credentials.username);
      });

      test('get credentials', () async {
        final currentUser = await kuzzle.getMyCredentials(LoginStrategy.local);
        expect(currentUser.username, credentials.username);
        expect(currentUser.kuid, user.id);
      });

      test('update credentials', () async {
        final credentialsResponse =
            await kuzzle.updateMyCredentials(credentials);
        expect(credentialsResponse.username, credentials.username);
      });

      test('get all strategies', () async {
        expect(await kuzzle.getStrategies(), ['local']);
      });

      test('get current user', () async {
        final currentUser = await kuzzle.getCurrentUser();
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
        final iAm = await kuzzle.whoAmI();
        expect(iAm.id, user.id);
      });

      test('get my rights', () async {
        final rights = await kuzzle.getMyRights();
        // All rights are valid
        expect(rights.length, 1);
        expect(rights[0].controller, '*');
        expect(rights[0].action, '*');
        expect(rights[0].index, '*');
        expect(rights[0].collection, '*');
        expect(rights[0].value, 'allowed');
      });

      test('signout', () async {
        await kuzzle.logout();
      });

      test('admin login', () async {
        await kuzzle.login(TestKuzzle.adminCredentials);
      });

      test('search users', () async {
        final searchUsers = await kuzzle.searchUsers({
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

  tearDownAll(kuzzle.disconect);
}
