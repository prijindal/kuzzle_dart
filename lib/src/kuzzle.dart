import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'collection.dart';
import 'credentials.dart';
import 'error.dart';
import 'memorystorage.dart';
import 'response.dart';
import 'rights.dart';
import 'security.dart';
import 'serverinfo.dart';
import 'statistics.dart';
import 'user.dart';

enum KuzzleConnectType { auto }
enum KuzzleOfflineModeType { auto, manual }

typedef NotificationCallback = void Function(RawKuzzleResponse response);

class CheckTokenResponse {
  CheckTokenResponse.fromMap(Map<String, dynamic> map)
      : valid = map['valid'],
        state = map['state'],
        expiresAt = map['expiresAt'];

  final int valid;
  final String state;
  final int expiresAt;
}

class IndexCreationResponse {
  IndexCreationResponse.fromMap(Map<String, dynamic> map)
      : acknowledged = map['acknowledged'],
        shardsAcknowledged = map['shards_acknowledged'];

  final bool acknowledged;
  final bool shardsAcknowledged;
}

class Kuzzle {
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
    connect();
  }

  final String host;
  final bool autoQueue;
  final bool autoReconnect;
  final bool autoReplay;
  final bool autoResubscribe;
  final KuzzleConnectType connectType;
  String defaultIndex;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> volatile;
  final KuzzleConnectType offlineMode;
  final int port;
  final int queueTTL;
  final int queueMaxSize;
  final int replayInterval;
  final int reconnectionDelay;
  final bool sslConnection;
  Security security;
  Map<String, Completer<RawKuzzleResponse>> futureMaps =
      <String, Completer<RawKuzzleResponse>>{};
  Map<String, NotificationCallback> roomMaps = <String, NotificationCallback>{};
  IOWebSocketChannel _webSocket;
  StreamSubscription<dynamic> _streamSubscription;
  Uuid uuid = Uuid();

  String jwtToken;
  // int offlineQueue;
  // void Function() offlineQueueLoader;
  // void Function() queueFilter;

  Future<RawKuzzleResponse> addNetworkQuery(
    Map<String, dynamic> body, {
    bool queuable = true,
  }) {
    final Completer<RawKuzzleResponse> completer =
        Completer<RawKuzzleResponse>();
    final String requestId = uuid.v1();
    body.addAll(<String, dynamic>{
      'requestId': requestId,
    });
    if (queuable) {
      networkQuery(body);
      futureMaps[requestId] = completer;
    } else {
      networkQuery(body);
      completer.complete(
          RawKuzzleResponse.fromMap(this, <String, dynamic>{'result': body}));
    }
    return completer.future;
  }

  void networkQuery(Map<String, dynamic> body) {
    _webSocket.sink.add(json.encode(body));
  }

  Future<CheckTokenResponse> checkToken(String token) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'token': token,
      }).then((RawKuzzleResponse response) =>
          CheckTokenResponse.fromMap(response.result));

  Collection collection(String collection, {String index}) {
    index ??= defaultIndex;
    return Collection(this, collection, index);
  }

  void connect() {
    _webSocket = IOWebSocketChannel.connect(
        'ws://' + host + ':' + port.toString() + '/ws');

    _streamSubscription = _webSocket.stream.listen((dynamic message) {
      final dynamic jsonResponse = json.decode(message);
      final String requestId = jsonResponse['requestId'];
      final RawKuzzleResponse response =
          RawKuzzleResponse.fromMap(this, jsonResponse);
      if (roomMaps.containsKey(response.room)) {
        roomMaps[response.room](response);
      } else if (futureMaps.containsKey(requestId) &&
          !futureMaps[requestId].isCompleted) {
        if (response.error == null) {
          futureMaps[requestId].complete(response);
        } else {
          futureMaps[requestId].completeError(response.error);
        }
        futureMaps.remove(requestId);
      }
    });
  }

  FutureOr<IndexCreationResponse> createIndex(
    String index, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'create',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) =>
              IndexCreationResponse.fromMap(response.result));

  Future<Credentials> createMyCredentials(
          String strategy, Credentials credentials,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'createMyCredentials',
        'strategy': strategy,
        'jwt': jwtToken,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      }, queuable: queuable)
          .then((RawKuzzleResponse response) =>
              Credentials.fromMap(response.result));

  Future<bool> deleteMyCredentials(String strategy,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'deleteMyCredentials',
        'strategy': strategy,
        'jwt': jwtToken,
      }, queuable: queuable)
          .then(
              (RawKuzzleResponse response) => response.result['acknowledged']);

  void disconect() => _streamSubscription.cancel();

  // void flushQueue() => throw ResponseError();

  Future<List<Statistics>> getAllStatistics({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'getAllStats',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['hits']
              .map((Map<String, dynamic> stats) => Statistics.fromMap(stats)));

  Future<bool> getAutoRefresh({String index, bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'getAutoRefresh',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result);

  String getJwtToken() => jwtToken;

  Future<Credentials> getMyCredentials(String strategy,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getMyCredentials',
        'strategy': strategy,
        'jwt': jwtToken,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) =>
              Credentials.fromMap(response.result));

  Future<Rights> getMyRights({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getMyRights',
        'jwt': jwtToken,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['hits']
              .map((Map<String, dynamic> stats) => Rights.fromMap(stats)));

  Future<ServerInfo> getServerInfo({bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'info',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) =>
              ServerInfo.fromMap(response.result));

  Future<List<Statistics>> getStatistics(
    String startTime,
    String endTime, {
    bool queuable = true,
  }) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'getStats',
        'startTime': startTime,
        'endTime': endTime,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['hits']
              .map((Map<String, dynamic> stats) => Statistics.fromMap(stats)));

  Future<List<Map<String, String>>> listCollections(
    String index, {
    bool queuable = true,
    int from,
    int size,
    String type = 'all',
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'collection',
        'action': 'list',
        'type': type,
        'from': from,
        'size': size,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['collections']);

  Future<List<String>> listIndexes({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'index',
        'action': 'list',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['indexes']);

  Future<RawKuzzleResponse> login(
    String strategy, {
    Credentials credentials,
    String expiresIn,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'createMyCredentials',
        'strategy': strategy,
        'expiresIn': expiresIn,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      });

  Future<void> logout() async => addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'createMyCredentials',
        'jwt': jwtToken,
      });

  MemoryStorage get memoryStorage => MemoryStorage(this);

  Future<int> now({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'now',
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result['now']);

  // void query({bool queuable = true}) => throw ResponseError();

  Future<RawKuzzleResponse> refreshIndex(String index,
          {bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'refresh',
      }, queuable: queuable);

  // void removeAllListeners({Event event}) => throw ResponseError();

  // void removeListener(Event event, EventListener eventListener) =>
  //     throw ResponseError();

  // void replayQueue() => throw ResponseError();

  Future<bool> setAutoRefresh(
    bool autoRefresh, {
    String index,
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'setAutoRefresh',
        'body': <String, dynamic>{
          'autoRefresh': autoRefresh,
        }
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result);

  void setDefaultIndex(String index) => defaultIndex = index;

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  void setJwtToken(String jwtToken) => this.jwtToken = jwtToken;

  // void startQueuing() => throw ResponseError();

  // void stopQueuing() => throw ResponseError();

  void unsetJwtToken() => jwtToken = null;

  Future<Credentials> updateMyCredentials(
    String strategy,
    Credentials credentials, {
    bool queuable = true,
  }) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'updateMyCredentials',
        'strategy': strategy,
        'jwt': jwtToken,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      }, queuable: queuable)
          .then((RawKuzzleResponse response) =>
              Credentials.fromMap(response.result));

  Future<User> updateSelf(Map<String, dynamic> content,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'updateSelf',
        'jwt': jwtToken,
        'body': content,
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => User.fromMap(response.result));

  Future<bool> validateMyCredentials(
    String strategy,
    Credentials credentials, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'validateMyCredentials',
        'strategy': strategy,
        'jwt': jwtToken,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      }, queuable: queuable)
          .then((RawKuzzleResponse response) => response.result);

  Future<User> whoAmI() async => addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getCurrentUser',
        'jwt': jwtToken,
      }).then((RawKuzzleResponse response) => User.fromMap(response.result));
}
