import 'package:kuzzle/kuzzle_dart.dart';

void main() {
  final kuzzle = Kuzzle(
    WebSocketProtocol('127.0.0.1.xip.io'),
    offlineMode: OfflineMode.auto,
  );

  // connection events
  kuzzle.on('connected', () => print('[connected]'));
  kuzzle.on('disconnected', () => print('[disconnected]'));
  kuzzle.on('reconnected', () => print('[reconnected]'));

  // errors events
  kuzzle.on('discarded', (request) => print('[discarded] => $request'));
  kuzzle.on('queryError', (error, request) {
    print('[queryError] => $request');
    print(error);
  });
  kuzzle.on('networkError', (error) {
    print('[networkError]');
    print(error);
  });

  // offline queue events
  kuzzle.on('offlineQueuePush', (request) => print('[queue] => $request'));
  kuzzle.on('offlineQueuePop', (request) => print('[dequeue] => $request'));

  // perform a query when offline
  kuzzle.query({
    'controller': 'server',
    'action': 'now'
  }).catchError((error) {
    // should raise an error:
    // KuzzleError[Unable to execute request: not connected to a Kuzzle server.]
    assert (error is KuzzleError);
    print(error);
  });

  kuzzle.connect().then((_) async {
    // this query should not be queued and resolved when answered
    var result = await kuzzle.server.now();
    print('[result][server][now] $result');

    result = await kuzzle.server.info();
    print('[result][server][info] $result');
  });

  // perform a query when connection status is not known
  kuzzle.query({
    'controller': 'server',
    'action': 'now'
  }).then((response) {
    // this query should be queued and resolved when connected & answered
    assert (response is KuzzleResponse);

    print('[response][queued] $response');
  });
}
