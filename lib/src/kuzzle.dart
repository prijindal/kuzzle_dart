import 'dart:async';

import 'controllers/abstract.dart';
import 'controllers/auth.dart';
import 'controllers/bulk.dart';
import 'controllers/collection.dart';
import 'controllers/document.dart';
import 'controllers/index.dart';
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
    this.autoQueue = false,
    this.autoReplay = false,
    this.autoResubscribe = true,
    this.eventTimeout = 200,
    this.offlineMode = OfflineMode.manual,
    this.offlineQueueLoader,
    this.queueFilter,
    this.queueTTL,
    this.queueMaxSize = 500,
    this.replayInterval,
    this.volatile,
  }) {
    if (offlineMode == OfflineMode.auto) {
      autoQueue = true;
      autoReplay = true;
    }

    volatile ??= <String, dynamic>{};
    queueTTL ??= Duration(minutes: 2);
    replayInterval ??= Duration(milliseconds: 10);

    server = ServerController(this);
    bulk = BulkController(this);
    auth = AuthController(this);
    index = IndexController(this);
    collection = CollectionController(this);
    document = DocumentController(this);

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

  BulkController get bulk => this['bulk'] as BulkController;
  set bulk(BulkController _bulk) => this['bulk'] = _bulk;

  IndexController get index => this['index'] as IndexController;
  set index(IndexController _index) => this['index'] = _index;

  DocumentController get document => this['document'] as DocumentController;
  set document(DocumentController _document) => this['document'] = _document;

  CollectionController get collection =>
      this['collection'] as CollectionController;
  set collection(CollectionController _collection) =>
      this['collection'] = _collection;

  /// Protocol used by the SDK
  final KuzzleProtocol protocol;

  final int eventTimeout;
  final OfflineMode offlineMode;
  final Function offlineQueueLoader;
  final Function queueFilter;

  /// Automatically queue all requests during offline mode
  bool autoQueue;

  /// Automatically replay queued requests on a reconnected event
  bool autoReplay;

  /// Automatically renew all subscriptions on a reconnected event
  bool autoResubscribe;

  /// Number of maximum requests kept during offline mode
  int queueMaxSize;

  /// Time a queued request is kept during offline mode, in milliseconds
  Duration queueTTL;

  /// Delay between each replayed requests
  Duration replayInterval;

  /// Token used in requests for authentication
  String jwt;

  /// Common volatile data, will be sent to all future requests
  Map<String, dynamic> volatile;

  bool get autoReconnect => protocol.autoReconnect;
  set autoReconnect(bool value) {
    protocol.autoReconnect = value;
  }

  final Map<String, KuzzleController> _controllers =
      <String, KuzzleController>{};
  final List<KuzzleQueuedRequest> _offlineQueue = <KuzzleQueuedRequest>[];
  bool _queuing = false;

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
  /// todo: replace request by a KuzzleRequest (avoid casts at each request)
  Future<KuzzleResponse> query(KuzzleRequest request,
      [Map<String, dynamic> options]) {
    //final _request = KuzzleRequest.fromMap(request);

    // bind volatile data
    request.volatile ??= volatile;

    for (final item in volatile.keys) {
      if (!request.volatile.containsKey(item)) {
        request.volatile[item] = volatile[item];
      }
    }

    request.volatile['sdkInstanceId'] = protocol.id;
    request.volatile['sdkVersion'] = '0.0.1';

    /*
     * Do not add the token for the checkToken route,
     * to avoid getting a token error when a developer
     * simply wish to verify his token
     */
    if ((jwt != null && jwt.isNotEmpty) &&
        !(request.controller == 'auth' && request.action == 'checkToken')) {
      request.jwt = jwt;
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
          request: request,
        );

        _cleanQueue();

        _offlineQueue.add(queuedRequest);
        emit('offlineQueuePush', [queuedRequest.request]);

        return completer.future;
      }

      emit('discarded', [request]);
      return Future.error(KuzzleError(
          'Unable to execute request: not connected to a Kuzzle server.'));
    }

    return protocol.query(request);
  }

  KuzzleController operator [](String accessor) => _controllers[accessor];

  void operator []=(String accessor, KuzzleController controller) {
    assert(_controllers[accessor] == null);

    controller.accessor = accessor;

    _controllers[accessor] = controller;
  }
}
