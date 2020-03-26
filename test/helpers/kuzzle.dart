import 'dart:async';
import 'package:kuzzle/kuzzle.dart';

const Map<String, dynamic> adminCredentials = {
  'username': 'admin',
  'password': 'flyfly'
};

Future<void> connectKuzzle(Kuzzle kuzzle) {
  final completer = Completer<void>();
  kuzzle.on('connected', completer.complete);
  kuzzle.connect();
  return completer.future;
}
