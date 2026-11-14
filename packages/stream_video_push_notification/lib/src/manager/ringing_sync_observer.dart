import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/stream_video.dart';

import 'native_call_controller.dart';
import 'ringing_event_broadcaster.dart';

const _idRinging = 2;
const _idCallEnded = 3;
const _idCallAccepted = 4;
const _idCallRejected = 6;
const _idCallParticipantCount = 7;
const _idActiveCall = 8;

/// Decides whether a `call.accepted` event for the current user describes an acceptance that
/// happened on this device.
@visibleForTesting
bool isAcceptedOnThisDevice({
  required bool acceptedLocally,
  required Call? activeCall,
}) {
  if (acceptedLocally) return true;
  return activeCall?.state.value.status is CallStatusActive;
}

/// Keeps the native call UI in step with what the SDK knows about a ringing
/// call: ends or dismisses it when the backend says the call ended, was
/// rejected, lost its last participant or was accepted on another device,
/// ends it when the app leaves the call, mirrors a native mute onto the
/// call's microphone, and on Android suspends a call's audio while Telecom
/// holds it.
///
/// The backend subscriptions live only while a call rings: they start with
/// the incoming event (or at start-up when the native side still shows a
/// call) and stop with the user's answer. Nothing is observed after
/// [dispose].
@internal
class RingingSyncObserver {
  RingingSyncObserver({
    required this._streamVideo,
    required this._client,
    required this._controller,
    required this._broadcaster,
    required this._ringingEvents,
  });

  final StreamVideo _streamVideo;
  final CoordinatorClient _client;
  final NativeCallController _controller;
  final RingingEventBroadcaster _broadcaster;
  final Stream<RingingEvent> _ringingEvents;

  /// The cids of the calls whose audio a Telecom hold suspended.
  final Set<String> _heldCalls = {};

  final _logger = taggedLogger(tag: 'SV:PNSync');

  final Subscriptions _subscriptions = Subscriptions();

  /// The calls the app is in, as of the last state change.
  List<Call> _currentActiveCalls = [];

  bool _disposed = false;

  /// Starts observing. Called once, on mobile only.
  void start() {
    _subscriptions.add(
      _idActiveCall,
      _streamVideo.state.activeCalls.listen(_onActiveCallsChanged),
    );

    // If there are active calls (for iOS) when connecting, subscribe to events as if the call was incoming.
    _controller
        .activeCalls()
        .then((calls) {
          if (calls.isNotEmpty && !_disposed) {
            _subscribeToEvents();
          }
        })
        .catchError((Object e) {
          _logger.w(() => '[start] Could not read the native calls: $e');
        });

    _subscriptions.add(_idRinging, _ringingEvents.listen(_onRingingEvent));
  }

  /// Ends the native call of every call the app left.
  Future<void> _onActiveCallsChanged(List<Call> calls) async {
    _logger.d(
      () =>
          '[activeCall] Active calls changed to [${calls.map((c) => c.callCid).join(', ')}]',
    );

    for (final previousCall in _currentActiveCalls) {
      if (calls.any((c) => c.callCid == previousCall.callCid)) continue;
      _heldCalls.remove(previousCall.callCid.value);
      _logger.d(
        () => '[activeCall] Stopping previous call: ${previousCall.callCid}',
      );
      await _controller.endCallByCid(previousCall.callCid.value);
      if (_disposed) return;
    }

    _currentActiveCalls = calls;
  }

  /// Starts the backend subscriptions on a ring and stops them with the
  /// user's answer; mirrors a native mute, and a Telecom hold on Android.
  void _onRingingEvent(RingingEvent event) {
    if (event is ActionCallToggleMute) {
      _onToggleMute(event);
    } else if (event is ActionCallToggleHold) {
      if (CurrentPlatform.isAndroid) _onToggleHold(event);
    } else if (event is ActionCallIncoming) {
      if (!_client.isConnected) {
        _client.openConnection();
      }
      _subscribeToEvents();
    } else if (event is ActionCallAccept ||
        event is ActionCallDecline ||
        event is ActionCallTimeout ||
        event is ActionCallEnded) {
      _subscriptions.cancel(_idCallAccepted);
      _subscriptions.cancel(_idCallEnded);
      _subscriptions.cancel(_idCallRejected);
      _subscriptions.cancel(_idCallParticipantCount);
    }
  }

  /// Applies a native mute to the call it names, found by [_callFor].
  Future<void> _onToggleMute(ActionCallToggleMute event) async {
    _logger.d(
      () =>
          '[onCallEvent] ActionCallToggleMute received: uuid=${event.uuid}, isMuted=${event.isMuted}',
    );

    final call = await _callFor(event.uuid, 'Mute');
    if (_disposed || call == null) return;
    await call.setMicrophoneEnabled(enabled: !event.isMuted);
  }

  /// Suspends the audio of the call a Telecom hold names while it is held,
  /// and resumes it with the call. A call whose audio was already suspended,
  /// for example by the multi-call audio policy, is left as it is, then and on
  /// resume. A resume without a hold seen first changes nothing.
  Future<void> _onToggleHold(ActionCallToggleHold event) async {
    _logger.d(
      () =>
          '[onCallEvent] ActionCallToggleHold received: uuid=${event.uuid}, isOnHold=${event.isOnHold}',
    );

    final call = await _callFor(
      event.uuid,
      'Hold',
      fallback: (calls) => calls.singleOrNull,
    );
    if (_disposed || call == null) return;
    final cid = call.callCid.value;

    try {
      if (event.isOnHold) {
        if (_heldCalls.contains(cid) || call.state.value.isAudioSuspended) {
          return;
        }
        _heldCalls.add(cid);
        await call.suspendAudio();
        if (!call.state.value.isAudioSuspended) _heldCalls.remove(cid);
      } else if (_heldCalls.remove(cid)) {
        await call.resumeAudio();
      }
    } catch (e, stk) {
      _logger.e(() => '[onCallEvent] Hold of $cid not applied: $e\n$stk');
    }
  }

  /// The call a native event's [uuid] belongs to, found through the cid the
  /// native side holds for it. When the native side does not know the uuid
  /// or its cid, or cannot be asked, the call [fallback] picks from the active
  /// calls, by default the one in the ringing flow. Null, with a warning
  /// naming [action], when the uuid names a call the app is not in or there
  /// is no call.
  Future<Call?> _callFor(
    String uuid,
    String action, {
    Call? Function(List<Call> calls)? fallback,
  }) async {
    var nativeCalls = const <CallData>[];
    try {
      nativeCalls = await _controller.activeCalls();
    } catch (e, stk) {
      _logger.w(
        () => '[onCallEvent] Could not read the native calls: $e\n$stk',
      );
    }
    if (_disposed) return null;

    final nativeCall = nativeCalls.firstWhereOrNull(
      (call) => call.uuid?.toLowerCase() == uuid.toLowerCase(),
    );
    final cid = nativeCall?.callCid;
    final activeCalls = _streamVideo.state.activeCalls.value;
    final Call? call;
    if (cid != null) {
      call = activeCalls.firstWhereOrNull((c) => c.callCid.value == cid);
    } else if (fallback != null) {
      call = fallback(activeCalls);
    } else {
      call = activeCalls.firstWhereOrNull((c) => c.state.value.isRingingFlow);
    }

    if (call == null && cid != null) {
      _logger.w(
        () => '[onCallEvent] $action dropped: the app is not in call $cid',
      );
    } else if (call == null) {
      _logger.w(() => '[onCallEvent] $action dropped: no active call');
    }
    return call;
  }

  void _subscribeToEvents() {
    _subscriptions.add(
      _idCallEnded,
      _client.events.on<StreamCallEndedEvent>((event) {
        _logger.d(
          () => '[subscribeToEvents] Call ended event: ${event.callCid}',
        );
        _broadcaster.suppressEvent();
        _controller.endCallByCid(event.callCid.toString());
      }),
    );

    _subscriptions.add(
      _idCallParticipantCount,
      _client.events.on<StreamCallSessionParticipantCountUpdatedEvent>((
        event,
      ) async {
        final roleCounts = event.participantsCountByRole.values.map((v) => v);

        final totalCount = roleCounts.isEmpty
            ? 0
            : roleCounts.reduce((a, b) => a + b);

        _logger.d(
          () =>
              '[subscribeToEvents] Participant count updated event: ${event.callCid}, count: $totalCount',
        );
        if (totalCount == 0) {
          _logger.v(
            () =>
                '[subscribeToEvents] No participants left, ending call: ${event.callCid}',
          );

          _broadcaster.suppressEvent();
          await _controller.endCallByCid(event.callCid.toString());
        }
      }),
    );

    _subscriptions.add(
      _idCallRejected,
      _client.events.on<StreamCallRejectedEvent>((event) async {
        _logger.d(
          () =>
              '[subscribeToEvents] Call rejected event: ${event.callCid}, rejected by: ${event.rejectedByUserId}',
        );
        if (event.rejectedByUserId == event.metadata.details.createdBy.id ||
            event.rejectedByUserId == _streamVideo.currentUser.id) {
          _logger.v(
            () =>
                '[subscribeToEvents] Call rejected by the current user or call owner, ending call: ${event.callCid}',
          );

          _broadcaster.suppressEvent();
          await _controller.endCallByCid(event.callCid.toString());
        }
      }),
    );

    _subscriptions.add(
      _idCallAccepted,
      _client.events.on<StreamCallAcceptedEvent>((event) async {
        _logger.d(
          () =>
              '[subscribeToEvents] Call accepted event: ${event.callCid}, accepted by: ${event.acceptedByUserId}',
        );
        if (event.acceptedByUserId != _streamVideo.currentUser.id) return;

        final activeCall = _streamVideo.activeCalls.firstWhereOrNull(
          (call) => call.callCid == event.callCid,
        );

        final acceptedOnThisDevice = isAcceptedOnThisDevice(
          acceptedLocally: _streamVideo.ringing.isCallAcceptedOnThisDevice(
            event.callCid.toString(),
          ),
          activeCall: activeCall,
        );

        // End the CallKit call on this device if the call was accepted on another device
        if (!acceptedOnThisDevice) {
          _logger.v(
            () =>
                '[subscribeToEvents] Call accepted on other device, ending call: ${event.callCid}',
          );
          await _controller.endCallByCid(event.callCid.toString());
        }
        // If the call was accepted on this device, end the Ringing call silently
        // (useful if the call was accepted via the app instead of the CallKit UI)
        else {
          _logger.v(
            () =>
                '[subscribeToEvents] Call accepted on the same device, ending CallKit silently: ${event.callCid}',
          );

          // The call is live on this device from here on, so only the ringing UI goes away.
          _broadcaster.suppressEvent();
          await _controller.dismissRingingCallByCid(event.callCid.toString());
        }
      }),
    );
  }

  /// Stops observing.
  void dispose() {
    _disposed = true;
    _subscriptions.cancelAll();
  }
}
