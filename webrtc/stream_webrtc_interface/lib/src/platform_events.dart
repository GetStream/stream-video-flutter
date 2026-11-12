import 'package:meta/meta.dart';

import 'third_party/flutter_webrtc/android_audio_configuration.dart';

/// The audio output route the platform switched to.
@immutable
class AudioRoute {
  const AudioRoute({
    required this.deviceId,
    required this.label,
    this.groupId,
  });

  /// The output's identifier. Empty when the platform reported none.
  final String deviceId;

  /// The output's name, as the platform reports it. The [deviceId] when the
  /// platform reports no name.
  final String label;

  /// The kind of output (the port type on iOS and macOS).
  final String? groupId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioRoute &&
          other.deviceId == deviceId &&
          other.label == label &&
          other.groupId == groupId;

  @override
  int get hashCode => Object.hash(deviceId, label, groupId);

  @override
  String toString() =>
      'AudioRoute(deviceId: $deviceId, label: $label, groupId: $groupId)';
}

/// Whether the local user started or stopped speaking, reported by the audio
/// device module while the microphone is muted.
enum SpeechActivity { started, ended }

/// Whether another audio session took the audio from the app, or gave it
/// back.
enum AudioInterruption { started, ended }

/// The audio processing the audio device module applies, reported whenever
/// it changes.
@immutable
class AudioProcessingState {
  const AudioProcessingState({
    required this.stereoPlayoutEnabled,
    required this.voiceProcessingEnabled,
    required this.voiceProcessingBypassed,
    required this.voiceProcessingAGCEnabled,
  });

  final bool stereoPlayoutEnabled;
  final bool voiceProcessingEnabled;
  final bool voiceProcessingBypassed;
  final bool voiceProcessingAGCEnabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioProcessingState &&
          other.stereoPlayoutEnabled == stereoPlayoutEnabled &&
          other.voiceProcessingEnabled == voiceProcessingEnabled &&
          other.voiceProcessingBypassed == voiceProcessingBypassed &&
          other.voiceProcessingAGCEnabled == voiceProcessingAGCEnabled;

  @override
  int get hashCode => Object.hash(
    stereoPlayoutEnabled,
    voiceProcessingEnabled,
    voiceProcessingBypassed,
    voiceProcessingAGCEnabled,
  );

  @override
  String toString() =>
      'AudioProcessingState(stereoPlayoutEnabled: $stereoPlayoutEnabled, '
      'voiceProcessingEnabled: $voiceProcessingEnabled, '
      'voiceProcessingBypassed: $voiceProcessingBypassed, '
      'voiceProcessingAGCEnabled: $voiceProcessingAGCEnabled)';
}

/// A screen share that ended outside the app's control: the user stopped it
/// from the system UI, or the capture source went away.
@immutable
class ScreenSharingStopped {
  const ScreenSharingStopped({this.trackId});

  /// The track whose capture stopped. Null when the platform does not say,
  /// as for the iOS broadcast extension.
  final String? trackId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenSharingStopped && other.trackId == trackId;

  @override
  int get hashCode => trackId.hashCode;

  @override
  String toString() => 'ScreenSharingStopped(trackId: $trackId)';
}

/// The events the WebRTC platform implementation reports outside of a peer
/// connection, a track or a renderer.
///
/// Every stream is a broadcast stream. A platform that never reports an event
/// returns a stream that never emits.
abstract class WebRtcPlatformEvents {
  /// The audio output route changed outside the app's control, for example
  /// from the system route picker. iOS and macOS.
  Stream<AudioRoute> get onAudioRouteChanged;

  /// The local user started or stopped speaking while the microphone is
  /// muted. Android, iOS and macOS.
  Stream<SpeechActivity> get onSpeechActivity;

  /// The audio device module changed its audio processing. iOS and macOS.
  Stream<AudioProcessingState> get onAudioProcessingStateChanged;

  /// The iOS broadcast extension started a screen share.
  Stream<void> get onScreenSharingStarted;

  /// A screen share stopped outside the app's control. Android, iOS and
  /// macOS.
  Stream<ScreenSharingStopped> get onScreenSharingStopped;

  /// Audio interruptions, reported once [enableInterruptionEvents] has run.
  /// Android and iOS.
  Stream<AudioInterruption> get onInterruption;

  /// Starts reporting audio interruptions on [onInterruption].
  ///
  /// On Android, [androidInterruptionSource] picks what counts as an
  /// interruption. Throws [UnimplementedError] on platforms other than Android
  /// and iOS.
  Future<void> enableInterruptionEvents({
    AndroidInterruptionSource androidInterruptionSource =
        AndroidInterruptionSource.audioFocusAndTelephony,
  });
}
