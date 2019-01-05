import 'dart:async';
import 'dart:io';
import 'package:kuzzle/kuzzle_dart.dart';
import 'package:web_socket_channel/io.dart';

import 'imitation.dart';

class TestKuzzle extends Kuzzle {
  TestKuzzle({String defaultIndex, int port = 7512, this.isImitation = false})
      : super('localhost', defaultIndex: defaultIndex, port: port);

  static const Credentials adminCredentials =
      Credentials(LoginStrategy.local, username: 'admin', password: 'admin');

  bool isImitation;
  HttpServer server;
  StreamSubscription<dynamic> streamSubscription;
  ImitationServer imitationServer;

  @override
  Future<void> connect() async {
    await super.connect();
    await login(adminCredentials);
  }

  @override
  Future<IOWebSocketChannel> connectInternal() async {
    if (isImitation) {
      var port = this.port;
      server = await HttpServer.bind(host, 0);
      streamSubscription =
          server.transform(WebSocketTransformer()).listen((webSocket) {
        imitationServer = ImitationServer();
        final channel = IOWebSocketChannel(webSocket);
        channel.stream.listen((data) {
          channel.sink.add(imitationServer.transform(data));
        });
      });
      port = server.port;
      return IOWebSocketChannel.connect('ws://$host:${port.toString()}/ws');
    }

    return super.connectInternal();
  }

  @override
  void disconnect() {
    super.disconnect();
    if (streamSubscription != null && server != null) {
      streamSubscription.cancel();
      server.close(force: true);
    }
  }
}
