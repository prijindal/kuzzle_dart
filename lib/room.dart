import 'collection.dart';
import 'error.dart';

enum RoomScope { inside, out, all, none }
enum RoomUsersScope { inside, out, all, none }

enum RoomState { pending, done, all }

class Room {
  Room(
    this.collection, {
    this.volatile,
    this.subscribeToSelf,
    RoomScope scope,
    RoomState state,
    RoomUsersScope users,
  });

  final Collection collection;
  final Map<String, dynamic> volatile;
  final bool subscribeToSelf;

  Map<String, dynamic> filters;
  Map<String, dynamic> get headers => collection.headers;
  String roomId;

  Future<int> count() => throw ResponseError();

  // TODO
  void renew() => throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  void unsubscribe() => throw ResponseError();
}
