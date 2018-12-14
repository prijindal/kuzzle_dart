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

class TestKuzzle extends Kuzzle {
  TestKuzzle(String host, {String defaultIndex, int port = 7512})
      : super(host, defaultIndex: defaultIndex, port: port);

  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;

  @override
  @override
  Future<void> connect() async {
    await super.connect();
    await login(adminCredentials);
  }

  @override
  void disconect() {
    super.disconect();
    if (streamSubscription != null && server != null) {
      streamSubscription.cancel();
      server.close(force: true);
    }
  }
}

Future<TestKuzzle> kuzzleTestConstructor({bool isImitation = false}) async {
  TestKuzzle kuzzle;
  if (isImitation) {
    kuzzle.server = await HttpServer.bind('localhost', 0);
    kuzzle.streamSubscription = kuzzle.server
        .transform(WebSocketTransformer())
        .listen(onServerTransformData);
    kuzzle = TestKuzzle('localhost',
        port: kuzzle.server.port, defaultIndex: 'testindex');
  } else {
    kuzzle = TestKuzzle('localhost', defaultIndex: 'testindex');
  }
  await kuzzle.connect();
  return kuzzle;
}
