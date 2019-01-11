
class KuzzleListener {
  KuzzleListener(this.fn, { this.once });

  final Function fn;
  final bool once;
}

class KuzzleEventEmitter {
  KuzzleEventEmitter();

  final Map<String, List<KuzzleListener>> _events = {};

  bool _exist (String eventName, Function callback) {
    assert(eventName != null);
    assert(eventName.isNotEmpty);
    assert(callback != null);

    if (!_events.containsKey(eventName)) {
      return false;
    }

    return _events[eventName].where(
      (listener) => listener.fn == callback
    ).isNotEmpty;
  }

  List<String> eventNames() => _events.keys.toList();

  int listenerCount(String eventName) {
    assert(eventName != null);
    assert(eventName.isNotEmpty);

    return (_events.containsKey(eventName)) ? _events[eventName].length : 0;
  }

  List<KuzzleListener> listeners (String eventName) {
    assert(eventName != null);
    assert(eventName.isNotEmpty);

    if (!_events.containsKey(eventName)) {
      return <KuzzleListener>[];
    }

    return _events[eventName];
  }

  void addListener(
    String eventName,
    Function callback,
    { bool once = false }
  ) {
    assert(callback != null);
    assert(eventName != null);
    assert(eventName.isNotEmpty);

    if (!_events.containsKey(eventName)) {
      _events[eventName] = <KuzzleListener>[];
    }

    if (!_exist(eventName, callback)) {
      _events[eventName].add(KuzzleListener(callback, once: once));
    }
  }

  void prependListener(
    String eventName,
    Function callback,
    { bool once = false }
  ) {
    assert(callback != null);
    assert(eventName != null);
    assert(eventName.isNotEmpty);

    if (!_events.containsKey(eventName)) {
      _events[eventName] = <KuzzleListener>[];
    }

    if (!_exist(eventName, callback)) {
      _events[eventName].insert(0, KuzzleListener(callback, once: once));
    }
  }

  void removeListener(String eventName, Function callback) {
    assert(callback != null);
    assert(eventName != null);
    assert(eventName.isNotEmpty);

    if (!_events.containsKey(eventName)) {
      return;
    }

    _events[eventName].removeWhere((listener) => listener.fn == callback);

    if (_events[eventName].isEmpty) {
      _events.remove(eventName);
    }
  }

  void removeAllListeners([String eventName]) {
    if (eventName.isNotEmpty) {
      _events[eventName].clear();
    } else {
      _events.clear();
    }
  }

  void on(String eventName, Function callback) =>
      addListener(eventName, callback);

  void off(String eventName, Function callback) =>
      removeListener(eventName, callback);

  void once(String eventName, Function callback) =>
      addListener(eventName, callback, once: true);

  bool emit(String eventName, [
    List positionalArguments,
    Map<Symbol, dynamic> namedArguments,
  ]) {
    assert(eventName != null);
    assert(eventName.isNotEmpty);

    if (!_events.containsKey(eventName)) {
      return false;
    }

    final _listeners = listeners(eventName);
    final _onceListeners = <KuzzleListener>[];

    for (final listener in _listeners) {
      if (listener.once) {
        _onceListeners.add(listener);
      }

      try {
        Function.apply(listener.fn, positionalArguments, namedArguments);
      } on Exception {
        print('$runtimeType.emit($eventName) => listener.fn errored');
        print('Did the listener was registered correctly?');
      }
    }

    for (final listener in _onceListeners) {
      removeListener(eventName, listener.fn);
    }

    return true;
  }
}

