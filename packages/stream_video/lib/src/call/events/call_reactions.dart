import '../call_events.dart';
import '../state/call_state_notifier.dart';
import 'keyed_timers.dart';

/// Sets reactions on a call's participants, and clears each one again after
/// `reactionAutoDismissTime`.
class CallReactions {
  CallReactions({required this._stateManager});

  final CallStateNotifier _stateManager;
  final _dismissTimers = KeyedTimers();

  /// Sets the reaction on its participant. A newer reaction from the same
  /// user restarts the wait before it is cleared.
  void onReaction(StreamCallReactionEvent event) {
    final userId = event.user.id;
    _dismissTimers.start(
      userId,
      _stateManager.callState.preferences.reactionAutoDismissTime,
      () => _stateManager.resetCallReaction(userId),
    );
    _stateManager.coordinatorCallReaction(event);
  }

  /// Stops every pending reaction dismissal.
  void cancelTimers() => _dismissTimers.cancelAll();
}
