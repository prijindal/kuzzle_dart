import 'error.dart';
import 'response.dart';

class ConnectedEvent {}
class NetworkErrorEvent {
  NetworkErrorEvent(
    this.error,
  );

  final Error error;
}
class DisconnectedEvent {}
class ReconnectedEvent {}
class TokenExpiredEvent {
  TokenExpiredEvent({
    this.request,
    this.future,
  });

  final RawKuzzleRequest request;
  final Future future;
}
class LoginAttemptEvent {
  LoginAttemptEvent({
    this.success = false,
    this.error,
  });

  final bool success;
  final Error error;
}
class OfflineQueuePushEvent {
  OfflineQueuePushEvent({
    this.request,
    this.future,
  });

  final RawKuzzleRequest request;
  final Future future;
}
class OfflineQueuePopEvent {
  OfflineQueuePopEvent({
    this.request,
  });

  final RawKuzzleRequest request;
}
class QueryErrorEvent {
  QueryErrorEvent({
    this.request,
    this.error,
    this.future,
  });

  final RawKuzzleRequest request;
  final ResponseError error;
  final Future future;
}
