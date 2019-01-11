import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

import '../kuzzle/errors.dart';
import '../kuzzle/event_emitter.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'state.dart';

final _uuid = Uuid();

abstract class KuzzleProtocol extends KuzzleEventEmitter {
  KuzzleProtocol(this.host, {
    this.autoReconnect = true,
    this.port = 7512,
    Duration reconnectionDelay,
    this.ssl = false,
  }) : assert(host.isNotEmpty),
    assert(port > 0),
    _state = KuzzleProtocolState.offline,
    _reconnectionDelay = reconnectionDelay ?? Duration(seconds: 1),
    id = _uuid.v4();

  bool autoReconnect;
  final String host;
  final String id;
  final int port;
  final Duration _reconnectionDelay;
  final bool ssl;

  @protected
  bool wasConnected = false;

  @protected
  bool stopRetryingToConnect = false;

  @protected
  bool retrying = false;

  KuzzleProtocolState _state;
  KuzzleProtocolState get state => _state;

  bool isReady() => _state == KuzzleProtocolState.connected;

  @mustCallSuper
  Future<void> connect() async {
    _state = KuzzleProtocolState.connecting;
  }

  void send(KuzzleRequest request);

  void clientConnected({
    KuzzleProtocolState state = KuzzleProtocolState.connected,
  }) {
    _state = state;
    stopRetryingToConnect = false;
    emit(wasConnected ? 'reconnect' : 'connect');

    wasConnected = true;
  }

  void clientDisconnected() {
    emit('disconnect');
  }

  void clientNetworkError(Error error) {
    _state = KuzzleProtocolState.offline;

    emit('networkError', [
      KuzzleError('Unable to connect to kuzzle server at $host:$port')
    ]);

    if (autoReconnect && !retrying && !stopRetryingToConnect) {
      retrying = true;

      Timer(_reconnectionDelay, () {
        retrying = false;
        connect().catchError(clientNetworkError);
      });
    } else {
      emit('disconnect');
    }
  }

  @mustCallSuper
  void close() {
    _state = KuzzleProtocolState.offline;
  }

  @mustCallSuper
  Future<KuzzleResponse> query(KuzzleRequest request) {
    if (!isReady()) {
      emit('discarded', [request]);

      return Future.error(KuzzleError(
        'Unable to execute request: not connected to a Kuzzle server.'
      ));
    }

    final completer = Completer<KuzzleResponse>();

    once(request.requestId, (response) {
      if (response.error != null) {
        emit('queryError', [response.error, request]);

        if (response.action != 'logout'
          && response.error.message == 'Token expired'
        ) {
          emit('tokenExpired');
        }

        return completer.completeError(response.error);
      }

      return completer.complete(response);
    });

    try {
      send(request);
    } on Exception catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }
}
