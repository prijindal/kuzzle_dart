import 'package:kuzzle/src/protocols/events.dart';

import '../kuzzle.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';

typedef RoomListener = void Function(KuzzleResponse);

class KuzzleRoom {
  KuzzleRoom(
      this.kuzzle, this.index, this.collection, this.filters, this.callback,
      {this.state,
      this.scope,
      this.users,
      this.volatile,
      this.autoResubscribe,
      this.subscribeToSelf}) {
    autoResubscribe ??= kuzzle.autoResubscribe;
    subscribeToSelf ??= true;

    _request = KuzzleRequest(
      action: 'subscribe',
      controller: 'realtime',
      index: index,
      collection: collection,
      body: filters,
      state: state,
      scope: scope,
      users: users,
      volatile: volatile,
    );
  }

  Kuzzle kuzzle;

  String id;
  String channel;
  String index;
  String collection;
  RoomListener callback;
  Map<String, dynamic> filters;
  Map<String, dynamic> options;

  KuzzleRequest _request;
  bool autoResubscribe;
  bool subscribeToSelf;

  String state;
  String scope;
  String users;
  Map<String, dynamic> volatile;

  Future<KuzzleResponse> subscribe() =>
      kuzzle.query(_request, volatile: volatile).then((response) {
        id = response.result['roomId'] as String;
        channel = response.result['channel'] as String;

        kuzzle.protocol.on(channel, _channelListener);
        kuzzle.on(ProtocolEvents.RECONNECTED, _reSubscribeListener);

        return response;
      });

  void removeListeners() {
    kuzzle.off(ProtocolEvents.RECONNECTED, _reSubscribeListener);

    if (channel != null) {
      kuzzle.protocol.off(channel, _channelListener);
    }
  }

  void _channelListener([KuzzleResponse response]) {
    var fromSelf = false;
    if (response.volatile != null && response.volatile.isNotEmpty) {
      if (response.volatile.containsKey('sdkInstanceId') &&
          response.volatile['sdkInstanceId'] == kuzzle.protocol.id) {
        fromSelf = true;
      }
    }

    if (subscribeToSelf == true || !fromSelf) {
      callback(response);
    }
  }

  Future<void> _reSubscribeListener() async {
    if (autoResubscribe) {
      await subscribe();
    }
  }
}
