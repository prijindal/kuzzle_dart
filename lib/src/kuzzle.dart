import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'collection.dart';
import 'credentials.dart';
import 'error.dart';
import 'helpers.dart';
import 'memorystorage.dart';
import 'response.dart';
import 'rights.dart';
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

  final int valid;
  final String state;
  final int expiresAt;
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
  Map<String, Completer<RawKuzzleResponse>> futureMaps =
      <String, Completer<RawKuzzleResponse>>{};
  Map<String, StreamController<RawKuzzleResponse>> roomMaps =
      <String, StreamController<RawKuzzleResponse>>{};
  IOWebSocketChannel _webSocket;
  StreamSubscription<dynamic> _streamSubscription;
  Uuid uuid = Uuid();

  Map<String, dynamic> headers;

  String _jwtToken;
  // int offlineQueue;
  // void Function() offlineQueueLoader;
  // void Function() queueFilter;

  Future<RawKuzzleResponse> addNetworkQuery(
    Map<String, dynamic> body, {
    bool queuable = true,
  }) {
    final completer = Completer<RawKuzzleResponse>();
    final String requestId = uuid.v1();
    body.addAll(<String, dynamic>{
      'requestId': requestId,
    });
    if (_jwtToken != null) {
      body['jwt'] = _jwtToken;
    }
    if (queuable) {
      networkQuery(body);
      futureMaps[requestId] = completer;
    } else {
      networkQuery(body);
      completer.complete(RawKuzzleResponse.fromMap(
        this,
        <String, dynamic>{'result': body['body']},
      ));
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
      }).then((response) => CheckTokenResponse.fromMap(response.result));

  Collection collection(String collection, {String index}) {
    index ??= defaultIndex;
    return Collection(this, collection, index);
  }

  Future<void> connect() async {
    _webSocket = await connectInternal();
    bindSubscription();
  }

  Future<IOWebSocketChannel> connectInternal() async =>
      IOWebSocketChannel.connect('ws://$host:${port.toString()}/ws');

  void bindSubscription() {
    _streamSubscription = _webSocket.stream.listen((message) {
      final jsonResponse = json.decode(message);
      final String requestId = jsonResponse['requestId'];
      final response = RawKuzzleResponse.fromMap(this, jsonResponse);
      // print(response.result);
      if (roomMaps.containsKey(response.room)) {
        roomMaps[response.room].add(response);
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

  FutureOr<SharedAcknowledgedResponse> createIndex(
    String index, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'create',
      }, queuable: queuable)
          .then((response) =>
              SharedAcknowledgedResponse.fromMap(response.result));

  Future<CredentialsResponse> createMyCredentials(
          LoginStrategy strategy, Credentials credentials,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'createMyCredentials',
        'strategy': enumToString<LoginStrategy>(credentials.strategy),
        'jwt': _jwtToken,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      }, queuable: queuable)
          .then((response) => CredentialsResponse.fromMap(response.result));

  Future<bool> deleteMyCredentials(LoginStrategy strategy,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'deleteMyCredentials',
        'strategy': enumToString<LoginStrategy>(strategy),
        'jwt': _jwtToken,
      }, queuable: queuable)
          .then((response) => response.result['acknowledged']);

  Future<AcknowledgedResponse> deleteIndex(String index) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'delete',
      }).then((response) => AcknowledgedResponse.fromMap(response.result));

  void disconect() {
    _streamSubscription.cancel();
    _webSocket.sink.close(status.goingAway);
  }

  Future<bool> existsIndex(
    String index, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'exists',
      }).then((response) => response.result as bool);

  // void flushQueue() => throw ResponseError();

  Future<List<Statistics>> getAllStatistics({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'getAllStats',
      }, queuable: queuable)
          .then((response) => response.result['hits']
              .map((stats) => Statistics.fromMap(stats)));

  Future<bool> getAutoRefresh({String index, bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'getAutoRefresh',
      }, queuable: queuable)
          .then((response) => response.result);

  String getJwtToken() => _jwtToken;

  Future<CredentialsResponse> getMyCredentials(LoginStrategy strategy,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getMyCredentials',
        'strategy': enumToString<LoginStrategy>(strategy),
        'jwt': _jwtToken,
      }, queuable: queuable)
          .then((response) => CredentialsResponse.fromMap(response.result));

  Future<Rights> getMyRights({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getMyRights',
        'jwt': _jwtToken,
      }, queuable: queuable)
          .then((response) =>
              response.result['hits'].map((stats) => Rights.fromMap(stats)));

  Future<ServerInfo> getServerInfo({bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'info',
      }, queuable: queuable)
          .then((response) => ServerInfo.fromMap(response.result));

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
          .then((response) => response.result['hits']
              .map((stats) => Statistics.fromMap(stats)));

  Future<List<ListCollectionResponse>> listCollections(
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
          .then((response) => (response.result['collections'] as List<dynamic>)
              .map((map) => ListCollectionResponse.fromMap(map))
              .toList());

  Future<List<String>> listIndexes({bool queuable = true}) async =>
      await addNetworkQuery(<String, dynamic>{
        'controller': 'index',
        'action': 'list',
      }, queuable: queuable)
          .then((response) => (response.result['indexes'] as List<dynamic>)
              .map((index) => index as String)
              .toList());

  Future<AuthResponse> login(
    Credentials credentials, {
    String expiresIn,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'login',
        'strategy': enumToString<LoginStrategy>(credentials.strategy),
        'expiresIn': expiresIn,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      })
          .then((response) => AuthResponse.fromMap(response.result))
          .then((response) {
        if (response.id == '-1') {
          throw ResponseError(
              message: 'wrong username or password', status: 401);
        } else {
          _jwtToken = response.jwt;
        }
        return response;
      });

  Future<User> register(
    User user,
    Credentials credentials, {
    String expiresIn,
  }) =>
      security.createUser(user, credentials);

  Future<void> logout() async => addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'logout',
        'jwt': _jwtToken,
      }).then((response) {
        _jwtToken = null;
      });

  MemoryStorage get memoryStorage => MemoryStorage(this);

  Future<int> now({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'now',
      }, queuable: queuable)
          .then((response) => response.result['now']);

  // void query({bool queuable = true}) => throw ResponseError();

  Future<Shards> refreshIndex(String index, {bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'refresh',
      }, queuable: queuable)
          .then((response) => Shards.fromMap(response.result['_shards']));

  // void removeAllListeners({Event event}) => throw ResponseError();

  // void removeListener(Event event, EventListener eventListener) =>
  //     throw ResponseError();

  // void replayQueue() => throw ResponseError();

  Future<bool> setAutoRefresh({
    @required bool autoRefresh,
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
          .then((response) => response.result['response']);

  // void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
  //     headers = newheaders;

  // void startQueuing() => throw ResponseError();

  // void stopQueuing() => throw ResponseError();

  void unsetJwtToken() {
    _jwtToken = null;
  }

  Future<CredentialsResponse> updateMyCredentials(
    Credentials credentials, {
    bool queuable = true,
  }) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'updateMyCredentials',
        'strategy': enumToString<LoginStrategy>(credentials.strategy),
        'jwt': _jwtToken,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      }, queuable: queuable)
          .then((response) => CredentialsResponse.fromMap(response.result));

  Future<User> updateSelf(Map<String, dynamic> content,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'updateSelf',
        'jwt': _jwtToken,
        'body': content,
      }, queuable: queuable)
          .then((response) => User.fromMap(security, response.result));

  Future<bool> validateMyCredentials(
    LoginStrategy strategy,
    Credentials credentials, {
    bool queuable = true,
  }) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'validateMyCredentials',
        'strategy': enumToString<LoginStrategy>(strategy),
        'jwt': _jwtToken,
        'body': <String, dynamic>{
          'username': credentials.username,
          'password': credentials.password,
        }
      }, queuable: queuable)
          .then((response) => response.result);

  Future<User> whoAmI() async => addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getCurrentUser',
        'jwt': _jwtToken,
      }).then((response) => User.fromMap(security, response.result));
}
