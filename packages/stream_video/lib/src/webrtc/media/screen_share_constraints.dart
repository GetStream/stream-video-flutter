import '../model/rtc_video_parameters.dart';
import 'screen_share_source.dart';
import 'video_constraints.dart';

/// Options used when creating a video track that captures the screen.
class ScreenShareConstraints extends VideoConstraints {
  const ScreenShareConstraints({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    String? sourceId,
    super.maxFrameRate,
    super.params = RtcVideoParametersPresets.h1080_16x9,
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

  /// The [sourceId] that makes macOS show the system content sharing picker
  /// instead of capturing a source chosen in-app.
  ///
  /// macOS 14 or newer only.
  static const systemPickerSourceId = 'system-picker';

  /// iOS only flag: Use Broadcast Extension for screen share capturing.
  /// See instructions on how to setup your Broadcast Extension here:
  /// https://github.com/flutter-webrtc/flutter-webrtc/wiki/iOS-Screen-Sharing#broadcast-extension-quick-setup
  final bool useiOSBroadcastExtension;
  final bool captureScreenAudio;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{...super.toMap()};
    ScreenShareSource.forPlatform().addTo(constraints, this);
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
  }) => ScreenShareConstraints(
    params: params ?? this.params,
    sourceId: deviceId ?? this.deviceId,
    maxFrameRate: maxFrameRate ?? this.maxFrameRate,
    captureScreenAudio: captureScreenAudio ?? this.captureScreenAudio,
    useiOSBroadcastExtension:
        useiOSBroadcastExtension ?? this.useiOSBroadcastExtension,
  );
}
