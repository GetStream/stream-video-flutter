import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../models/audio_interruption_reaction.dart';
import '../state/call_state_notifier.dart';

/// Applies the platform's interruptions of a call's audio to the call: keeps
/// `CallState.isAudioInterrupted` up to date and reacts as
/// `CallPreferences.audioInterruptionReaction` says.
///
/// An interruption is only taken while `isActive` says the call's audio is in
/// progress. Events are handled one at a time, in order.
@internal
class CallAudioInterruptions {
  CallAudioInterruptions({
    required this._stateManager,
    required this._isActive,
    required this._reaction,
    required this._onStarted,
    required this._onEnded,
    required this._logger,
  });

  final CallStateNotifier _stateManager;
  final bool Function() _isActive;
  final AudioInterruptionReaction Function() _reaction;

  /// The interruption started; turns the microphone off when
  /// `muteMicrophone` is set.
  final Future<void> Function({required bool muteMicrophone}) _onStarted;

  /// The interruption ended; turns back on what [_onStarted] turned off when
  /// `restore` is set.
  final Future<void> Function({required bool restore}) _onEnded;

  final TaggedLogger _logger;

  final _lock = Lock();

  bool get _isInterrupted => _stateManager.callState.isAudioInterrupted;

  /// The platform started (`true`) or ended (`false`) interrupting the audio
  /// of the call in progress.
  Future<void> onInterruption({required bool interrupted}) {
    return _lock.synchronized(() => interrupted ? _onStart() : _onEnd());
  }

  Future<void> _onStart() async {
    if (_isInterrupted || !_isActive()) return;

    final reaction = _reaction();
    _logger.i(() => '[onInterruption] started, reaction: ${reaction.name}');
    _stateManager.rtcSetAudioInterrupted(isInterrupted: true);

    await _onStarted(
      muteMicrophone: reaction == AudioInterruptionReaction.muteMicrophone,
    );
  }

  Future<void> _onEnd() async {
    if (!_isInterrupted) return;

    _logger.i(() => '[onInterruption] ended');
    _stateManager.rtcSetAudioInterrupted(isInterrupted: false);

    await _onEnded(restore: _isActive());
  }

  /// The call ended: no interruption applies to it any more, and nothing is
  /// turned back on.
  ///
  /// The interruption is cleared without waiting for an event in progress.
  Future<void> reset() async {
    // A call can end from inside an update of its state, such as the SFU
    // ending the call, and setting the state again from inside one throws.
    await Future<void>.value();
    _stateManager.rtcSetAudioInterrupted(isInterrupted: false);
    await _lock.synchronized(() => _onEnded(restore: false));
  }
}
