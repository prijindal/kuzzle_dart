import 'dart:io';
import 'package:web_socket_channel/io.dart';

void onServerTransformData(WebSocket webSocket) {
  final IOWebSocketChannel channel = IOWebSocketChannel(webSocket);
  channel.stream.listen((dynamic data) {
    channel.sink.add(data);
  });
}
