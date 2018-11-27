import 'collection.dart';
import 'error.dart';
import 'response.dart';
import 'room.dart';
import 'subscription.dart';

class Document extends Object {
  Document(
    this.collection, {
    this.id,
    this.content,
  });

  final Collection collection;
  final String id;
  final Map<String, dynamic> content;

  Map<String, dynamic> get headers => collection.headers;
  Map<String, dynamic> get meta => <String, dynamic>{};
  int get version => 0;

  Future<String> delete({
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  Future<bool> exists({
    Map<String, dynamic> volatile,
    bool queuable = true,
  }) async =>
      throw ResponseError();

  Future<void> publish({
    Map<String, dynamic> volatile,
    bool queuable = true,
  }) async =>
      throw ResponseError();

  Future<Document> refresh({
    bool queuable = true,
  }) async =>
      throw ResponseError();

  Future<Document> save({
    Map<String, dynamic> volatile,
    bool queuable = true,
    String refresh,
  }) async =>
      throw ResponseError();

  Future<void> setContent(
    Map<String, dynamic> content, {
    bool replace = false,
  }) async =>
      throw ResponseError();

  void setHeaders(Map<String, dynamic> newheaders, {bool replace = false}) =>
      throw ResponseError();

  Subscription subscribe(
    void Function(NotificationResponse response) notificationCallback, {
    final Map<String, dynamic> volatile,
    bool subscribeToSelf,
    RoomScope scope,
    RoomState state,
    RoomUsersScope users,
  }) =>
      Subscription(
        Room(
          collection,
          volatile: volatile,
          subscribeToSelf: subscribeToSelf,
          scope: scope,
          state: state,
          users: users,
        ),
      );

  @override
  String toString() {
    return content.toString();
  }
}
