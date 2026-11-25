import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../call_events.dart';
import '../state/call_state_notifier.dart';

/// Applies and clears video moderation on one call, as set up by the call's
/// [VideoModerationConfig].
@internal
class CallVideoModeration {
  CallVideoModeration({
    required this._stateManager,
    required this._currentUserId,
    required this._setMicrophoneEnabled,
    required this._setCameraEnabled,
    required this._setModerationFilter,
    required this._logger,
  });

  final CallStateNotifier _stateManager;
  final String Function() _currentUserId;
  final Future<Result<None>> Function({required bool enabled})
  _setMicrophoneEnabled;
  final Future<Result<None>> Function({required bool enabled})
  _setCameraEnabled;
  final Future<void> Function(VideoFilter? filter) _setModerationFilter;
  final TaggedLogger _logger;

  Timer? _videoModerationTimer;

  /// Whether [VideoModerationConfig.blurFilter] is on the camera.
  bool _blurApplied = false;

  /// Passes a warning for the current user to
  /// [VideoModerationConfig.onWarning].
  void onWarning(StreamCallModerationWarningEvent event) {
    final config = _stateManager.callState.preferences.videoModerationConfig;
    if (config.isDisabled || event.userId != _currentUserId()) {
      return;
    }

    config.onWarning?.call(event.message);
  }

  /// Applies the moderation configured for a blur of the current user, and
  /// schedules [clear] when the config has a duration. A failed mute is
  /// logged, and the rest of the moderation is still applied.
  Future<void> onBlur(StreamCallModerationBlurEvent event) async {
    final config = _stateManager.callState.preferences.videoModerationConfig;
    if (config.isDisabled || event.userId != _currentUserId()) {
      return;
    }

    _stateManager.coordinatorCallModerationBlur(event.userId);

    _videoModerationTimer?.cancel();
    _videoModerationTimer = null;
    if (config.duration != null) {
      _videoModerationTimer = Timer(config.duration!, clear);
    }

    if (config.muteAudio) {
      final result = await _setMicrophoneEnabled(enabled: false);
      if (result.isFailure) {
        _logger.w(() => '[onBlur] failed to mute the microphone: $result');
      }
    }
    if (config.muteVideo) {
      final result = await _setCameraEnabled(enabled: false);
      if (result.isFailure) {
        _logger.w(() => '[onBlur] failed to mute the camera: $result');
      }
    }
    if (config.blurFilter case final filter?) {
      _blurApplied = true;
      await _setModerationFilter(filter);
    }
    config.onApply?.call();
  }

  /// Cancels a pending timed clear, then clears the moderation action if the
  /// call is moderated.
  void clear() {
    cancelTimer();

    final callState = _stateManager.callState;
    if (!callState.isVideoModerated) return;

    final config = callState.preferences.videoModerationConfig;
    _stateManager.clearModerationBlur();

    if (_blurApplied) {
      _blurApplied = false;
      unawaited(
        _setModerationFilter(null).catchError((Object e, StackTrace stk) {
          _logger.w(() => '[clear] failed to remove the blur: $e\n$stk');
        }),
      );
    }
    config.onClear?.call();
  }

  /// Stops a pending timed [clear].
  void cancelTimer() {
    _videoModerationTimer?.cancel();
    _videoModerationTimer = null;
  }
}
