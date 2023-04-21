part of 'store.dart';

/// A class that intercepts actions and potentially transform actions before
/// they reach the reducer.
///
/// Middleware intercept actions before they reach the reducer. This gives them
/// the ability to produce side-effects or modify the passed in action before
/// they reach the reducer.
abstract class Middleware<State, Action> {
  const Middleware();

  /// A [Middleware] function that intercepts a dispatched action
  dynamic intercept(
    Store<State, Action> store,
    Action action,
    NextDispatcher<Action> next,
  );
}

/// The contract between one piece of middleware and the next in the chain. Use
/// it to send the current action in your [Middleware] to the next piece of
/// [Middleware] in the chain.
///
/// Middleware can optionally pass the original action or a modified action to
/// the next piece of middleware, or never call the next piece of middleware at
/// all.
typedef NextDispatcher<Action> = dynamic Function(Action action);
