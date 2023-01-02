import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';

/// A listener that can be added to a [EventEmitter] using
/// [EventEmitter.on] or [EventEmitter.listen].
///
/// This callback gets invoked once we call [EventEmitter.emit].
typedef Listener<T> = void Function(T data);

/// A callback that can be used to remove a listener added with
/// [EventEmitter.on] or [EventEmitter.listen].
///
/// It is safe to call this callback multiple times.
///
/// Calling this callback multiple times will remove the listener only once,
/// even if [EventEmitter.on] or [EventEmitter.listen] was called multiple times
/// with the exact same listener.
typedef CancelListener = void Function();

/// A callback that can be passed to [EventEmitter.onError].
///
/// This callback should not throw.
///
/// It exists merely for error reporting, and should not be used otherwise.
typedef ErrorListener = void Function(Object error, StackTrace? stackTrace);

/// A simple event emitter mixin.
mixin EventEmittable<T> {
  /// The [EventEmitter] instance.
  EventEmitter<T> get events => _events;

  final _events = EventEmitter<T>();
}

/// A simple event listener which can be used to listen to events emitted by
/// [EventEmitter].
class EventListener<T> {
  /// Creates a new [EventListener] instance.
  EventListener(this._emitter) {
    if (_emitter.mounted) _emitter.listen(_onData);
  }

  final EventEmitter<T> _emitter;
  final _listener = EventEmitter<T>();

  void _onData(T data) {
    if (!_listener.mounted) return;
    _listener.emit(data);
  }

  /// Binds the [listener] to any event to be invoked at most [limit].
  CancelListener listen(Listener<T> listener, {int? limit}) {
    return _listener.listen(listener, limit: limit);
  }

  CancelListener on<E extends T>(
    Listener<E> then, {
    bool Function(E)? filter,
    int? limit,
  }) {
    return _listener.on(
      then,
      filter: filter,
      limit: limit,
    );
  }

  /// waits for a specific event type
  Future<E> waitFor<E extends T>({
    required Duration duration,
    bool Function(E)? filter,
    FutureOr<E> Function()? onTimeout,
  }) {
    return _listener.waitFor<E>(
      duration: duration,
      filter: filter,
      onTimeout: onTimeout,
    );
  }

  /// Unbinds the [listener] from any event.
  void cancel(Listener<T> listener) => _listener.cancel(listener);

  /// Unbinds all the handlers from all the events.
  void cancelAll() => _listener.cancelAll();

  /// If a listener has been added using [bind] for a particular event
  /// and hasn't been removed yet.
  bool hasListeners(String event) => _listener.hasListeners(event);

  /// Disposes the [EventListener] instance.
  void dispose() {
    if (_emitter.mounted) _emitter.cancel(_onData);
    _listener.dispose();
  }
}

/// EventListener extension for [EventEmitter].
extension EventListenerX<T> on EventEmitter<T> {
  /// Creates a new [EventListener] instance.
  EventListener<T> createListener() => EventListener(this);
}

/// A simple event emitter.
class EventEmitter<T> {
  late final _listeners = LinkedList<_ListenerEntry<T>>();

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
  void emit(T data) {
    assert(_debugIsMounted(), '');
    final listeners = _listeners;
    if (listeners.isEmpty) return;
    final removables = <_ListenerEntry<T>>[];
    for (final entry in [...listeners]) {
      try {
        entry.listener(data);
        var limit = entry.limit;
        if (limit != null) {
          if (limit > 0) entry.limit = limit -= 1;
          if (limit == 0) removables.add(entry);
        }
      } catch (error, stackTrace) {
        if (onError != null) {
          onError!(error, stackTrace);
        } else {
          Zone.current.handleUncaughtError(error, stackTrace);
        }
      }
    }
    for (final entry in removables) {
      listeners.remove(entry);
    }
  }

  /// Binds the [listener] to any event to be invoked at most [limit].
  CancelListener listen(Listener<T> listener, {int? limit}) {
    assert(_debugIsMounted(), '');
    final listenerEntry = _ListenerEntry(listener, limit: limit);
    _listeners.add(listenerEntry);

    // return func to cancel listening and remove from list in 1 call
    return () {
      if (listenerEntry.list != null) {
        listenerEntry.unlink();
      }
    };
  }

  CancelListener on<E extends T>(
    Listener<E> then, {
    bool Function(E)? filter,
    int? limit,
  }) {
    return listen(
      limit: limit,
      (event) {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        then(event);
      },
    );
  }

  /// waits for a specific event type
  Future<E> waitFor<E extends T>({
    required Duration duration,
    bool Function(E)? filter,
    FutureOr<E> Function()? onTimeout,
  }) async {
    final completer = Completer<E>();

    void onEvent(E data) {
      if (!completer.isCompleted) {
        completer.complete(data);
      }
    }

    final cancel = on(onEvent, filter: filter, limit: 1);

    try {
      // wait to complete with timeout
      return await completer.future.timeout(
        duration,
        onTimeout: onTimeout ??
            () {
              throw TimeoutException(
                'Timeout waiting for event "$E"',
                duration,
              );
            },
      );
      // do not catch exceptions and pass it up
    } finally {
      // always clean-up listener
      cancel();
    }
  }

  /// Unbinds the [listener] from any event.
  void cancel(Listener<T> listener) {
    assert(_debugIsMounted(), '');
    final listeners = _listeners;
    if (listeners.isEmpty) return;
    for (final entry in listeners) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  /// Unbinds all the handlers from all the events.
  void cancelAll() {
    assert(_debugIsMounted(), '');
    _listeners.clear();
  }

  /// If a listener has been added using [bind] for a particular event
  /// and hasn't been removed yet.
  bool hasListeners(String event) {
    assert(_debugIsMounted(), '');
    final listeners = _listeners;
    return listeners.isNotEmpty;
  }

  /// Frees all the resources associated to this object.
  ///
  /// This marks the object as no longer usable and will make all methods/properties
  /// besides [mounted] inaccessible.
  @mustCallSuper
  void dispose() {
    assert(_debugIsMounted(), '');
    _listeners.clear();
    _mounted = false;
  }
}

class _ListenerEntry<T> extends LinkedListEntry<_ListenerEntry<T>> {
  _ListenerEntry(this.listener, {this.limit});

  int? limit;
  final Listener<T> listener;
}
