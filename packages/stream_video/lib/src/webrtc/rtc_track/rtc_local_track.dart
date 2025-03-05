import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../exceptions/video_exception.dart';
import '../../logger/stream_log.dart';
import '../../platform_detector/platform_detector.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/result.dart';
import '../media/media_constraints.dart';
import '../model/rtc_video_dimension.dart';
import '../rtc_media_device/rtc_media_device.dart';
import '../rtc_media_device/rtc_media_device_notifier.dart';
import 'rtc_track.dart';

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
    super.videoDimension,
  });

  static Future<RtcLocalAudioTrack> audio({
    String trackIdPrefix = kLocalTrackIdPrefix,
    AudioConstraints constraints = const AudioConstraints(),
  }) async {
    streamLog.i(_tag, () => 'Creating audio track');

    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
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
    );

    return track;
  }

  static Future<RtcLocalCameraTrack> camera({
    String trackIdPrefix = kLocalTrackIdPrefix,
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    streamLog.i(_tag, () => 'Creating camera track');
    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) {
      streamLog.w(_tag, () => 'No camera track found');
      throw VideoException('No camera track found');
    }

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.video,
      mediaStream: stream,
      mediaTrack: videoTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

  static Future<RtcLocalScreenShareTrack> screenShare({
    String trackIdPrefix = kLocalTrackIdPrefix,
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    streamLog.i(_tag, () => 'Creating screen share track');

    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
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
      for (final track in clonedTracks) {
        await track.stop();
      }
    } catch (e) {
      streamLog.w(_tag, () => 'Error stopping mediaTrack: $e');
    }

    try {
      await mediaStream.dispose();
    } catch (e) {
      streamLog.w(_tag, () => 'Error disposing mediaStream: $e');
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
    );
  }

  /// Recreates the track with new [mediaConstraints].
  Future<RtcLocalTrack<T>> recreate(
    List<rtc.RTCRtpTransceiver> transceivers, {
    T? mediaConstraints,
  }) async {
    streamLog.i(_tag, () => 'Recreating track: $trackId');

    // Stop the current track.
    await stop();

    // Use the current constraints if none are provided.
    final constraints = mediaConstraints ?? this.mediaConstraints;

    // Create a new track with the new constraints.
    final newStream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final newTrack = newStream.getTracks().first;
    final clonedTracks = <rtc.MediaStreamTrack>[];

    // Replace the track on the transceiver if it exists.
    for (final transceiver in transceivers) {
      if (transceiver.sender.track == null) {
        continue;
      }

      final clonedTrack = await newTrack.clone();
      clonedTracks.add(clonedTrack);

      streamLog.i(_tag, () => 'Replacing track on sender');
      await transceiver.sender.replaceTrack(clonedTrack);
    }

    return copyWith(
      mediaTrack: newTrack,
      mediaStream: newStream,
      mediaConstraints: constraints,
      clonedTracks: clonedTracks,
    );
  }

  @override
  String toString() {
    return 'RtcLocalTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${mediaStream.id}';
  }
}

const _cameraTag = 'SV:RtcLocalCameraTrack';

extension RtcLocalCameraTrackHardwareExt on RtcLocalCameraTrack {
  Future<RtcLocalCameraTrack> flipCamera() async {
    streamLog.i(_cameraTag, () => 'Flipping camera');

    if (CurrentPlatform.isWeb) {
      streamLog.w(_cameraTag, () => 'Flipping camera is not supported on web');
      throw UnsupportedError('Flipping camera is not supported on web');
    }

    // Use the native switchCamera method.
    final isFrontCamera = await rtc.Helper.switchCamera(mediaTrack);

    final mediaDevicesResult = await RtcMediaDeviceNotifier.instance
        .enumerateDevices(kind: RtcMediaDeviceKind.videoInput);

    final mediaDevices = mediaDevicesResult.fold(
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

    // Default to user facing mode.
    var facingMode = FacingMode.user;

    // Use the facingMode from the track settings if available.
    try {
      final settings = updatedTrack.mediaTrack.getSettings();
      facingMode = FacingMode.fromAlias(settings['facingMode']);
    } catch (e) {
      // ignore
    }

    return updatedTrack.copyWith(
      mediaConstraints: updatedTrack.mediaConstraints.copyWith(
        facingMode: facingMode,
      ),
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

    if (CurrentPlatform.isWeb) {
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

    return mediaConstraints.useiOSBroadcastExtension ==
            constraints.useiOSBroadcastExtension &&
        mediaConstraints.deviceId == constraints.deviceId;
  }
}
