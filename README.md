# Kuzzle SDK for dart

[![Build Status](https://travis-ci.org/prijindal/kuzzle_dart.svg?branch=master)](https://travis-ci.org/prijindal/kuzzle_dart)
[![codecov](https://codecov.io/gh/prijindal/kuzzle_dart/branch/master/graph/badge.svg)](https://codecov.io/gh/prijindal/kuzzle_dart)

The kuzzle_dart package provides SDK for [kuzzle](https://docs.kuzzle.io).
It uses websocket to do the same.

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
import 'package:kuzzle/kuzzle_dart.dart';
final Kuzzle kuzzle = Kuzzle('localhost', defaultIndex: 'playground');

void setup() async {
    kuzzle.connect();
    await kuzzle.createIndex('playground');
    
    final Collection collection = kuzzle.collection('collection');

    await collection.create();

    const Map<String, dynamic> message = <String, dynamic>{
        'message': 'Hello World',
        'echoing': 1
    };
    final Document document = await collection.createDocument(message);
    print(document.version);
}

setup();

```

## Information
- Uses websocket to communicate with kuzzle, in the future http might also be used
- Soon documentation will also be coming
