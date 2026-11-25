import 'dart:async';
import 'dart:math';

import 'package:async/async.dart' show CancelableOperation;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';
import 'package:synchronized/synchronized.dart';

import '../../../open_api/video/coordinator/api.dart' hide User;
import '../../audio/platform_audio_controller.dart';
import '../../call_state.dart';
import '../../errors/stream_video_exception.dart';
import '../../internal/_background_mute_policy.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/audio_configuration_policy.dart';
import '../../models/models.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/extensions.dart';
import '../../utils/future.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/apple_audio_route.dart';
import '../../webrtc/media/media_constraints.dart';
import '../../webrtc/media/screen_share_source.dart';
import '../../webrtc/model/rtc_video_parameters.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_media_device/device_enumeration_trigger.dart';
import '../../webrtc/rtc_media_device/rtc_media_device.dart';
import '../../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../../webrtc/rtc_track/rtc_track.dart';
import '../call_connect_options.dart';
import '../call_events.dart';
import '../session/call_session.dart';
import '../state/call_state_notifier.dart';
import '../stats/sfu_stats_reporter.dart';
import 'ios_broadcast_screen_share.dart';
import '../../webrtc/webrtc_engine.dart';

/// Owns a call's connect options and its local media: the camera,
/// microphone and screen share, and the audio and video devices.
@internal
class LocalMediaController {
  LocalMediaController({
    required this._stateManager,
    required this._session,
    required this._sfuStatsReporter,
    required this._hasPermission,
    required this._rtcMediaDeviceNotifier,
    required this._audioConfigurationPolicy,
    required this._muteVideoWhenInBackground,
    required this._muteAudioWhenInBackground,
    required this._onMicrophoneMuted,
    required this._onAudioOutputDeviceSet,
    required this._activeCalls,
    required this._onCallEvent,
    required this._logger,
  });

  final CallStateNotifier _stateManager;
  final CallSession? Function() _session;
  final SfuStatsReporter? Function() _sfuStatsReporter;
  final bool Function(CallPermission permission) _hasPermission;
  final RtcMediaDeviceNotifier Function() _rtcMediaDeviceNotifier;
  final AudioConfigurationPolicy Function() _audioConfigurationPolicy;
  final bool Function() _muteVideoWhenInBackground;
  final bool Function() _muteAudioWhenInBackground;
  final Future<void> Function(bool muted) _onMicrophoneMuted;

  /// Mirrors an output WebRTC now uses into the system call, whose route can
  /// win over WebRTC's. Not awaited.
  final Future<void> Function(RtcMediaDevice device) _onAudioOutputDeviceSet;

  /// The controllers of the client's active calls, which share an iOS
  /// broadcast no call requested.
  final List<LocalMediaController> Function() _activeCalls;

  /// Delivers an event this controller raises on the call's events.
  final void Function(StreamCallEvent event) _onCallEvent;
  final TaggedLogger _logger;

  final _multitaskingCameraLock = Lock();
  final _backgroundLock = Lock();
  final _sfuStatsTimers = <CancelableOperation<void>>{};

  /// Whether going to the background turned the camera off, so coming back
  /// turns it on again.
  bool _cameraMutedInBackground = false;

  /// Whether going to the background turned the microphone off, so coming
  /// back turns it on again.
  bool _microphoneMutedInBackground = false;

  /// Whether the app is in the background, between [onAppPaused] and
  /// [onAppResumed].
  bool _isAppPaused = false;

  /// The screen share through the iOS broadcast extension.
  late final IosBroadcastScreenShare _broadcast = IosBroadcastScreenShare(
    stateManager: _stateManager,
    session: _session,
    hasApplied: _hasAppliedInCurrentConnect,
    applyScreenShare: _applyScreenShare,
    readConnectOptions: () => _connectOptions,
    writeConnectOptions: (options) => _connectOptions = options,
    defaultConstraints: _defaultScreenShareConstraints,
    hasPermission: _hasPermission,
    rtcMediaDeviceNotifier: _rtcMediaDeviceNotifier,
    activeCalls: () => [for (final media in _activeCalls()) media._broadcast],
    onCallEvent: _onCallEvent,
    logger: _logger,
  );

  /// Whether the platform interrupts the call's audio with the microphone to
  /// be off for it.
  bool _muteMicrophoneWhileInterrupted = false;

  /// Whether the microphone was turned off for an interruption, and is to be
  /// turned back on when it ends.
  bool _microphoneMutedByInterruption = false;

  CallConnectOptions _connectOptions = const CallConnectOptions();

  /// The options [setConnectOptions] set last. Each join attempt merges them
  /// over the call settings, until a session applies the options.
  CallConnectOptions? _connectOptionsOverride;

  /// The camera resolution [setCameraTargetResolution] asked for. It wins
  /// over the call settings each time they are applied.
  StreamTargetResolution? _requestedTargetResolution;

  /// Whether a join has applied the call settings, after which a change is
  /// also merged into the resolved options.
  bool _joinSettingsApplied = false;

  /// The session that started applying the options. While it is the call's
  /// session, they can only change through the device methods.
  CallSession? _optionsAppliedBy;

  /// The session that last finished applying the options, also when the
  /// apply failed.
  CallSession? _optionsAppliedTo;

  /// The call's status when [_optionsAppliedTo] finished applying them.
  CallStatus? _optionsAppliedDuring;

  /// Whether the connect options' audio output went to the system route on
  /// join. A rejoin or a migration applies it again to WebRTC only: the
  /// system may have moved the route since, to a car or a headset.
  bool _audioOutputRoutedOnJoin = false;

  CallState get _state => _stateManager.callState;

  /// The options the next session starts with: an override set before the
  /// join, or the options the call resolved.
  CallConnectOptions get connectOptions => _joinSettingsApplied
      ? _connectOptions
      : _connectOptionsOverride ?? _connectOptions;

  /// Changes the options the pending join applies. Fails once the call's
  /// session has started applying them.
  Result<None> setConnectOptions(CallConnectOptions connectOptions) {
    // A session that failed and was replaced, as by a join retry, leaves the
    // options to the next one.
    final appliedBy = _optionsAppliedBy;
    if (appliedBy != null && identical(appliedBy, _session())) {
      _logger.w(
        () =>
            '[setConnectOptions] rejected (the session already applied the '
            'connect options)',
      );
      return failureWithError(
        'The session already applied the connect options. Change the devices '
        'through the call instead.',
      );
    }

    _logger.d(() => '[setConnectOptions] connectOptions: $connectOptions');
    _connectOptionsOverride = connectOptions;
    if (_joinSettingsApplied) {
      _connectOptions = _connectOptions.merge(connectOptions);
    }
    return const Result.success(none);
  }

  /// Resolves the connect options for a join from [settings], then merges
  /// [joinOptions] and an override over them. An iOS broadcast that started
  /// before keeps its screen share option.
  Future<void> applyJoinSettings(
    CallSettings settings, {
    CallConnectOptions? joinOptions,
  }) async {
    await _broadcast.keepBroadcastOptionThrough(() async {
      await applyCallSettings(settings);

      if (joinOptions != null) {
        _connectOptions = _connectOptions.merge(joinOptions);
      }

      if (_connectOptionsOverride case final override?) {
        _connectOptions = _connectOptions.merge(override);
      }
    });

    _joinSettingsApplied = true;
  }

  /// Writes the camera, microphone and camera facing [settings] ask for over
  /// the resolved connect options, without enumerating devices.
  ///
  /// A call built from ringing metadata has not fetched the call, so this lets
  /// the incoming screen show what the join turns on. An override set with
  /// [setConnectOptions] still wins, and [applyCallSettings] writes the same
  /// values again at join.
  void applyRingingSettings(CallSettings settings) {
    _connectOptions = _connectOptions.copyWith(
      camera: TrackOption.fromSetting(
        enabled: settings.video.cameraDefaultOn,
      ),
      microphone: TrackOption.fromSetting(
        enabled: settings.audio.micDefaultOn,
      ),
      cameraFacingMode: settings.video.cameraFacing == CameraFacing.front
          ? FacingMode.user
          : FacingMode.environment,
    );
  }

  /// Writes the camera, microphone, devices and resolutions [settings] and
  /// the devices present ask for over the current connect options. A requested
  /// camera resolution is kept.
  Future<void> applyCallSettings(CallSettings settings) async {
    final mediaDevicesResult = await _rtcMediaDeviceNotifier()
        .enumerateDevicesFor(
          DeviceEnumerationTrigger.callSettings,
        );

    final mediaDevices = mediaDevicesResult.foldResult(
      success: (success) => success.data,
      failure: (failure) => <RtcMediaDevice>[],
    );

    final audioOutputs = mediaDevices
        .where((d) => d.kind == RtcMediaDeviceKind.audioOutput)
        .toList();
    final audioInputs = mediaDevices
        .where((d) => d.kind == RtcMediaDeviceKind.audioInput)
        .toList();

    /// Determines if the speaker should be enabled based on a priority hierarchy of
    /// settings.
    ///
    /// The priority order is as follows:
    /// 1. If the audio policy defaults to the speaker, such as the viewer
    ///    policy, speaker is enabled whatever the settings below say
    /// 2. If video camera is set to be on by default, speaker is enabled
    /// 3. If audio speaker is set to be on by default, speaker is enabled
    /// 4. If the default audio device is set to speaker, speaker is enabled
    final speakerOnWithSettingsPriority =
        _audioConfigurationPolicy().defaultsToSpeaker ||
        settings.video.cameraDefaultOn ||
        settings.audio.speakerDefaultOn ||
        settings.audio.defaultDevice == AudioDefaultDevice.speaker;

    // Determine default audio output with priority:
    // 1. External device (if available)
    var defaultAudioOutput = audioOutputs.firstWhereOrNull(
      (device) => device.isExternal,
    );

    if (defaultAudioOutput == null) {
      bool isSpeaker(RtcMediaDevice device) => device.id.equalsIgnoreCase(
        AudioDefaultDevice.speaker,
      );

      // 2. Speaker (if settings indicate it should be used)
      if (speakerOnWithSettingsPriority) {
        defaultAudioOutput = audioOutputs.firstWhereOrNull(isSpeaker);
      }

      // 3. First non-speaker device. Also when the speaker should be used
      // but there is none: only iOS and Android list one, so web and desktop
      // fall back to their first output.
      defaultAudioOutput ??= audioOutputs.firstWhereOrNull(
        (device) => !isSpeaker(device),
      );
    }

    final defaultAudioOutputIsExternal =
        defaultAudioOutput?.isExternal ?? false;

    // iOS doesn't allow implicitly setting the default audio output,
    // if external device is connected we trust the OS to set it as default.
    if (defaultAudioOutputIsExternal && CurrentPlatform.isIos) {
      defaultAudioOutput = null;
    }

    // Match the default audio input with the default audio output if possible
    final defaultAudioInput = audioInputs.firstWhereOrNull(
      (d) => d.label == defaultAudioOutput?.label,
    );

    _connectOptions = connectOptions.copyWith(
      camera: TrackOption.fromSetting(
        enabled: settings.video.cameraDefaultOn,
      ),
      microphone: TrackOption.fromSetting(
        enabled: settings.audio.micDefaultOn,
      ),
      audioInputDevice: defaultAudioInput,
      audioOutputDevice: defaultAudioOutput,
      cameraFacingMode: settings.video.cameraFacing == CameraFacing.front
          ? FacingMode.user
          : FacingMode.environment,
      speakerDefaultOn:
          !defaultAudioOutputIsExternal && speakerOnWithSettingsPriority,
      targetResolution:
          _requestedTargetResolution ?? settings.video.targetResolution,
      screenShareTargetResolution: settings.screenShare.targetResolution,
    );
  }

  /// Applies the connect options to [session], a newly started session.
  ///
  /// [inheritedTracks] are the live local tracks of the session it replaces.
  /// An enabled or provided option publishes its inherited track instead of
  /// opening the device again. Inherited tracks that are not published are
  /// stopped.
  Future<void> applyConnectOptions({
    required CallSession session,
    List<RtcLocalTrack> inheritedTracks = const [],
  }) async {
    _optionsAppliedBy = session;
    _connectOptionsOverride = null;
    _broadcast.adoptRunningBroadcast();
    _logger.d(
      () =>
          '[applyConnectOptions] connectOptions: $_connectOptions, '
          'inheritedTracks: $inheritedTracks',
    );

    final inherited = <SfuTrackType, RtcLocalTrack>{};
    final duplicates = <RtcLocalTrack>[];
    for (final track in inheritedTracks) {
      final replaced = inherited[track.trackType];
      if (replaced != null) duplicates.add(replaced);
      inherited[track.trackType] = track;
    }

    RtcLocalTrack? take(SfuTrackType trackType, TrackOption option) {
      if (option is! TrackEnabled && option is! TrackProvided) return null;
      return inherited.remove(trackType);
    }

    final camera = take(SfuTrackType.video, _connectOptions.camera);
    final microphone = take(SfuTrackType.audio, _connectOptions.microphone);
    final screenShare = take(
      SfuTrackType.screenShare,
      _connectOptions.screenShare,
    );

    // Taken tracks are stopped if the apply fails before they are published.
    final unpublished = {?camera, ?microphone, ?screenShare};
    Future<Result<None>> adopt(RtcLocalTrack track) {
      unpublished.remove(track);
      return _adoptInheritedTrack(session, track);
    }

    // A refused option leaves the device off, so the intent comes down with
    // it: the setters only downgrade `_connectOptions` on success, and a
    // control that reads the intent while no track has been reported would
    // otherwise draw the device as live for the rest of the call — and refuse
    // to toggle, having no track to mute.
    bool failed(String option, Result<None> result) {
      if (result is! Failure) return false;

      _logger.e(
        () =>
            '[applyConnectOptions] $option not applied: '
            '${result.videoError.message}',
      );

      return true;
    }

    var broadcastRanAtScreenShare = false;
    try {
      // Stopped up front: a screen share picker can keep the apply waiting.
      for (final track in [...duplicates, ...inherited.values]) {
        _logger.v(() => '[applyConnectOptions] stopping unused $track');
        await track.stop();
      }

      // iOS: set the session before capture so WebRTC doesn't rebuild the
      // audio engine.
      if (CurrentPlatform.isIos) await _applyAudioOutputOption();

      final cameraFailed = failed(
        'camera',
        camera != null
            ? await adopt(camera)
            : await _applyCameraOption(
                _connectOptions.camera,
                _connectOptions.cameraFacingMode,
                _connectOptions.targetResolution,
                _connectOptions.videoInputDevice?.id,
              ),
      );
      if (cameraFailed) {
        _connectOptions = _connectOptions.copyWith(
          camera: TrackOption.disabled(),
        );
      }

      final microphoneFailed = failed(
        'microphone',
        microphone != null
            ? await adopt(microphone)
            : await _applyMicrophoneOption(_connectOptions.microphone),
      );
      if (microphoneFailed) {
        _connectOptions = _connectOptions.copyWith(
          microphone: TrackOption.disabled(),
        );
      }

      // A broadcast that starts after this is shared once the apply is done.
      broadcastRanAtScreenShare = _broadcast.isBroadcasting;
      final screenShareFailed = failed(
        'screenShare',
        screenShare != null
            ? await adopt(screenShare)
            : await _applyScreenShareOption(
                session,
                _connectOptions.screenShare,
                _connectOptions.screenShareTargetResolution,
              ),
      );
      if (screenShareFailed) {
        _connectOptions = _connectOptions.copyWith(
          screenShare: TrackOption.disabled(),
        );
      }
    } finally {
      try {
        await _stopUnpublished(unpublished);
      } finally {
        _optionsAppliedTo = session;
        _optionsAppliedDuring = _state.status;
      }
    }

    if (!broadcastRanAtScreenShare) {
      await _broadcast.shareRunningBroadcast(session);
    }

    if (_connectOptions.audioInputDevice != null) {
      await setAudioInputDevice(_connectOptions.audioInputDevice!);
    }

    if (!CurrentPlatform.isIos) {
      await _applyAudioOutputOption();
    } else if (_connectOptions.audioInputDevice != null &&
        _connectOptions.audioOutputDevice != null) {
      // Picking the input can change the route, which drops the speaker
      // override. The session configuration is unchanged by now, so this only
      // overrides the port again.
      await _setAudioOutputDevice(
        _connectOptions.audioOutputDevice!,
        routeSystem: false,
      );
    }

    _logger.v(() => '[applyConnectOptions] finished');
  }

  /// Applies the connect options' audio output, or on iOS when none is set,
  /// the audio session the call settings ask for.
  Future<void> _applyAudioOutputOption() async {
    if (_connectOptions.audioOutputDevice case final device?) {
      final result = await _setAudioOutputDevice(
        device,
        routeSystem: !_audioOutputRoutedOnJoin,
      );
      if (result.isSuccess) _audioOutputRoutedOnJoin = true;
    } else if (CurrentPlatform.isIos) {
      // Under a policy that defaults to the speaker, keeps the loudspeaker
      // as the built-in output while headphones are connected, so
      // disconnecting them does not fall back to the earpiece.
      final policy = _audioConfigurationPolicy();
      final rtcManager = _session()?.rtcManager;
      final result = rtcManager == null
          ? failureWithError<None>('no RTC manager')
          : await rtcManager.configureAudioSession(
              speakerOn: resolveAppleSpeakerOn(
                policy: policy,
                speakerRequested: _connectOptions.speakerDefaultOn,
              ),
              policy: policy,
            );
      if (result is Failure) {
        _logger.e(
          () =>
              '[applyConnectOptions] appleAudioConfiguration not applied: '
              '${result.videoError.message}',
        );
      }
    }
  }

  Future<Result<None>> _applyCameraOption(
    TrackOption cameraOption,
    FacingMode facingMode,
    StreamTargetResolution? targetResolution,
    String? deviceId,
  ) async {
    if (cameraOption is TrackProvided) {
      return setLocalTrack(cameraOption.track);
    } else if (cameraOption is TrackEnabled) {
      final constraints = cameraOption.constraints is CameraConstraints
          ? cameraOption.constraints as CameraConstraints?
          : null;

      return setCameraEnabled(
        enabled: true,
        constraints:
            constraints ??
            CameraConstraints(
              facingMode: facingMode,
              deviceId: deviceId,
              params:
                  targetResolution?.toVideoParams() ??
                  RtcVideoParametersPresets.h720_16x9,
            ),
      );
    }

    return const Result.success(none);
  }

  Future<Result<None>> _applyMicrophoneOption(
    TrackOption microphoneOption,
  ) async {
    if (microphoneOption is TrackProvided) {
      return setLocalTrack(microphoneOption.track);
    } else if (microphoneOption is TrackEnabled) {
      final constraints = microphoneOption.constraints is AudioConstraints
          ? microphoneOption.constraints as AudioConstraints?
          : null;
      return setMicrophoneEnabled(enabled: true, constraints: constraints);
    }

    return const Result.success(none);
  }

  Future<void> _stopUnpublished(Set<RtcLocalTrack> unpublished) async {
    for (final track in unpublished) {
      _logger.w(() => '[applyConnectOptions] stopping unpublished $track');
      await track.stop();
    }
  }

  /// Whether [session] applied the connect options, and while a migration or
  /// a rejoin runs, did so during it: a session that applied before is the
  /// one being replaced.
  bool _hasAppliedInCurrentConnect(CallSession session) {
    if (!identical(_optionsAppliedTo, session)) return false;
    final applied = _optionsAppliedDuring;
    return switch (_state.status) {
      CallStatusMigrating() => applied is CallStatusMigrating,
      CallStatusReconnecting(isFastReconnectAttempt: false, :final attempt) =>
        applied is CallStatusReconnecting && applied.attempt == attempt,
      _ => true,
    };
  }

  Future<Result<None>> _applyScreenShareOption(
    CallSession session,
    TrackOption screenShareOption,
    StreamTargetResolution? targetResolution,
  ) async {
    if (screenShareOption is TrackProvided) {
      return setLocalTrack(screenShareOption.track);
    } else if (screenShareOption is TrackEnabled) {
      final constraints =
          screenShareOption.constraints is ScreenShareConstraints
          ? screenShareOption.constraints as ScreenShareConstraints?
          : null;

      if (constraints != null && _broadcast.isRunning(constraints)) {
        // A session replaced meanwhile leaves the broadcast to the next one.
        if (!identical(session, _session())) return const Result.success(none);
        return _broadcast.publish(constraints);
      }

      return setScreenShareEnabled(
        enabled: true,
        constraints:
            constraints ??
            ScreenShareConstraints(
              params:
                  targetResolution?.toVideoParams(
                    defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
                  ) ??
                  RtcVideoParametersPresets.h1080_16x9,
            ),
      );
    }

    return const Result.success(none);
  }

  /// Publishes [track], taken over from the session [target] replaced, on
  /// [target], while that is still the call's session. A track that is not
  /// published is stopped.
  ///
  /// A screen share is not published through [setScreenShareEnabled], which
  /// always captures a new screen and so asks the user to pick one again.
  Future<Result<None>> _adoptInheritedTrack(
    CallSession target,
    RtcLocalTrack track,
  ) async {
    _logger.d(() => '[adoptInheritedTrack] track: $track');

    final constraints = track.mediaConstraints;
    final String? refused;
    if (track.trackType == SfuTrackType.video) {
      refused = _sendVideoBlockedReason();
    } else if (track.trackType == SfuTrackType.audio) {
      refused = _sendAudioBlockedReason();
    } else if (track.trackType != SfuTrackType.screenShare) {
      refused = 'Unsupported track type: ${track.trackType}';
    } else if (constraints is! ScreenShareConstraints) {
      refused =
          'Unexpected screen share constraints: ${constraints.runtimeType}';
    } else if (!_hasPermission(CallPermission.screenshare)) {
      refused = 'Missing permission to share screen for the user';
    } else {
      refused = null;
    }

    final Result<None> result;
    try {
      if (refused != null) {
        result = failureWithError(refused);
      } else if (!identical(_session(), target)) {
        result = failureWithError('the call moved on to another session');
      } else {
        result = await target.setLocalTrack(track);
      }
    } catch (_) {
      await track.stop();
      rethrow;
    }

    _logger.v(() => '[adoptInheritedTrack] completed: $result');
    if (result.isFailure) {
      await track.stop();
      return result;
    }

    if (constraints is ScreenShareConstraints) {
      _onScreenShareEnabled(
        enabled: true,
        constraints: constraints,
        track: track,
      );
    } else {
      await _onLocalTrackSet(track);
    }

    return result;
  }

  /// Publishes [track] on the current session.
  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    _logger.d(() => '[setLocalTrack] localTrack: $track');
    final session = _session();
    if (session == null) {
      _logger.w(() => '[setLocalTrack] rejected (session is null);');
      return failureWithError('no call session');
    }
    final result = await session.setLocalTrack(track);
    _logger.v(() => '[setLocalTrack] completed: $result');
    if (result.isSuccess) await _onLocalTrackSet(track);
    return result;
  }

  /// Brings the device state in line with [track], just published.
  Future<void> _onLocalTrackSet(RtcLocalTrack track) async {
    final mediaConstraints = track.mediaConstraints;
    if (mediaConstraints is AudioConstraints) {
      _logger.v(() => '[setLocalTrack]: setMicrophoneEnabled true');
      await setMicrophoneEnabled(
        enabled: track.mediaTrack.enabled,
        constraints: mediaConstraints,
      );
    } else if (mediaConstraints is CameraConstraints) {
      _logger.v(() => '[setLocalTrack]: setCameraEnabled true');
      await setCameraEnabled(
        enabled: track.mediaTrack.enabled,
        constraints: mediaConstraints,
      );
    } else if (mediaConstraints is ScreenShareConstraints) {
      _logger.v(() => '[setLocalTrack] setScreenShareEnabled true');
      await setScreenShareEnabled(
        enabled: track.mediaTrack.enabled,
        constraints: mediaConstraints,
      );
    } else {
      _logger.e(() => '[_setLocalTrack] failed: $mediaConstraints');
    }
  }

  /// Follows the screen share and audio route changes the platform reports.
  StreamSubscription<NativeWebRtcEvent> observeNativeWebRtcEvents() {
    return PlatformAudioController.instance.nativeWebRtcEventsStream().listen((
      event,
    ) {
      _logger.d(() => '[_onNativeWebRtcEvent] event: $event');

      switch (event) {
        case ScreenSharingStoppedEvent _:
          if (CurrentPlatform.isIos) {
            _broadcast.onStopped();
            // On iOS only one broadcast extension can be active at a time
            unawaited(_disableScreenShareOnStop());
          } else {
            final trackId = event.trackId;
            final localParticipant = _state.localParticipant;
            if (trackId != null && localParticipant != null) {
              final track = _session()?.getTrack(
                localParticipant.trackIdPrefix,
                SfuTrackType.screenShare,
              );

              if (track?.mediaTrack.id == trackId) {
                unawaited(_disableScreenShareOnStop());
              }
            }
          }
          break;
        case ScreenSharingStartedEvent _:
          unawaited(_broadcast.onStarted());
          break;
        case AudioRouteChangedEvent _:
          onAudioRouteChanged(event);
          break;
        default:
          return;
      }
    });
  }

  /// Turns the screen share off after the platform stopped it.
  Future<void> _disableScreenShareOnStop() async {
    final result = await setScreenShareEnabled(enabled: false);
    if (result case Failure(:final error)) {
      _logger.w(() => '[onScreenSharingStopped] disable failed: $error');
    }
  }

  /// Whether [setAudioOutputDevice] is applying an output. The system
  /// re-routes while it does, which says nothing about where audio ends up.
  ///
  /// Best effort: the WebRTC plugin delivers route changes asynchronously, so
  /// the ones an output change causes usually arrive after it returned, when
  /// this is false again. One that names the other built-in output then puts
  /// the selection back once more, and the last one names the output that
  /// was set, so the selection still ends up where the user put it.
  bool _isSettingAudioOutput = false;

  /// Follows an iOS audio route change, unless the system moved audio between
  /// the speaker and the receiver on its own and the user had chosen one of
  /// them: that output is put back instead. While an output is being set, the
  /// system's own re-routing is ignored.
  @visibleForTesting
  void onAudioRouteChanged(AudioRouteChangedEvent event) {
    if (!CurrentPlatform.isIos) return;

    final device = event.device;
    final selected = _state.audioOutputDevice;
    _logger.d(
      () =>
          '[onAudioRouteChanged] route: ${device.id}, reason: '
          '${event.reason.name}, selected: ${selected?.id}, '
          'byUser: ${_stateManager.audioOutputSelectedByUser}',
    );
    if (selected?.id.equalsIgnoreCase(device.id) ?? false) {
      return;
    }

    if (event.reason.isSystemReconfiguration) {
      if (_isSettingAudioOutput) return;
      if (_stateManager.audioOutputSelectedByUser &&
          selected != null &&
          _isBuiltInOutput(selected) &&
          _isBuiltInOutput(device)) {
        unawaited(_putBackSelectedOutput(selected, route: device));
        return;
      }
    }

    _followAudioRoute(device);
  }

  static bool _isBuiltInOutput(RtcMediaDevice device) =>
      device.isBuiltInSpeaker || device.isBuiltInEarpiece;

  /// Puts [selected], the output the user chose, back, and follows [route]
  /// when that fails, unless another output was selected in the meantime.
  Future<void> _putBackSelectedOutput(
    RtcMediaDevice selected, {
    required RtcMediaDevice route,
  }) async {
    final result = await _session()?.applyCurrentAudioOutputDevice();
    if (result is Success) return;

    final current = _state.audioOutputDevice;
    if (!(current?.id.equalsIgnoreCase(selected.id) ?? false)) {
      _logger.d(
        () =>
            '[onAudioRouteChanged] chosen output not put back, but '
            '${current?.id} was selected since; keeping it',
      );
      return;
    }

    _logger.w(
      () =>
          '[onAudioRouteChanged] chosen output not put back, following '
          '${route.id}',
    );
    _followAudioRoute(route);
  }

  void _followAudioRoute(RtcMediaDevice device) {
    _connectOptions = connectOptions.copyWith(audioOutputDevice: device);
    _stateManager.participantSetAudioOutputDevice(device: device);
    _stateManager.audioOutputSelectedByUser = false;
  }

  Future<Result<None>> setCameraPosition(CameraPosition cameraPosition) async {
    final result =
        await _session()?.setCameraPosition(cameraPosition) ??
        failureWithError('Session is null');

    if (result.isSuccess) {
      _stateManager.participantUpdateCameraPosition(
        cameraPosition: cameraPosition,
      );
    }

    return result;
  }

  Future<Result<None>> flipCamera() async {
    final result =
        await _session()?.flipCamera() ?? failureWithError('Session is null');

    await result.foldResult(
      success: (success) async {
        final mediaDevicesResult = await _rtcMediaDeviceNotifier()
            .enumerateDevicesFor(DeviceEnumerationTrigger.flipCamera);

        final mediaDevices = mediaDevicesResult.foldResult(
          success: (success) => success.data,
          failure: (failure) => <RtcMediaDevice>[],
        );

        final currentInput = mediaDevices
            .where((d) => d.id == success.data.mediaConstraints.deviceId)
            .firstOrNull;

        _connectOptions = connectOptions.copyWith(
          cameraFacingMode: success.data.mediaConstraints.facingMode,
          videoInputDevice: currentInput,
        );

        _stateManager.participantFlipCamera(
          currentInput,
          track: success.data,
        );
      },
      failure: (failure) {},
    );

    return result.map((_) => none);
  }

  Future<Result<bool>> setMultitaskingCameraAccessEnabled(bool enabled) async {
    return _multitaskingCameraLock.synchronized(() async {
      if (CurrentPlatform.isIos) {
        try {
          final result = await webRtcEngine.camera.setMultitaskingAccessEnabled(
            enabled,
          );
          return Result.success(result);
        } catch (error, stackTrace) {
          _logger.e(() => 'Failed to set multitasking camera access: $error');
          return failureWithError<bool>(
            'Failed to set multitasking camera access',
            stackTrace: stackTrace,
          );
        }
      }

      return const Result.success(false);
    });
  }

  Future<Result<None>> setZoom({
    required double zoomLevel,
  }) async {
    _logger.d(() => '[setZoom] zoomLevel: $zoomLevel');

    final localTrackIdPrefix = _state.localParticipant?.trackIdPrefix;

    if (localTrackIdPrefix == null) {
      _logger.w(() => '[setZoom] local participant not found');
      return failureWithError('Local participant not found');
    }
    final localTrack = _session()?.getTrack(
      localTrackIdPrefix,
      SfuTrackType.video,
    );

    if (localTrack == null) {
      _logger.w(() => '[setZoom] local track not found');
      return failureWithError('Local track not found');
    }

    try {
      await webRtcEngine.camera.setZoom(localTrack.mediaTrack, zoomLevel);
      return const Result.success(none);
    } catch (error, stackTrace) {
      _logger.e(() => '[setZoom] Failed to set zoom: $error');
      return failureWithError('Failed to set zoom', stackTrace: stackTrace);
    }
  }

  Future<Result<None>> focus({Point<double>? focusPoint}) async {
    _logger.d(() => '[focus] focusPoint: $focusPoint');

    final localTrackIdPrefix = _state.localParticipant?.trackIdPrefix;

    if (localTrackIdPrefix == null) {
      _logger.w(() => '[focus] local participant not found');
      return failureWithError('Local participant not found');
    }

    final localTrack = _session()?.getTrack(
      localTrackIdPrefix,
      SfuTrackType.video,
    );
    if (localTrack == null) {
      _logger.w(() => '[focus] local track not found');
      return failureWithError('Local track not found');
    }

    try {
      await webRtcEngine.camera.setFocusPoint(
        localTrack.mediaTrack,
        focusPoint,
      );
      await webRtcEngine.camera.setExposurePoint(
        localTrack.mediaTrack,
        focusPoint,
      );
    } catch (error, stackTrace) {
      _logger.e(() => '[focus] Failed to set focus: $error');
      return failureWithError('Failed to set focus', stackTrace: stackTrace);
    }

    return const Result.success(none);
  }

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) async {
    final result =
        await _session()?.setVideoInputDevice(device) ??
        failureWithError('Session is null');

    if (result.isSuccess) {
      final track = result.getDataOrNull()!;

      _connectOptions = connectOptions.copyWith(
        videoInputDevice: device,
        cameraFacingMode: track.mediaConstraints.facingMode,
      );

      _stateManager.participantSetVideoInputDevice(
        device: device,
        track: track,
      );
    }

    return result.map((_) => none);
  }

  /// Why the camera may not be turned on, or null when it may.
  String? _sendVideoBlockedReason() {
    if (_state.isVideoModerated &&
        _state.preferences.videoModerationConfig.muteVideo) {
      return 'Blocked by video moderation';
    }
    if (!_hasPermission(CallPermission.sendVideo)) {
      return 'Missing permission to send video';
    }
    return null;
  }

  /// Why the microphone may not be turned on, or null when it may.
  String? _sendAudioBlockedReason() {
    if (_state.isVideoModerated &&
        _state.preferences.videoModerationConfig.muteAudio) {
      return 'Blocked by video moderation';
    }
    if (!_hasPermission(CallPermission.sendAudio)) {
      return 'Missing permission to send audio';
    }
    return null;
  }

  /// Sends the SFU stats 3 seconds after [track] was turned on, if it still
  /// is.
  void _sendSfuStatsSoon(RtcLocalTrack track) {
    late final CancelableOperation<void> operation;
    operation = Future<void>.delayed(const Duration(seconds: 3)).then((_) {
      _sfuStatsTimers.remove(operation);
      if (track.mediaTrack.enabled) {
        _sfuStatsReporter()?.sendSfuStats();
      }
    }).asCancelable();
    _sfuStatsTimers.add(operation);
  }

  /// Cancels the SFU stats sends that are still waiting.
  Future<void> cancelSfuStatsTimers() async {
    final operations = [..._sfuStatsTimers];
    _sfuStatsTimers.clear();
    for (final operation in operations) {
      await operation.cancel();
    }
  }

  /// Turns the camera on or off, and cancels turning it back on after the
  /// background.
  Future<Result<None>> setCameraEnabled({
    required bool enabled,
    CameraConstraints? constraints,
  }) {
    _cameraMutedInBackground = false;
    return _setCameraEnabled(enabled: enabled, constraints: constraints);
  }

  Future<Result<None>> _setCameraEnabled({
    required bool enabled,
    CameraConstraints? constraints,
  }) async {
    final blocked = enabled ? _sendVideoBlockedReason() : null;
    if (blocked != null) {
      _logger.w(() => '[setCameraEnabled] rejected: $blocked');
      return failureWithError(blocked);
    }
    final result =
        await _session()?.setCameraEnabled(enabled, constraints: constraints) ??
        failureWithError('Session is null');

    if (result.isSuccess) {
      _sendSfuStatsSoon(result.getDataOrNull()!);

      var multitaskingEnabled = _state.iOSMultitaskingCameraAccessEnabled;
      if (enabled && !multitaskingEnabled) {
        // Set multitasking camera access for iOS
        final multitaskingResult = await setMultitaskingCameraAccessEnabled(
          enabled && !_muteVideoWhenInBackground(),
        );

        multitaskingEnabled = multitaskingResult.getDataOrNull() ?? false;
      }

      _stateManager.participantSetCameraEnabled(
        enabled: enabled,
        iOSMultitaskingCameraAccessEnabled: multitaskingEnabled,
      );

      var facingMode = constraints?.facingMode;
      if (facingMode == null && result.getDataOrNull() is RtcLocalCameraTrack) {
        final track = result.getDataOrNull()! as RtcLocalCameraTrack;
        facingMode = track.mediaConstraints.facingMode;
      }

      _connectOptions = _connectOptions.copyWith(
        camera: enabled
            ? TrackOption.enabled(constraints: constraints)
            : TrackOption.disabled(),
        cameraFacingMode: facingMode ?? _connectOptions.cameraFacingMode,
      );
    }

    return result.map((_) => none);
  }

  Future<Result<None>> setCameraTargetResolution(
    StreamTargetResolution targetResolution,
  ) async {
    _requestedTargetResolution = targetResolution;
    _connectOptions = _connectOptions.copyWith(
      targetResolution: targetResolution,
    );
    // A join attempt merges the override over the options again.
    if (_connectOptionsOverride case final override?) {
      _connectOptionsOverride = override.copyWith(
        targetResolution: targetResolution,
      );
    }

    final rtcManager = _session()?.rtcManager;
    if (rtcManager == null) {
      return const Result.success(none);
    }

    final params = targetResolution.toVideoParams();
    final result = await rtcManager.setCameraVideoParameters(
      params: params,
    );

    return result.map((_) => none);
  }

  /// Turns the microphone on or off, and cancels turning it back on after
  /// the background or an interruption.
  Future<Result<None>> setMicrophoneEnabled({
    required bool enabled,
    AudioConstraints? constraints,
    bool? stopTrackOnMute,
  }) {
    _microphoneMutedInBackground = false;
    _microphoneMutedByInterruption = false;
    _muteMicrophoneWhileInterrupted = false;
    return _setMicrophoneEnabled(
      enabled: enabled,
      constraints: constraints,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<Result<None>> _setMicrophoneEnabled({
    required bool enabled,
    AudioConstraints? constraints,
    bool? stopTrackOnMute,
  }) async {
    final blocked = enabled ? _sendAudioBlockedReason() : null;
    if (blocked != null) {
      _logger.w(() => '[setMicrophoneEnabled] rejected: $blocked');
      return failureWithError(blocked);
    }

    final result =
        await _session()?.setMicrophoneEnabled(
          enabled,
          constraints: constraints,
          stopTrackOnMute: stopTrackOnMute,
        ) ??
        failureWithError('Session is null');

    if (result.isSuccess) {
      // Make sure the audio input device is set
      if (enabled && _connectOptions.audioInputDevice != null) {
        await setAudioInputDevice(_connectOptions.audioInputDevice!);
      }

      _sendSfuStatsSoon(result.getDataOrNull()!);

      await _onMicrophoneMuted(!enabled);

      _stateManager.participantSetMicrophoneEnabled(
        enabled: enabled,
      );

      _connectOptions = _connectOptions.copyWith(
        microphone: enabled
            ? TrackOption.enabled(constraints: constraints)
            : TrackOption.disabled(),
      );
    }

    return result.map((_) => none);
  }

  Future<bool> requestScreenSharePermission() async {
    // Request screen share permission from the native factory if available
    final nativeFactory = await _session()?.rtcManager?.pcFactory
        .ensureNativeFactory();

    if (nativeFactory != null) {
      return nativeFactory.requestCapturePermission();
    }

    return webRtcEngine.requestCapturePermission();
  }

  Future<Result<None>> setScreenShareEnabled({
    required bool enabled,
    ScreenShareConstraints? constraints,
  }) async {
    // Checks to ensure the user can share their screen.
    final canShare = _hasPermission(CallPermission.screenshare);
    if (enabled && !canShare) {
      return failureWithError(
        'Missing permission to share screen for the user',
      );
    }

    final updatedConstraints = constraints ?? _defaultScreenShareConstraints();

    if (!enabled) releaseBroadcastRequest();

    if (enabled &&
        ScreenShareSource.forPlatform().usesBroadcastExtension(
          updatedConstraints,
        )) {
      return _broadcast.request(updatedConstraints);
    }

    return _applyScreenShare(enabled: enabled, constraints: updatedConstraints);
  }

  /// Screen share constraints at the call's screen share resolution.
  ScreenShareConstraints _defaultScreenShareConstraints() {
    return const ScreenShareConstraints().copyWith(
      params: _connectOptions.screenShareTargetResolution?.toVideoParams(
        defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
      ),
    );
  }

  Future<Result<None>> _applyScreenShare({
    required bool enabled,
    required ScreenShareConstraints constraints,
  }) async {
    final result =
        await _session()?.setScreenShareEnabled(
          enabled,
          constraints: constraints,
        ) ??
        failureWithError('Call session is null, cannot start screen share');

    if (result.isSuccess) {
      _onScreenShareEnabled(
        enabled: enabled,
        constraints: constraints,
        track: result.getDataOrNull(),
      );
    }

    return result.map((_) => none);
  }

  /// Forgets this call's request for an iOS broadcast, so a broadcast that
  /// starts later is not shared with its constraints, and another call can
  /// take a broadcast nobody requested.
  void releaseBroadcastRequest() => _broadcast.releaseRequest();

  void _onScreenShareEnabled({
    required bool enabled,
    required ScreenShareConstraints constraints,
    RtcLocalTrack? track,
  }) {
    _stateManager.participantSetScreenShareEnabled(
      enabled: enabled,
    );

    // The system picker's choice cannot be replayed; keeping it would show
    // the picker again whenever the connect options are re-applied.
    final replayable =
        enabled &&
        constraints.deviceId != ScreenShareConstraints.systemPickerSourceId;

    _connectOptions = _connectOptions.copyWith(
      screenShare: replayable
          ? TrackOption.enabled(constraints: constraints)
          : TrackOption.disabled(),
    );

    if (enabled) {
      // [web only] Automatically stop screen share when the track ends
      track?.mediaTrack.onEnded = () {
        setScreenShareEnabled(enabled: false);
      };
    }
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) async {
    final result =
        await _session()?.setAudioInputDevice(device) ??
        failureWithError('Session is null');

    _connectOptions = _connectOptions.copyWith(audioInputDevice: device);

    if (result.isSuccess) {
      _stateManager.participantSetAudioInputDevice(device: device);
      return const Result.success(none);
    } else {
      final error = result.getErrorOrNull();
      if (error is StreamVideoException &&
          error.rawCause is TrackMissingException) {
        // If the track is null, it most probably means that the user
        // joined the call muted and the audio track was not created.
        // We will set the audio input device when the user unmutes.
        return const Result.success(none);
      } else {
        return result;
      }
    }
  }

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) =>
      _setAudioOutputDevice(device, routeSystem: true);

  /// Switches WebRTC to [device] and, with [routeSystem], asks the system
  /// route to follow.
  Future<Result<None>> _setAudioOutputDevice(
    RtcMediaDevice device, {
    required bool routeSystem,
  }) async {
    _isSettingAudioOutput = true;
    final Result<None> result;
    try {
      result =
          await _session()?.setAudioOutputDevice(device) ??
          failureWithError('Session is null');
    } finally {
      _isSettingAudioOutput = false;
    }

    if (result.isSuccess) {
      _connectOptions = connectOptions.copyWith(audioOutputDevice: device);

      _stateManager.participantSetAudioOutputDevice(device: device);
      _stateManager.audioOutputSelectedByUser = true;

      // Not awaited: the system can wait seconds for the output to appear,
      // and this also runs while joining.
      if (routeSystem) {
        unawaited(
          _onAudioOutputDeviceSet(device).catchError((
            Object e,
            StackTrace stk,
          ) {
            _logger.w(
              () => '[setAudioOutputDevice] system route failed: $e\n$stk',
            );
          }),
        );
      }
    }

    return result;
  }

  /// Whether the capture session in use supports camera access while
  /// multitasking, or `null` off iOS or when it could not be read.
  Future<bool?> _multitaskingCameraAccessSupported() async {
    if (!CurrentPlatform.isIos) return null;

    try {
      return await webRtcEngine.camera.isMultitaskingAccessSupported();
    } catch (e, stk) {
      _logger.w(() => '[multitaskingCameraAccessSupported] failed: $e\n$stk');
      return null;
    }
  }

  /// Turns the camera off as the app goes to the background when
  /// `muteVideoWhenInBackground` is set or iOS can't keep capturing while
  /// multitasking, and the microphone when `muteAudioWhenInBackground` is
  /// set. Runs after any [onAppResumed] still in progress.
  Future<void> onAppPaused() => _backgroundLock.synchronized(() async {
    _isAppPaused = true;
    final localParticipant = _state.localParticipant;
    final isVideoEnabled = localParticipant?.isVideoEnabled ?? false;
    final isAudioEnabled = localParticipant?.isAudioEnabled ?? false;

    final muteCamera = shouldMuteCameraInBackground(
      isVideoEnabled: isVideoEnabled,
      muteVideoWhenInBackground: _muteVideoWhenInBackground(),
      multitaskingCameraAccessSupported: isVideoEnabled
          ? await _multitaskingCameraAccessSupported()
          : null,
      platform: CurrentPlatform.type,
    );

    if (muteCamera) {
      if (await _backgroundStep(
        'onAppPaused camera',
        () => _setCameraEnabled(enabled: false),
      )) {
        _cameraMutedInBackground = true;
      }
    }
    if (_muteAudioWhenInBackground() && isAudioEnabled) {
      if (await _backgroundStep(
        'onAppPaused microphone',
        () => _setMicrophoneEnabled(enabled: false),
      )) {
        _microphoneMutedInBackground = true;
      }
    }
  });

  /// Turns on again what [onAppPaused] turned off. What fails to turn on is
  /// tried again on the next resume, unless it is set explicitly before
  /// then. Runs after any [onAppPaused] still in progress.
  Future<void> onAppResumed() => _backgroundLock.synchronized(() async {
    _isAppPaused = false;
    if (_cameraMutedInBackground &&
        await _backgroundStep(
          'onAppResumed camera',
          () => _setCameraEnabled(enabled: true),
        )) {
      _cameraMutedInBackground = false;
    }
    if (_microphoneMutedInBackground && _muteMicrophoneWhileInterrupted) {
      // The interruption turns it back on when it ends.
      _microphoneMutedInBackground = false;
      _microphoneMutedByInterruption = true;
    } else if (_microphoneMutedInBackground &&
        await _backgroundStep(
          'onAppResumed microphone',
          () => _setMicrophoneEnabled(enabled: true),
        )) {
      _microphoneMutedInBackground = false;
    }
  });

  /// The platform started interrupting the call's audio. With
  /// [muteMicrophone], turns the microphone off until the interruption ends.
  /// Runs after any background mute or restore still in progress.
  Future<void> onAudioInterruptionStarted({required bool muteMicrophone}) =>
      _backgroundLock.synchronized(() async {
        _muteMicrophoneWhileInterrupted = muteMicrophone;
        if (!muteMicrophone) return;

        if (_microphoneMutedInBackground) {
          // Already off for the background; the interruption decides when
          // it comes back.
          _microphoneMutedInBackground = false;
          _microphoneMutedByInterruption = true;
          return;
        }

        final isAudioEnabled = _state.localParticipant?.isAudioEnabled ?? false;
        if (isAudioEnabled &&
            await _backgroundStep(
              'onAudioInterruptionStarted microphone',
              () => _setMicrophoneEnabled(enabled: false),
            )) {
          _microphoneMutedByInterruption = true;
        }
      });

  /// The interruption ended. With [restore], turns back on the microphone it
  /// turned off: right away in the foreground, or on [onAppResumed] while
  /// the app is in the background and the microphone is muted there. A
  /// microphone that cannot be turned on now, such as during a reconnect, is
  /// turned on by the next session.
  Future<void> onAudioInterruptionEnded({required bool restore}) =>
      _backgroundLock.synchronized(() async {
        _muteMicrophoneWhileInterrupted = false;
        if (!_microphoneMutedByInterruption) return;
        _microphoneMutedByInterruption = false;
        if (!restore) return;

        if (_isAppPaused && _muteAudioWhenInBackground()) {
          _microphoneMutedInBackground = true;
          return;
        }

        if (!await _backgroundStep(
          'onAudioInterruptionEnded microphone',
          () => _setMicrophoneEnabled(enabled: true),
        )) {
          _connectOptions = _connectOptions.copyWith(
            microphone: TrackOption.enabled(),
          );
        }
      });

  /// Runs one background mute or restore, and answers whether it succeeded.
  /// A failure is logged, and the next step still runs.
  Future<bool> _backgroundStep(
    String tag,
    Future<Result<None>> Function() step,
  ) async {
    try {
      final result = await step();
      if (result case Failure(:final error)) {
        _logger.w(() => '[$tag] failed: $error');
        return false;
      }
      _logger.v(() => '[$tag] done');
      return true;
    } catch (e, stk) {
      _logger.e(() => '[$tag] failed: $e\n$stk');
      return false;
    }
  }
}
