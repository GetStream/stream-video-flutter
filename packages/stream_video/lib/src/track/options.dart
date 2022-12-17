import '../platform_detector/platform_detector.dart';
import '../types/video_parameters.dart';

/// A type that represents front or back of the camera.
enum CameraPosition {
  front,
  back,
}

/// Convenience extension for [CameraPosition].
extension CameraPositionExt on CameraPosition {
  /// Return a [CameraPosition] which front and back is switched.
  CameraPosition switched() {
    switch (this) {
      case CameraPosition.front:
        return CameraPosition.back;
      case CameraPosition.back:
        return CameraPosition.front;
    }
  }
}

/// Options used when creating a [LocalVideoTrack] that captures the camera.
class CameraCaptureOptions extends VideoCaptureOptions {
  const CameraCaptureOptions({
    this.cameraPosition = CameraPosition.front,
    super.deviceId,
    super.maxFrameRate,
    super.params = VideoParametersPresets.h540_169,
  });

  CameraCaptureOptions.from({required VideoCaptureOptions captureOptions})
      : cameraPosition = CameraPosition.front,
        super(
          params: captureOptions.params,
          deviceId: captureOptions.deviceId,
          maxFrameRate: captureOptions.maxFrameRate,
        );

  final CameraPosition cameraPosition;

  @override
  Map<String, dynamic> toMediaConstraintsMap() {
    final constraints = <String, dynamic>{
      ...super.toMediaConstraintsMap(),
      'facingMode':
          cameraPosition == CameraPosition.front ? 'user' : 'environment',
    };
    if (deviceId != null) {
      if (CurrentPlatform.isWeb) {
        constraints['deviceId'] = deviceId;
      } else {
        constraints['optional'] = [
          {'sourceId': deviceId},
        ];
      }
    }
    if (maxFrameRate != null) {
      constraints['frameRate'] = {'max': maxFrameRate};
    }
    return constraints;
  }

  @override
  CameraCaptureOptions copyWith({
    VideoParameters? params,
    CameraPosition? cameraPosition,
    String? deviceId,
    double? maxFrameRate,
  }) =>
      CameraCaptureOptions(
        params: params ?? this.params,
        cameraPosition: cameraPosition ?? this.cameraPosition,
        deviceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
      );
}

/// Options used when creating a [LocalVideoTrack] that captures the screen.
class ScreenShareCaptureOptions extends VideoCaptureOptions {
  const ScreenShareCaptureOptions({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    String? sourceId,
    super.maxFrameRate,
    super.params = VideoParametersPresets.screenShareH720FPS15,
  }) : super(deviceId: sourceId);

  ScreenShareCaptureOptions.from({
    this.useiOSBroadcastExtension = false,
    this.captureScreenAudio = false,
    required VideoCaptureOptions captureOptions,
  }) : super(params: captureOptions.params);

  /// iOS only flag: Use Broadcast Extension for screen share capturing.
  /// See instructions on how to setup your Broadcast Extension here:
  /// https://github.com/flutter-webrtc/flutter-webrtc/wiki/iOS-Screen-Sharing#broadcast-extension-quick-setup
  final bool useiOSBroadcastExtension;
  final bool captureScreenAudio;

  @override
  Map<String, dynamic> toMediaConstraintsMap() {
    final constraints = super.toMediaConstraintsMap();
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
    return constraints;
  }

  @override
  ScreenShareCaptureOptions copyWith({
    VideoParameters? params,
    String? deviceId,
    double? maxFrameRate,
    bool? captureScreenAudio,
    bool? useiOSBroadcastExtension,
  }) =>
      ScreenShareCaptureOptions(
        params: params ?? this.params,
        sourceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
        captureScreenAudio: captureScreenAudio ?? this.captureScreenAudio,
        useiOSBroadcastExtension:
            useiOSBroadcastExtension ?? this.useiOSBroadcastExtension,
      );
}

/// Base class for options when creating a [LocalVideoTrack].
abstract class VideoCaptureOptions extends LocalTrackOptions {
  const VideoCaptureOptions({
    this.params = VideoParametersPresets.h540_169,
    this.deviceId,
    this.maxFrameRate,
  });
  final VideoParameters params;

  /// The deviceId of the capture device to use.
  /// Available deviceIds can be obtained through `flutter_webrtc`:
  /// <pre>
  /// import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
  ///
  /// List<MediaDeviceInfo> devices = await rtc.navigator.mediaDevices.enumerateDevices();
  /// // or
  /// List<DesktopCapturerSource> desktopSources = await rtc.desktopCapturer.getSources(types: [rtc.SourceType.Screen, rtc.SourceType.Window]);
  /// </pre>
  final String? deviceId;

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

  @override
  Map<String, dynamic> toMediaConstraintsMap() {
    return params.toMediaConstraintsMap();
  }
}

/// Options used when creating a [LocalAudioTrack].
class AudioCaptureOptions extends LocalTrackOptions {
  const AudioCaptureOptions({
    this.deviceId,
    this.noiseSuppression = true,
    this.echoCancellation = true,
    this.autoGainControl = true,
    this.highPassFilter = false,
    this.typingNoiseDetection = true,
  });

  /// The deviceId of the capture device to use.
  /// Available deviceIds can be obtained through `flutter_webrtc`:
  /// <pre>
  /// import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
  ///
  /// List<MediaDeviceInfo> devices = await rtc.navigator.mediaDevices.enumerateDevices();
  /// </pre>
  final String? deviceId;

  /// Attempt to use noiseSuppression option (if supported by the platform)
  /// See https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackSettings/noiseSuppression
  /// Defaults to true.
  final bool noiseSuppression;

  /// Attempt to use echoCancellation option (if supported by the platform)
  /// See https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackSettings/echoCancellation
  /// Defaults to true.
  final bool echoCancellation;

  /// Attempt to use autoGainControl option (if supported by the platform)
  /// See https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackConstraints/autoGainControl
  /// Defaults to true.
  final bool autoGainControl;

  /// Attempt to use highPassFilter options (if supported by the platform)
  /// Defaults to false.
  final bool highPassFilter;

  /// Attempt to use typingNoiseDetection option (if supported by the platform)
  /// Defaults to true.
  final bool typingNoiseDetection;

  @override
  Map<String, dynamic> toMediaConstraintsMap() {
    final constraints = <String, dynamic>{};

    /// in we platform it's not possible to provide optional and mandatory parameters.
    /// deviceId is a mandatory parameter
    if (!CurrentPlatform.isWeb || (CurrentPlatform.isWeb && deviceId == null)) {
      constraints['optional'] = <Map<String, dynamic>>[
        {'echoCancellation': echoCancellation},
        {'googDAEchoCancellation': echoCancellation},
        {'googEchoCancellation': echoCancellation},
        {'googEchoCancellation2': echoCancellation},
        {'noiseSuppression': noiseSuppression},
        {'googNoiseSuppression': noiseSuppression},
        {'googNoiseSuppression2': noiseSuppression},
        {'googAutoGainControl': autoGainControl},
        {'googHighpassFilter': highPassFilter},
        {'googTypingNoiseDetection': typingNoiseDetection},
      ];
    }

    if (deviceId != null) {
      if (CurrentPlatform.isWeb) {
        constraints['deviceId'] = deviceId;
      } else {
        constraints['optional']
            .cast<Map<String, dynamic>>()
            .add(<String, dynamic>{'sourceId': deviceId});
      }
    }
    return constraints;
  }

  @override
  AudioCaptureOptions copyWith({
    String? deviceId,
    bool? noiseSuppression,
    bool? echoCancellation,
    bool? autoGainControl,
    bool? highPassFilter,
    bool? typingNoiseDetection,
  }) =>
      AudioCaptureOptions(
        deviceId: deviceId ?? this.deviceId,
        noiseSuppression: noiseSuppression ?? this.noiseSuppression,
        echoCancellation: echoCancellation ?? this.echoCancellation,
        autoGainControl: autoGainControl ?? this.autoGainControl,
        highPassFilter: highPassFilter ?? this.highPassFilter,
        typingNoiseDetection: typingNoiseDetection ?? this.typingNoiseDetection,
      );
}

/// Base class for track options.
abstract class LocalTrackOptions {
  const LocalTrackOptions();

  // All subclasses must be able to report constraints
  Map<String, dynamic> toMediaConstraintsMap();

  LocalTrackOptions copyWith();

  /// The [when] method is the equivalent to pattern matching.
  T when<T extends Object>({
    required T Function(AudioCaptureOptions) onAudio,
    required T Function(VideoCaptureOptions) onVideo,
  }) {
    if (this is AudioCaptureOptions) {
      return onAudio(this as AudioCaptureOptions);
    } else if (this is VideoCaptureOptions) {
      return onVideo(this as VideoCaptureOptions);
    } else {
      throw Exception('Unknown LocalTrackOptions type');
    }
  }
}
