import 'package:meta/meta.dart';

import '../kuzzle.dart';

abstract class KuzzleController {
  KuzzleController(
    this.kuzzle, {
    this.name,
  });

  final String name;
  String accessor;

  @protected
  final Kuzzle kuzzle;
}
