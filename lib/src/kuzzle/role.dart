import '../kuzzle.dart';
import '../kuzzle/response.dart';

class Role {
  Role(
    this.kuzzle, {
    this.uid,
    this.controllers,
  });

  Role.fromKuzzleResponse(this.kuzzle, KuzzleResponse response) {
    uid = response.result['_id'] as String;
    controllers =
        response.result['_source']['controllers'] as Map<String, dynamic>;
  }

  final Kuzzle kuzzle;
  String uid;
  Map<String, dynamic> controllers;
}
