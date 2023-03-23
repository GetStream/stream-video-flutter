import '../../platform_detector/platform_detector.dart';
import 'media_constraints.dart';

/// Options used when creating an AudioTrack.
class AudioConstraints extends MediaConstraints {
  const AudioConstraints({
    super.deviceId,
    this.noiseSuppression = true,
    this.echoCancellation = true,
    this.autoGainControl = true,
    this.highPassFilter = false,
    this.typingNoiseDetection = true,
  });

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
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{};

    /// in web platform it's not possible to provide optional and mandatory parameters.
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
        {'DtlsSrtpKeyAgreement': 'true'},
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
    return {
      'audio': constraints,
      'video': false,
    };
  }

  @override
  AudioConstraints copyWith({
    String? deviceId,
    bool? noiseSuppression,
    bool? echoCancellation,
    bool? autoGainControl,
    bool? highPassFilter,
    bool? typingNoiseDetection,
  }) =>
      AudioConstraints(
        deviceId: deviceId ?? this.deviceId,
        noiseSuppression: noiseSuppression ?? this.noiseSuppression,
        echoCancellation: echoCancellation ?? this.echoCancellation,
        autoGainControl: autoGainControl ?? this.autoGainControl,
        highPassFilter: highPassFilter ?? this.highPassFilter,
        typingNoiseDetection: typingNoiseDetection ?? this.typingNoiseDetection,
      );
}
