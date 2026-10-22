// Copyright 2024 LiveKit, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart' as sync;

typedef CancelListenFunc = Function();

mixin EventsEmittable<T> {
  final events = EventsEmitter<T>();
  EventsListener<T> createListener({bool synchronized = false}) =>
      EventsListener<T>(events, synchronized: synchronized);
}

class EventsEmitter<T> extends EventsListenable<T> {
  EventsEmitter({
    bool listenSynchronized = false,
  }) : super(synchronized: listenSynchronized);
  // suppport for multiple event listeners
  final streamCtrl = StreamController<T>.broadcast(sync: false);

  @override
  EventsEmitter<T> get emitter => this;

  @internal
  void emit(T event) {
    // emit the event
    streamCtrl.add(event);
  }
}

// for listening only
class EventsListener<T> extends EventsListenable<T> {
  EventsListener(
    this.emitter, {
    bool synchronized = false,
  }) : super(
          synchronized: synchronized,
        );
  @override
  final EventsEmitter<T> emitter;
}

// ensures all listeners will close on dispose
abstract class EventsListenable<T> {
  EventsListenable({
    required this.synchronized,
  });
  // the emitter to listen to
  EventsEmitter<T> get emitter;

  final bool synchronized;
  // keep track of listeners to cancel later
  final _listeners = <StreamSubscription<T>>[];
  final _syncLock = sync.Lock();

  List<StreamSubscription<T>> get listeners => _listeners;

  Future<void> cancelAll() async {
    if (_listeners.isNotEmpty) {
      // Stop listening to all events
      //print('cancelling ${_listeners.length} listeners(s)');
      for (final listener in _listeners) {
        await listener.cancel();
      }
    }
  }

  // listens to all events, guaranteed to be cancelled on dispose
  CancelListenFunc listen(FutureOr<void> Function(T) onEvent) {
    var func = onEvent;
    if (synchronized) {
      // ensure `onEvent` will trigger one by one (waits for previous `onEvent` to complete)
      func = (event) async {
        await _syncLock.synchronized(() async {
          await onEvent(event);
        });
      };
    }

    final listener = emitter.streamCtrl.stream.listen(func);
    _listeners.add(listener);

    // make a cancel func to cancel listening and remove from list in 1 call
    void cancelFunc() async {
      await listener.cancel();
      _listeners.remove(listener);
      //print('event was cancelled by func');
    }

    return cancelFunc;
  }

  // convenience method to listen & filter a specific event type
  CancelListenFunc on<E>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  /// convenience method to listen & filter a specific event type, just once.
  void once<E>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) {
    CancelListenFunc? cancelFunc;
    cancelFunc = listen((event) async {
      // event must be E
      if (event is! E) return;
      // filter must be true (if filter is used)
      if (filter != null && !filter(event)) return;
      // cast to E
      await then(event);
      // cancel after 1 event
      cancelFunc?.call();
    });
  }

  // waits for a specific event type
  Future<E> waitFor<E>({
    required Duration duration,
    bool Function(E)? filter,
    FutureOr<E> Function()? onTimeout,
  }) async {
    final completer = Completer<E>();

    final cancelFunc = on<E>(
      (event) {
        if (!completer.isCompleted) {
          completer.complete(event);
        }
      },
      filter: filter,
    );

    try {
      // wait to complete with timeout
      return await completer.future.timeout(
        duration,
        onTimeout: onTimeout ?? () => throw Exception('waitFor timed out'),
      );
      // do not catch exceptions and pass it up
    } finally {
      // always clean-up listener
      await cancelFunc.call();
    }
  }
}
