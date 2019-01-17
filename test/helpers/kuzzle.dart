import 'dart:async';
import 'package:kuzzle/kuzzle_dart.dart';

const Map<String, dynamic> adminCredentials = {
  'username': 'admin',
  'password': 'admin'
};

Future<void> connectKuzzle(Kuzzle kuzzle) {
  final completer = Completer<void>();
  kuzzle.on('connected', completer.complete);
  kuzzle.connect();
  return completer.future;
}
