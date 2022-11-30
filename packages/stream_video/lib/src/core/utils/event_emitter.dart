import 'dart:async';
import 'dart:collection';
import 'package:meta/meta.dart';

/// A listener that can be added to a [EventEmitter] using
/// [EventEmitter.on] or [EventEmitter.addListener].
///
/// This callback gets invoked once we call [EventEmitter.emit].
typedef Listener<T> = void Function(T data);

/// A callback that can be passed to [EventEmitter.onError].
///
/// This callback should not throw.
///
/// It exists merely for error reporting, and should not be used otherwise.
typedef ErrorListener = void Function(Object error, StackTrace? stackTrace);

/// A simple event emitter.
class EventEmitter<T> {
  LinkedList<_ListenerEntry<T>>? _onAnyListeners;

  /// Mapping of events to a list of event handlers
  late final _events = <String, LinkedList<_ListenerEntry<T>>>{};

  /// A callback for error reporting if one of the listeners added with [bind]
  /// throws.
  ///
  /// This callback should not throw.
  ///
  /// It exists for error reporting, and should not be used otherwise.
  ///
  /// If no [onError] is specified, fallbacks to
  /// [Zone.current.handleUncaughtError].
  ErrorListener? onError;

  bool _mounted = true;

  /// Whether [dispose] was called or not.
  bool get mounted => _mounted;

  bool _debugIsMounted() {
    assert(() {
      if (!_mounted) {
        throw StateError('''
        Tried to use $runtimeType after `dispose` was called.
        Consider checking `mounted`.
        ''');
      }
      return true;
    }(), '');
    return true;
  }

  /// Triggers all the `listeners` currently listening
  /// to [event] and passes them [data].
  void emit(String event, T data) {
    assert(_debugIsMounted(), '');
    final listeners = _events[event];
    final anyListeners = _onAnyListeners;
    final allListeners = [...?listeners, ...?anyListeners];
    if (allListeners.isEmpty) return;
    var didThrow = false;
    final removables = <_ListenerEntry<T>>[];
    for (final entry in allListeners) {
      try {
        entry.listener(data);
        var limit = entry.limit;
        if (limit != null) {
          if (limit > 0) entry.limit = limit -= 1;
          if (limit == 0) removables.add(entry);
        }
      } catch (error, stackTrace) {
        didThrow = true;
        if (onError != null) {
          onError!(error, stackTrace);
        } else {
          Zone.current.handleUncaughtError(error, stackTrace);
        }
      }
    }
    for (final entry in removables) {
      listeners?.remove(entry);
      anyListeners?.remove(entry);
    }
    if (didThrow) throw Error();
  }

  /// Binds the [listener] to any event to be invoked at most [limit].
  void listen(Listener<T> listener, {int? limit}) {
    return onAny(listener, limit: limit);
  }

  /// Unbinds the [listener] from any event.
  void unlisten(Listener<T> listener) => offAny(listener);

  /// Binds the [listener] to any event to be invoked at most [limit].
  void onAny(Listener<T> listener, {int? limit}) {
    assert(_debugIsMounted(), '');
    final listenerEntry = _ListenerEntry(listener, limit: limit);
    final listeners = _onAnyListeners ??= LinkedList<_ListenerEntry<T>>();
    listeners.add(listenerEntry);
    _onAnyListeners = listeners;
  }

  /// Unbinds the [listener] from any event.
  void offAny(Listener<T> listener) {
    assert(_debugIsMounted(), '');
    final listeners = _onAnyListeners;
    if (listeners == null) return;
    for (final entry in listeners) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  /// Binds the [listener] to the passed [event] to be invoked at most [limit].
  void on(String event, Listener<T> listener, {int? limit}) =>
      addListener(event, listener, limit: limit);

  /// Binds the [listener] to the passed [event] to be invoked at most once.
  void once(String event, Listener<T> listener) =>
      addListener(event, listener, limit: 1);

  /// Binds the [listener] to the passed [event] to be invoked at most [limit].
  void addListener(String event, Listener<T> listener, {int? limit}) {
    assert(_debugIsMounted(), '');
    final listenerEntry = _ListenerEntry(listener, limit: limit);
    final listeners = _events[event] ?? LinkedList<_ListenerEntry<T>>();
    listeners.add(listenerEntry);
    _events[event] = listeners;
  }

  /// Unbind all the `listeners` from the passed [event].
  void off(String event) {
    assert(_debugIsMounted(), '');
    _events[event] = LinkedList<_ListenerEntry<T>>();
  }

  /// Unbinds the [listener] from the passed [event].
  void removeListener(String event, Listener<T> listener) {
    assert(_debugIsMounted(), '');
    final listeners = _events[event];
    if (listeners == null) return;
    for (final entry in listeners) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  /// Unbinds all the handlers from all the events.
  void removeAllListeners() {
    assert(_debugIsMounted(), '');
    _events.clear();
    _onAnyListeners?.clear();
  }

  /// If a listener has been added using [bind] for a particular event
  /// and hasn't been removed yet.
  bool hasListeners(String event) {
    assert(_debugIsMounted(), '');
    final listeners = _events[event];
    final anyListeners = _onAnyListeners;
    final allListeners = [...?listeners, ...?anyListeners];
    return allListeners.isNotEmpty;
  }

  /// Frees all the resources associated to this object.
  ///
  /// This marks the object as no longer usable and will make all methods/properties
  /// besides [mounted] inaccessible.
  @mustCallSuper
  void dispose() {
    assert(_debugIsMounted(), '');
    _onAnyListeners?.clear();
    _events.values.forEach((listeners) => listeners.clear());
    _mounted = false;
  }
}

class _ListenerEntry<T> extends LinkedListEntry<_ListenerEntry<T>> {
  _ListenerEntry(this.listener, {this.limit});

  int? limit;
  final Listener<T> listener;
}

///
extension EventEmitterX<T> on EventEmitter<T> {
  /// waits for a specific event type
  Future<T> waitFor({
    required String event,
    required Duration duration,
    FutureOr<T> Function()? onTimeout,
  }) async {
    final completer = Completer<T>();

    void onEvent(T data) {
      completer.complete(data);
    }

    once(event, onEvent);

    try {
      // wait to complete with timeout
      return await completer.future.timeout(
        duration,
        onTimeout: onTimeout ??
            () {
              throw TimeoutException(
                'Timeout waiting for event "$event"',
                duration,
              );
            },
      );
      // do not catch exceptions and pass it up
    } finally {
      // always clean-up listener
      removeListener(event, onEvent);
    }
  }
}

mixin EventEmitterMixin<T> {
  final emitter = EventEmitter<T>();

  void on(String event, Listener<T> listener, {int? limit}) =>
      emitter.on(event, listener, limit: limit);

  void once(String event, Listener<T> listener) =>
      emitter.once(event, listener);

  void off(String event) => emitter.off(event);

  void listen(Listener<T> listener, {int? limit}) =>
      emitter.listen(listener, limit: limit);

  void unlisten(Listener<T> listener) => emitter.unlisten(listener);

  void addListener(String event, Listener<T> listener, {int? limit}) =>
      emitter.addListener(event, listener, limit: limit);

  void removeListener(String event, Listener<T> listener) =>
      emitter.removeListener(event, listener);

  void removeAllListeners() => emitter.removeAllListeners();

  bool hasListeners(String event) => emitter.hasListeners(event);

  Future<T> waitFor({
    required String event,
    required Duration duration,
    FutureOr<T> Function()? onTimeout,
  }) {
    return emitter.waitFor(
      event: event,
      duration: duration,
      onTimeout: onTimeout,
    );
  }
}
