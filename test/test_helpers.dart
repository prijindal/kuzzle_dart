import 'dart:io';
import 'package:web_socket_channel/io.dart';

import 'package:kuzzle_dart/kuzzle_dart.dart';

class TestKuzzle extends Kuzzle {
  TestKuzzle(
    String host,
  ) : super(host);

  @override
  Future<IOWebSocketChannel> connectInternal() async {
    final HttpServer server = await HttpServer.bind('localhost', 0);
    server.transform(WebSocketTransformer()).listen((WebSocket webSocket) {
      final IOWebSocketChannel channel = IOWebSocketChannel(webSocket);
      channel.stream.listen((dynamic data) {
        channel.sink.add(data);
      });
    });

    return IOWebSocketChannel.connect('ws://localhost:${server.port}');
  }
}
