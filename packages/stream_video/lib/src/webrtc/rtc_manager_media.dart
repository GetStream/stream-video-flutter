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
      final flipped = await _publisher.updateHeldTrack(
        track.trackId,
        (current) => (current as RtcLocalCameraTrack).flipCamera(),
        tag: '[flipCamera]',
      );
      return flipped.map((it) => it as RtcLocalCameraTrack);
    } finally {
      // small delay avoids camera being mirrored wrongly for a brief moment
      await Future<void>.delayed(const Duration(milliseconds: 50));
      track.enable();
    }
  }

  Future<Result<RtcLocalCameraTrack>> setVideoInputDevice({
    required RtcMediaDevice device,
  }) {
    return _publisher.setVideoInputDevice(device);
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

    if (track.mediaConstraints.deviceId == device.id) {
      _logger.i(() => '[setAudioInputDevice] already selected: $device');
      return Result.success(track);
    }

    final Result<RtcLocalTrack> switched;
    try {
      // On web the input is a property of the capture, so it is captured
      // again; elsewhere the platform switches the input of the capture.
      switched = CurrentPlatform.isWeb
          ? await _publisher.recapture(
              track.trackId,
              tag: '[setAudioInputDevice]',
              constraintsFor: (current) => (current as RtcLocalAudioTrack)
                  .mediaConstraints
                  .copyWith(deviceId: device.id),
            )
          : await _publisher.updateHeldTrack(
              track.trackId,
              (current) => (current as RtcLocalAudioTrack).selectAudioInput(
                const [],
                device,
              ),
              tag: '[setAudioInputDevice]',
            );
    } finally {
      // Switching the input restarts capture, which drops the ADM mute.
      // Reconciled on failure too.
      await reconcileAppleAdmMicrophoneMute();
    }

    return switched.map((it) => it as RtcLocalAudioTrack);
  }

  Future<Result<None>> setAudioOutputDevice({
    required RtcMediaDevice device,
  }) async {
    if (CurrentPlatform.isWeb) {
      return _subscriber.setAudioSink(device);
    }

    final audioTracks = _subscriber.audioTracks;

    try {
      // The policy the call's factory was built with, so the session and the
      // factory never disagree.
      final policy = pcFactory.resolvedAudioConfigurationPolicy;
      final configured = await configureAudioSession(
        speakerOn: IosAudioSession.speakerOnFor(device, policy),
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
      await _audioSession.selectOutput(device);
      _subscriber.useAudioOutput(device, audioTracks);

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[setAudioOutputDevice] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
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
      return _startBroadcastShare(constraints);
    }

    await _cancelPendingBroadcast();
    return _setTrackEnabled(
      trackType: SfuTrackType.screenShare,
      enabled: enabled,
      constraints: constraints,
    );
  }

  /// Creates the screen share track of an iOS broadcast at once, and
  /// publishes it when the broadcast extension starts.
  ///
  /// Runs as the screen share's single flight. A broadcast that was created
  /// but never started is cancelled first.
  Future<Result<RtcLocalTrack>> _startBroadcastShare(
    ScreenShareConstraints constraints,
  ) {
    return _publisher.singleFlight(SfuTrackType.screenShare, () async {
      await _cancelPendingBroadcast();
      final generation = _broadcastGeneration;

      final created = await _trackAcquirer.createScreenShareTrack(
        constraints: constraints,
      );
      if (created is! Success<RtcLocalScreenShareTrack>) {
        _logger.e(
          () =>
              '[startBroadcastShare] failed to create screen share track: '
              '${created.getErrorOrNull()}',
        );
        return created;
      }

      // Disabled or disposed while the track was being created.
      if (generation != _broadcastGeneration) {
        _logger.i(() => '[startBroadcastShare] cancelled while creating');
        await created.data.stop();
        return failureWithError('Screen share was cancelled while starting');
      }

      _awaitBroadcastStart(created.data);
      return created;
    });
  }

  /// Publishes [track] on the first start of the broadcast, or stops it when
  /// the broadcast stops before it ever started. Only the first of the two
  /// counts.
  void _awaitBroadcastStart(RtcLocalScreenShareTrack track) {
    _pendingBroadcastTrack = track;
    _pendingBroadcastSubscription = RtcMediaDeviceNotifier.instance
        .nativeWebRtcEventsStream()
        .where(
          (it) =>
              it is ScreenSharingStartedEvent ||
              it is ScreenSharingStoppedEvent,
        )
        .take(1)
        .listen((event) async {
          _logger.i(() => '[awaitBroadcastStart] received: $event');
          _pendingBroadcastSubscription = null;
          _pendingBroadcastTrack = null;

          if (event is! ScreenSharingStartedEvent) return track.stop();

          final published = await publishVideoTrack(track: track);
          if (published.isFailure) {
            _logger.e(
              () =>
                  '[awaitBroadcastStart] publish failed: '
                  '${published.getErrorOrNull()}',
            );
            await track.stop();
          }
        });
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
      final inFlight = _publisher.inFlight(trackType);
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
        await _publisher.detachFromSenders(track.trackId);

        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await muteTrack(trackId: screenShareAudioTrack.trackId);
          await _publisher.detachFromSenders(screenShareAudioTrack.trackId);
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
    return _publisher.singleFlight(
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
    final acquired = await _trackAcquirer.acquire(
      trackType: trackType,
      constraints: constraints,
    );

    return acquired.foldResult(
      success: (it) => _publishAcquired(it.data),
      failure: (it) => it,
    );
  }

  Future<Result<RtcLocalTrack>> _publishAcquired(RtcLocalTrack track) async {
    if (track is RtcLocalAudioTrack) return publishAudioTrack(track: track);
    if (track is RtcLocalVideoTrack) return publishVideoTrack(track: track);

    final message = 'Unsupported track type: ${track.runtimeType}';
    _logger.e(() => message);
    return failureWithError(message);
  }
}
