import '../../platform_detector/platform_detector.dart';
import '../model/rtc_video_parameters.dart';
import 'video_constraints.dart';

/// Options used when creating a video track that captures the screen.
class ScreenShareConstraints extends VideoConstraints {
  const ScreenShareConstraints({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    String? sourceId,
    super.maxFrameRate,
    super.params = RtcVideoParametersPresets.h720_16x9,
  }) : super(deviceId: sourceId);

  ScreenShareConstraints.from({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    required VideoConstraints constraints,
  }) : super(
          deviceId: constraints.deviceId,
          maxFrameRate: constraints.maxFrameRate,
          params: constraints.params,
        );

  /// iOS only flag: Use Broadcast Extension for screen share capturing.
  /// See instructions on how to setup your Broadcast Extension here:
  /// https://github.com/flutter-webrtc/flutter-webrtc/wiki/iOS-Screen-Sharing#broadcast-extension-quick-setup
  final bool useiOSBroadcastExtension;
  final bool captureScreenAudio;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{...super.toMap()};
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
    RtcVideoParameters? params,
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
