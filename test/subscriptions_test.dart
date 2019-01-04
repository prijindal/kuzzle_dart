import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:kuzzle/kuzzle_dart.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = TestKuzzle();
  setUpAll(() async {
    await kuzzle.connect();
    kuzzle.defaultIndex = Uuid().v1();
  });

  group('Subscriptions', () {
    Collection collection;
    Room room;
    final sampleContent = {'foo': 'bar'};
    setUpAll(() async {
      await kuzzle.createIndex(kuzzle.defaultIndex);
      collection = kuzzle.collection('posts');
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
      await kuzzle.deleteIndex(kuzzle.defaultIndex);
    });
  });

  tearDownAll(kuzzle.disconect);
}
