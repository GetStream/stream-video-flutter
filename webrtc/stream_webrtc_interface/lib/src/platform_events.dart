import 'package:meta/meta.dart';

import 'speech_activity_detector.dart';

/// The audio output route the platform switched to.
@immutable
class AudioRoute {
  const AudioRoute({
    required this.deviceId,
    required this.label,
    this.groupId,
    this.reasonCode,
  });

  /// The output's identifier. Never empty: a change without one is not
  /// reported.
  final String deviceId;

  /// The output's name, as the platform reports it.
  final String label;

  /// The kind of output (the port type on iOS).
  final String? groupId;

  /// Why the route changed: the raw `AVAudioSessionRouteChangeReason` on iOS.
  /// Null when the platform does not report it.
  final int? reasonCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioRoute &&
          other.deviceId == deviceId &&
          other.label == label &&
          other.groupId == groupId &&
          other.reasonCode == reasonCode;

  @override
  int get hashCode => Object.hash(deviceId, label, groupId, reasonCode);

  @override
  String toString() =>
      'AudioRoute(deviceId: $deviceId, label: $label, groupId: $groupId, '
      'reasonCode: $reasonCode)';
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

  /// Whether remote audio plays out in stereo.
  final bool stereoPlayoutEnabled;

  /// Whether the voice processing audio unit is in use.
  final bool voiceProcessingEnabled;

  /// Whether voice processing (echo cancellation, noise suppression) is
  /// bypassed.
  final bool voiceProcessingBypassed;

  /// Whether automatic gain control is on.
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
  /// muted, reported by the audio device module. Android, iOS and macOS.
  Stream<SpeechActivity> get onSpeechActivity;

  /// Creates a detector of the local user's speech while the microphone is
  /// muted, independent of every other detector. Android, iOS, macOS and the
  /// browser; on Windows and Linux it never reports.
  SpeechActivityDetector createSpeechActivityDetector();

  /// The audio device module changed its audio processing. iOS and macOS.
  Stream<AudioProcessingState> get onAudioProcessingStateChanged;

  /// The iOS broadcast extension started a screen share.
  Stream<void> get onScreenSharingStarted;

  /// A screen share stopped outside the app's control: on Android, from the
  /// system UI; on macOS, a share started from the system content picker; on
  /// iOS, the broadcast extension.
  Stream<ScreenSharingStopped> get onScreenSharingStopped;

  /// Audio interruptions, reported once [enableInterruptionEvents] has run.
  /// Android and iOS.
  Stream<AudioInterruption> get onInterruption;

  /// Starts reporting audio interruptions on [onInterruption].
  ///
  /// Call it once. On Android, calling it again while an interruption is in
  /// progress drops that interruption, and its end is never reported.
  ///
  /// On Android, an interruption is the call losing the audio focus it holds
  /// while its audio runs; on iOS, an audio session interruption. Throws
  /// [UnimplementedError] on platforms other than Android and iOS.
  Future<void> enableInterruptionEvents();
}
