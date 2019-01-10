import 'dart:async';
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'authentication.dart';
import 'collection.dart';
import 'credentials.dart';
import 'error.dart';
import 'event.dart';
import 'memorystorage.dart';
import 'response.dart';
import 'security.dart';
import 'serverinfo.dart';
import 'statistics.dart';
import 'user.dart';

enum KuzzleConnectType { auto }
enum KuzzleOfflineModeType { auto, manual }

class CheckTokenResponse {
  CheckTokenResponse.fromMap(Map<String, dynamic> map)
      : valid = map['valid'],
        state = map['state'],
        expiresAt = map['expiresAt'];

  final bool valid;
  final String state;
  final int expiresAt;
}

class Kuzzle extends EventBus {
  Kuzzle(
    this.host, {
    this.autoQueue = false,
    this.autoReconnect = true,
    this.autoReplay = false,
    this.autoResubscribe = true,
    this.connectType = KuzzleConnectType.auto,
    this.defaultIndex,
    this.headers,
    this.volatile,
    this.offlineMode,
    this.port = 7512,
    this.queueTTL = 120000,
    this.queueMaxSize = 500,
    this.replayInterval = 10,
    this.reconnectionDelay = 1000,
    this.sslConnection = false,
  }) {
    security = Security(this);
  }

  final String host;
  final bool autoQueue;
  final bool autoReconnect;
  final bool autoReplay;
  final bool autoResubscribe;
  final KuzzleConnectType connectType;
  String defaultIndex;
  final Map<String, dynamic> volatile;
  final KuzzleConnectType offlineMode;
  final int port;
  final int queueTTL;
  final int queueMaxSize;
  final int replayInterval;
  final int reconnectionDelay;
  final bool sslConnection;
  Security security;
  Map<String, RawKuzzleRequest> pendingRequests = <String, RawKuzzleRequest>{};
  Map<String, Completer<RawKuzzleResponse>> futureMaps =
      <String, Completer<RawKuzzleResponse>>{};
  Map<String, StreamController<RawKuzzleResponse>> roomMaps =
      <String, StreamController<RawKuzzleResponse>>{};
  IOWebSocketChannel _webSocket;
  StreamSubscription<dynamic> _streamSubscription;
  Uuid uuid = Uuid();

  Map<String, dynamic> headers;

  String jwtToken;

  // int offlineQueue;
  // void Function() offlineQueueLoader;
  // void Function() queueFilter;

  Future<RawKuzzleResponse> addNetworkQuery(
    RawKuzzleRequest request, {
    bool queuable = true,
  }) {
    final completer = Completer<RawKuzzleResponse>();
    final String requestId = uuid.v1();
    request.query.addAll(<String, dynamic>{
      'requestId': requestId,
    });
    if (jwtToken != null) {
      request.query['jwt'] = jwtToken;
    }
    if (queuable) {
      networkQuery(request);
      pendingRequests[requestId] = request;
      futureMaps[requestId] = completer;
    } else {
      networkQuery(request);
      completer.complete(RawKuzzleResponse.fromMap(
        this,
        RawKuzzleRequest(request.query),
        <String, dynamic>{'result': request.query['body']},
      ));
    }
    return completer.future;
  }

  /// Checks if an administrator account has been created,
  ///
  /// return true if it exists and false if it does not.
  Future<bool> adminExists({bool queuable = true}) => addNetworkQuery(
          RawKuzzleRequest({'controller': 'server', 'action': 'adminExists'}))
      .then((response) => response.result['exists'] as bool);

  void networkQuery(RawKuzzleRequest request) {
    _webSocket.sink.add(json.encode(request.query));
  }

  Authentication get auth => Authentication(this);

  Collection collection(String collection, {String index}) {
    index ??= defaultIndex;
    return Collection(this, collection, index);
  }

  IOWebSocketChannel get webSocket => _webSocket;

  Future<void> connect() async {
    _webSocket = await connectInternal();
    bindSubscription();
  }

  Future<IOWebSocketChannel> connectInternal() async {
    final channel =
        IOWebSocketChannel.connect('ws://$host:${port.toString()}/ws');

    fire(ConnectedEvent());

    return channel;
  }

  void onStreamListen(dynamic message) {
    final jsonResponse = json.decode(message);
    final requestId = jsonResponse['requestId'];
    final request = pendingRequests[requestId];

    if (request == null) {
      // Todo: handle error
      return;
    }

    final response = RawKuzzleResponse.fromMap(this, request, jsonResponse);

    if (roomMaps.containsKey(response.room)) {
      roomMaps[response.room].add(response);

      // pendingRequests.remove(requestId);
      return;
    }

    if (response.action != 'logout' &&
        response.error != null &&
        response.error.message == 'Token expired') {
      unsetJwtToken();
      fire(TokenExpiredEvent(
          request: request, future: futureMaps[requestId].future));
    }

    if (response.error is ResponseError) {
      fire(QueryErrorEvent(
          error: response.error,
          request: request,
          future: futureMaps[requestId].future));
    }

    if (futureMaps.containsKey(requestId) &&
        !futureMaps[requestId].isCompleted) {
      if (response.error == null) {
        futureMaps[requestId].complete(response);
      } else {
        futureMaps[requestId].completeError(response.error);
      }

      futureMaps.remove(requestId);
    }

    pendingRequests.remove(requestId);
  }

  void bindSubscription() {
    _streamSubscription = _webSocket.stream.listen(onStreamListen);

    _streamSubscription.onError((error) {
      fire(NetworkErrorEvent(error));

      futureMaps.forEach((requestId, future) {
        future.completeError(error);
      });
    });
  }

  FutureOr<SharedAcknowledgedResponse> createIndex(
    String index, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(
              RawKuzzleRequest({
                'index': index,
                'controller': 'index',
                'action': 'create',
              }),
              queuable: queuable)
          .then((response) =>
              SharedAcknowledgedResponse.fromMap(response.result));

  Future<AcknowledgedResponse> deleteIndex(String index) async =>
      addNetworkQuery(RawKuzzleRequest({
        'index': index,
        'controller': 'index',
        'action': 'delete',
      })).then((response) => AcknowledgedResponse.fromMap(response.result));

  void disconnect() {
    _streamSubscription.cancel();
    _webSocket.sink.close(status.goingAway);
    roomMaps.forEach((key, roomSubscription) {
      roomSubscription.close();
    });
    roomMaps.removeWhere((key, room) => true);

    fire(DisconnectedEvent());
  }

  Future<bool> existsIndex(
    String index, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(RawKuzzleRequest({
        'index': index,
        'controller': 'index',
        'action': 'exists',
      })).then((response) => response.result as bool);

  // void flushQueue() => throw ResponseError();

  /// Kuzzle monitors its internal activities and makes regular snapshots.
  ///
  /// This command returns all the stored statistics. By default,
  /// snapshots are made every 10 seconds and they are stored for 1 hour.
  Future<ScrollResponse<Statistics>> getAllStatistics(
          {bool queuable = true}) async =>
      addNetworkQuery(
              RawKuzzleRequest({
                'controller': 'server',
                'action': 'getAllStats',
              }),
              queuable: queuable)
          .then((response) => ScrollResponse<Statistics>.fromMap(
              response.result,
              (map) => Statistics.fromMap(map as Map<String, dynamic>)));

  /// Returns the current Kuzzle configuration.
  Future<Map<String, dynamic>> getConfig() => addNetworkQuery(RawKuzzleRequest({
        'controller': 'server',
        'action': 'getConfig',
      })).then((response) => response.result);

  Future<Statistics> getLastStatistics({bool queuable = true}) async =>
      addNetworkQuery(
              RawKuzzleRequest({
                'controller': 'server',
                'action': 'getLastStats',
              }),
              queuable: queuable)
          .then((response) => Statistics.fromMap(response.result));

  /// Returns statistics for snapshots made
  /// after a given timestamp (utc, in milliseconds).
  Future<ScrollResponse<Statistics>> getStatistics(
          DateTime startTime, DateTime endTime, {bool queuable = true}) async =>
      addNetworkQuery(
              RawKuzzleRequest({
                'controller': 'server',
                'action': 'getStats',
                'startTime': startTime.millisecondsSinceEpoch,
                'endTime': endTime.millisecondsSinceEpoch,
              }),
              queuable: queuable)
          .then((response) => ScrollResponse<Statistics>.fromMap(
              response.result,
              (map) => Statistics.fromMap(map as Map<String, dynamic>)));

  Future<bool> getAutoRefresh({String index, bool queuable = true}) async =>
      addNetworkQuery(
              RawKuzzleRequest({
                'index': index,
                'controller': 'index',
                'action': 'getAutoRefresh',
              }),
              queuable: queuable)
          .then((response) => response.result);

  String getJwtToken() => jwtToken;

  Future<ServerInfo> getServerInfo({bool queuable = true}) => addNetworkQuery(
          RawKuzzleRequest({
            'controller': 'server',
            'action': 'info',
          }),
          queuable: queuable)
      .then((response) => ServerInfo.fromMap(response.result));

  Future<List<String>> listIndexes({bool queuable = true}) async =>
      await addNetworkQuery(
              RawKuzzleRequest({
                'controller': 'index',
                'action': 'list',
              }),
              queuable: queuable)
          .then((response) => (response.result['indexes'] as List<dynamic>)
              .map((index) => index as String)
              .toList());

  Future<User> register(
    User user,
    Credentials credentials, {
    String expiresIn,
  }) =>
      security.createUser(user, credentials);

  MemoryStorage get memoryStorage => MemoryStorage(this);

  Future<int> now({bool queuable = true}) async => addNetworkQuery(
          RawKuzzleRequest({
            'controller': 'server',
            'action': 'now',
          }),
          queuable: queuable)
      .then((response) => response.result['now']);

  // void query({bool queuable = true}) => throw ResponseError();

  Future<Shards> refreshIndex(String index, {bool queuable = true}) =>
      addNetworkQuery(
              RawKuzzleRequest({
                'index': index,
                'controller': 'index',
                'action': 'refresh',
              }),
              queuable: queuable)
          .then((response) => Shards.fromMap(response.result['_shards']));

  // void removeAllListeners({Event event}) => throw ResponseError();

  // void removeListener(Event event, EventListener eventListener) =>
  //     throw ResponseError();

  // void replayQueue() => throw ResponseError();

  Future<SearchResponse<User>> searchUsers(Map<String, dynamic> body,
          {bool queuable = true}) =>
      addNetworkQuery(
              RawKuzzleRequest({
                'controller': Security.controller,
                'action': 'searchUsers',
                'body': body,
                'from': 0,
                'size': 10,
              }),
              queuable: queuable)
          .then((response) => SearchResponse<User>.fromMap(response.result,
              (map) => User.fromMap(security, map as Map<dynamic, dynamic>)));

  Future<bool> setAutoRefresh({
    @required bool autoRefresh,
    String index,
    bool queuable = true,
  }) async =>
      addNetworkQuery(
              RawKuzzleRequest({
                'index': index,
                'controller': 'index',
                'action': 'setAutoRefresh',
                'body': <String, dynamic>{
                  'autoRefresh': autoRefresh,
                }
              }),
              queuable: queuable)
          .then((response) => response.result['response']);

  void unsetJwtToken() {
    jwtToken = null;
  }

  Future<User> whoAmI() async => auth.getCurrentUser();
}
