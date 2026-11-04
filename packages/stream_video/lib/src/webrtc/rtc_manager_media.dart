part of 'rtc_manager.dart';

extension RtcManagerTrackHelper on RtcManager {
  Future<Result<RtcLocalCameraTrack>> flipCamera() async {
    if (CurrentPlatform.isWeb) {
      _logger.e(() => '[switchCamera] rejected (not supported on web)');
      return failureWithError('Not supported on web');
    }

    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.e(() => '[switchCamera] rejected (track is null)');
      return failureWithError('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.e(() => '[switchCamera] rejected (track is not camera)');
      return failureWithError('Track is not camera');
    }

    track.disable();

    try {
      final updatedTrack = await track.flipCamera();
      tracks[updatedTrack.trackId] = updatedTrack;
      return Result.success(updatedTrack);
    } finally {
      // small delay avoids camera being mirrored wrongly for a brief moment
      await Future<void>.delayed(const Duration(milliseconds: 50));
      track.enable();
    }
  }

  Future<Result<RtcLocalCameraTrack>> setVideoInputDevice({
    required RtcMediaDevice device,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is null)');
      return failureWithError('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is not camera)');
      return failureWithError('Track is not camera');
    }

    final transceivers = transceiversManager
        .getTransceiversForTrack(track.trackId)
        .toList();

    final updatedTrack = await track.selectVideoInput(device, transceivers);
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalAudioTrack>> setAudioInputDevice({
    required RtcMediaDevice device,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.audio);
    if (track == null) {
      _logger.d(() => '[setMicrophoneDeviceId] rejected (track is null)');
      return failureWithError(
        'Track is null',
        cause: TrackMissingException(trackType: SfuTrackType.audio),
      );
    }

    if (track is! RtcLocalAudioTrack) {
      _logger.w(() => '[setMicrophoneDeviceId] rejected (track is not audio)');
      return failureWithError('Track is not audio');
    }

    final transceivers = transceiversManager
        .getTransceiversForTrack(track.trackId)
        .toList();

    final RtcLocalAudioTrack updatedTrack;
    try {
      updatedTrack = await track.selectAudioInput(transceivers, device);
    } finally {
      // Switching the input restarts capture, which drops the ADM mute.
      // Reconciled on failure too.
      await reconcileAppleAdmMicrophoneMute();
    }

    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<None>> setAudioOutputDevice({
    required RtcMediaDevice device,
  }) async {
    final audioTracks = tracks.values
        .whereType<RtcRemoteTrack>()
        .where((it) => it.trackType == SfuTrackType.audio)
        .toList();

    if (CurrentPlatform.isWeb) {
      return _setWebAudioOutputDevice(device, audioTracks);
    }

    try {
      // The policy the call's factory was built with, so the session and the
      // factory never disagree.
      final policy = pcFactory.resolvedAudioConfigurationPolicy;
      final configured = await setAppleAudioConfiguration(
        speakerOn: resolveAppleSpeakerOn(
          policy: policy,
          speakerRequested: device.isBuiltInSpeaker,
          earpieceRequested: device.isBuiltInEarpiece,
        ),
        policy: policy,
      );
      if (configured is Failure) {
        _logger.w(
          () =>
              '[setAudioOutputDevice] audio session not configured for '
              '${device.id}: ${configured.videoError.message}',
        );
      }

      // Change the audio output device for all remote audio tracks.
      await rtc.Helper.selectAudioOutput(device.id);
      for (final audioTrack in audioTracks) {
        final updatedTrack = audioTrack.copyWith(audioSinkId: device.id);
        tracks[updatedTrack.trackId] = updatedTrack;
      }

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[setAudioOutputDevice] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Sets the sink id of every remote audio track in [audioTracks] to
  /// [device], as the web selects the audio output per element.
  Future<Result<None>> _setWebAudioOutputDevice(
    RtcMediaDevice device,
    List<RtcRemoteTrack> audioTracks,
  ) async {
    if (!rtc_audio.checkIfAudioOutputChangeSupported()) {
      _logger.w(
        () =>
            '[setAudioOutputDevice] rejected: Audio Output device change is not supported on this browser.',
      );
      return failureWithError(
        'Audio Output device change is not supported on this browser.',
      );
    }

    // Try every track instead of aborting on the first rejection: stopping
    // half way leaves the switched tracks on the new device and the rest on
    // the old one, with no way to record both.
    final applied = <RtcRemoteTrack>[];
    final failures = <(String, Object, StackTrace)>[];

    await Future.wait(
      audioTracks.map((audioTrack) async {
        if (audioTrack.audioSinkId == device.id) {
          applied.add(audioTrack);
          return;
        }

        try {
          applied.add(await audioTrack.setSinkId(device.id));
        } catch (e, stk) {
          failures.add((audioTrack.trackId, e, stk));
        }
      }),
    );

    for (final updatedTrack in applied) {
      tracks[updatedTrack.trackId] = updatedTrack;
    }

    for (final (trackId, error, _) in failures) {
      _logger.w(
        () => '[setAudioOutputDevice] track $trackId rejected: $error',
      );
    }

    if (applied.isEmpty && failures.isNotEmpty) {
      final (_, error, stk) = failures.first;
      _logger.e(() => '[setAudioOutputDevice] rejected: $error');
      return Result.failure(StreamVideoExceptions.compose(error, stk), stk);
    }

    return const Result.success(none);
  }

  Future<Result<RtcLocalCameraTrack>> setCameraPosition({
    required CameraPosition cameraPosition,
  }) {
    final facingMode = cameraPosition.toFacingMode();
    return setTrackFacingMode(facingMode: facingMode);
  }

  Future<Result<RtcLocalTrack>> setCameraEnabled({
    bool enabled = true,
    CameraConstraints? constraints,
  }) {
    return _setTrackEnabled(
      trackType: SfuTrackType.video,
      enabled: enabled,
      constraints: constraints,
    );
  }

  Future<Result<RtcLocalTrack>> setMicrophoneEnabled({
    bool enabled = true,
    AudioConstraints? constraints,
    bool? stopTrackOnMute,
  }) {
    return _setTrackEnabled(
      trackType: SfuTrackType.audio,
      enabled: enabled,
      constraints: constraints,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<Result<RtcLocalTrack>> setScreenShareEnabled({
    bool enabled = true,
    ScreenShareConstraints? constraints,
  }) async {
    if (CurrentPlatform.isIos &&
        enabled &&
        constraints is ScreenShareConstraints &&
        constraints.useiOSBroadcastExtension) {
      final screenShareTrackResult = await createScreenShareTrack(
        constraints: constraints,
      );

      if (screenShareTrackResult.isFailure) {
        _logger.e(
          () =>
              '[ScreenSharingStartedEvent] failed to create screen share track: ${screenShareTrackResult.getErrorOrNull()}',
        );
        return screenShareTrackResult;
      }

      _startListeningToScreenShareStarted(
        screenShareTrackResult.getDataOrNull()!,
      );

      return Future.value(
        Result.success(screenShareTrackResult.getDataOrNull()!),
      );
    } else {
      await _screenSharingStartedSubscription?.cancel();
      return _setTrackEnabled(
        trackType: SfuTrackType.screenShare,
        enabled: enabled,
        constraints: constraints,
      );
    }
  }

  Future<Result<RtcLocalTrack>> _setTrackEnabled({
    required SfuTrackType trackType,
    required bool enabled,
    MediaConstraints? constraints,
    bool? stopTrackOnMute,
  }) async {
    var track = getPublisherTrackByType(trackType);

    // Wait out an in-flight creation before deciding anything.
    //
    // Screen share is left out on the enable side: it deliberately creates a
    // fresh track every time so a new screen can be picked, and waiting here
    // would queue a second picker behind the one still on screen.
    final awaitsCreation =
        track == null && (!enabled || trackType != SfuTrackType.screenShare);

    if (awaitsCreation) {
      final inFlight = _pendingTrackCreations[trackType];
      if (inFlight != null) {
        _logger.i(
          () =>
              '[setTrackEnabled] $trackType is still being created; '
              'waiting for it before applying enabled: $enabled',
        );
        await inFlight;
        track = getPublisherTrackByType(trackType);
      }
    }

    // Track found, mute/unmute it.
    if (track != null) {
      if (enabled && track is RtcLocalScreenShareTrack) {
        // Always create a new screen share track when enabling screen sharing.
        // This ensures correct handling of constraints on iOS and supports selecting different screens on web and desktop platforms.
        return _createAndPublishTrack(
          trackType: trackType,
          constraints: constraints,
        );
      }

      final toggledTrack = await _toggleTrackMuteState(
        track: track,
        muted: !enabled,
        stopTrackOnMute: stopTrackOnMute,
      );

      return Result.success(toggledTrack);
    }

    // Track not found, create a new one and publish it if enabled is true.
    if (enabled) {
      return _createAndPublishTrack(
        trackType: trackType,
        constraints: constraints,
      );
    }

    // Track not found and enabled is false, return error.
    return failureWithError('Track not found and enabled is false');
  }

  Future<RtcLocalTrack> _toggleTrackMuteState({
    required RtcLocalTrack track,
    required bool muted,
    bool? stopTrackOnMute,
  }) async {
    if (muted) {
      await muteTrack(trackId: track.trackId, stopTrackOnMute: stopTrackOnMute);

      // If the track is a screen share track, mute the audio track as well.
      if (track.trackType == SfuTrackType.screenShare) {
        await _detachFromSenders(track.trackId);

        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await muteTrack(trackId: screenShareAudioTrack.trackId);
          await _detachFromSenders(screenShareAudioTrack.trackId);
        }
      }
    } else {
      await unmuteTrack(trackId: track.trackId);

      // If the track is a screen share track, unmute the audio track as well.
      if (track.trackType == SfuTrackType.screenShare) {
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await unmuteTrack(trackId: screenShareAudioTrack.trackId);
        }
      }
    }

    return track;
  }

  /// Takes the track of [trackId] off every sender carrying it.
  ///
  /// For a stopped screen share. Muting leaves the ended track on the sender,
  /// and every announce reports a sender that has a track, so a reconnect or
  /// a migration would tell the SFU the share is still published. Sharing
  /// again always publishes a new track, which puts one back.
  Future<void> _detachFromSenders(String trackId) async {
    for (final transceiver in transceiversManager.getTransceiversForTrack(
      trackId,
    )) {
      try {
        await transceiver.sender.replaceTrack(null);
      } catch (e, stk) {
        _logger.w(() => '[detachFromSenders] failed for $trackId: $e\n$stk');
      }
    }
  }

  /// Acquires media for [trackType] and publishes it.
  ///
  /// Collapsed per track type: a second "enable" arriving while the first is
  /// still in `getUserMedia` joins it rather than opening the camera or
  /// microphone a second time. That is the window the duplicate-publish bug
  /// came through — `tracks` is only populated once acquisition returns, so
  /// until then every caller sees "nothing published yet". A joining caller's
  /// [constraints] are ignored, which matches what it would have observed had
  /// it arrived a moment later and found the track already published.
  Future<Result<RtcLocalTrack>> _createAndPublishTrack({
    required SfuTrackType trackType,
    MediaConstraints? constraints,
  }) {
    return _singleFlightCreate(
      trackType,
      () => _acquireAndPublishTrack(
        trackType: trackType,
        constraints: constraints,
      ),
    );
  }

  Future<Result<RtcLocalTrack>> _acquireAndPublishTrack({
    required SfuTrackType trackType,
    MediaConstraints? constraints,
  }) async {
    if (trackType == SfuTrackType.video) {
      if (constraints != null && constraints is! CameraConstraints) {
        final errorMessage =
            'Invalid media constraints type ${constraints.runtimeType}, $CameraConstraints expected';
        _logger.e(() => errorMessage);
        return failureWithError(errorMessage);
      }

      final cameraTrackResult = await createCameraTrack(
        constraints:
            (constraints ?? const CameraConstraints()) as CameraConstraints,
      );
      return cameraTrackResult.foldResult(
        success: (it) => publishVideoTrack(track: it.data),
        failure: (it) => it,
      );
    } else if (trackType == SfuTrackType.audio) {
      if (constraints != null && constraints is! AudioConstraints) {
        final errorMessage =
            'Invalid media constraints type ${constraints.runtimeType}, $AudioConstraints expected';
        _logger.e(() => errorMessage);
        return failureWithError(errorMessage);
      }

      final audioTrackResult = await createAudioTrack(
        constraints:
            (constraints ?? _defaultAudioConstraints) as AudioConstraints,
      );
      return audioTrackResult.foldResult(
        success: (it) => publishAudioTrack(track: it.data),
        failure: (it) => it,
      );
    } else if (trackType == SfuTrackType.screenShare) {
      if (constraints != null && constraints is! ScreenShareConstraints) {
        final errorMessage =
            'Invalid media constraints type ${constraints.runtimeType}, $ScreenShareConstraints expected';
        _logger.e(() => errorMessage);
        return failureWithError(errorMessage);
      }

      final screenShareTrackResult = await createScreenShareTrack(
        constraints:
            (constraints ?? const ScreenShareConstraints())
                as ScreenShareConstraints,
      );

      return screenShareTrackResult.foldResult(
        success: (it) => publishVideoTrack(track: it.data),
        failure: (it) => it,
      );
    }

    _logger.e(() => 'Unsupported trackType $trackType');
    return failureWithError('Unsupported trackType $trackType');
  }

  void _startListeningToScreenShareStarted(
    RtcLocalTrack<ScreenShareConstraints> track,
  ) {
    _screenSharingStartedSubscription?.cancel();
    _screenSharingStartedSubscription = RtcMediaDeviceNotifier.instance
        .nativeWebRtcEventsStream()
        .whereType<ScreenSharingStartedEvent>()
        .listen((event) async {
          _logger.i(() => '[ScreenSharingStartedEvent] received: $event');

          await publishVideoTrack(track: track);
        });
  }
}
