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

  /// The output's identifier. Never empty: a change without one is not
  /// reported.
  final String deviceId;

  /// The output's name, as the platform reports it.
  final String label;

  /// The kind of output (the port type on iOS).
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

/// Whether the app lost its audio to another app or a phone call, or got it
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
/// returns a stream that never emits, and [enableInterruptionEvents] throws
/// where interruptions are not reported.
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class WebRtcPlatformEvents {
  /// The active audio output route changed. iOS.
  Stream<AudioRoute> get onAudioRouteChanged;

  /// The local user started or stopped speaking while the microphone is
  /// muted. Android, iOS and macOS.
  Stream<SpeechActivity> get onSpeechActivity;

  /// The audio device module changed its audio processing. iOS and macOS.
  Stream<AudioProcessingState> get onAudioProcessingStateChanged;

  /// The iOS broadcast extension started a screen share. Posted by
  /// `stream_video_flutter`'s iOS plugin.
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
