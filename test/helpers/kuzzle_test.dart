import 'dart:async';
import 'dart:io';
import 'package:kuzzle/kuzzle_dart.dart';
import 'package:web_socket_channel/io.dart';

import 'imitation.dart';

void onServerTransformData(WebSocket webSocket) {
  final imitationServer = ImitationServer();
  final channel = IOWebSocketChannel(webSocket);
  channel.stream.listen((data) {
    channel.sink.add(imitationServer.transform(data));
  });
}

const Credentials adminCredentials =
    Credentials(LoginStrategy.local, username: 'admin', password: 'admin');

class KuzzleTestHelper {
  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;
  Kuzzle kuzzle;

  Future<void> connect({bool isImitation = true}) async {
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
    await kuzzle.login(adminCredentials);
  }

  void end() {
    kuzzle.disconect();
    if (streamSubscription != null && server != null) {
      streamSubscription.cancel();
      server.close(force: true);
    }
  }
}
