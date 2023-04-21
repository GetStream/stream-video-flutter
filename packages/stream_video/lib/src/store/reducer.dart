part of 'store.dart';

/// Defines an application's state change
///
/// Implement this to modify your app [State] in response to a given [Action].
abstract class Reducer<State, Action> {
  const Reducer();

  /// The [Reducer] function that converts the current state and action into a
  /// new state
  State reduce(State state, Action action);
}
