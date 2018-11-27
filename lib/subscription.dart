import 'room.dart';

class Subscription {
  Subscription(this.room);

  final Room room;

  void onDone(void Function(Room room) callback) {
    callback(room);
  }
}
