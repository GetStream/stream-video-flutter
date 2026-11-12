import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import '../../exceptions/video_exception.dart';
import '../rtc_media_device/device_enumeration_trigger.dart';

const kLocalTrackIdPrefix = 'local';

typedef RtcLocalAudioTrack = RtcLocalTrack<AudioConstraints>;
typedef RtcLocalVideoTrack = RtcLocalTrack<VideoConstraints>;
typedef RtcLocalCameraTrack = RtcLocalTrack<CameraConstraints>;
typedef RtcLocalScreenShareTrack = RtcLocalTrack<ScreenShareConstraints>;

const _tag = 'SV:RtcLocalTrack';

class RtcLocalTrack<T extends MediaConstraints> extends RtcTrack {
  const RtcLocalTrack({
    required super.trackIdPrefix,
    required super.trackType,
    required super.mediaStream,
    required super.mediaTrack,
    required this.mediaConstraints,
    this.stopTrackOnMute = true,
    this.clonedTracks = const [],
    this.nativeFactory,
    super.videoDimension,
  });

  /// Per-call native factory the track is pinned to. Carried on the track so
  /// [recreate] can target the same factory. Null on web, which has no
  /// per-call factory concept.
  final rtc.NativePeerConnectionFactory? nativeFactory;

  static Future<RtcLocalAudioTrack> audio({
    String trackIdPrefix = kLocalTrackIdPrefix,
    AudioConstraints constraints = const AudioConstraints(),
    rtc.NativePeerConnectionFactory? nativeFactory,
  }) async {
    streamLog.i(_tag, () => 'Creating audio track');

    final stream = await rtc.navigator.mediaDevices.getMedia(
      constraints,
      nativeFactory: nativeFactory,
    );
    final audioTrack = stream.getAudioTracks().firstOrNull;

    if (audioTrack == null) {
      streamLog.w(_tag, () => 'No audio track found');
      throw VideoException('No audio track found');
    }

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.audio,
      mediaStream: stream,
      mediaTrack: audioTrack,
      mediaConstraints: constraints,
      nativeFactory: nativeFactory,
    );

    return track;
  }

  static Future<RtcLocalCameraTrack> camera({
    String trackIdPrefix = kLocalTrackIdPrefix,
    CameraConstraints constraints = const CameraConstraints(),
    rtc.NativePeerConnectionFactory? nativeFactory,
  }) async {
    streamLog.i(_tag, () => 'Creating camera track');
    final stream = await rtc.navigator.mediaDevices.getMedia(
      constraints,
      nativeFactory: nativeFactory,
    );
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) {
      streamLog.w(_tag, () => 'No camera track found');
      throw VideoException('No camera track found');
    }

    final detectedFacingMode = _detectFacingModeFromTrack(
      videoTrack,
      fallbackFacingMode: constraints.facingMode,
    );

    final updatedConstraints = constraints.copyWith(
      facingMode: detectedFacingMode,
    );

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.video,
      mediaStream: stream,
      mediaTrack: videoTrack,
      mediaConstraints: updatedConstraints,
      nativeFactory: nativeFactory,
    );

    return track;
  }

  static Future<RtcLocalScreenShareTrack> screenShare({
    String trackIdPrefix = kLocalTrackIdPrefix,
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
    rtc.NativePeerConnectionFactory? nativeFactory,
  }) async {
    streamLog.i(_tag, () => 'Creating screen share track');

    final stream = await rtc.navigator.mediaDevices.getMedia(
      constraints,
      nativeFactory: nativeFactory,
    );
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) {
      streamLog.w(_tag, () => 'No video track found');
      throw VideoException('No video track found');
    }

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.screenShare,
      mediaStream: stream,
      mediaTrack: videoTrack,
      mediaConstraints: constraints,
      nativeFactory: nativeFactory,
    );

    return track;
  }

  final List<rtc.MediaStreamTrack> clonedTracks;

  /// The media constraints used to create this track.
  ///
  /// This is used to recreate the track if needed.
  /// For example, if the user changes the camera.
  final T mediaConstraints;

  /// Whether to stop the track when the user mutes it.
  ///
  /// This is used to avoid the track indicator light remaining on.
  final bool stopTrackOnMute;

  @override
  Future<void> start() async {
    streamLog.i(_tag, () => 'Starting track: $trackId');
    // Enable the track.
    enable();
  }

  @override
  Future<void> stop() async {
    // Disable the track.
    disable();

    // Stop the track.
    streamLog.i(_tag, () => 'Stopping track: $trackId');
    try {
      await mediaTrack.stop();
      await _stopClones();
    } catch (e) {
      streamLog.w(_tag, () => 'Error stopping mediaTrack: $e');
    }

    try {
      await mediaStream.dispose();
    } catch (e) {
      streamLog.w(_tag, () => 'Error disposing mediaStream: $e');
    }
  }

  /// Stops the clones given to senders, but not [mediaTrack] or
  /// [mediaStream], so the device keeps capturing for whoever else holds the
  /// track.
  Future<void> stopClones() async {
    streamLog.i(_tag, () => 'Stopping clones of track: $trackId');
    await _stopClones();
  }

  Future<void> _stopClones() async {
    for (final track in clonedTracks) {
      try {
        await track.stop();
      } catch (e) {
        streamLog.w(_tag, () => 'Error stopping clone ${track.id}: $e');
      }
    }
  }

  @override
  void enable() {
    // Return if the track is already enabled.
    if (mediaTrack.enabled) return;

    streamLog.i(_tag, () => 'Enabling track $trackId');
    try {
      mediaTrack.enabled = true;

      for (final track in clonedTracks) {
        track.enabled = true;
      }
    } catch (_) {
      streamLog.w(_tag, () => 'Failed to enable track $trackId');
    }
  }

  @override
  void disable() {
    // Return if the track is already disabled.
    if (!mediaTrack.enabled) return;

    streamLog.i(_tag, () => 'Disabling track $trackId');
    try {
      mediaTrack.enabled = false;
      for (final track in clonedTracks) {
        track.enabled = false;
      }
    } catch (_) {
      streamLog.w(_tag, () => 'Failed to disable track $trackId');
    }
  }

  @override
  RtcLocalTrack<T> copyWith({
    String? trackIdPrefix,
    SfuTrackType? trackType,
    rtc.MediaStream? mediaStream,
    rtc.MediaStreamTrack? mediaTrack,
    T? mediaConstraints,
    bool? stopTrackOnMute,
    RtcVideoDimension? videoDimension,
    List<rtc.MediaStreamTrack>? clonedTracks,
    rtc.NativePeerConnectionFactory? nativeFactory,
  }) {
    return RtcLocalTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      mediaStream: mediaStream ?? this.mediaStream,
      mediaTrack: mediaTrack ?? this.mediaTrack,
      mediaConstraints: mediaConstraints ?? this.mediaConstraints,
      stopTrackOnMute: stopTrackOnMute ?? this.stopTrackOnMute,
      videoDimension: videoDimension ?? this.videoDimension,
      clonedTracks: clonedTracks ?? this.clonedTracks,
      nativeFactory: nativeFactory ?? this.nativeFactory,
    );
  }

  /// Recreates the track with new [mediaConstraints] and sends the new
  /// capture on [transceivers].
  Future<RtcLocalTrack<T>> recreate(
    List<rtc.RTCRtpTransceiver> transceivers, {
    T? mediaConstraints,
  }) async {
    final captured = await recapture(mediaConstraints: mediaConstraints);
    try {
      return await captured.sendOn(transceivers);
    } catch (_) {
      await captured.stop();
      rethrow;
    }
  }

  /// Stops this track and captures it again with [mediaConstraints], or its
  /// own when null, on the same per-call factory. The new capture has no
  /// clones and is on no sender yet.
  Future<RtcLocalTrack<T>> recapture({T? mediaConstraints}) async {
    streamLog.i(_tag, () => 'Recapturing track: $trackId');

    await stop();

    final constraints = mediaConstraints ?? this.mediaConstraints;
    final newStream = await rtc.navigator.mediaDevices.getMedia(
      constraints,
      nativeFactory: nativeFactory,
    );

    return copyWith(
      mediaTrack: newStream.getTracks().first,
      mediaStream: newStream,
      mediaConstraints: constraints,
      clonedTracks: const [],
    );
  }

  /// Sends a clone of this track on every one of [transceivers] that is
  /// sending a track, and returns this track carrying those clones. When one
  /// fails, the clones made so far are stopped.
  Future<RtcLocalTrack<T>> sendOn(
    List<rtc.RTCRtpTransceiver> transceivers,
  ) async {
    final clonedTracks = <rtc.MediaStreamTrack>[];

    try {
      for (final transceiver in transceivers) {
        if (transceiver.sender.track == null) continue;

        final clonedTrack = await mediaTrack.clone();
        clonedTracks.add(clonedTrack);

        streamLog.i(_tag, () => 'Replacing track on sender');
        await transceiver.sender.replaceTrack(clonedTrack);
      }
    } catch (_) {
      await copyWith(clonedTracks: clonedTracks).stopClones();
      rethrow;
    }

    return copyWith(clonedTracks: clonedTracks);
  }

  @override
  String toString() {
    return 'RtcLocalTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${mediaStream.id}';
  }
}

const _cameraTag = 'SV:RtcLocalCameraTrack';

/// Detects the facing mode from a video track.
FacingMode _detectFacingModeFromTrack(
  rtc.MediaStreamTrack videoTrack, {
  required FacingMode fallbackFacingMode,
  String? deviceLabel,
}) {
  try {
    final settings = videoTrack.getSettings();
    final settingsFacingMode = settings['facingMode'];

    if (settingsFacingMode != null) {
      return FacingMode.fromAlias(settingsFacingMode);
    } else {
      // Try to infer from device label if available
      if (deviceLabel != null) {
        return _inferFacingModeFromLabel(deviceLabel, fallbackFacingMode);
      }
    }
  } catch (e) {
    if (deviceLabel != null) {
      return _inferFacingModeFromLabel(deviceLabel, fallbackFacingMode);
    }
  }

  return fallbackFacingMode;
}

FacingMode _inferFacingModeFromLabel(String label, FacingMode fallback) {
  final lowerLabel = label.toLowerCase();
  if (lowerLabel.contains('back') ||
      lowerLabel.contains('rear') ||
      lowerLabel.contains('environment')) {
    return FacingMode.environment;
  } else if (lowerLabel.contains('front')) {
    return FacingMode.user;
  }

  return fallback;
}

extension RtcLocalCameraTrackHardwareExt on RtcLocalCameraTrack {
  Future<RtcLocalCameraTrack> flipCamera() async {
    streamLog.i(_cameraTag, () => 'Flipping camera');

    if (!rtc.webRtcCapabilities.supportsCameraSwitch) {
      streamLog.w(_cameraTag, () => 'Flipping camera is not supported');
      throw UnsupportedError(
        'Flipping camera is not supported on this platform',
      );
    }

    // Use the native switchCamera method.
    final isFrontCamera = await rtc.Helper.switchCamera(mediaTrack);

    final mediaDevicesResult = await RtcMediaDeviceNotifier.instance
        .enumerateDevicesFor(
          DeviceEnumerationTrigger.flipCamera,
          kind: RtcMediaDeviceKind.videoInput,
        );

    final mediaDevices = mediaDevicesResult.foldResult(
      success: (success) => success.data,
      failure: (failure) => <RtcMediaDevice>[],
    );

    final currentCamera = mediaDevices
        .where(
          (d) =>
              d.label.toLowerCase().contains(isFrontCamera ? 'front' : 'back'),
        )
        .firstOrNull;

    return copyWith(
      mediaConstraints: mediaConstraints.copyWith(
        facingMode: isFrontCamera ? FacingMode.user : FacingMode.environment,
        deviceId: currentCamera?.id,
      ),
    );
  }

  Future<RtcLocalCameraTrack> selectVideoInput(
    RtcMediaDevice device,
    List<rtc.RTCRtpTransceiver> transceivers,
  ) async {
    streamLog.i(_cameraTag, () => 'Selecting camera input: $device');

    final currentDeviceId = mediaConstraints.deviceId;
    // Check if the device is already selected.
    if (currentDeviceId == device.id) {
      streamLog.i(_cameraTag, () => 'Video input already selected: $device');
      return this;
    }

    // recreate the track with new deviceId.
    final updatedTrack = await recreate(
      transceivers,
      mediaConstraints: mediaConstraints.copyWith(
        deviceId: device.id,
      ),
    );

    return updatedTrack.withFacingModeOf(
      device,
      fallback: mediaConstraints.facingMode,
    );
  }

  /// This track with the facing mode its capture reports. When it reports
  /// none, the facing mode is inferred from [device]'s label, and is
  /// [fallback] when the label does not tell either.
  RtcLocalCameraTrack withFacingModeOf(
    RtcMediaDevice device, {
    required FacingMode fallback,
  }) {
    final facingMode = _detectFacingModeFromTrack(
      mediaTrack,
      fallbackFacingMode: fallback,
      deviceLabel: device.label,
    );

    return copyWith(
      mediaConstraints: mediaConstraints.copyWith(facingMode: facingMode),
    );
  }
}

const _audioTag = 'SV:RtcLocalAudioTrack';

extension RtcLocalAudioTrackHardwareExt on RtcLocalAudioTrack {
  Future<RtcLocalAudioTrack> selectAudioInput(
    List<rtc.RTCRtpTransceiver> transceivers,
    RtcMediaDevice device,
  ) async {
    streamLog.i(_audioTag, () => 'Selecting audio input: $device');

    final currentDeviceId = mediaConstraints.deviceId;
    // Check if the device is already selected.
    if (currentDeviceId == device.id) {
      streamLog.i(_audioTag, () => 'Audio input already selected: $device');
      return this;
    }

    final updatedConstraints = mediaConstraints.copyWith(deviceId: device.id);

    if (!rtc.webRtcCapabilities.switchesAudioInputInPlace) {
      // recreate the track with new deviceId.
      return recreate(transceivers, mediaConstraints: updatedConstraints);
    }

    try {
      await rtc.Helper.selectAudioInput(device.id);
      return copyWith(mediaConstraints: updatedConstraints);
    } catch (e) {
      streamLog.e(_audioTag, () => 'Error selecting audio input: $e');
      rethrow;
    }
  }
}

extension RtcLocalScreenShareTrackExt on RtcLocalScreenShareTrack {
  bool compareScreenShareMode(MediaConstraints? constraints) {
    if (constraints is! ScreenShareConstraints) {
      return true;
    }

    // Without reuse every request is a new capture, and deviceId is `null`.
    if (!rtc.webRtcCapabilities.reusesScreenShareCapture) {
      return false;
    }

    return mediaConstraints.useiOSBroadcastExtension ==
            constraints.useiOSBroadcastExtension &&
        mediaConstraints.deviceId == constraints.deviceId;
  }
}
