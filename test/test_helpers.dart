import 'dart:io';
import 'package:web_socket_channel/io.dart';

import 'package:kuzzle_dart/src/imitation.dart';

void onServerTransformData(WebSocket webSocket) {
  final ImitationServer imitationServer = ImitationServer();
  final IOWebSocketChannel channel = IOWebSocketChannel(webSocket);
  channel.stream.listen((dynamic data) {
    imitationServer.transform(data).then((String transformedData) {
      print(transformedData);
      channel.sink.add(transformedData);
    });
  });
}
