part of 'call_session.dart';

/// The media calls of a [CallSession], each passed on to its [RtcManager].
///
/// A call made while the session has no manager fails with "Call not
/// connected".
mixin _CallSessionMedia {
  RtcManager? get rtcManager;

  TaggedLogger get _logger;

  Tracer get _zonedTracer;

  abstract int zonedTracerSeq;

  /// Runs [action] on the manager, or fails with "Unable to [what], Call not
  /// connected" when the session has none.
  Future<Result<T>> _withManager<T>(
    String what,
    Future<Result<T>> Function(RtcManager rtcManager) action,
  ) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return failureWithError('Unable to $what, Call not connected');
    }

    return action(rtcManager);
  }

  Future<Result<None>> setLocalTrack(RtcLocalTrack track) {
    _logger.d(() => '[setLocalTrack] track: $track');

    return _withManager('set local track', (rtcManager) async {
      final result = await rtcManager.publishTrack(track);
      return result.map((_) => none);
    });
  }

  /// Gives this session's live local tracks to the session that replaces it.
  /// See [RtcManager.handOverLocalTracks].
  List<RtcLocalTrack> handOverLocalTracks() {
    return rtcManager?.handOverLocalTracks() ?? const [];
  }

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    final trackId = '$trackIdPrefix:$trackType';
    return rtcManager?.getTrack(trackId);
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?rtcManager?.getTracks(trackIdPrefix)];
  }

  SfuTrackType? getTrackType(String trackId) {
    return rtcManager?.getTrack(trackId)?.trackType;
  }

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) {
    return _withManager(
      'set speaker device',
      (rtcManager) => rtcManager.setAudioOutputDevice(device: device),
    );
  }

  Future<Result<RtcLocalTrack>> setCameraEnabled(
    bool enabled, {
    CameraConstraints? constraints,
  }) {
    return _withManager('set camera', (rtcManager) {
      return TracerZone.run(_zonedTracer, ++zonedTracerSeq, () async {
        return rtcManager.setCameraEnabled(
          enabled: enabled,
          constraints: constraints,
        );
      });
    });
  }

  Future<Result<RtcLocalTrack>> setMicrophoneEnabled(
    bool enabled, {
    AudioConstraints? constraints,
    bool? stopTrackOnMute,
  }) {
    return _withManager('set microphone', (rtcManager) {
      return TracerZone.run(_zonedTracer, ++zonedTracerSeq, () async {
        return rtcManager.setMicrophoneEnabled(
          enabled: enabled,
          constraints: constraints,
          stopTrackOnMute: stopTrackOnMute,
        );
      });
    });
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) {
    return _withManager('set audioInput', (rtcManager) async {
      final result = await rtcManager.setAudioInputDevice(device: device);
      return result.map((_) => none);
    });
  }

  Future<Result<RtcLocalTrack>> setScreenShareEnabled(
    bool enabled, {
    ScreenShareConstraints? constraints,
  }) {
    return _withManager(
      'set ScreenShare',
      (rtcManager) => rtcManager.setScreenShareEnabled(
        enabled: enabled,
        constraints: constraints,
      ),
    );
  }

  Future<Result<RtcLocalTrack<CameraConstraints>>> flipCamera() {
    return _withManager(
      'flip camera',
      (rtcManager) => rtcManager.flipCamera(),
    );
  }

  Future<Result<RtcLocalTrack<CameraConstraints>>> setVideoInputDevice(
    RtcMediaDevice device,
  ) {
    return _withManager(
      'set video input',
      (rtcManager) => rtcManager.setVideoInputDevice(device: device),
    );
  }

  Future<Result<None>> setCameraPosition(CameraPosition position) {
    return _withManager('set camera position', (rtcManager) async {
      final result = await rtcManager.setCameraPosition(
        cameraPosition: position,
      );
      return result.map((_) => none);
    });
  }
}
