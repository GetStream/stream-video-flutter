import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';

import '../../../open_api/video/coordinator/api.dart' as open;
import '../../call_state.dart';
import '../../coordinator/coordinator_client.dart';
import '../../core/client_state.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_metadata.dart';
import '../../models/call_status.dart';
import '../../models/disconnect_reason.dart';
import '../../models/leave_initiator.dart';
import '../../ring_state_polling_settings.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../call.dart';
import '../call_events.dart';
import '../call_reject_reason.dart';
import '../call_ringing_state.dart';
import '../connection/leave_attribution.dart';
import '../ring_state_poller.dart';
import '../state/call_state_notifier.dart';
import '../stats/trace_tag.dart';

/// Rings a [Call]: accepting and rejecting it, following the accept and
/// reject events from the coordinator, waiting for the ring to be answered,
/// and polling the ring state of an outgoing ring.
@internal
class CallRingingController {
  CallRingingController({
    required this._call,
    required this._stateManager,
    required this._coordinatorClient,
    required this._clientState,
    required this._prepareToAccept,
    required this._pollingSettings,
    required this._trace,
    required this._logger,
  });

  /// The call this rings, as the client state knows it.
  final Call _call;
  final CallStateNotifier _stateManager;
  final CoordinatorClient _coordinatorClient;
  final ClientState _clientState;

  /// Clears the way for accepting: other calls this one replaces. `null`
  /// when there is nothing to clear.
  final Future<void>? Function() _prepareToAccept;
  final RingStatePollingSettings Function() _pollingSettings;
  final void Function(String tag, Object? data) _trace;
  final TaggedLogger _logger;

  /// Whether an accept from this instance is waiting for its response.
  bool _accepting = false;

  /// Whether the server's echo of the pending accept arrived, so the accept
  /// took effect whatever its response says.
  bool _acceptReachedServer = false;

  /// Whether this instance has sent a reject, so the server's echo of it is
  /// not taken for an answer from elsewhere.
  bool _rejecting = false;

  RingStatePoller? _ringStatePoller;
  StreamSubscription<CallState>? _ringStatePollerStatusSubscription;

  StreamCallCid get _callCid => _call.callCid;

  /// Accepts the incoming call.
  Future<Result<None>> accept() async {
    final state = _stateManager.callState;
    _logger.i(() => '[accept] state: $state');

    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[accept] rejected (invalid status): $status');
      return failureWithError('invalid status: $status');
    }

    // Awaited only when there is work, so the call is marked accepted in the
    // same turn as the accept when nothing is replaced.
    final preparing = _prepareToAccept();
    if (preparing != null) await preparing;

    _trace(TraceTag.callAccept, null);

    // Optimistically mark the call as accepted
    _stateManager.lifecycleCallAccepted();
    _clientState.markCallAcceptedOnThisDevice(_callCid, _call);

    _accepting = true;
    _acceptReachedServer = false;
    final Result<None> result;
    try {
      result = await _coordinatorClient.acceptCall(cid: state.callCid);
    } finally {
      _accepting = false;
    }

    if (result is Failure && _acceptReachedServer) {
      // The response failed, a timeout say, but the server's echo of the
      // accept arrived first, so it took effect. Reverting would take that
      // echo for an accept from elsewhere and end the call here. An echo
      // that arrives only after the failure still does.
      _logger.w(() => '[accept] response failed, but accepted: $result');
      return const Result.success(none);
    }

    if (result is Failure) {
      // Revert the optimistic acceptance so the user can retry or reject.
      _stateManager.lifecycleCallAccepted(accepted: false);
      _clientState.clearCallAcceptedOnThisDevice(_callCid, _call);
    }

    return result;
  }

  /// Rejects the incoming call, then leaves it.
  Future<Result<None>> reject({
    CallRejectReason? reason,
    LeaveInitiator? initiator,
  }) async {
    final state = _stateManager.callState;
    _logger.i(() => '[reject] reason: $reason');

    _trace(TraceTag.callReject, reason?.value);
    _rejecting = true;
    final result = await _coordinatorClient.rejectCall(
      cid: state.callCid,
      reason: reason?.value,
    );

    // Always leave the call after rejecting it.
    await _call.leave(
      reason: result is Success<None>
          ? DisconnectReason.rejected(
              byUserId: state.currentUserId,
              reason: reason,
              initiator: initiator,
            )
          : DisconnectReason.left(
              initiator: initiator ?? LeaveAttribution.rejectInitiator(reason),
              message: 'reject failed: ${reason?.value ?? 'unspecified'}',
            ),
    );

    return result;
  }

  /// Follows a `call.accepted` event. An accept by the current user
  /// somewhere else ends the ring here.
  Future<void> onCallAccepted(StreamCallAcceptedEvent event) async {
    final currentUserId = _stateManager.callState.currentUserId;
    if (_accepting && event.acceptedByUserId == currentUserId) {
      _acceptReachedServer = true;
    }

    if (_isOwnPendingAnswer(event.acceptedByUserId)) {
      _logger.i(() => '[onCallAccepted] accepted elsewhere');
      await _leaveAnsweredElsewhere();
      return;
    }

    _stateManager.coordinatorCallAccepted(event);
  }

  /// Follows a `call.rejected` event. A reject by the current user
  /// somewhere else ends the ring here.
  Future<void> onCallRejected(StreamCallRejectedEvent event) async {
    if (_isOwnPendingAnswer(event.rejectedByUserId)) {
      _logger.i(() => '[onCallRejected] rejected elsewhere');
      await _leaveAnsweredElsewhere();
      return;
    }

    _stateManager.coordinatorCallRejected(event);
  }

  /// Whether [userId] answering is the current user answering this ring
  /// while it still rings here.
  bool _isOwnPendingAnswer(String userId) {
    final state = _stateManager.callState;
    final status = state.status;
    return userId == state.currentUserId &&
        status is CallStatusIncoming &&
        !status.acceptedByMe;
  }

  /// Ends the ring here, for an answer given on another device or through
  /// another [Call] for the same cid. It sends no reject: the answer is
  /// already on the server, and the other SDKs also just leave
  /// (`answeredElsewhere` / `declinedElsewhere`).
  ///
  /// The echo of a reject this instance sent is left to [reject], which
  /// leaves with the reason it was given.
  Future<void> _leaveAnsweredElsewhere() async {
    if (_rejecting) {
      _logger.v(() => '[leaveAnsweredElsewhere] echo of own reject, ignoring');
      return;
    }

    await _call.leave(
      reason: DisconnectReason.rejected(
        byUserId: _stateManager.callState.currentUserId,
        reason: CallRejectReason.userRespondedElsewhere(),
      ),
    );
  }

  /// Waits until a ringing call is answered: an outgoing ring by a callee, an
  /// incoming one by the current user. Succeeds at once when the call does
  /// not ring, and fails when nobody answers in time.
  ///
  /// Once [left] completes the wait ends with `null`, and its timer stops.
  Future<Result<None>?> awaitAnswer({required Future<void> left}) {
    final state = _stateManager.callState;
    final status = state.status;
    final settings = state.settings;

    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      final timeout = settings.ring.autoCancelTimeout;
      _logger.d(() => '[awaitIfNeeded] outgoing timeout: $timeout');
      return _awaitStatus(
        'awaitOutgoingToBeAccepted',
        (status) => status is CallStatusOutgoing && status.acceptedByCallee,
        timeout,
        left,
      );
    }
    if (status is CallStatusIncoming && !status.acceptedByMe) {
      final timeout = settings.ring.autoRejectTimeout;
      _logger.d(() => '[awaitIfNeeded] incoming timeout: $timeout');
      return _awaitStatus(
        'awaitIncomingToBeAccepted',
        (status) => status is CallStatusIncoming && status.acceptedByMe,
        timeout,
        left,
      );
    }

    return Future.value(const Result.success(none));
  }

  Future<Result<None>?> _awaitStatus(
    String tag,
    bool Function(CallStatus status) answered,
    Duration timeLimit,
    Future<void> left,
  ) {
    final completer = Completer<Result<None>?>();
    StreamSubscription<CallState>? subscription;
    Timer? timer;

    void settle(Result<None>? result) {
      if (completer.isCompleted) return;
      timer?.cancel();
      unawaited(subscription?.cancel());
      completer.complete(result);
    }

    timer = Timer(timeLimit, () {
      final error = TimeoutException('No answer within $timeLimit', timeLimit);
      final stackTrace = StackTrace.current;
      _logger.e(() => '[$tag] failed: $error');
      settle(
        Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    });
    subscription = _stateManager.callStateStream.listen((state) {
      if (answered(state.status)) {
        _logger.i(() => '[$tag] completed');
        settle(const Result.success(none));
      }
    });
    unawaited(
      left.then((_) {
        if (completer.isCompleted) return;
        _logger.d(() => '[$tag] stopped (call was left)');
        settle(null);
      }),
    );

    return completer.future;
  }

  /// Drops this call from the client's ringing bookkeeping.
  void release() {
    _clientState
      ..clearCallAcceptedOnThisDevice(_callCid, _call)
      ..releaseRingingCall(_callCid, _call);
  }

  /// Restarts the poller's quiet period, after a ring event arrived.
  void onRingActivity() => _ringStatePoller?.restartQuietPeriod();

  /// Starts polling for the outcome of a ring the current user just started,
  /// in case the `call.accepted` or `call.rejected` event never arrives.
  void startRingStatePollingIfNeeded(CallMetadata metadata) {
    final settings = _pollingSettings();
    if (!settings.enabled) return;
    if (_ringStatePoller?.isStopped == false) return;

    // A zero interval would fire the poll timer on every event-loop turn.
    if (settings.interval <= Duration.zero) {
      _logger.w(
        () =>
            '[startRingStatePolling] rejected (interval is not positive): '
            '${settings.interval}',
      );
      return;
    }

    final status = _stateManager.callState.status;
    if (status is! CallStatusOutgoing || status.acceptedByCallee) return;

    // Captured once: the ring state is read for the session that rang.
    final sessionId = metadata.session.id;
    if (sessionId.isEmpty) {
      _logger.w(() => '[startRingStatePolling] rejected (no session)');
      return;
    }

    final ringTimeout = metadata.settings.ring.autoCancelTimeout;
    if (ringTimeout <= Duration.zero) return;

    final poller = RingStatePoller(
      settings: settings,
      ringTimeout: ringTimeout,
      fetchRingState: () => _coordinatorClient.getCallRingState(
        callCid: _callCid,
        sessionId: sessionId,
      ),
      onRingState: _onPolledRingState,
    );
    _ringStatePoller = poller;

    unawaited(_ringStatePollerStatusSubscription?.cancel());
    _ringStatePollerStatusSubscription = _stateManager.callStateStream.listen((
      state,
    ) {
      final status = state.status;
      if (status is! CallStatusOutgoing || status.acceptedByCallee) {
        stopRingStatePolling();
      }
    });

    poller.start();
  }

  /// Applies a polled ring state, returning whether the ring is settled.
  bool _onPolledRingState(open.GetCallRingStateResponse ringState) {
    final callState = _stateManager.callState;
    final status = callState.status;
    if (status is! CallStatusOutgoing || status.acceptedByCallee) return true;

    final snapshot = ringState.toRingingSnapshot(
      memberIds: callState.callMembers.map((member) => member.userId),
    );

    final ringingState = snapshot.resolveFor(callState.currentUserId);
    if (!ringingState.isRinging) {
      // A settled ring here means the event that carried it was dropped.
      _logger.i(
        () => '[onPolledRingState] resolved by polling: $ringingState',
      );
    }

    _stateManager.coordinatorOutgoingRingResolved(ringingState, snapshot);
    return !ringingState.isRinging;
  }

  void stopRingStatePolling() {
    _ringStatePoller?.stop();
    _ringStatePoller = null;
    unawaited(_ringStatePollerStatusSubscription?.cancel());
    _ringStatePollerStatusSubscription = null;
  }
}
