import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../stream_video_flutter.dart';

/// Opens the camera the outgoing screen previews. See
/// [StreamRingingCameraController].
///
/// Injectable because [RtcLocalTrack]'s factories are static, so a test has no
/// other way to produce a track.
@visibleForTesting
typedef RingingCameraTrackOpener = Future<RtcLocalCameraTrack> Function();

/// The microphone and camera an outgoing call will be placed with, and the
/// camera track the ringing screen shows behind its blur.
///
/// The track is written into [Call.connectOptions] as [TrackOption.provided]
/// the moment it opens, so the call carries on with the camera the caller was
/// already previewing rather than opening a second one when the callee picks
/// up.
class StreamRingingCameraController extends ChangeNotifier {
  /// Creates a controller previewing the camera [call] will be placed with.
  StreamRingingCameraController({
    required this.call,
    @visibleForTesting RingingCameraTrackOpener? openCameraTrack,
  }) : _openCameraTrack = openCameraTrack {
    // The call was created with a camera preference; the preview starts in
    // whatever state that named.
    if (call.connectOptions.camera.isEnabled) {
      unawaited(setCameraEnabled(enabled: true));
    }
  }

  late final _logger = taggedLogger(tag: 'SV:RingingCamera');

  /// The call being placed.
  final Call call;

  final RingingCameraTrackOpener? _openCameraTrack;

  RtcLocalCameraTrack? _cameraTrack;
  StreamDeviceError? _cameraError;
  bool _opening = false;
  bool _cameraDesired = false;
  bool _disposed = false;

  /// The running camera, or null while it is off or still opening.
  RtcLocalCameraTrack? get cameraTrack => _cameraTrack;

  /// Why the camera could not be opened, if it could not be.
  ///
  /// Ringing carries on regardless: a camera that will not start is not a
  /// reason to stop the call from being placed.
  StreamDeviceError? get cameraError => _cameraError;

  /// Whether the camera is running.
  ///
  /// Not [CallConnectOptions.camera]'s own `isEnabled`, which reads false for
  /// a provided track: once the preview is running the option holds the track
  /// rather than a request to open one.
  bool get cameraEnabled => _cameraTrack != null;

  /// Whether the call will be placed with the microphone open.
  bool get microphoneEnabled => call.connectOptions.microphone.isEnabled;

  /// Turns the camera on if it is off, and off if it is on.
  Future<void> toggleCamera() => setCameraEnabled(enabled: !cameraEnabled);

  /// Opens the camera, or closes it.
  Future<void> setCameraEnabled({required bool enabled}) async {
    _cameraDesired = enabled;

    if (!enabled) {
      final track = _cameraTrack;
      _cameraTrack = null;
      call.connectOptions = call.connectOptions.copyWith(
        camera: TrackOption.disabled(),
      );
      _notify();
      await track?.stop();
      return;
    }

    if (_cameraTrack != null || _opening) return;
    await _openCamera();
  }

  /// Turns the microphone on if it is off, and off if it is on.
  void toggleMicrophone() => setMicrophoneEnabled(enabled: !microphoneEnabled);

  /// Records whether the call should be placed with the microphone open.
  ///
  /// Nothing is opened here — there is no preview to feed, and the call opens
  /// the microphone itself when it connects.
  void setMicrophoneEnabled({required bool enabled}) {
    call.connectOptions = call.connectOptions.copyWith(
      microphone: TrackOption.fromSetting(enabled: enabled),
    );
    _notify();
  }

  Future<void> _openCamera() async {
    _opening = true;
    _notify();

    try {
      final track = await _open();

      // The user can turn the camera off, or leave, while the platform is
      // still opening it. The track that lands then has no owner.
      if (_disposed || !_cameraDesired) {
        _opening = false;
        await track.stop();
        return;
      }

      _cameraTrack = track;
      _cameraError = null;
      call.connectOptions = call.connectOptions.copyWith(
        camera: TrackOption.provided(track),
      );
    } catch (e, stk) {
      _logger.e(() => 'Error creating camera track: $e\n$stk');
      _cameraError = StreamDeviceError.from(e, stk);
      // The call is still placed, with the camera off rather than pending.
      call.connectOptions = call.connectOptions.copyWith(
        camera: TrackOption.disabled(),
      );
    }

    _opening = false;
    _notify();
  }

  Future<RtcLocalCameraTrack> _open() async {
    if (_openCameraTrack case final open?) return open();
    return RtcLocalTrack.camera(
      nativeFactory: await call.ensureNativeFactory(),
    );
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    // Set first: an open already in flight reads this to decide whether the
    // track it is about to produce has an owner.
    _disposed = true;

    // A call that is going ahead owns the track now — it was handed over as
    // TrackOption.provided, and stopping it here would cut the video the
    // caller just joined with. A call that was cancelled or refused leaves
    // nobody to turn the camera off but this.
    if (!_callIsGoingAhead) {
      _cameraTrack?.stop().onError((e, stk) {
        _logger.e(() => 'Error stopping the camera track: $e\n$stk');
      });
    }

    _cameraTrack = null;
    super.dispose();
  }

  bool get _callIsGoingAhead => switch (call.state.value.status) {
    CallStatusOutgoing(:final acceptedByCallee) => acceptedByCallee,
    CallStatusIdle() || CallStatusDisconnected() => false,
    _ => true,
  };
}
