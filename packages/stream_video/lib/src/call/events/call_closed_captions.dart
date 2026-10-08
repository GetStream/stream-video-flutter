import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';
import 'package:synchronized/synchronized.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../models/call_closed_caption.dart';
import '../call_events.dart';
import '../state/call_state_notifier.dart';
import 'keyed_timers.dart';

/// Holds a call's closed captions, and removes each one again after
/// `closedCaptionsVisibilityDurationMs`, unless that is 0 or less.
@internal
class CallClosedCaptions {
  CallClosedCaptions({
    required this._stateManager,
    required this._logger,
  });

  final CallStateNotifier _stateManager;
  final TaggedLogger _logger;

  final _expiryTimers = KeyedTimers();
  final _lock = Lock();

  /// The closed captions currently on screen, oldest first. The list is
  /// unmodifiable.
  StateEmitter<List<StreamClosedCaption>> get closedCaptions => _closedCaptions;
  final _closedCaptions = MutableStateEmitter<List<StreamClosedCaption>>(
    const [],
  );

  /// Adds the caption to [closedCaptions], keeping only the newest
  /// `closedCaptionsVisibleCaptions`, and removes it after
  /// `closedCaptionsVisibilityDurationMs`. Duplicates are ignored. When the
  /// visibility duration is 0 or less, captions stay until newer ones push
  /// them out.
  Future<void> onClosedCaption(StreamCallClosedCaptionsEvent event) {
    return _lock.synchronized(() {
      try {
        _logger.v(() => '[onClosedCaption] event: $event');

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
        final visibleCaptions =
            _stateManager.callState.preferences.closedCaptionsVisibleCaptions;

        // schedule the removal of the closed caption after the retention time
        if (visibilityDurationMs > 0) {
          _expiryTimers.start(
            currentKey,
            Duration(milliseconds: visibilityDurationMs),
            () => _removeExpiredCaption(keyFor, currentCaption),
          );
        }

        // cancel the removal of the captions that drop out of the queue
        if (newQueue.length > visibleCaptions) {
          for (var i = 0; i < newQueue.length - visibleCaptions; i++) {
            _expiryTimers.cancel(keyFor(newQueue[i]));
          }
        }

        _closedCaptions.value = List.unmodifiable(
          newQueue.length > visibleCaptions
              ? newQueue.sublist(newQueue.length - visibleCaptions)
              : newQueue,
        );
      } catch (error, stackTrace) {
        _logger.e(
          () => '[onClosedCaption] failed: $error, stackTrace: $stackTrace',
        );
      }
    });
  }

  /// Stops every pending caption removal and clears [closedCaptions].
  void reset() {
    _expiryTimers.cancelAll();
    _closedCaptions.value = const [];
  }

  Future<void> _removeExpiredCaption(
    String Function(StreamClosedCaption) keyFor,
    StreamClosedCaption caption,
  ) async {
    return _lock.synchronized(() {
      _closedCaptions.value = List.unmodifiable(
        _closedCaptions.value.where((c) => keyFor(c) != keyFor(caption)),
      );
    });
  }
}
