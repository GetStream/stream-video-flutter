import '../../../platform_detector/platform_detector.dart';
import 'media_constraints.dart';

/// Options used when creating a video track that captures the screen.
class ScreenShareConstraints extends MediaConstraints {
  const ScreenShareConstraints({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    String? sourceId,
    this.maxFrameRate = 30,
    this.width = 1280,
    this.height = 720,
  }) : super(deviceId: sourceId);

  final int? width;
  final int? height;

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

  /// iOS only flag: Use Broadcast Extension for screen share capturing.
  /// See instructions on how to setup your Broadcast Extension here:
  /// https://github.com/flutter-webrtc/flutter-webrtc/wiki/iOS-Screen-Sharing#broadcast-extension-quick-setup
  final bool useiOSBroadcastExtension;
  final bool captureScreenAudio;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{
      'width': width,
      'height': height,
      'frameRate': maxFrameRate,
    };
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
    String? deviceId,
    int? width,
    int? height,
    double? maxFrameRate,
    bool? captureScreenAudio,
    bool? useiOSBroadcastExtension,
  }) =>
      ScreenShareConstraints(
        sourceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
        width: width ?? this.width,
        height: height ?? this.height,
        captureScreenAudio: captureScreenAudio ?? this.captureScreenAudio,
        useiOSBroadcastExtension:
            useiOSBroadcastExtension ?? this.useiOSBroadcastExtension,
      );
}
