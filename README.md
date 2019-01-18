# Kuzzle SDK for dart

[![Build Status](https://travis-ci.org/prijindal/kuzzle_dart.svg?branch=master)](https://travis-ci.org/prijindal/kuzzle_dart)
[![codecov](https://codecov.io/gh/prijindal/kuzzle_dart/branch/master/graph/badge.svg)](https://codecov.io/gh/prijindal/kuzzle_dart)

The kuzzle package provides SDK for [kuzzle](https://kuzzle.io).
It uses WebSocket to do the same.

## Getting Started

Include this in your pubspec.yaml

```yaml
dependencies:
  kuzzle:
    git: git://github.com/prijindal/kuzzle_dart.git

```
Right now i would recommend that this be used directly from the git or a tar package.
In the future versioning of pub will be used

## Example

```dart
import 'package:kuzzle/kuzzle.dart';

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

> view all samples in [example/ folder](./example/)

## Information
- Uses WebSocket to communicate with kuzzle, in the future http might also be used
- Documentation is auto generated from source, and [available here](https://prijindal.github.io/kuzzle_dart/)
- More detailed documentation is [available on kuzzle website](https://docs-v2.kuzzle.io)
