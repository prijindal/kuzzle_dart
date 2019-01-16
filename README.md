# Kuzzle SDK for dart

[![Build Status](https://travis-ci.org/prijindal/kuzzle_dart.svg?branch=master)](https://travis-ci.org/prijindal/kuzzle_dart)
[![codecov](https://codecov.io/gh/prijindal/kuzzle_dart/branch/master/graph/badge.svg)](https://codecov.io/gh/prijindal/kuzzle_dart)

The kuzzle_dart package provides SDK for [kuzzle](https://docs.kuzzle.io).
It uses WebSocket to do the same.

## Getting Started

Include this in your pubspec.yaml

```yaml
dependencies:
  kuzzle:
    branch: dev
    git: git://github.com/prijindal/kuzzle_dart.git

```
Right now i would recommend that this be used directly from the git or a tar package.
In the future versioning of pub will be used

## Example

```dart
import 'package:kuzzle/kuzzle_dart.dart';

final kuzzle = Kuzzle(
  WebSocketProtocol('127.0.0.1.xip.io'),
  offlineMode: OfflineMode.auto,
);

void main () async {
  // note that we don't need to await connection to be effective
  kuzzle.connect(); 
  
  final result = await kuzzle.server.info();
  print('[result][server][info] $result');
}
```

> view all samples in [example/example.dart file](./example/example.dart)

## Information
- Uses WebSocket to communicate with kuzzle, in the future http might also be used
- Soon documentation will also be coming
