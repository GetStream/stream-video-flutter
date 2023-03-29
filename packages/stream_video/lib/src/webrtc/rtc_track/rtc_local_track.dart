import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../exceptions/video_exception.dart';
import '../../logger/stream_log.dart';
import '../../platform_detector/platform_detector.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../media/media_constraints.dart';
import '../model/rtc_video_dimension.dart';
import '../rtc_media_device/rtc_media_device.dart';
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
    super.videoDimension,
    super.receiver,
    super.transceiver,
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
  RtcLocalTrack<T> copyWith({
    String? trackIdPrefix,
    SfuTrackType? trackType,
    rtc.MediaStream? mediaStream,
    rtc.MediaStreamTrack? mediaTrack,
    T? mediaConstraints,
    bool? stopTrackOnMute,
    RtcVideoDimension? videoDimension,
    rtc.RTCRtpReceiver? receiver,
    rtc.RTCRtpTransceiver? transceiver,
  }) {
    return RtcLocalTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      mediaStream: mediaStream ?? this.mediaStream,
      mediaTrack: mediaTrack ?? this.mediaTrack,
      mediaConstraints: mediaConstraints ?? this.mediaConstraints,
      stopTrackOnMute: stopTrackOnMute ?? this.stopTrackOnMute,
      videoDimension: videoDimension ?? this.videoDimension,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
    );
  }

  /// Recreates the track with new [mediaConstraints].
  Future<RtcLocalTrack<T>> recreate({T? mediaConstraints}) async {
    streamLog.i(_tag, () => 'Recreating track: $trackId');

    // Stop the current track.
    await stop();

    // Use the current constraints if none are provided.
    final constraints = mediaConstraints ?? this.mediaConstraints;

    // Create a new track with the new constraints.
    final newStream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final newTrack = newStream.getTracks().first;

    // Replace the track on the transceiver if it exists.
    final sender = transceiver?.sender;
    if (sender != null) {
      streamLog.i(_tag, () => 'Replacing track on sender');
      await sender.replaceTrack(newTrack);
    }

    return copyWith(
      mediaTrack: newTrack,
      mediaStream: newStream,
      mediaConstraints: constraints,
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
    return copyWith(
      mediaConstraints: mediaConstraints.copyWith(
        facingMode: isFrontCamera ? FacingMode.user : FacingMode.environment,
      ),
    );
  }

  Future<RtcLocalCameraTrack> selectVideoInput(RtcMediaDevice device) async {
    streamLog.i(_cameraTag, () => 'Selecting camera input: $device');

    final currentDeviceId = mediaConstraints.deviceId;
    // Check if the device is already selected.
    if (currentDeviceId == device.id) {
      streamLog.i(_cameraTag, () => 'Video input already selected: $device');
      return this;
    }

    // recreate the track with new deviceId.
    final updatedTrack = await recreate(
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
  Future<RtcLocalAudioTrack> selectAudioInput(RtcMediaDevice device) async {
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
      return recreate(mediaConstraints: updatedConstraints);
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
