import 'dart:async';

import 'controllers/abstract.dart';
import 'controllers/auth.dart';
import 'controllers/server.dart';
import 'kuzzle/errors.dart';
import 'kuzzle/event_emitter.dart';
import 'kuzzle/request.dart';
import 'kuzzle/response.dart';
import 'protocols/abstract.dart';

enum OfflineMode { manual, auto }

class KuzzleQueuedRequest {
  KuzzleQueuedRequest({
    this.completer,
    this.request,
  }) : queuedAt = DateTime.now();

  Completer<KuzzleResponse> completer;
  KuzzleRequest request;
  DateTime queuedAt;
}

class Kuzzle extends KuzzleEventEmitter {
  Kuzzle(
    this.protocol, {
    bool autoQueue = false,
    bool autoReplay = false,
    this.autoResubscribe = true,
    this.eventTimeout = 200,
    this.offlineMode = OfflineMode.manual,
    this.offlineQueueLoader,
    this.queueFilter,
    Duration queueTTL,
    this.queueMaxSize = 500,
    Duration replayInterval,
    Map<String, dynamic> volatile,
  }) {
    if (offlineMode == OfflineMode.auto) {
      _autoQueue = true;
      _autoReplay = true;
    } else {
      _autoQueue = autoQueue;
      _autoReplay = autoReplay;
    }

    _volatile = volatile ?? <String, dynamic>{};
    _queueTTL = queueTTL ?? Duration(minutes: 2);
    _replayInterval = replayInterval ?? Duration(milliseconds: 10);

    server = ServerController(this);
    auth = AuthController(this);

    protocol.on('queryError', (error, request) {
      emit('queryError', [error, request]);
    });

    protocol.on('tokenExpired', () {
      jwt = null;
      emit('tokenExpired');
    });
  }

  ServerController get server => this['server'] as ServerController;
  set server(ServerController _server) => this['server'] = _server;

  AuthController get auth => this['auth'] as AuthController;
  set auth(AuthController _auth) => this['auth'] = _auth;

  final KuzzleProtocol protocol;
  final bool autoResubscribe;
  final int eventTimeout;
  final OfflineMode offlineMode;
  final Function offlineQueueLoader;
  final Function queueFilter;
  final int queueMaxSize;

  final List<KuzzleController> _controllers = <KuzzleController>[];
  final List<KuzzleQueuedRequest> _offlineQueue = <KuzzleQueuedRequest>[];
  bool _queuing = false;

  String jwt;

  Map<String, dynamic> _volatile;
  Map<String, dynamic> get volatile => _volatile;

  Duration _queueTTL;
  Duration get queueTTL => _queueTTL;

  Duration _replayInterval;
  Duration get replayInterval => _replayInterval;

  bool _autoQueue;
  bool get autoQueue => _autoQueue;

  bool _autoReplay;
  bool get autoReplay => _autoReplay;

  bool get autoReconnect => protocol.autoReconnect;
  set autoReconnect(bool value) {
    protocol.autoReconnect = value;
  }

  /// Connects to a Kuzzle instance using the provided host name
  Future<void> connect() {
    if (protocol.isReady()) {
      return Future.value();
    }

    if (autoQueue) {
      startQueuing();
    }

    protocol.on('connect', () {
      if (autoQueue) {
        stopQueuing();
      }

      if (autoReplay) {
        playQueue();
      }

      emit('connected');
    });

    protocol.on('networkError', (error) {
      if (autoQueue) {
        startQueuing();
      }

      emit('networkError', [error]);
    });

    protocol.on('disconnect', () {
      emit('disconnected');
    });

    protocol.on('reconnect', () {
      if (autoQueue) {
        stopQueuing();
      }

      if (autoReplay) {
        playQueue();
      }

      if (jwt != null) {
        // todo: implement checkToken on reconnection
      }

      emit('reconnected');
    });

    protocol.on('discarded', (request) {
      emit('discarded', [request]);
    });

    return protocol.connect();
  }

  /// Disconnects from Kuzzle and invalidate this instance.
  void disconnect() {
    protocol.close();
  }

  /// Starts the requests queuing.
  void startQueuing() {
    _queuing = true;
  }

  /// Stops the requests queuing.
  void stopQueuing() {
    _queuing = false;
  }

  /// Plays the requests queued during offline mode.
  void playQueue() {
    if (protocol.isReady()) {
      _cleanQueue();
      _dequeue();
    }
  }

  /// Empties the offline queue without replaying it.
  void flushQueue() {
    _offlineQueue.clear();
  }

  /// Clean up invalid requests in the queue
  ///
  /// Ensure the `queryTTL` and `queryMaxSize` properties are respected
  void _cleanQueue() {
    final now = DateTime.now();
    var lastDocumentIndex = -1;

    if (!queueTTL.isNegative) {
      lastDocumentIndex = _offlineQueue.lastIndexWhere((queuedRequest) =>
          queuedRequest.queuedAt.add(queueTTL).difference(now).isNegative);

      if (lastDocumentIndex != -1) {
        for (final queuedRequest
            in _offlineQueue.getRange(0, lastDocumentIndex + 1)) {
          emit('offlineQueuePop', [queuedRequest.request]);
        }

        _offlineQueue.removeRange(0, lastDocumentIndex + 1);
      }
    }

    if (queueMaxSize > 0 && _offlineQueue.length > queueMaxSize) {
      for (final queuedRequest in _offlineQueue.getRange(
          0, _offlineQueue.length - queueMaxSize + 1)) {
        emit('offlineQueuePop', [queuedRequest.request]);
      }

      _offlineQueue.removeRange(0, _offlineQueue.length - queueMaxSize + 1);
    }
  }

  /// Play all queued requests, in order.
  void _dequeue() {
    void _dequeuingProcess() {
      if (_offlineQueue.isNotEmpty) {
        final queuedRequest = _offlineQueue.first;

        protocol.query(queuedRequest.request).then((response) {
          queuedRequest.completer.complete(response);
        }).catchError((error) {
          queuedRequest.completer.completeError(error);
        });

        emit('offlineQueuePop', [queuedRequest.request]);
        _offlineQueue.removeAt(0);

        Timer(replayInterval, _dequeuingProcess);
      }
    }

    if (offlineQueueLoader != null) {
      // todo: implement offlineQueueLoader
    }

    _dequeuingProcess();
  }

  /// Base method used to send read queries to Kuzzle
  ///
  /// This is a low-level method, with offline queue management,
  /// exposed to allow advanced SDK users to bypass high-level methods.
  ///
  /// Takes an optional Map `[options]` with the following properties:
  ///
  /// ```
  ///  final options = {
  ///    'queueable': bool,
  ///    'volatile': Map<String, dynamic>,
  ///  };
  /// ```
  ///
  Future<KuzzleResponse> query(Map<String, dynamic> request,
      [Map<String, dynamic> options]) {
    final _request = KuzzleRequest.fromMap(request);

    // bind volatile data
    _request.volatile ??= volatile;

    for (final item in volatile.keys) {
      if (!_request.volatile.containsKey(item)) {
        _request.volatile[item] = volatile[item];
      }
    }

    _request.volatile['sdkInstanceId'] = protocol.id;
    _request.volatile['sdkVersion'] = '0.0.1';

    /*
     * Do not add the token for the checkToken route,
     * to avoid getting a token error when a developer
     * simply wish to verify his token
     */
    if ((jwt != null && jwt.isNotEmpty) &&
        !(_request.controller == 'auth' && _request.action == 'checkToken')) {
      _request.jwt = jwt;
    }

    var queueable = true;
    if (options != null && options.containsKey('queueable')) {
      queueable = options['queueable'] as bool;
    }

    if (queueFilter != null) {
      // todo: implement queueFilter
    }

    // check queueing
    if (_queuing) {
      if (queueable) {
        final completer = Completer<KuzzleResponse>();
        final queuedRequest = KuzzleQueuedRequest(
          completer: completer,
          request: _request,
        );

        _cleanQueue();

        _offlineQueue.add(queuedRequest);
        emit('offlineQueuePush', [queuedRequest.request]);

        return completer.future;
      }

      emit('discarded', [_request]);
      return Future.error(KuzzleError(
          'Unable to execute request: not connected to a Kuzzle server.'));
    }

    return protocol.query(_request);
  }

  KuzzleController operator [](String accessor) =>
      _controllers.singleWhere((controller) => controller.accessor == accessor);

  void operator []=(String accessor, KuzzleController controller) {
    assert(this[accessor] == null);

    controller.accessor = accessor;

    _controllers.add(controller);
  }
}
