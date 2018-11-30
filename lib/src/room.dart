import 'dart:async';
import 'collection.dart';
import 'error.dart';
import 'response.dart';

enum RoomScope { inside, out, all, none }
enum RoomUsersScope { inside, out, all, none }

enum RoomState { pending, done, all }

class Room {
  Room(
    this.collection, {
    this.id,
    this.channel,
    this.subscribeToSelf,
    this.scope,
    this.state,
    this.users,
    this.volatile,
  });

  final Collection collection;
  final String id;
  final String channel;
  final bool subscribeToSelf;
  final RoomScope scope;
  final RoomState state;
  final RoomUsersScope users;
  final Map<String, dynamic> volatile;

  StreamSubscription<RawKuzzleResponse> subscription;

  Map<String, dynamic> filters;
  Map<String, dynamic> get headers => collection.headers;
  String roomId;

  Future<int> count() => throw ResponseError();

  void renew() => throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  Future<String> unsubscribe() async {
    subscription.cancel();
    collection.kuzzle.roomMaps[channel].close();
    collection.kuzzle.roomMaps.remove(channel);
    return await collection.kuzzle.addNetworkQuery(<String, dynamic>{
      'index': collection.index,
      'collection': collection.collection,
      'controller': 'realtime',
      'action': 'unsubscribe',
      'volatile': volatile,
      'body': <String, dynamic>{
        'roomId': id,
      }
    }, queuable: false).then(
        (RawKuzzleResponse response) => response.result['roomId']);
  }
}
