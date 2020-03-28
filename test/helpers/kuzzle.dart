import 'dart:async';
import 'package:kuzzle/kuzzle.dart';
import 'package:kuzzle/src/protocols/events.dart';

const Map<String, dynamic> adminCredentials = {
  'username': 'admin',
  'password': 'admin'
};

Future<void> connectKuzzle(Kuzzle kuzzle) {
  final completer = Completer<void>();
  kuzzle.on(ProtocolEvents.CONNECTED, completer.complete);
  kuzzle.connect();
  return completer.future;
}
