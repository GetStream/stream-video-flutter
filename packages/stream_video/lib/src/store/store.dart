import 'package:flutter/foundation.dart';

import '../disposable.dart';
import '../state_emitter.dart';

part 'middleware.dart';

part 'reducer.dart';

/// Creates a Redux store that holds the app state tree.
///
/// The only way to change the state tree in the store is to [dispatch] an
/// action. the action will then be intercepted by any provided [Middleware].
/// After running through the middleware, the action will be sent to the given
/// [Reducer] to update the state tree.
///
/// To access the state tree, call the [state] getter or listen to its stream.
class Store<State, Action> extends Disposable {
  /// Creates an instance of a Redux Store.
  ///
  /// The [reducer] argument specifies how the state should be changed in
  /// response to dispatched actions.
  ///
  /// The optional [initialState] argument defines the State of the store when
  /// the Store is first created.
  ///
  /// The optional [middlewares] argument takes a list of [Middleware].
  /// See the [Middleware] documentation for information on how they are used.
  ///
  /// The [syncStream] argument allows you to use a synchronous
  /// [StateEmitter] instead of an async `StateEmitter` under the hood.
  /// By default, the Emitter is async.
  Store(
    this.reducer, {
    required State initialState,
    List<Middleware<State, Action>> middlewares = const [],
    bool syncStream = false,

    /// If set to true, the Store will not emit onChange events if the new State
    /// that is returned from your [reducer] in response to an Action is equal
    /// to the previous state.
    ///
    /// Under the hood, it will use the `==` method from your State class to
    /// determine whether or not the two States are equal.
    bool distinct = true,
  }) : _state = MutableStateEmitterImpl(initialState, sync: syncStream) {
    _dispatchers = _createDispatchers(
      middlewares,
      _createReduceAndNotify(distinct),
    );
  }

  /// The [Reducer] for your Store. Allows you to get the current reducer or
  /// replace it with a new one if need be.
  Reducer<State, Action> reducer;

  final MutableStateEmitter<State> _state;
  late final List<NextDispatcher<Action>> _dispatchers;

  /// Returns the current state of the app
  StateEmitter<State> get state => _state;

  // Creates the base [NextDispatcher].
  //
  // The base NextDispatcher will be called after all other middleware provided
  // by the user have been run. Its job is simple: Run the current state through
  // the reducer, save the result, and notify any subscribers.
  NextDispatcher<Action> _createReduceAndNotify(bool distinct) {
    return (Action action) {
      final state = reducer.reduce(_state.value, action);

      if (distinct && state == _state) return;

      _state.value = state;
    };
  }

  List<NextDispatcher<Action>> _createDispatchers(
    List<Middleware<State, Action>> middlewares,
    NextDispatcher<Action> reduceAndNotify,
  ) {
    final dispatchers = [reduceAndNotify];

    // Convert each [Middleware] into a [NextDispatcher]
    for (final nextMiddleware in middlewares.reversed) {
      final next = dispatchers.last;

      dispatchers.add(
        (Action action) => nextMiddleware.intercept(this, action, next),
      );
    }

    return dispatchers.reversed.toList();
  }

  /// Runs the action through all provided [Middleware], then applies an action
  /// to the state using the given [Reducer]. Please note: [Middleware] can
  /// intercept actions, and can modify actions or stop them from passing
  /// through to the reducer.
  dynamic dispatch(Action action) {
    return _dispatchers[0](action);
  }

  /// Closes down the Store so it will no longer be operational. Only use this
  /// if you want to destroy the Store while your app is running. Do not use
  /// this method as a way to stop listening to [state] changes.
  @override
  Future<void> dispose() async {
    await _state.close();
    return super.dispose();
  }
}
