import 'dart:async';
import 'dart:io';
import 'package:kuzzle_dart/kuzzle_dart.dart';
import 'package:web_socket_channel/io.dart';

import 'package:kuzzle_dart/src/imitation.dart';

void onServerTransformData(WebSocket webSocket) {
  final ImitationServer imitationServer = ImitationServer();
  final IOWebSocketChannel channel = IOWebSocketChannel(webSocket);
  channel.stream.listen((dynamic data) {
    channel.sink.add(imitationServer.transform(data));
  });
}

const Credentials adminCredentials =
    Credentials(LoginStrategy.local, username: 'admin', password: 'admin');

class KuzzleTestHelper {
  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;
  Kuzzle kuzzle;

  Future<void> connect([bool isImitation = true]) async {
    if (isImitation) {
      server = await HttpServer.bind('localhost', 0);
      streamSubscription = server
          .transform(WebSocketTransformer())
          .listen(onServerTransformData);
      kuzzle =
          Kuzzle('localhost', port: server.port, defaultIndex: 'testindex');
    } else {
      kuzzle = Kuzzle('localhost', defaultIndex: 'testindex');
    }
    await kuzzle.connect();
    kuzzle.login(adminCredentials);
  }

  void end() {
    kuzzle.disconect();
    if (streamSubscription != null && server != null) {
      streamSubscription.cancel();
      server.close(force: true);
    }
  }
}
