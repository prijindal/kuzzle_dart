import 'dart:io' show exit;
import 'package:kuzzle/kuzzle_dart.dart';

const String HOST = 'localhost';
const String DEFAULT_INDEX = 'testindex';
const String TEST_COLLECTION = 'testcollection';

const String ADMIN_USERNAME = 'admin';
const String ADMIN_PASSWORD = 'admin';

const Credentials adminCredentials = Credentials(LoginStrategy.local,
    username: ADMIN_USERNAME, password: ADMIN_PASSWORD);

const Credentials creds =
    Credentials(LoginStrategy.local, username: 'prijindal', password: '123456');

Future<void> kuzzleConnections() async {
  final kuzzle = Kuzzle(HOST, defaultIndex: DEFAULT_INDEX);
  await kuzzle.connect();
  await kuzzle.login(adminCredentials);

  final indexes = await kuzzle.listIndexes();

  if (indexes.contains(DEFAULT_INDEX) == false) {
    await kuzzle.createIndex(DEFAULT_INDEX);
  }

  final collection = kuzzle.collection(TEST_COLLECTION);

  await collection.create();

  final room = await collection.subscribe((response) {
    print('${response.state} ${response.action} ${response.controller}');
    print(response.toObject());
  }, scope: RoomScope.all, state: RoomState.done, users: RoomUsersScope.all);

  await kuzzle.logout();

  try {
    final response = await kuzzle.login(creds);
    print(response);
  } on dynamic catch (e) {
    if (e is ResponseError) {
      if (e.status == 401) {
        final user = User(kuzzle.security, name: 'Priyanshu Jindal');
        await kuzzle.register(user, creds);
      }
    }
  }

  const message = <String, dynamic>{'message': 'Hello World', 'echoing': 1};
  final document = await collection.createDocument(message);
  print(document.version);
  final doesDocumentExists = await document.exists();
  print(doesDocumentExists);

  await document.publish();
  print(document.toString());

  final count = await collection.count();
  print(count);

  await collection
      .updateDocument(document.id, <String, dynamic>{'Hello': 'world'});

  await document.delete();

  await kuzzle.logout();

  await kuzzle.login(adminCredentials);

  final collectionMapping = await collection.getMapping();
  print(collectionMapping);

  await collection.truncate();

  await kuzzle.deleteIndex(kuzzle.defaultIndex);

  final roomId = await room.unsubscribe();
  print(roomId);

  kuzzle.disconect();
}

void main() {
  const shouldExit = true;
  if (!shouldExit) {
    kuzzleConnections();
    return;
  }
  kuzzleConnections().then((value) {
    exit(0);
  });
}
