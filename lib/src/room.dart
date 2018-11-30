import 'dart:async';
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

  StreamSubscription<RawKuzzleResponse> subscription;

  Map<String, dynamic> filters;
  String roomId;

  Future<int> count() => addNetworkQuery(<String, dynamic>{
        'action': 'count',
        'volatile': volatile,
        'body': <String, dynamic>{
          'roomId': id,
        }
      }).then((RawKuzzleResponse response) => response.result['count'] as int);

  Future<Room> renew(
    NotificationCallback notificationCallback, {
    Map<String, dynamic> query = emptyMap,
  }) async {
    unsubscribe();
    final Room room = await collection.subscribe(
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
    subscription.cancel();
    collection.kuzzle.roomMaps[channel].close();
    collection.kuzzle.roomMaps.remove(channel);
    return await addNetworkQuery(<String, dynamic>{
      'action': 'unsubscribe',
      'volatile': volatile,
      'body': <String, dynamic>{
        'roomId': id,
      }
    }, queuable: false)
        .then((RawKuzzleResponse response) => response.result['roomId']);
  }
}
