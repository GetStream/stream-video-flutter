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
/// ends it when the app leaves the call, and mirrors a CallKit mute onto the
/// call's microphone.
///
/// The backend subscriptions live only while a call rings: they start with
/// the incoming event (or at start-up when the native side still shows a
/// call) and stop with the user's answer.
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

  final _logger = taggedLogger(tag: 'SV:PNSync');

  final Subscriptions _subscriptions = Subscriptions();

  /// The calls the app is in, as of the last state change.
  List<Call> _currentActiveCalls = [];

  /// Starts observing. Called once, on mobile only.
  void start() {
    _subscriptions.add(
      _idActiveCall,
      _streamVideo.state.activeCalls.listen((calls) async {
        _logger.d(
          () =>
              '[activeCall] Active calls changed to [${calls.map((c) => c.callCid).join(', ')}]',
        );

        for (final previousCall in _currentActiveCalls) {
          if (!calls.any((c) => c.callCid == previousCall.callCid)) {
            _logger.d(
              () =>
                  '[activeCall] Stopping previous call: ${previousCall.callCid}',
            );
            await _controller.endCallByCid(previousCall.callCid.value);
          }
        }

        _currentActiveCalls = calls;
      }),
    );

    // If there are active calls (for iOS) when connecting, subscribe to events as if the call was incoming.
    _controller.activeCalls().then((calls) {
      if (calls.isNotEmpty) {
        _subscribeToEvents();
      }
    });

    _subscriptions.add(
      _idRinging,
      _ringingEvents.listen((event) {
        if (event is ActionCallToggleMute) {
          _onToggleMute(event);
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
      }),
    );
  }

  /// Applies a CallKit mute to the call it names. The native side reports the
  /// call's uuid; the matching active call is found through the cid the
  /// native side holds for that uuid. A uuid the native side no longer knows
  /// falls back to the call in the ringing flow, as every mute did before.
  Future<void> _onToggleMute(ActionCallToggleMute event) async {
    _logger.d(
      () =>
          '[onCallEvent] ActionCallToggleMute received: uuid=${event.uuid}, isMuted=${event.isMuted}',
    );

    // The lookup is a method-channel round trip; a failure there must not
    // cost the mute, so it falls back to the rule below.
    var nativeCalls = const <CallData>[];
    try {
      nativeCalls = await _controller.activeCalls();
    } catch (e, stk) {
      _logger.w(
        () => '[onCallEvent] Could not read the native calls: $e\n$stk',
      );
    }
    final nativeCall = nativeCalls.firstWhereOrNull(
      (call) => call.uuid?.toLowerCase() == event.uuid.toLowerCase(),
    );
    final cid = nativeCall?.callCid;
    final call =
        (cid == null
            ? null
            : _currentActiveCalls.firstWhereOrNull(
                (c) => c.callCid.value == cid,
              )) ??
        _currentActiveCalls.firstWhereOrNull(
          (c) => c.state.value.isRingingFlow,
        );

    if (call != null) {
      await call.setMicrophoneEnabled(enabled: !event.isMuted);
    } else {
      _logger.w(() => '[onCallEvent] Cannot toggle mute: no active call');
    }
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
    _subscriptions.cancelAll();
  }
}
