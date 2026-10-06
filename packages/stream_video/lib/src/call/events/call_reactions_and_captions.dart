import 'dart:async';

import 'package:stream_core/stream_core.dart';
import 'package:synchronized/synchronized.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../models/call_closed_caption.dart';
import '../call_events.dart';
import '../state/call_state_notifier.dart';

/// Holds one call's reactions and closed captions, and the timers that clear
/// them again.
class CallReactionsAndCaptions {
  CallReactionsAndCaptions({
    required this._stateManager,
    required this._logger,
  });

  final CallStateNotifier _stateManager;
  final TaggedLogger _logger;

  final Map<String, Timer> _reactionTimers = {};
  final Map<String, Timer> _captionsTimers = {};
  final _captionsLock = Lock();

  /// The closed captions currently on screen, oldest first.
  StateEmitter<List<StreamClosedCaption>> get closedCaptions => _closedCaptions;
  final _closedCaptions = MutableStateEmitter<List<StreamClosedCaption>>(
    [],
  );

  /// Sets the reaction on its participant, and clears it again after
  /// `reactionAutoDismissTime`. A newer reaction from the same user restarts
  /// that wait.
  void onReaction(StreamCallReactionEvent event) {
    _reactionTimers[event.user.id]?.cancel();

    _reactionTimers[event.user.id] = Timer(
      _stateManager.callState.preferences.reactionAutoDismissTime,
      () {
        _stateManager.resetCallReaction(event.user.id);
        _reactionTimers.remove(event.user.id);
      },
    );
    _stateManager.coordinatorCallReaction(event);
  }

  /// Adds the caption to [closedCaptions], and removes it again after
  /// `closedCaptionsVisibilityDurationMs`.
  void onClosedCaption(StreamCallClosedCaptionsEvent event) {
    _captionsLock.synchronized(() {
      _logger.v(() => '[handleClosedCaptionEvent] event: $event');

      String keyFor(StreamClosedCaption caption) {
        return '${caption.speakerId}_${caption.startTime}';
      }

      final queue = _closedCaptions.value;
      final currentCaption = StreamClosedCaption.fromEvent(event);
      final currentKey = keyFor(currentCaption);

      // Ignore duplicates from backend
      if (queue.any((caption) => keyFor(caption) == currentKey)) {
        return;
      }

      final newQueue = [...queue, currentCaption];

      final visibilityDurationMs = _stateManager
          .callState
          .preferences
          .closedCaptionsVisibilityDurationMs;
      final visibileCaptions =
          _stateManager.callState.preferences.closedCaptionsVisibleCaptions;

      try {
        // schedule the removal of the closed caption after the retention time
        if (visibilityDurationMs > 0) {
          final timer = Timer(Duration(milliseconds: visibilityDurationMs), () {
            _removeExpiredCaption(keyFor, currentCaption);
            _captionsTimers.remove(currentKey);
          });

          _captionsTimers[currentKey] = timer;

          // cancel the cleanup tasks for the closed captions that are no longer in the queue
          if (newQueue.length > visibileCaptions) {
            for (var i = 0; i < newQueue.length - visibileCaptions; i++) {
              final key = keyFor(newQueue[i]);
              final timer = _captionsTimers[key];

              timer?.cancel();
              _captionsTimers.remove(key);
            }
          }

          _closedCaptions.value = newQueue.length > visibileCaptions
              ? newQueue.sublist(newQueue.length - visibileCaptions)
              : newQueue;
        }
      } catch (error) {
        _logger.e(() => '[handleClosedCaptionEvent] failed: $error');
      }
    });
  }

  /// Stops every pending reaction dismissal and caption removal.
  void cancelTimers() {
    for (final timer in [
      ..._reactionTimers.values,
      ..._captionsTimers.values,
    ]) {
      timer.cancel();
    }
  }

  Future<void> _removeExpiredCaption(
    String Function(StreamClosedCaption) keyFor,
    StreamClosedCaption caption,
  ) async {
    return _captionsLock.synchronized(() {
      _closedCaptions.value = _closedCaptions.value.where((c) {
        return keyFor(c) != keyFor(caption);
      }).toList();
    });
  }
}
