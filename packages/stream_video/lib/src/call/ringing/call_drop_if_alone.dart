import 'dart:async';

import 'package:meta/meta.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../models/disconnect_reason.dart';
import '../../models/leave_initiator.dart';
import '../../sfu/data/models/sfu_participant.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../state/call_state_notifier.dart';

/// Ends a ringing call once the current user is the only one left in it, as
/// `CallPreferences.dropIfAloneInRingingFlow` asks.
///
/// The call ends only after [gracePeriod], and only if it is still alone then.
@internal
class CallDropIfAlone {
  CallDropIfAlone({
    required this._stateManager,
    required this._currentUserId,
    required this._isLeftOrLeaving,
    required this._end,
    required this._leave,
    required this._logger,
  });

  /// How long a call that looks alone waits before it ends itself.
  ///
  /// A remote participant who rejoins or migrates leaves with its old session
  /// before its new one is announced, so the call looks alone for a moment.
  @visibleForTesting
  static const gracePeriod = Duration(seconds: 3);

  final CallStateNotifier _stateManager;
  final String Function() _currentUserId;
  final bool Function() _isLeftOrLeaving;
  final Future<Result<None>> Function({
    String? reason,
    LeaveInitiator initiator,
  })
  _end;
  final Future<Result<None>> Function({DisconnectReason? reason}) _leave;
  final TaggedLogger _logger;

  Timer? _timer;

  /// Starts the wait if the call is alone once [leaving] is gone, and
  /// restarts it if it is already running.
  void onParticipantLeft(SfuParticipant leaving) {
    // The participant list may not have dropped the leaving session yet.
    if (!_dropsIfAlone || !_isAlone(leaving: leaving)) return;
    _schedule();
  }

  /// Stops a pending wait.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether the call is in a ringing flow that drops when alone.
  bool get _dropsIfAlone {
    final state = _stateManager.callState;
    return state.isRingingFlow && state.preferences.dropIfAloneInRingingFlow;
  }

  /// Whether exactly one participant, a session of the current user, remains,
  /// not counting [leaving].
  bool _isAlone({SfuParticipant? leaving}) {
    final currentUserId = _currentUserId();
    var remaining = 0;

    for (final participant in _stateManager.callState.callParticipants) {
      if (leaving != null &&
          participant.userId == leaving.userId &&
          participant.sessionId == leaving.sessionId) {
        continue;
      }
      if (participant.userId != currentUserId || ++remaining > 1) {
        return false;
      }
    }

    return remaining == 1;
  }

  void _schedule() {
    _timer?.cancel();
    _logger.d(() => '[dropIfAlone] alone, checking again in $gracePeriod');
    _timer = Timer(gracePeriod, () {
      _timer = null;
      unawaited(_dropIfStillAlone());
    });
  }

  /// Ends the call if it is still connected and still alone. Falls back to
  /// leaving when the end is not delivered.
  Future<void> _dropIfStillAlone() async {
    try {
      if (_isLeftOrLeaving()) return;

      // While this side joins or reconnects its participant list is not
      // current, so the check waits for the connection to settle.
      final status = _stateManager.callState.status;
      if (!status.isConnected) {
        if (status.isActive) _schedule();
        return;
      }

      // By now the left event has reached the participant list, so the list
      // is checked as it is.
      if (!_dropsIfAlone || !_isAlone()) {
        _logger.d(() => '[dropIfAlone] skipped, no longer alone');
        return;
      }

      final endResult = await _end(
        reason: 'last participant left the call (ringing flow)',
        initiator: LeaveInitiator.app,
      );

      if (endResult.isFailure) {
        _logger.w(
          () =>
              '[dropIfAlone] auto-end failed while alone in ringing flow: '
              '$endResult',
        );
        await _leave(reason: DisconnectReason.lastParticipantLeft());
      }
    } catch (error, stackTrace) {
      _logger.e(
        () => '[dropIfAlone] failed: $error, stackTrace: $stackTrace',
      );
    }
  }
}
