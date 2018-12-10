import 'dart:async';
import 'package:pedantic/pedantic.dart';

import 'collection.dart';
import 'helpers.dart';
import 'response.dart';

enum RoomScope { inside, out, all, none }
enum RoomUsersScope { inside, out, all, none }

enum RoomState { pending, done, all }

class Room extends KuzzleObject {
  Room(
    Collection collection, {
    this.id,
    this.channel,
    this.subscribeToSelf,
    this.scope,
    this.state,
    this.users,
    this.volatile,
  }) : super(collection);

  String id;
  String channel;
  final bool subscribeToSelf;
  final RoomScope scope;
  final RoomState state;
  final RoomUsersScope users;
  final Map<String, dynamic> volatile;
  static const String controller = 'realtime';

  @override
  String getController() => controller;

  StreamSubscription<RawKuzzleResponse> subscription;

  Map<String, dynamic> filters;
  String roomId;

  Future<int> count() => addNetworkQuery(
        'count',
        body: <String, dynamic>{
          'roomId': id,
        },
        optionalParams: <String, dynamic>{
          'volatile': volatile,
        },
      ).then((response) => response.result['count'] as int);

  Future<Room> renew(
    NotificationCallback notificationCallback, {
    Map<String, dynamic> query = emptyMap,
  }) async {
    unawaited(unsubscribe());
    final room = await collection.subscribe(
      notificationCallback,
      query: emptyMap,
      volatile: volatile,
      subscribeToSelf: subscribeToSelf,
      scope: scope,
      state: state,
      users: users,
    );
    id = room.id;
    channel = room.channel;
    subscription = room.subscription;
    return this;
  }

  Future<String> unsubscribe() async {
    unawaited(subscription.cancel());
    unawaited(collection.kuzzle.roomMaps[channel].close());
    collection.kuzzle.roomMaps.remove(channel);
    return await addNetworkQuery(
      'unsubscribe',
      body: <String, dynamic>{
        'roomId': id,
      },
      optionalParams: <String, dynamic>{
        'volatile': volatile,
      },
      queuable: false,
    ).then((response) => response.result['roomId']);
  }
}
