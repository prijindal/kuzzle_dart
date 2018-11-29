import 'package:kuzzle_dart/kuzzle_dart.dart';

Future<void> main() async {
  final Kuzzle kuzzle = Kuzzle('localhost', defaultIndex: 'playground');

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
    print(response.action + ' ' + response.controller);
    print(response.toObject());
  });
  print(room.channel);

  const Map<String, dynamic> message = <String, dynamic>{
    'message': 'Hello World',
    'echoing': 1
  };
  final Document document = await collection.createDocument(message);
  // print(document.toString());

  // final int count = await collection.count();
  // print(count);

  // final CollectionMapping collectionMapping = await collection.getMapping();
  // print(collectionMapping);

  await document.delete();

  // final RawKuzzleResponse response = await collection.truncate();
  // print(response);
}
