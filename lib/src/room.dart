import 'collection.dart';
import 'error.dart';

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
  });

  final Collection collection;
  final String id;
  final String channel;
  final bool subscribeToSelf;
  final RoomScope scope;
  final RoomState state;
  final RoomUsersScope users;

  Map<String, dynamic> filters;
  Map<String, dynamic> get headers => collection.headers;
  String roomId;

  Future<int> count() => throw ResponseError();

  void renew() => throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  void unsubscribe() => throw ResponseError();
}
