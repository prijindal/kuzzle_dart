import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzleTestHelper = KuzzleTestHelper();
  setUpAll(() async {
    await kuzzleTestHelper.connect();
    kuzzleTestHelper.kuzzle.defaultIndex = Uuid().v1();
  });

  group('Subscriptions', () {
    Collection collection;
    Room room;
    final sampleContent = {'foo': 'bar'};
    setUpAll(() async {
      await kuzzleTestHelper.kuzzle
          .createIndex(kuzzleTestHelper.kuzzle.defaultIndex);
      collection = kuzzleTestHelper.kuzzle.collection('posts');
      await collection.create();
    });

    test('creating subscription', () async {
      room = await collection.subscribe((response) {
        final obj = response.toObject();
        if (obj is Document) {
          expect(obj.content, sampleContent);
        }
      },
          scope: RoomScope.all,
          state: RoomState.done,
          users: RoomUsersScope.all);
    });

    test('creating a document', () async {
      expect((await collection.createDocument({'foo': 'bar'})).content,
          sampleContent);
    });

    test('ubsubscribing', () async {
      final id = await room.unsubscribe();
      expect(id, room.id);
    });

    tearDownAll(() async {
      await kuzzleTestHelper.kuzzle
          .deleteIndex(kuzzleTestHelper.kuzzle.defaultIndex);
    });
  });

  tearDownAll(kuzzleTestHelper.end);
}
