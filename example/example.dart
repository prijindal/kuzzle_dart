import 'dart:io' show exit;
import 'package:kuzzle_dart/kuzzle_dart.dart';

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
  final Kuzzle kuzzle = Kuzzle(HOST, defaultIndex: DEFAULT_INDEX);
  await kuzzle.connect();
  await kuzzle.login(adminCredentials);

  final List<String> indexes = await kuzzle.listIndexes();

  if (indexes.contains(DEFAULT_INDEX) == false) {
    await kuzzle.createIndex(DEFAULT_INDEX);
  }

  final Collection collection = kuzzle.collection(TEST_COLLECTION);

  await collection.create();

  final Room room = await collection.subscribe((RawKuzzleResponse response) {
    print(response.state + ' ' + response.action + ' ' + response.controller);
    print(response.toObject());
  }, scope: RoomScope.all, state: RoomState.done, users: RoomUsersScope.all);

  await kuzzle.logout();

  try {
    final AuthResponse response = await kuzzle.login(creds);
    print(response);
  } catch (e) {
    if (e is ResponseError) {
      if (e.status == 401) {
        final User user = User(kuzzle.security, name: 'Priyanshu Jindal');
        await kuzzle.register(user, creds);
      }
    }
  }

  const Map<String, dynamic> message = <String, dynamic>{
    'message': 'Hello World',
    'echoing': 1
  };
  final Document document = await collection.createDocument(message);
  print(document.version);
  final bool doesDocumentExists = await document.exists();
  print(doesDocumentExists);

  await document.publish();
  print(document.toString());

  final int count = await collection.count();
  print(count);

  await collection
      .updateDocument(document.id, <String, dynamic>{'Hello': 'world'});

  await document.delete();

  await kuzzle.logout();

  await kuzzle.login(adminCredentials);

  final CollectionMapping collectionMapping = await collection.getMapping();
  print(collectionMapping);

  final List<String> deletedIds = await collection.truncate();
  print(deletedIds);

  await kuzzle.deleteIndex(kuzzle.defaultIndex);

  final String roomId = await room.unsubscribe();
  print(roomId);

  kuzzle.disconect();
}

void main() {
  const bool shouldExit = true;
  if (!shouldExit) {
    kuzzleConnections();
    return;
  }
  kuzzleConnections().then((void value) {
    exit(0);
  });
}
