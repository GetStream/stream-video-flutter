import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_core/stream_core.dart' hide LifecycleState;
import 'package:uuid/uuid.dart';

import '../call/call.dart';
import '../call/call_reject_reason.dart';
import '../call/call_ringing_state.dart';
import '../call/call_type.dart';
import '../coordinator/coordinator_client.dart';
import '../coordinator/models/coordinator_events.dart';
import '../core/client_state.dart';
import '../errors/stream_video_exception.dart';
import '../lifecycle/lifecycle_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../models/call_metadata.dart';
import '../models/call_preferences.dart';
import '../models/call_received_data.dart';
import '../models/call_ringing_data.dart';
import '../models/call_status.dart';
import '../models/disconnect_reason.dart';
import '../push_notification/push_notification_manager.dart';
import '../stream_video.dart' show StreamVideoOptions;
import '../utils/result.dart';
import 'ringing_call_coordinator.dart';

/// Builds the [Call] for a ringing flow.
@internal
typedef RingingCallFactory =
    Call Function(CallRingingData data, {CallPreferences? preferences});

/// Connects the user to the coordinator, as `StreamVideo.connect` does.
@internal
typedef EnsureConnected =
    Future<Result<UserToken>> Function({
      required bool includeUserDetails,
      required bool registerPushDevice,
    });

/// The [RingingCallCoordinator] behind `StreamVideo.ringing`, with the hooks
/// the client drives it through.
@internal
class RingingCallCoordinatorImpl implements RingingCallCoordinator {
  RingingCallCoordinatorImpl({
    required this._state,
    required this._client,
    required this._pushNotificationManager,
    required this._options,
    required this._makeRingingCall,
    required this._ensureConnected,
  });

  final MutableClientState _state;
  final CoordinatorClient _client;
  final PushNotificationManager? Function() _pushNotificationManager;
  final StreamVideoOptions _options;
  final RingingCallFactory _makeRingingCall;
  final EnsureConnected _ensureConnected;

  final _logger = taggedLogger(tag: 'SV:Ringing');

  final Map<String, Timer> _incomingAutoRejectTimers = {};
  final Set<String> _handledIncomingCallCids = {};
  final Set<String> _acceptingCallCids = {};

  List<Call> get _activeCalls => _state.activeCalls.value;

  /// Drops the per-connection ringing bookkeeping. The auto-reject timers
  /// keep running; [dispose] cancels them.
  void clear() {
    _state.ringingCalls.clear();
    _state.locallyAcceptedCalls.clear();
    _acceptingCallCids.clear();
    _handledIncomingCallCids.clear();
  }

  /// Cancels the auto-reject timers and drops the ringing bookkeeping.
  void dispose() {
    for (final timer in _incomingAutoRejectTimers.values) {
      timer.cancel();
    }
    _incomingAutoRejectTimers.clear();
    clear();
  }

  /// The calls built for a ringing flow, for the client to dispose.
  Iterable<Call> get ringingCalls => _state.ringingCalls.values;

  /// Handles a ring and a reject from the coordinator. Answers whether
  /// [event] was one of them.
  bool handleCoordinatorEvent(CoordinatorEvent event) {
    if (event is CoordinatorCallRingingEvent) {
      _onCallRinging(event);
      return true;
    }
    if (event is CoordinatorCallRejectedEvent) {
      unawaited(_onRingingCancelled(event));
      return true;
    }
    return false;
  }

  void _onCallRinging(CoordinatorCallRingingEvent event) {
    if (event.metadata.details.createdBy.id == _state.currentUser.id ||
        !event.data.ringing) {
      return;
    }

    _logger.v(() => '[onCoordinatorEvent] onCallRinging: ${event.data}');
    final cid = event.data.callCid.value;

    // In a edge case where call with the same CID as the incoming call is also an outgoing call
    // we want to use the same Call instance.
    if (_state.outgoingCall.value?.callCid.value == cid) {
      _state.incomingCall.value = _state.outgoingCall.value;
      return;
    }

    if (isCallAcceptedOnThisDevice(cid)) {
      _logger.v(
        () => '[onCoordinatorEvent] already accepted here: ${event.data}',
      );
      return;
    }

    final consumedCall = _state.ringingCalls[cid];
    if (consumedCall != null) {
      _logger.v(
        () => '[onCoordinatorEvent] reusing consumed call: ${event.data}',
      );
      _state.incomingCall.value = consumedCall;
      return;
    }

    final call = _makeRingingCall(event.data);
    _state.ringingCalls[cid] = call;
    _state.incomingCall.value = call;
  }

  /// Ends a ringing call cancelled by the caller.
  ///
  /// Applies only when the caller rejects; other rejections are handled elsewhere.
  Future<void> _onRingingCancelled(CoordinatorCallRejectedEvent event) async {
    final cid = event.callCid.value;
    if (event.rejectedBy.id != event.metadata.details.createdBy.id) return;

    final call = _state.ringingCalls[cid] ?? _state.incomingCall.value;
    if (call == null || call.callCid.value != cid) return;

    final status = call.state.value.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) return;

    _logger.i(
      () => '[onCoordinatorEvent] ringing cancelled by the caller, cid: $cid',
    );

    _cancelIncomingAutoRejectTimerByCid(cid);

    // Leaving, not rejecting: the caller has already withdrawn the call, so
    // there is nothing to tell the coordinator. `leave` clears the ringing
    // cache and `incomingCall` on its way out.
    await call.leave(
      reason: DisconnectReason.cancelled(byUserId: event.rejectedBy.id),
    );
  }

  @override
  StreamSubscription<T>? onRingingEvent<T extends RingingEvent>(
    void Function(T event)? onEvent,
  ) {
    final manager = _pushNotificationManager();
    if (manager == null) {
      _logger.e(() => '[onRingingEvent] rejected (no manager)');
      return null;
    }

    return manager.on<T>(onEvent);
  }

  @override
  Future<bool> consumeAndAcceptActiveCall({
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    final allCalls = await _pushNotificationManager()?.activeCalls();

    // Only consume calls that the user explicitly accepted via the native notification UI.
    final calls = allCalls?.where((c) => c.isAccepted).toList();
    if (calls == null || calls.isEmpty) return false;

    final uuid = calls.first.uuid;
    final cid = calls.first.callCid;
    if (uuid == null || cid == null) return false;

    return _acceptRingingCall(
      'consumeAndAcceptActiveCall',
      uuid: uuid,
      cid: cid,
      onCallAccepted: onCallAccepted,
      callPreferences: callPreferences,
      // During cold start, autoConnect may still be in progress so we need to
      // wait for it to complete.
      connectFirst: true,
      joinAfter: false,
    );
  }

  @override
  CompositeSubscription observeCoreRingingEvents({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) {
    final ringingEventSubscriptions = CompositeSubscription();

    observeCallIncomingRingingEvent()?.addTo(ringingEventSubscriptions);

    observeCallAcceptRingingEvent(
      onCallAccepted: onCallAccepted,
      acceptCallPreferences: acceptCallPreferences,
    )?.addTo(ringingEventSubscriptions);

    observeCallDeclinedRingingEvent()?.addTo(ringingEventSubscriptions);
    observeCallEndedRingingEvent()?.addTo(ringingEventSubscriptions);

    // The incoming and accept events can be emitted before this call (terminated
    // state), in which case they aren't delivered to the subscriptions above at
    // all, so calls that are already displayed - ringing or answered - are
    // picked up here.
    unawaited(
      verifyDisplayedIncomingCalls(
        onCallAccepted: onCallAccepted,
        acceptCallPreferences: acceptCallPreferences,
      ),
    );

    return ringingEventSubscriptions;
  }

  @override
  CompositeSubscription observeCoreRingingEventsForBackground() {
    final ringingEventSubscriptions = CompositeSubscription();

    observeCallIncomingRingingEvent()?.addTo(ringingEventSubscriptions);
    observeCallDeclinedRingingEvent()?.addTo(ringingEventSubscriptions);

    return ringingEventSubscriptions;
  }

  @override
  StreamSubscription<ActionCallAccept>? observeCallAcceptRingingEvent({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) {
    return onRingingEvent<ActionCallAccept>((event) {
      // Ignore call accept event when app is in detached state on Android.
      // The call flow should be handled by consuming the call like in the terminated state.
      if (!CurrentPlatform.isAndroid ||
          _state.appLifecycleState.value != LifecycleState.detached) {
        _onCallAccept(
          event,
          onCallAccepted: onCallAccepted,
          callPreferences: acceptCallPreferences,
        );
      }
    });
  }

  @override
  StreamSubscription<ActionCallIncoming>? observeCallIncomingRingingEvent() {
    return onRingingEvent<ActionCallIncoming>(_onCallIncoming);
  }

  @override
  StreamSubscription<ActionCallDecline>? observeCallDeclinedRingingEvent() {
    return onRingingEvent<ActionCallDecline>(_onCallDecline);
  }

  @override
  StreamSubscription<ActionCallEnded>? observeCallEndedRingingEvent() {
    return onRingingEvent<ActionCallEnded>(_onCallEnded);
  }

  Future<void> _onCallAccept(
    ActionCallAccept event, {
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    _logger.d(() => '[onCallAccept] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    await _acceptRingingCall(
      'acceptIncomingCall',
      uuid: uuid,
      cid: cid,
      onCallAccepted: onCallAccepted,
      callPreferences: callPreferences,
      connectFirst: false,
      joinAfter: true,
    );
  }

  /// Ends the native call for [cid] after the user answered it but the call
  /// could not be set up, so they are not left on an answered call screen with
  /// nothing behind it.
  Future<void> _endUnjoinableNativeCall(String cid) async {
    await _pushNotificationManager()?.endCallByCid(cid);
  }

  /// Consumes and accepts the call the user answered on the native call
  /// screen, and answers whether it did. [connectFirst] connects the user
  /// before consuming the call, and [joinAfter] joins it once accepted.
  ///
  /// A call that cannot be set up has its native call ended. A call another
  /// path on this client already accepted is handed to [onCallAccepted] as is.
  Future<bool> _acceptRingingCall(
    String tag, {
    required String uuid,
    required String cid,
    required bool connectFirst,
    required bool joinAfter,
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    // Before the dedupe guard and before connecting: the user has answered, so
    // the call must not be auto-rejected no matter which path ends up handling
    // it, and on a cold start connecting is the slow part.
    _cancelIncomingAutoRejectTimerByCid(cid);

    if (!_acceptingCallCids.add(cid)) {
      _logger.v(() => '[$tag] already accepting: $cid');
      return false;
    }

    try {
      final accepted = _state.locallyAcceptedCalls[cid];
      if (accepted != null) {
        _logger.v(() => '[$tag] already accepted: $cid');
        onCallAccepted?.call(accepted);
        return true;
      }

      if (connectFirst) {
        final connectResult = await _ensureConnected(
          includeUserDetails: true,
          registerPushDevice: true,
        );
        if (connectResult.isFailure) {
          _logger.e(
            () =>
                '[$tag] failed to connect: '
                '${connectResult.getErrorOrNull()}',
          );
          await _endUnjoinableNativeCall(cid);
          return false;
        }
      }

      final consumeResult = await consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        preferences: callPreferences,
      );

      if (consumeResult.isFailure) {
        _logger.w(
          () =>
              '[$tag] error consuming incoming call: '
              '${consumeResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      final call = consumeResult.getDataOrNull();
      if (call == null) {
        _logger.e(() => '[$tag] no call consumed: $cid');
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      final acceptResult = await call.accept();
      if (acceptResult.isFailure) {
        _logger.w(
          () =>
              '[$tag] error accepting call ($call): '
              '${acceptResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      if (joinAfter) unawaited(call.join());
      onCallAccepted?.call(call);

      return true;
    } finally {
      _acceptingCallCids.remove(cid);
    }
  }

  Future<void> _onCallIncoming(ActionCallIncoming event) async {
    _logger.d(() => '[onCallIncoming] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    return _handleIncomingCall(uuid: uuid, cid: cid);
  }

  @override
  Future<void> verifyDisplayedIncomingCalls({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) async {
    final manager = _pushNotificationManager();
    if (manager == null) return;

    final displayedCalls = await manager.activeCalls();
    _logger.d(
      () => '[verifyDisplayedIncomingCalls] calls: $displayedCalls',
    );

    for (final displayedCall in displayedCalls) {
      final uuid = displayedCall.uuid;
      final cid = displayedCall.callCid;
      if (uuid == null || cid == null) continue;

      if (displayedCall.isAccepted) {
        await _acceptDisplayedIncomingCall(
          uuid: uuid,
          cid: cid,
          onCallAccepted: onCallAccepted,
          callPreferences: acceptCallPreferences,
        );
        continue;
      }

      await _handleIncomingCall(uuid: uuid, cid: cid);
    }
  }

  /// Picks up a call the user answered on the native call screen before the app
  /// was able to observe the [ActionCallAccept] for it.
  Future<void> _acceptDisplayedIncomingCall({
    required String uuid,
    required String cid,
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    // iOS only: handles accepting calls answered via CallKit before Dart runs.
    if (!CurrentPlatform.isIos) {
      _logger.v(() => '[acceptDisplayedCall] skipped (not iOS): $cid');
      return;
    }

    if (_activeCalls.any((call) => call.callCid.value == cid)) {
      _logger.v(() => '[acceptDisplayedCall] already joined: $cid');
      return;
    }

    if (isCallAcceptedOnThisDevice(cid)) {
      _logger.v(() => '[acceptDisplayedCall] already accepted: $cid');
      return;
    }

    _logger.d(() => '[acceptDisplayedCall] answered before subscribing: $cid');

    await _acceptRingingCall(
      'acceptIncomingCall',
      uuid: uuid,
      cid: cid,
      onCallAccepted: onCallAccepted,
      callPreferences: callPreferences,
      connectFirst: false,
      joinAfter: true,
    );
  }

  Future<void> _handleIncomingCall({
    required String uuid,
    required String cid,
  }) async {
    // The same call can be reported by the incoming call event and by the
    // displayed calls verification at the same time.
    if (!_handledIncomingCallCids.add(cid)) {
      _logger.v(() => '[handleIncomingCall] already handling: $cid');
      return;
    }

    try {
      await _verifyAndConsumeIncomingCall(uuid: uuid, cid: cid);
    } finally {
      _handledIncomingCallCids.remove(cid);
    }
  }

  Future<void> _verifyAndConsumeIncomingCall({
    required String uuid,
    required String cid,
  }) async {
    // The incoming call UI is already on screen at this point on iOS where the OS
    // requires the CallKit call to be reported as soon as the VoIP push is
    // received. Verify the call is still ringing and dismiss it if it isn't.
    final callCid = StreamCallCid(cid: cid);
    final metadata = await _getCallForRingingEvent(callCid);

    if (metadata == null) {
      // The state couldn't be verified. Keep ringing instead of dismissing a
      // call that might still be valid, consumeIncomingCall retries the fetch.
      _logger.w(
        () => '[verifyIncomingCall] could not verify ringing state: $cid',
      );
    } else {
      final ringingState = metadata.ringingStateFor(_state.currentUser.id);

      if (!ringingState.isRinging) {
        // Never end the native call when it's already being answered on this
        // device (in the app or on the native call screen while the state was
        // still being verified), as that would tear down the ongoing call.
        if (await _isAnsweredOnThisDevice(cid)) {
          _logger.d(
            () =>
                '[verifyIncomingCall] call is no longer ringing ($ringingState) '
                'but is answered on this device, keeping it: $cid',
          );
          return;
        }

        _logger.d(
          () =>
              '[verifyIncomingCall] call is no longer ringing ($ringingState), '
              'dismissing incoming call UI: $cid',
        );

        // Silently, as the ringing flow is already resolved and the native end
        // must not be reported back as a decline/ended action.
        await _pushNotificationManager()?.endCallByCid(cid, silent: true);

        _cancelIncomingAutoRejectTimerByCid(cid);
        await _resolveStaleIncomingCall(cid, ringingState);
        return;
      }
    }

    final consumeResult = await consumeIncomingCall(
      uuid: uuid,
      cid: cid,
      metadata: metadata,
    );

    final incomingCall = consumeResult.getDataOrNull();
    if (incomingCall == null) return;

    final timeout = incomingCall.state.value.settings.ring.autoRejectTimeout;
    _startIncomingAutoRejectTimer(incomingCall, timeout);
  }

  /// Fetches the call state used to decide whether the incoming call UI should
  /// stay on screen. Returns `null` when the state can't be established.
  ///
  /// The push is often delivered while the client is still starting up (cold
  /// start after the app was terminated), and `getCall` only waits for the
  /// coordinator connection, it doesn't establish it. Connecting first is what
  /// makes the check work in that case instead of timing out and leaving a
  /// resolved call ringing.
  Future<CallMetadata?> _getCallForRingingEvent(StreamCallCid callCid) async {
    final connectResult = await _ensureConnected(
      includeUserDetails: _options.includeUserDetailsForAutoConnect,
      // The device is registered already, otherwise the push wouldn't have been
      // delivered. Registering it is not this flow's concern.
      registerPushDevice: false,
    );

    if (connectResult.isFailure) {
      _logger.e(
        () =>
            '[getCallForRingingEvent] failed to connect: '
            '${connectResult.getErrorOrNull()}',
      );
      return null;
    }

    final callResult = await _client.getCall(callCid: callCid);
    if (callResult is! Success<CallReceivedData>) {
      _logger.e(
        () =>
            '[getCallForRingingEvent] failed to get call: '
            '${callResult.getErrorOrNull()}',
      );
      return null;
    }

    return callResult.data.metadata;
  }

  @override
  bool isCallAcceptedOnThisDevice(String cid) =>
      _state.locallyAcceptedCalls.containsKey(cid);

  /// Whether the call is already being answered on this device, either in the
  /// app or on the native call screen.
  Future<bool> _isAnsweredOnThisDevice(String cid) async {
    // Covers the window between accepting and [Call.join] marking the call
    // active, which is where the integrator's own navigation happens when the
    // call is answered from a terminated state.
    if (isCallAcceptedOnThisDevice(cid)) return true;

    if (_activeCalls.any((call) => call.callCid.value == cid)) return true;

    // The native call is marked as accepted from the moment it's answered on the
    // native call screen, before the call is joined in the app.
    final nativeCalls = await _pushNotificationManager()?.activeCalls();
    return nativeCalls?.any(
          (call) => call.callCid == cid && call.isAccepted,
        ) ??
        false;
  }

  /// Brings the in-app incoming call in sync with a ringing flow that turned
  /// out to be already resolved.
  Future<void> _resolveStaleIncomingCall(
    String cid,
    CallRingingState ringingState,
  ) async {
    final incomingCall = _state.incomingCall.value;
    if (incomingCall == null || incomingCall.callCid.value != cid) return;

    _logger.d(
      () => '[resolveStaleIncomingCall] cid: $cid, state: $ringingState',
    );

    await incomingCall.leave(
      reason: DisconnectReason.rejected(
        byUserId: _state.currentUser.id,
        reason: ringingState.toReason(),
      ),
    );

    if (identical(_state.incomingCall.value, incomingCall)) {
      await _state.setIncomingCall(null);
    }
  }

  Future<void> _onCallDecline(ActionCallDecline event) async {
    _logger.d(() => '[onCallDecline] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    _cancelIncomingAutoRejectTimerByCid(cid);

    final call = await consumeIncomingCall(uuid: uuid, cid: cid);
    final callToReject = call.getDataOrNull();
    if (callToReject == null) return;

    final result = await callToReject.reject(
      reason: CallRejectReason.decline(),
    );

    if (result is Failure) {
      _logger.d(() => '[onCallDecline] error rejecting call: ${result.error}');
    }
  }

  /// ActionCallEnded event is sent by native side of stream_video_push_notification package when the call is ended.
  /// On iOS this is connected to CallKit and should end active call or reject incoming call.
  /// On Android this is connected to push notification being dismissed.
  /// When app is terminated it can be send even when accepting the call. That's why we only handle
  /// it on iOS, unless the event carries [CallData.endedBySystem]: a hang-up reported by the
  /// Android Telecom stack (paired watch, headset, car head unit) is unambiguous and has to be
  /// applied, otherwise the call keeps running after the system has already ended it.
  Future<void> _onCallEnded(ActionCallEnded event) async {
    if (CurrentPlatform.isAndroid && !event.data.endedBySystem) return;

    _logger.d(() => '[onCallEnded] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    _cancelIncomingAutoRejectTimerByCid(cid);

    final activeCall = _activeCalls.firstWhereOrNull(
      (call) => call.callCid.value == cid,
    );
    final incomingCall = _state.incomingCall.value;

    if (activeCall?.callCid.value == cid) {
      final result = await activeCall?.leave(
        reason: DisconnectReason.callEnded(),
      );

      if (result is Failure) {
        _logger.d(() => '[onCallEnded] error leaving call: ${result.error}');
      }
    } else if (incomingCall?.callCid.value == cid) {
      final status = incomingCall?.state.value.status;
      if (status is CallStatusIncoming && !status.acceptedByMe) {
        final result = await incomingCall?.reject(
          reason: CallRejectReason.callEnded(),
        );
        if (result is Failure) {
          _logger.d(
            () =>
                '[onCallEnded] error rejecting incoming call: ${result.error}',
          );
        }
      } else {
        _logger.v(() => '[onCallEnded] skip reject (status: $status)');
      }
    }
  }

  void _startIncomingAutoRejectTimer(Call call, Duration timeout) {
    if (timeout <= Duration.zero) return;
    final cid = call.callCid.value;

    _incomingAutoRejectTimers[cid]?.cancel();
    _incomingAutoRejectTimers[cid] = Timer(timeout, () async {
      try {
        // Also guards against a stale timer: an accepted call is never
        // rejected here, whoever forgot to cancel.
        final status = call.state.value.status;
        if (status is CallStatusIncoming && !status.acceptedByMe) {
          await call.reject(reason: CallRejectReason.timeout());
        }
      } catch (e) {
        _logger.e(() => '[incomingTimeout] failed cid: $cid: $e');
      } finally {
        _incomingAutoRejectTimers.remove(cid);
      }
    });
  }

  void _cancelIncomingAutoRejectTimerByCid(String cid) {
    final timer = _incomingAutoRejectTimers.remove(cid);
    timer?.cancel();
  }

  @override
  Future<bool> handleRingingFlowNotifications(
    Map<String, dynamic> payload, {
    bool handleMissedCall = true,
  }) async {
    _logger.d(() => '[handleRingingFlowNotifications] payload: $payload');
    final manager = _pushNotificationManager();
    if (manager == null) {
      _logger.e(() => '[handleRingingFlowNotifications] rejected (no manager)');
      return false;
    }

    // Only handle messages from stream.video
    if (!StreamPushPayload.isStreamPush(payload)) return false;

    final callCid = StreamPushPayload.callCidOf(payload);
    if (callCid == null) return false;

    final callUUID = const Uuid().v4();
    var callId = const Uuid().v4();
    var callType = StreamCallType.defaultType();

    final splitCid = callCid.split(':');
    if (splitCid.length == 2) {
      callType = StreamCallType.fromString(splitCid.first);
      callId = splitCid.last;
    }

    final createdById = payload[StreamPushPayload.createdByIdKey] as String?;
    final createdByName =
        payload[StreamPushPayload.createdByDisplayNameKey] as String?;
    final callDisplayName =
        payload[StreamPushPayload.callDisplayNameKey] as String?;

    final hasVideo = payload[StreamPushPayload.videoKey] as String?;

    if (handleMissedCall && StreamPushPayload.isMissedCallPush(payload)) {
      unawaited(
        manager.showMissedCall(
          uuid: callUUID,
          handle: createdById,
          callerName: (callDisplayName?.isNotEmpty ?? false)
              ? callDisplayName
              : createdByName,
          callCid: callCid,
        ),
      );

      return true;
    } else if (!StreamPushPayload.isRingingPush(payload)) {
      return false;
    }

    final callRingingState = await getCallRingingState(
      callType: callType,
      id: callId,
    );

    switch (callRingingState) {
      case CallRingingState.ringing:
        unawaited(
          manager.showIncomingCall(
            uuid: callUUID,
            handle: createdById,
            callerName: (callDisplayName?.isNotEmpty ?? false)
                ? callDisplayName
                : createdByName,
            callCid: callCid,
            hasVideo: hasVideo != 'false',
          ),
        );
        return true;
      case CallRingingState.accepted:
        return false;
      case CallRingingState.rejected:
        return false;
      case CallRingingState.ended:
        return false;
    }
  }

  @override
  Future<CallRingingState> getCallRingingState({
    required StreamCallType callType,
    required String id,
  }) async {
    final callResult = await _client.getCall(
      callCid: StreamCallCid.from(type: callType, id: id),
      ringing: false,
      notify: false,
      video: false,
    );

    return callResult.foldResult(
      failure: (failure) {
        _logger.e(() => '[getCallRingingState] failed: $failure');
        return CallRingingState.ended;
      },
      success: (success) {
        final state = success.data.metadata.ringingStateFor(
          _state.currentUser.id,
        );
        _logger.d(() => '[getCallRingingState] state: $state');
        return state;
      },
    );
  }

  @override
  Future<Result<Call>> consumeIncomingCall({
    required String uuid,
    required String cid,
    CallPreferences? preferences,
    CallMetadata? metadata,
  }) async {
    _logger.d(() => '[consumeIncomingCall] uuid: $uuid, cid: $cid');
    final manager = _pushNotificationManager();
    if (manager == null) {
      return const Result.failure(
        StreamVideoException(
          message: 'Push notification manager not initialized.',
        ),
      );
    }

    // If call was already created by consuming ringing event, use the same instance.
    final existingCall = _state.ringingCalls[cid] ?? _state.incomingCall.value;
    if (existingCall?.callCid.value == cid) {
      final call = existingCall!;
      if (preferences != null) {
        call.updateCallPreferences(preferences);
      }
      return Result.success(call);
    }

    final callCid = StreamCallCid(cid: cid);

    var callMetadata = metadata;
    if (callMetadata == null) {
      final callResult = await _client.getCall(callCid: callCid);
      if (callResult is! Success<CallReceivedData>) {
        return callResult as Failure;
      }

      callMetadata = callResult.data.metadata;

      // Re-check: a concurrent consume for the same cid may have populated the
      // cache while the fetch above was in flight.
      final cached = _state.ringingCalls[cid] ?? _state.incomingCall.value;
      if (cached?.callCid.value == cid) {
        if (preferences != null) {
          cached!.updateCallPreferences(preferences);
        }
        return Result.success(cached!);
      }
    }

    final call = _makeRingingCall(
      CallRingingData(
        callCid: callCid,
        ringing: true,
        metadata: callMetadata,
      ),
      preferences: preferences ?? _options.defaultCallPreferences,
    );

    _state.ringingCalls[cid] = call;

    return Result.success(call);
  }
}
