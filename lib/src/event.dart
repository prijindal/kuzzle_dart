enum Event {
  connected,
  discacrded,
  disconnected,
  loginAttempt,
  networkError,
  offlineQueuePop,
  offlineQueuePush,
  queryError,
  reconnected,
  tokenExpired
}

typedef EventListener = void Function();
