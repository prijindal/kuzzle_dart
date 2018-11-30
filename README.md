# Kuzzle SDK for dart

[![Build Status](https://travis-ci.org/prijindal/kuzzle_dart.svg?branch=master)](https://travis-ci.org/prijindal/kuzzle_dart)
[![Coverage Status](https://coveralls.io/repos/github/prijindal/kuzzle_dart/badge.svg?branch=master)](https://coveralls.io/github/prijindal/kuzzle_dart?branch=master)

The kuzzle_dart package provides SDK for [kuzzle](https://docs.kuzzle.io).
It uses websocket to do the same.

## Getting Started

```dart
import 'package:kuzzle_dart/kuzzle_dart.dart';
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