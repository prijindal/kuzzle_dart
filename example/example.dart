import 'dart:io' show exit;
import 'package:kuzzle_dart/kuzzle_dart.dart';

Future<void> kuzzleConnections() async {
  final Kuzzle kuzzle = Kuzzle('localhost', defaultIndex: 'playground');
  kuzzle.connect();
  try {
    await kuzzle.createIndex('playground');
  } catch (err) {
    if (err is ResponseError) {
      print(err.status);
    }
  }

  final Collection collection = kuzzle.collection('collection');

  await collection.create();

  final Room room = await collection.subscribe((RawKuzzleResponse response) {
    print(response.state + ' ' + response.action + ' ' + response.controller);
    print(response.toObject());
  }, scope: RoomScope.all, state: RoomState.done, users: RoomUsersScope.all);

  const Map<String, dynamic> message = <String, dynamic>{
    'message': 'Hello World',
    'echoing': 1
  };
  final Document document = await collection.createDocument(message);
  print(document.version);
  final bool doesDocumentExists = await document.exists();
  print(doesDocumentExists);

  await document.publish();
  // print(document.toString());

  // final int count = await collection.count();
  // print(count);

  // final CollectionMapping collectionMapping = await collection.getMapping();
  // print(collectionMapping);

  await collection
      .updateDocument(document.id, <String, dynamic>{'Hello': 'world'});

  await document.delete();

  await collection.truncate();
  // print(deletedIds);

  final String roomId = await room.unsubscribe();
  print(roomId);

  // kuzzle.disconect();
}

void main() {
  const bool shouldExit = false;
  if (!shouldExit) {
    kuzzleConnections();
    return;
  }
  kuzzleConnections().then((void value) {
    exit(0);
  });
}
