import '../../../platform_detector/platform_detector.dart';
import '../../../track/options.dart';
import '../../../types/video_parameters.dart';
import 'media_constraints.dart';

/// Options used when creating a video track that captures the screen.
class ScreenShareConstraints extends MediaConstraints {
  const ScreenShareConstraints({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    String? sourceId,
    this.maxFrameRate,
    this.params = VideoParametersPresets.screenShareH720FPS15,
  }) : super(deviceId: sourceId);

  ScreenShareConstraints.from({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    required VideoCaptureOptions captureOptions,
  })  : params = captureOptions.params,
        maxFrameRate = captureOptions.maxFrameRate,
        super(
          deviceId: captureOptions.deviceId,
        );

  final VideoParameters params;

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

  /// iOS only flag: Use Broadcast Extension for screen share capturing.
  /// See instructions on how to setup your Broadcast Extension here:
  /// https://github.com/flutter-webrtc/flutter-webrtc/wiki/iOS-Screen-Sharing#broadcast-extension-quick-setup
  final bool useiOSBroadcastExtension;
  final bool captureScreenAudio;

  @override
  Map<String, dynamic> toMap() {
    final constraints = params.toMediaConstraintsMap();
    if (useiOSBroadcastExtension && CurrentPlatform.isIos) {
      constraints['deviceId'] = 'broadcast';
    }
    if (CurrentPlatform.isDesktop) {
      if (deviceId != null) {
        constraints['deviceId'] = {'exact': deviceId};
      }
      if (maxFrameRate != 0.0) {
        constraints['mandatory'] = {'frameRate': maxFrameRate};
      }
    }
    return {
      'audio': captureScreenAudio,
      'video': constraints,
    };
  }

  @override
  ScreenShareConstraints copyWith({
    VideoParameters? params,
    String? deviceId,
    double? maxFrameRate,
    bool? captureScreenAudio,
    bool? useiOSBroadcastExtension,
  }) =>
      ScreenShareConstraints(
        params: params ?? this.params,
        sourceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
        captureScreenAudio: captureScreenAudio ?? this.captureScreenAudio,
        useiOSBroadcastExtension:
            useiOSBroadcastExtension ?? this.useiOSBroadcastExtension,
      );
}
