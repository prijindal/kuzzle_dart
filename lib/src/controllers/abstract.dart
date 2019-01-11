import 'package:meta/meta.dart';

import '../kuzzle.dart';

abstract class KuzzleController {
  KuzzleController(this.kuzzle, {
    this.name,
    this.accessor,
  });

  final String name;
  final String accessor;

  @protected
  final Kuzzle kuzzle;
}


