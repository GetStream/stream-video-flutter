import 'dart:async';

import 'package:meta/meta.dart';

import '../../audio/platform_audio_controller.dart';
import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/media/media_constraints.dart';
import '../../webrtc/media/screen_share_source.dart';
import '../../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../call_connect_options.dart';
import '../call_events.dart';
import '../session/call_session.dart';
import '../state/call_state_notifier.dart';

/// Applies or removes a screen share on the call's session.
typedef ApplyScreenShare =
    Future<Result<None>> Function({
      required bool enabled,
      required ScreenShareConstraints constraints,
    });

/// A call's screen share through the iOS broadcast extension.
///
/// Requesting shows the broadcast picker. Once the broadcast starts, the call
/// that owns it turns its screen share option on, and shares it on the
/// session when that session has applied the connect options. A session
/// still applying them, or the next one, shares it when it applies.
///
/// The broadcast belongs to the call that showed the picker last, or with no
/// request, to the client's only active call.
@internal
class IosBroadcastScreenShare {
  IosBroadcastScreenShare({
    required this._stateManager,
    required this._session,
    required this._hasApplied,
    required this._applyScreenShare,
    required this._readConnectOptions,
    required this._writeConnectOptions,
    required this._defaultConstraints,
    required this._hasPermission,
    required this._rtcMediaDeviceNotifier,
    required this._activeCalls,
    required this._onCallEvent,
    required this._logger,
  });

  static final _broadcast = _Broadcast();

  final CallStateNotifier _stateManager;
  final CallSession? Function() _session;

  /// Whether a session has applied the connect options, during the running
  /// migration or rejoin when there is one.
  final bool Function(CallSession session) _hasApplied;
  final ApplyScreenShare _applyScreenShare;
  final CallConnectOptions Function() _readConnectOptions;
  final void Function(CallConnectOptions options) _writeConnectOptions;

  /// The call's screen share constraints, before they ask for the broadcast
  /// extension.
  final ScreenShareConstraints Function() _defaultConstraints;
  final bool Function(CallPermission permission) _hasPermission;
  final RtcMediaDeviceNotifier Function() _rtcMediaDeviceNotifier;

  /// The shares of the client's active calls.
  final List<IosBroadcastScreenShare> Function() _activeCalls;

  /// Delivers an event on the call's events.
  final void Function(StreamCallEvent event) _onCallEvent;
  final TaggedLogger _logger;

  /// The constraints of the last request, used once the broadcast starts.
  ScreenShareConstraints? _requestedConstraints;

  /// How many broadcast starts this call took.
  int _startsTaken = 0;

  CallState get _state => _stateManager.callState;

  /// Records the broadcast starts and stops of the app, also while no call
  /// observes them, so the next call that joins shares a running broadcast.
  /// Does nothing when already observing.
  static void observeBroadcasts() {
    _broadcast.observe(
      PlatformAudioController.instance.nativeWebRtcEventsStream(),
    );
  }

  /// Whether the broadcast runs, as far as the calls know.
  @visibleForTesting
  static bool get isBroadcastRunning => _broadcast.isRunning;

  /// Forgets whether the broadcast runs and who requested it, and stops
  /// observing the broadcast starts and stops.
  @visibleForTesting
  static void resetOwnership() => _broadcast.reset();

  /// Shows the picker of the broadcast extension. The share starts when the
  /// broadcast does, in [onStarted].
  ///
  /// Fails without showing the picker while the call has no session.
  Future<Result<None>> request(ScreenShareConstraints constraints) async {
    if (_session() == null) {
      return failureWithError(
        'Call session is null, cannot start screen share',
      );
    }
    _requestedConstraints = constraints;
    _broadcast.requester = this;
    try {
      await _rtcMediaDeviceNotifier().presentiOSBroadcastPicker();
      return const Result.success(none);
    } catch (error, stackTrace) {
      _logger.e(() => '[requestBroadcast] failed to show the picker: $error');
      releaseRequest();
      return failureWithError(
        'Failed to show the broadcast picker',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Forgets this call's request, so a broadcast that starts later is not
  /// shared with its constraints, and another call can take a broadcast
  /// nobody requested.
  void releaseRequest() {
    _requestedConstraints = null;
    if (identical(_broadcast.requester, this)) _broadcast.requester = null;
  }

  /// Whether the broadcast runs, as far as the calls know.
  bool get isBroadcasting => _broadcast.isRunning;

  /// Whether [constraints] capture the broadcast extension while it is
  /// broadcasting.
  bool isRunning(ScreenShareConstraints constraints) {
    return _broadcast.isRunning &&
        ScreenShareSource.forPlatform().usesBroadcastExtension(constraints);
  }

  /// Turns the screen share option on for a running broadcast no call has
  /// taken yet, when this call owns it, so the session applying the options
  /// shares it. A broadcast a call took, and maybe stopped sharing since, is
  /// left alone.
  void adoptRunningBroadcast() {
    if (!_broadcast.isRunning || _broadcast.isTaken || !_ownsBroadcast()) {
      return;
    }
    _broadcast.isTaken = true;

    _logger.d(() => '[applyConnectOptions] sharing the running broadcast');
    _enableOption(_requestedConstraints ?? _broadcastConstraints());
  }

  /// Runs [resolve], which writes the connect options a join resolves, and
  /// keeps the screen share option of a broadcast that started before it or
  /// while it ran.
  Future<void> keepBroadcastOptionThrough(
    Future<void> Function() resolve,
  ) async {
    final kept = _broadcast.isRunning ? _broadcastOption() : null;
    final startsTaken = _startsTaken;
    await resolve();
    if (!_broadcast.isRunning) return;

    if (kept != null) {
      _enableOption(kept);
    } else if (_startsTaken != startsTaken) {
      _enableOption(_requestedConstraints ?? _broadcastConstraints());
    }
  }

  /// Records that the broadcast stopped, and turns off a screen share option
  /// that captures it, so a later session does not capture a stopped
  /// broadcast.
  void onStopped() {
    _broadcast.onStopped();
    if (_broadcastOption() == null) return;
    _writeConnectOptions(
      _readConnectOptions().copyWith(screenShare: TrackOption.disabled()),
    );
  }

  /// Turns the screen share option on once the broadcast extension has
  /// started, with the constraints of the last request or the default
  /// broadcast ones, and shares it when the session has applied the options.
  ///
  /// Skipped in a call that does not own the broadcast.
  Future<void> onStarted() async {
    _broadcast.onStarted();

    if (!_ownsBroadcast()) {
      _logger.v(() => '[onBroadcastStarted] shared by another call');
      return;
    }
    _broadcast.isTaken = true;
    if (_state.localParticipant?.isScreenShareEnabled ?? false) {
      _logger.w(() => '[onBroadcastStarted] skipped: a screen share is live');
      return;
    }

    _startsTaken++;
    _enableOption(_requestedConstraints ?? _broadcastConstraints());

    final session = _session();
    if (session == null || !_hasApplied(session)) {
      _logger.i(() => '[onBroadcastStarted] shared once a session applies');
      return;
    }
    await shareRunningBroadcast(session);
  }

  /// Shares the running broadcast the screen share option asks for on
  /// [session], when it is still the call's session and the call is not
  /// sharing yet. Called once a session has applied the connect options, for
  /// a broadcast that started after the apply passed the screen share.
  Future<void> shareRunningBroadcast(CallSession session) async {
    final constraints = _broadcastOption();
    if (constraints == null || !_broadcast.isRunning) return;
    if (!identical(session, _session())) return;
    if (_state.localParticipant?.isScreenShareEnabled ?? false) return;

    _logger.d(() => '[shareRunningBroadcast] sharing the running broadcast');
    await publish(constraints);
  }

  /// Publishes the running broadcast with [constraints]. A missing permission
  /// or a failed share ends the broadcast and is reported as a
  /// [StreamCallScreenShareFailedEvent].
  Future<Result<None>> publish(ScreenShareConstraints constraints) async {
    if (!_hasPermission(CallPermission.screenshare)) {
      _logger.w(() => '[shareBroadcast] missing screenshare permission');
      await _stop();
      _reportFailure(ScreenShareFailureReason.missingPermission);
      return failureWithError(
        'Missing permission to share screen for the user',
      );
    }

    Result<None> result;
    Object? error;
    try {
      result = await _applyScreenShare(enabled: true, constraints: constraints);
      if (result case Failure(error: final failure)) error = failure;
    } catch (thrown, stackTrace) {
      error = thrown;
      result = failureWithError(
        'Failed to share the broadcast',
        cause: thrown,
        stackTrace: stackTrace,
      );
    }
    if (error == null) return result;

    _logger.e(() => '[shareBroadcast] share failed: $error');
    await _stop();
    _reportFailure(ScreenShareFailureReason.publishFailed, error: error);
    return result;
  }

  /// The constraints of a screen share option that captures the broadcast
  /// extension, or null.
  ScreenShareConstraints? _broadcastOption() {
    final option = _readConnectOptions().screenShare;
    if (option is! TrackEnabled) return null;
    final constraints = option.constraints;
    if (constraints is! ScreenShareConstraints) return null;
    return ScreenShareSource.forPlatform().usesBroadcastExtension(constraints)
        ? constraints
        : null;
  }

  void _enableOption(ScreenShareConstraints constraints) {
    _writeConnectOptions(
      _readConnectOptions().copyWith(
        screenShare: TrackOption.enabled(constraints: constraints),
      ),
    );
  }

  ScreenShareConstraints _broadcastConstraints() {
    return _defaultConstraints().copyWith(useiOSBroadcastExtension: true);
  }

  /// Whether this call shares the broadcast: the call that requested it, or
  /// with no request, the client's only active call.
  bool _ownsBroadcast() {
    final requester = _broadcast.requester;
    if (requester != null) return identical(requester, this);
    final calls = _activeCalls();
    return calls.length == 1 && identical(calls.single, this);
  }

  /// Reports a broadcast this call could not share on the call's events.
  void _reportFailure(ScreenShareFailureReason reason, {Object? error}) {
    _onCallEvent(
      StreamCallScreenShareFailedEvent(
        _state.callCid,
        reason: reason,
        error: error,
      ),
    );
  }

  /// Asks the broadcast extension to finish the broadcast this call could
  /// not share, and records it as stopped, as the extension may not report
  /// the stop. The local participant is not sharing.
  Future<void> _stop() async {
    onStopped();
    _stateManager.participantSetScreenShareEnabled(enabled: false);
    try {
      await _rtcMediaDeviceNotifier().stopiOSBroadcast();
    } catch (error) {
      _logger.e(() => '[stopBroadcast] failed: $error');
    }
  }
}

/// The app's broadcast, process-wide, as the app has one broadcast
/// extension: whether it runs, and which call requested it.
class _Broadcast {
  StreamSubscription<NativeWebRtcEvent>? _events;

  /// Whether the broadcast is running, as the last start or stop said.
  bool isRunning = false;

  /// The call that showed the picker last, until the broadcast stops.
  Object? requester;

  /// Whether a call took the running broadcast, so no other call, nor the
  /// same one after the user stopped sharing it, takes it again.
  bool isTaken = false;

  /// Follows the broadcast starts and stops in [events]. Does nothing when
  /// already following.
  void observe(Stream<NativeWebRtcEvent> events) {
    _events ??= events.listen((event) {
      switch (event) {
        case ScreenSharingStartedEvent _:
          onStarted();
        case ScreenSharingStoppedEvent _:
          onStopped();
        default:
          return;
      }
    });
  }

  /// Records a running broadcast. A start while it runs, which each call
  /// also reports, changes nothing.
  void onStarted() {
    if (isRunning) return;
    isRunning = true;
    isTaken = false;
  }

  void onStopped() {
    isRunning = false;
    isTaken = false;
    requester = null;
  }

  void reset() {
    unawaited(_events?.cancel());
    _events = null;
    onStopped();
  }
}
