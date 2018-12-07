import 'dart:async';
import 'dart:io';
import 'package:kuzzle_dart/kuzzle_dart.dart';
import 'package:web_socket_channel/io.dart';

import 'package:kuzzle_dart/src/imitation.dart';

void onServerTransformData(WebSocket webSocket) {
  final ImitationServer imitationServer = ImitationServer();
  final IOWebSocketChannel channel = IOWebSocketChannel(webSocket);
  channel.stream.listen((dynamic data) {
    imitationServer.transform(data).then((String transformedData) {
      channel.sink.add(transformedData);
    });
  });
}

class KuzzleTestHelper {
  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;
  Kuzzle kuzzle;

  Future<void> connect() async {
    server = await HttpServer.bind('localhost', 0);
    streamSubscription =
        server.transform(WebSocketTransformer()).listen(onServerTransformData);
    kuzzle = Kuzzle('localhost', port: server.port, defaultIndex: 'testindex');
    kuzzle.connect();
  }

  void end() {
    kuzzle.disconect();
    streamSubscription.cancel();
    server.close(force: true);
  }
}
