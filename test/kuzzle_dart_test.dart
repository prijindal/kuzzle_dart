import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:kuzzle_dart/kuzzle_dart.dart';

import 'test_helpers.dart';

void main() {
  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;
  Kuzzle kuzzle;

  setUpAll(() async {
    server = await HttpServer.bind('localhost', 0);
    streamSubscription =
        server.transform(WebSocketTransformer()).listen(onServerTransformData);
    kuzzle = Kuzzle('localhost', port: server.port, defaultIndex: 'testindex');
  });

  test('Simple test for kuzzle connection', () async {
    await kuzzle.connect();
  });

  test('test for collection constructor', () async {
    final Collection collection = kuzzle.collection('posts');
    await collection.create(mapping: <String, MappingDefinition>{
      'title': MappingDefinition('', 'text', <String, dynamic>{}),
    });
  });

  test('test for security constructor', () async {
    kuzzle.security.role('id', <String, dynamic>{});
  });

  test('test for disconnection', () {
    kuzzle.disconect();
  });

  tearDownAll(() {
    kuzzle.disconect();
    streamSubscription.cancel();
    server.close(force: true);
  });
}
