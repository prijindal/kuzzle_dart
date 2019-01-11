import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

import 'abstract.dart';

class WebSocketProtocol extends KuzzleProtocol {
  WebSocketProtocol(String host, {
    bool autoReconnect = true,
    int port = 7512,
    Duration reconnectionDelay,
    bool ssl = false,
  }) : super(host,
    autoReconnect: autoReconnect,
    port: port,
    reconnectionDelay: reconnectionDelay,
    ssl: ssl,
  );

  String _lastUrl;
  WebSocket _webSocket;


  @override
  Future<void> connect() async {
    final url = '${ssl ? 'wss' : 'ws'}://$host:$port';

    await super.connect();

    if (url != _lastUrl) {
      wasConnected = false;
      _lastUrl = url;
    }

    try {
      _webSocket = await WebSocket.connect(url);
      clientConnected();
    } on WebSocketException catch (error) {
      if (wasConnected) {
        clientNetworkError(KuzzleError(error.message));
      }

      rethrow;
    }

    _webSocket.listen((payload) {
      try {
        final json = jsonDecode(payload);
        final response = KuzzleResponse.fromJson(json);

        if (response.room.isNotEmpty) {
          emit(response.room, [response]);
        }
        else {
          emit('discarded', [response]);
        }
      } on Exception catch(error) {
        print('websocket.onData.payloadError:');
        print(error);
      }
    }, onError: (error) {
      print('websocket.onError');
      print(error);
      clientNetworkError(error);

      /*if (_webSocket.readyState == WebSocket.closing
        || _webSocket.readyState == WebSocket.closed
      ) {
        completer.completeError(error);
      }*/
    }, onDone: () {
      if (_webSocket.closeCode == 1000) {
        clientDisconnected();
      }
      else if (wasConnected) {
        clientNetworkError(KuzzleError(
          _webSocket.closeReason,
          _webSocket.closeCode
        ));
      }
    });
  }

  @override
  void send(KuzzleRequest request) {
    if (_webSocket != null
        && _webSocket.readyState == WebSocket.open
    ) {
      _webSocket.add(jsonEncode(request));
    }
  }

  @override
  void close() {
    super.close();

    removeAllListeners();
    wasConnected = false;
    if (_webSocket != null) {
      _webSocket.close();
    }
    _webSocket = null;
    stopRetryingToConnect = true;
  }
}