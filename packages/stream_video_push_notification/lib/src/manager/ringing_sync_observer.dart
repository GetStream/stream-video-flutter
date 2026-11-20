import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/stream_video.dart';

import 'native_call_controller.dart';

const _idRinging = 2;

/// Applies what the native call UI reports and core does not handle itself:
/// opens the coordinator connection when a call rings, mirrors a native mute
/// onto the call's microphone, and on Android leaves a call Telecom holds.
///
/// Core ends the native call whenever it leaves a call, and dismisses its
/// ring when the user accepts it in the app. Nothing is observed after
/// [dispose].
@internal
class RingingSyncObserver {
  RingingSyncObserver({
    required this._streamVideo,
    required this._client,
    required this._controller,
    required this._ringingEvents,
  });

  final StreamVideo _streamVideo;
  final CoordinatorClient _client;
  final NativeCallController _controller;
  final Stream<RingingEvent> _ringingEvents;

  final _logger = taggedLogger(tag: 'SV:PNSync');

  final Subscriptions _subscriptions = Subscriptions();

  bool _disposed = false;

  /// Starts observing. Called once, on mobile only.
  void start() {
    _subscriptions.add(_idRinging, _ringingEvents.listen(_onRingingEvent));
  }

  /// Opens the connection on a ring, so the backend's events about it
  /// arrive; mirrors a native mute, and leaves a call Telecom holds on
  /// Android.
  void _onRingingEvent(RingingEvent event) {
    switch (event) {
      case ActionCallToggleMute():
        _onToggleMute(event);
      case ActionCallToggleHold():
        if (CurrentPlatform.isAndroid) _onToggleHold(event);
      case ActionCallIncoming():
        if (!_client.isConnected) {
          _client.openConnection();
        }
      default:
        break;
    }
  }

  /// Applies a CallKit mute to the call it names, found through the cid the
  /// native side holds for the event's uuid. When the native side does not
  /// know the uuid or its cid, or cannot be asked, the mute goes to the call
  /// in the ringing flow. When the uuid names a call the app is not in, the
  /// mute is dropped.
  Future<void> _onToggleMute(ActionCallToggleMute event) async {
    _logger.d(
      () =>
          '[onCallEvent] ActionCallToggleMute received: uuid=${event.uuid}, isMuted=${event.isMuted}',
    );

    var nativeCalls = const <CallData>[];
    try {
      nativeCalls = await _controller.activeCalls();
    } catch (e, stk) {
      _logger.w(
        () => '[onCallEvent] Could not read the native calls: $e\n$stk',
      );
    }
    if (_disposed) return;

    final nativeCall = nativeCalls.firstWhereOrNull(
      (call) => call.uuid?.toLowerCase() == event.uuid.toLowerCase(),
    );
    final cid = nativeCall?.callCid;
    final activeCalls = _streamVideo.state.activeCalls.value;
    final call = cid == null
        ? activeCalls.firstWhereOrNull((c) => c.state.value.isRingingFlow)
        : activeCalls.firstWhereOrNull((c) => c.callCid.value == cid);

    if (call != null) {
      await call.setMicrophoneEnabled(enabled: !event.isMuted);
    } else if (cid != null) {
      _logger.w(
        () => '[onCallEvent] Mute dropped: the app is not in call $cid',
      );
    } else {
      _logger.w(() => '[onCallEvent] Cannot toggle mute: no active call');
    }
  }

  /// Leaves the call a Telecom hold names, as the Android SDK does. Telecom
  /// holds a call to make room for another, such as a phone call the user
  /// answered, and does not resume it when that call ends, so a held call
  /// would stay silent. A resume changes nothing.
  ///
  /// The call is found by the cid the event carries, never guessed. An
  /// incoming call the user has not accepted is left alone; Telecom cannot
  /// hold one anyway. An outgoing call is left while it still rings, since
  /// Telecom treats it as active from the start, and leaving cancels the ring.
  ///
  /// Nothing is done while several calls may be active, because Telecom also
  /// holds the call in progress when the user answers another of the app's
  /// calls. A hold there, including one for a phone call, leaves the call
  /// joined with its audio on, and Telecom keeps it held.
  Future<void> _onToggleHold(ActionCallToggleHold event) async {
    _logger.d(
      () =>
          '[onCallEvent] ActionCallToggleHold received: uuid=${event.uuid}, '
          'cid=${event.callCid}, isOnHold=${event.isOnHold}',
    );
    if (!event.isOnHold) return;
    if (_streamVideo.options.allowMultipleActiveCalls) {
      _logger.d(
        () => '[onCallEvent] Hold ignored: several calls may be active',
      );
      return;
    }

    final cid = event.callCid;
    final call = cid == null
        ? null
        : _streamVideo.state.activeCalls.value.firstWhereOrNull(
            (call) => call.callCid.value == cid,
          );
    if (call == null) {
      _logger.w(() => '[onCallEvent] Hold of $cid names no active call');
      return;
    }
    final status = call.state.value.status;
    if (status is CallStatusIncoming && !status.acceptedByMe) {
      _logger.d(() => '[onCallEvent] Hold of $cid ignored: not accepted');
      return;
    }

    try {
      final result = await call.leave(
        reason: const DisconnectReason.left(
          initiator: LeaveInitiator.callkit,
          message: 'Call put on hold',
        ),
      );
      if (result is Failure) {
        _logger.e(
          () => '[onCallEvent] Leaving held $cid failed: ${result.error}',
        );
      }
    } catch (e, stk) {
      _logger.e(() => '[onCallEvent] Leaving held $cid failed: $e\n$stk');
    }
  }

  /// Stops observing.
  void dispose() {
    _disposed = true;
    _subscriptions.cancelAll();
  }
}
