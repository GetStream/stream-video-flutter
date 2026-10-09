import 'dart:async';
import 'dart:math';

import 'package:async/async.dart' show CancelableOperation;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';
import 'package:synchronized/synchronized.dart';

import '../../../open_api/video/coordinator/api.dart' hide User;
import '../../call_state.dart';
import '../../errors/stream_video_exception.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/audio_configuration_policy.dart';
import '../../models/models.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/extensions.dart';
import '../../utils/future.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/media/media_constraints.dart';
import '../../webrtc/model/rtc_video_parameters.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_media_device/device_enumeration_trigger.dart';
import '../../webrtc/rtc_media_device/rtc_media_device.dart';
import '../../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../../webrtc/rtc_track/rtc_track.dart';
import '../call_connect_options.dart';
import '../session/call_session.dart';
import '../state/call_state_notifier.dart';
import '../stats/sfu_stats_reporter.dart';

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
    required this._onMicrophoneMuted,
    required this._logger,
  });

  final CallStateNotifier _stateManager;
  final CallSession? Function() _session;
  final SfuStatsReporter? Function() _sfuStatsReporter;
  final bool Function(CallPermission permission) _hasPermission;
  final RtcMediaDeviceNotifier _rtcMediaDeviceNotifier;
  final AudioConfigurationPolicy Function() _audioConfigurationPolicy;
  final bool Function() _muteVideoWhenInBackground;
  final Future<void> Function(bool muted) _onMicrophoneMuted;
  final TaggedLogger _logger;

  final _multitaskingCameraLock = Lock();
  final _sfuStatsTimers = <CancelableOperation<void>>{};

  CallConnectOptions _connectOptions = const CallConnectOptions();
  CallConnectOptions? _connectOptionsOverride;

  /// The camera resolution [setCameraTargetResolution] asked for. It wins
  /// over the call settings each time they are applied.
  StreamTargetResolution? _requestedTargetResolution;

  /// Whether the join has applied the call settings, after which a change
  /// is written into the resolved options instead of the override.
  bool _joinSettingsApplied = false;

  /// The session that started applying the options. While it is the call's
  /// session, they can only change through the device methods.
  CallSession? _optionsAppliedBy;

  CallState get _state => _stateManager.callState;

  /// The options the next session starts with: an override set before the
  /// join, or the options the call resolved.
  CallConnectOptions get connectOptions =>
      _connectOptionsOverride ?? _connectOptions;

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
    // Before the join, an override goes over the call settings it applies;
    // after it, the options are already resolved.
    if (_joinSettingsApplied) {
      _connectOptions = _connectOptions.merge(connectOptions);
    } else {
      _connectOptionsOverride = connectOptions;
    }
    return const Result.success(none);
  }

  /// Resolves the connect options for a join from [settings], then merges
  /// [joinOptions] and an override over them.
  Future<void> applyJoinSettings(
    CallSettings settings, {
    CallConnectOptions? joinOptions,
  }) async {
    await applyCallSettings(settings);

    if (joinOptions != null) {
      _connectOptions = _connectOptions.merge(joinOptions);
    }

    if (_connectOptionsOverride != null) {
      _connectOptions = _connectOptions.merge(_connectOptionsOverride!);
      _connectOptionsOverride = null;
    }

    _joinSettingsApplied = true;
  }

  /// Writes the camera, microphone, devices and resolutions [settings] and
  /// the devices present ask for over the connect options, starting from an
  /// override when one is set. A requested camera resolution is kept.
  Future<void> applyCallSettings(CallSettings settings) async {
    final mediaDevicesResult = await _rtcMediaDeviceNotifier
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
    /// 1. If video camera is set to be on by default, speaker is enabled
    /// 2. If audio speaker is set to be on by default, speaker is enabled
    /// 3. If the default audio device is set to speaker, speaker is enabled
    final speakerOnWithSettingsPriority =
        settings.video.cameraDefaultOn ||
        settings.audio.speakerDefaultOn ||
        settings.audio.defaultDevice ==
            AudioSettingsRequestDefaultDevice.speaker;

    // Determine default audio output with priority:
    // 1. External device (if available)
    var defaultAudioOutput = audioOutputs.firstWhereOrNull(
      (device) => device.isExternal,
    );

    if (defaultAudioOutput == null) {
      // 2. Speaker (if settings indicate it should be used)
      if (speakerOnWithSettingsPriority) {
        defaultAudioOutput = audioOutputs.firstWhereOrNull(
          (device) => device.id.equalsIgnoreCase(
            AudioSettingsRequestDefaultDevice.speaker,
          ),
        );
      } else {
        // 3. First non-speaker device
        defaultAudioOutput = audioOutputs.firstWhereOrNull(
          (device) => !device.id.equalsIgnoreCase(
            AudioSettingsRequestDefaultDevice.speaker,
          ),
        );
      }
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
      cameraFacingMode:
          settings.video.cameraFacing == VideoSettingsRequestCameraFacing.front
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
    CallSession? session,
    List<RtcLocalTrack> inheritedTracks = const [],
  }) async {
    _optionsAppliedBy = session;
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

    // Stopped up front: a screen share picker can keep the apply waiting.
    for (final track in [...duplicates, ...inherited.values]) {
      _logger.v(() => '[applyConnectOptions] stopping unused $track');
      await track.stop();
    }

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

    try {
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

      final screenShareFailed = failed(
        'screenShare',
        screenShare != null
            ? await adopt(screenShare)
            : await _applyScreenShareOption(
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
      for (final track in unpublished) {
        _logger.w(() => '[applyConnectOptions] stopping unpublished $track');
        await track.stop();
      }
    }

    if (_connectOptions.audioInputDevice != null) {
      await setAudioInputDevice(_connectOptions.audioInputDevice!);
    }

    if (_connectOptions.audioOutputDevice != null) {
      await setAudioOutputDevice(_connectOptions.audioOutputDevice!);
    } else {
      if (CurrentPlatform.isIos) {
        await _session()?.rtcManager?.setAppleAudioConfiguration(
          speakerOn: _connectOptions.speakerDefaultOn,
          policy: _audioConfigurationPolicy(),
        );
      }
    }

    _logger.v(() => '[applyConnectOptions] finished');
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

  Future<Result<None>> _applyScreenShareOption(
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
    CallSession? target,
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
      } else if (target == null || !identical(_session(), target)) {
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
    return RtcMediaDeviceNotifier.instance.nativeWebRtcEventsStream().listen((
      event,
    ) {
      _logger.d(
        () => '[_onNativeWebRtcEvent] screenSharingStopped: $event',
      );

      switch (event) {
        case ScreenSharingStoppedEvent _:
          if (CurrentPlatform.isIos) {
            // On iOS only one broadcast extension can be active at a time
            setScreenShareEnabled(enabled: false);
          } else {
            final trackId = event.data?['trackId'] as String?;
            final localParticipant = _state.localParticipant;
            if (trackId != null && localParticipant != null) {
              final track = _session()?.getTrack(
                localParticipant.trackIdPrefix,
                SfuTrackType.screenShare,
              );

              if (track?.mediaTrack.id == trackId) {
                setScreenShareEnabled(enabled: false);
              }
            }
          }
          break;
        case ScreenSharingStartedEvent _:
          _stateManager.participantSetScreenShareEnabled(
            enabled: true,
          );

          _connectOptions = _connectOptions.copyWith(
            screenShare: TrackOption.enabled(
              constraints: const ScreenShareConstraints(
                useiOSBroadcastExtension: true,
              ),
            ),
          );
          break;
        case AudioRouteChangedEvent _:
          if (!CurrentPlatform.isIos) break;

          final device = event.device;
          if (_state.audioOutputDevice?.id.equalsIgnoreCase(device.id) ??
              false) {
            break;
          }

          _connectOptions = connectOptions.copyWith(audioOutputDevice: device);
          _stateManager.participantSetAudioOutputDevice(device: device);
          _stateManager.audioOutputSelectedByUser = false;
          break;
        default:
          return;
      }
    });
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
        final mediaDevicesResult = await _rtcMediaDeviceNotifier
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
          final result = await rtc.Helper.enableIOSMultitaskingCameraAccess(
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
      await rtc.Helper.setZoom(localTrack.mediaTrack, zoomLevel);
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
      await Helper.setFocusPoint(localTrack.mediaTrack, focusPoint);
      await Helper.setExposurePoint(localTrack.mediaTrack, focusPoint);
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

  Future<Result<None>> setCameraEnabled({
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
    // An override replaces the options until the join merges it.
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

  Future<Result<None>> setMicrophoneEnabled({
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

    return Helper.requestCapturePermission();
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

    final updatedConstraints = (constraints ?? const ScreenShareConstraints())
        .copyWith(
          params:
              constraints?.params ??
              _connectOptions.screenShareTargetResolution?.toVideoParams(
                defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
              ),
        );

    final result =
        await _session()?.setScreenShareEnabled(
          enabled,
          constraints: updatedConstraints,
        ) ??
        failureWithError('Call session is null, cannot start screen share');

    // In case of iOS Broadcast Extension, we don't update the state here
    // We listen to the ScreenShareStarted event instead
    if (CurrentPlatform.isIos &&
        constraints is ScreenShareConstraints &&
        constraints.useiOSBroadcastExtension) {
      return result.map((_) => none);
    }

    if (result.isSuccess) {
      _onScreenShareEnabled(
        enabled: enabled,
        constraints: updatedConstraints,
        track: result.getDataOrNull(),
      );
    }

    return result.map((_) => none);
  }

  void _onScreenShareEnabled({
    required bool enabled,
    required ScreenShareConstraints constraints,
    RtcLocalTrack? track,
  }) {
    _stateManager.participantSetScreenShareEnabled(
      enabled: enabled,
    );

    _connectOptions = _connectOptions.copyWith(
      screenShare: enabled
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

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) async {
    final result =
        await _session()?.setAudioOutputDevice(device) ??
        failureWithError('Session is null');

    if (result.isSuccess) {
      _connectOptions = connectOptions.copyWith(audioOutputDevice: device);

      _stateManager.participantSetAudioOutputDevice(device: device);
      _stateManager.audioOutputSelectedByUser = true;
    }

    return result;
  }
}
