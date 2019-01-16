import 'dart:async';

import '../kuzzle.dart';
import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';
import '../kuzzle/room.dart';

import 'abstract.dart';

class RealTimeController extends KuzzleController {
  RealTimeController(Kuzzle kuzzle) : super(kuzzle, name: 'realtime');

  final Map<String, List<Room>> _subscriptions = {};

  /// Returns the number of other connections sharing the same subscription.
  Future<int> count(String roomId) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'refresh',
      body: <String, dynamic>{
        'roomId': roomId,
      },
    ));

    return response.result['count'] as int;
  }

  /// Sends a real-time message to Kuzzle.
  ///
  /// The message will be dispatched to all clients with
  /// subscriptions matching the index, the collection and the message content.
  ///
  /// A _kuzzle_info object will be added to the message content,
  /// with the following properties:
  ///  - author: sender kuid
  ///  (or -1 if the message is sent by an anonymous connection)
  ///  - createdAt: message timestamp, using the Epoch-millis format
  Future<bool> publish(
      String index, String collection, Map<String, dynamic> message) async {
    final response = await kuzzle.query(KuzzleRequest(
      controller: name,
      action: 'publish',
      index: index,
      collection: collection,
      body: message,
    ));

    return response.result['published'] as bool;
  }

  /// Subscribes by providing a set of filters: messages, document changes and,
  /// optionally, user events matching the provided filters will
  /// generate real-time notifications, sent to you in real-time by Kuzzle.
  Future<String> subscribe(String index, String collection,
      Map<String, dynamic> filters, RoomListener callback,
      {String scope,
      String state,
      String users,
      Map<String, dynamic> volatile,
      bool subscribeToSelf,
      bool autoResubscribe}) async {
    final room = Room(kuzzle, index, collection, filters, callback,
        volatile: volatile,
        users: users,
        scope: scope,
        state: state,
        subscribeToSelf: subscribeToSelf,
        autoResubscribe: autoResubscribe);

    return room.subscribe().then((response) {
      if (!_subscriptions.containsKey(room.id)) {
        _subscriptions[room.id] = <Room>[];
      }

      _subscriptions[room.id].add(room);

      return room.id;
    });
  }

  /// Removes a subscription.
  Future<Map<String, dynamic>> unsubscribe(String roomId) async {
    if (!_subscriptions.containsKey(roomId)) {
      return Future.error(
          KuzzleError('$name.unsubscribe; not subscribed to $roomId'));
    }

    for (final room in _subscriptions[roomId]) {
      room.removeListeners();
    }

    _subscriptions[roomId].clear();
    _subscriptions.remove(roomId);

    final response = await kuzzle.query(KuzzleRequest(
        controller: name,
        action: 'unsubscribe',
        body: <String, dynamic>{'roomId': roomId}));

    return response.result;
  }
}
