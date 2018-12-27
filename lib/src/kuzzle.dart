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

  final bool valid;
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
  
  String get jwtToken {
    return _jwtToken;
  }

  void set jwtToken(String _newJwtToken) {
    _jwtToken = _newJwtToken;
  }
  
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

  /// Checks if an administrator account has been created,
  ///
  /// return true if it exists and false if it does not.
  Future<bool> adminExists({bool queuable = true}) => addNetworkQuery(
          <String, dynamic>{'controller': 'server', 'action': 'adminExists'})
      .then((response) => response.result['exists'] as bool);

  void networkQuery(Map<String, dynamic> body) {
    _webSocket.sink.add(json.encode(body));
  }

  Future<CheckTokenResponse> checkToken(String token) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'checkToken',
        'controller': 'auth',
        'body': {
          'token': token,
        },
      }).then((response) => CheckTokenResponse.fromMap(response.result));

  Future<bool> credentialsExist(LoginStrategy strategy) async =>
      addNetworkQuery(<String, dynamic>{
        'action': 'credentialsExist',
        'controller': 'auth',
        'strategy': enumToString<LoginStrategy>(strategy),
      }).then((response) => response.result as bool);

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

  Future<CredentialsResponse> createMyCredentials(Credentials credentials,
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

  Future<AcknowledgedResponse> deleteMyCredentials(LoginStrategy strategy,
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'deleteMyCredentials',
        'strategy': enumToString<LoginStrategy>(strategy),
        'jwt': _jwtToken,
      }, queuable: queuable)
          .then((response) => AcknowledgedResponse.fromMap(response.result));

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

  /// Kuzzle monitors its internal activities and makes regular snapshots.
  ///
  /// This command returns all the stored statistics. By default,
  /// snapshots are made every 10 seconds and they are stored for 1 hour.
  Future<ScrollResponse<Statistics>> getAllStatistics(
          {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'getAllStats',
      }, queuable: queuable)
          .then((response) => ScrollResponse<Statistics>.fromMap(
              response.result,
              (map) => Statistics.fromMap(map as Map<String, dynamic>)));

  /// Returns the current Kuzzle configuration.
  Future<Map<String, dynamic>> getConfig() => addNetworkQuery({
        'controller': 'server',
        'action': 'getConfig',
      }).then((response) => response.result);

  Future<Statistics> getLastStatistics({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'getLastStats',
      }, queuable: queuable)
          .then((response) => Statistics.fromMap(response.result));

  /// Returns statistics for snapshots made
  /// after a given timestamp (utc, in milliseconds).
  Future<ScrollResponse<Statistics>> getStatistics(
          DateTime startTime, DateTime endTime, {bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'getStats',
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      }, queuable: queuable)
          .then((response) => ScrollResponse<Statistics>.fromMap(
              response.result,
              (map) => Statistics.fromMap(map as Map<String, dynamic>)));

  Future<bool> getAutoRefresh({String index, bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'index': index,
        'controller': 'index',
        'action': 'getAutoRefresh',
      }, queuable: queuable)
          .then((response) => response.result);

  Future<User> getCurrentUser({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getCurrentUser',
      }, queuable: queuable)
          .then((response) => User.fromMap(security, response.result));

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

  Future<List<Rights>> getMyRights({bool queuable = true}) async =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getMyRights',
        'jwt': _jwtToken,
      }, queuable: queuable)
          .then((response) => (response.result['hits'] as List<dynamic>)
              .map<Rights>((stats) => Rights.fromMap(stats))
              .toList());

  Future<ServerInfo> getServerInfo({bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'server',
        'action': 'info',
      }, queuable: queuable)
          .then((response) => ServerInfo.fromMap(response.result));

  /// Get all authentication strategies registered in Kuzzle
  Future<List<String>> getStrategies({bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'controller': 'auth',
        'action': 'getStrategies',
      }, queuable: queuable)
          .then((response) => (response.result as List<dynamic>)
              .map<String>((res) => res as String)
              .toList());

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

  Future<SearchResponse<User>> searchUsers(Map<String, dynamic> body,
          {bool queuable = true}) =>
      addNetworkQuery(<String, dynamic>{
        'controller': Security.controller,
        'action': 'searchUsers',
        'body': body,
        'from': 0,
        'size': 10,
      }, queuable: queuable)
          .then((response) => SearchResponse<User>.fromMap(response.result,
              (map) => User.fromMap(security, map as Map<dynamic, dynamic>)));

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
