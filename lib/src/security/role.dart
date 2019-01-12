import '../kuzzle.dart';

class Role {
  Role(
    this.kuzzle, {
    this.uid,
    this.controllers,
  });

  final Kuzzle kuzzle;
  String uid;
  Map<String, dynamic> controllers;
}
