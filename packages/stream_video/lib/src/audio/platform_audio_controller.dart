import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video.dart';
import '../call/stats/trace_tag.dart';
import '../call/stats/tracer.dart';
import '../webrtc/rtc_audio_api/rtc_audio_api.dart' as rtc_audio;

abstract class InterruptionEvent {}

class InterruptionBeginEvent extends InterruptionEvent {}

class InterruptionEndEvent extends InterruptionEvent {}

abstract class NativeWebRtcEvent {}

/// A screen share stopped outside the app's control.
class ScreenSharingStoppedEvent extends NativeWebRtcEvent {
  ScreenSharingStoppedEvent({this.trackId});

  /// The track whose capture stopped. Null for the iOS broadcast extension.
  final String? trackId;
}

/// The iOS broadcast extension started a screen share.
class ScreenSharingStartedEvent extends NativeWebRtcEvent {}

/// Emitted (iOS) when the active audio output route changes outside of an
/// explicit [Call.setAudioOutputDevice] call, e.g. when the user picks a
/// different output through the native route-selection UI
/// ([PlatformAudioController.triggeriOSAudioRouteSelectionUI]).
class AudioRouteChangedEvent extends NativeWebRtcEvent {
  AudioRouteChangedEvent({required this.device});
  final RtcMediaDevice device;
}

sealed class SpeechActivityEvent {
  const SpeechActivityEvent();
}

class SpeechActivityStarted extends SpeechActivityEvent {
  const SpeechActivityStarted();
}

class SpeechActivityEnded extends SpeechActivityEvent {
  const SpeechActivityEnded();
}

/// The app-wide audio of the platform: playout pause, interruptions, the
/// audio configuration, speech activity and the screen share and audio route
/// events the WebRTC plugin reports.
class PlatformAudioController {
  PlatformAudioController._internal() {
    // Routes remote audio playback traces (web only).
    rtc_audio.setAudioTraceHandler(_tracer.trace);

    _listenForAudioProcessingStateChanges();
  }

  static PlatformAudioController? _instance;

  /// The shared [PlatformAudioController] instance.
  ///
  /// Created lazily on first access so that platform channels are only
  /// touched when the controller is actually used.
  // ignore: prefer_constructors_over_static_methods, lazy singleton accessor
  static PlatformAudioController get instance =>
      _instance ??= PlatformAudioController._internal();

  /// Overrides the shared [instance], for testing.
  ///
  /// Pass `null` to restore the default lazily-created instance. Always
  /// reset the override (e.g. in `tearDown`) to avoid leaking a mock between
  /// tests.
  @visibleForTesting
  static set instance(PlatformAudioController? controller) =>
      _instance = controller;

  final _tracer = Tracer(null);

  @internal
  TraceSlice getTrace() {
    return _tracer.take();
  }

  /// Whether the local user started or stopped speaking while the microphone
  /// is muted.
  Stream<SpeechActivityEvent> get speechActivityStream =>
      platformEvents.onSpeechActivity.map(
        (activity) => switch (activity) {
          rtc.SpeechActivity.started => const SpeechActivityStarted(),
          rtc.SpeechActivity.ended => const SpeechActivityEnded(),
        },
      );

  /// The events the WebRTC plugin reports. Replaceable in tests, because the
  /// plugin reports interruptions only on Android and iOS hosts.
  @visibleForTesting
  rtc.WebRtcPlatformEvents platformEvents = rtc.platformEvents;

  /// Allows to handle call interruption callbacks.
  /// [onInterruptionStart] is called when the call interruption begins.
  /// [onInterruptionEnd] is called when the call interruption ends.
  /// [androidInterruptionSource] specifies the source of the interruption on Android.
  ///
  /// On iOS, interruptions can occur due to:
  /// - Incoming phone calls
  /// - Siri activation
  /// - Alarm or timer sounds
  /// - Audio from other apps taking over (e.g., voice memo, navigation)
  ///
  /// On Android, interruption sources depend on the [androidInterruptionSource]:
  /// - With audioFocus:
  ///   - Other media apps interrupting (e.g., Spotify)
  ///   - Assistant voice prompts (e.g., Google Assistant)
  ///   - Alarms and notifications
  /// - With telephony:
  ///   - Phone calls (requires READ_PHONE_STATE permission)
  ///
  /// This method allows you to pause the call, mute the audio, or perform any other
  /// necessary actions when interruptions occur.
  ///
  /// For more details on handling call interruptions, refer to the
  /// [Stream Video documentation](https://getstream.io/video/docs/flutter/advanced/handling-system-audio-interruptions/).
  Future<void> handleCallInterruptionCallbacks({
    void Function()? onInterruptionStart,
    void Function()? onInterruptionEnd,
    rtc.AndroidInterruptionSource androidInterruptionSource =
        rtc.AndroidInterruptionSource.audioFocusAndTelephony,
  }) async {
    await platformEvents.enableInterruptionEvents(
      androidInterruptionSource: androidInterruptionSource,
    );

    final cancelPrevious = _interruptionSubscription?.cancel();
    _interruptionSubscription = platformEvents.onInterruption.listen((
      interruption,
    ) {
      switch (interruption) {
        case rtc.AudioInterruption.started:
          onInterruptionStart?.call();
        case rtc.AudioInterruption.ended:
          onInterruptionEnd?.call();
      }
    });
    await cancelPrevious;
  }

  StreamSubscription<rtc.AudioInterruption>? _interruptionSubscription;

  /// The screen share and audio route changes the platform reports.
  Stream<NativeWebRtcEvent> nativeWebRtcEventsStream() {
    final events = platformEvents;
    return Rx.merge<NativeWebRtcEvent>([
      events.onScreenSharingStopped.map(
        (stopped) => ScreenSharingStoppedEvent(trackId: stopped.trackId),
      ),
      events.onScreenSharingStarted.map((_) => ScreenSharingStartedEvent()),
      events.onAudioRouteChanged.map(
        (route) => AudioRouteChangedEvent(
          device: RtcMediaDevice(
            id: route.deviceId,
            label: route.label,
            groupId: route.groupId,
            kind: RtcMediaDeviceKind.audioOutput,
          ),
        ),
      ),
    ]).asBroadcastStream();
  }

  void _listenForAudioProcessingStateChanges() {
    platformEvents.onAudioProcessingStateChanged.listen((state) {
      _tracer.trace(
        TraceTag.audioProcessingStateChanged,
        {
          'stereoPlayoutEnabled': state.stereoPlayoutEnabled,
          'voiceProcessingEnabled': state.voiceProcessingEnabled,
          'voiceProcessingBypassed': state.voiceProcessingBypassed,
          'voiceProcessingAGCEnabled': state.voiceProcessingAGCEnabled,
        },
      );
    });
  }

  Future<void> triggeriOSAudioRouteSelectionUI() {
    return rtc.Helper.triggeriOSAudioRouteSelectionUI();
  }

  /// Whether [pauseAudioPlayout] can mute remote audio on this platform.
  ///
  /// Supported on Android, iOS, macOS and web. On Windows and Linux pausing
  /// playout is not implemented, so [pauseAudioPlayout] and
  /// [resumeAudioPlayout] do nothing and [isAudioPlayoutPaused] stays `false`.
  bool get isAudioPlayoutPauseSupported =>
      rtc.webRtcCapabilities.supportsAudioPlayoutPause;

  /// Whether remote audio playout is currently paused via
  /// [pauseAudioPlayout].
  ///
  /// Playout is app-wide, so this reflects every call, not just one. Always
  /// `false` where [isAudioPlayoutPauseSupported] is `false`.
  bool get isAudioPlayoutPaused => _audioPlayoutPausedController.value;

  /// Emits whenever [isAudioPlayoutPaused] changes. A new listener receives
  /// the current value first.
  Stream<bool> get audioPlayoutPausedChanges =>
      _audioPlayoutPausedController.stream;

  final _audioPlayoutPausedController = BehaviorSubject<bool>.seeded(false);

  /// Pauses playout in the WebRTC plugin. Replaceable in tests, because the
  /// plugin only reaches the platform channel on Android, iOS and macOS hosts.
  @visibleForTesting
  Future<void> Function() nativePauseAudioPlayout =
      rtc.Helper.pauseAudioPlayout;

  /// Resumes playout in the WebRTC plugin, see [nativePauseAudioPlayout].
  @visibleForTesting
  Future<void> Function() nativeResumeAudioPlayout =
      rtc.Helper.resumeAudioPlayout;

  /// Temporarily mutes all audio output (playout) from the app.
  /// This does not affect the microphone, the audio output route or remote
  /// track subscriptions; remote tracks that arrive while paused start muted.
  /// Use as a global "mute all sounds" toggle or when the app goes to background.
  ///
  /// Observe [isAudioPlayoutPaused] / [audioPlayoutPausedChanges] to reflect
  /// the state in UI. Does nothing where [isAudioPlayoutPauseSupported] is
  /// `false` (Windows, Linux).
  Future<void> pauseAudioPlayout() async {
    if (!isAudioPlayoutPauseSupported) return;

    _tracer.trace(TraceTag.pauseAudioPlayout, null);
    await nativePauseAudioPlayout();
    rtc_audio.setAudioPlayoutPaused(paused: true);
    _setAudioPlayoutPaused(true);
  }

  /// Resumes audio output (playout) muted via [pauseAudioPlayout].
  /// Does not change microphone state or remote track subscriptions.
  /// Does nothing where [isAudioPlayoutPauseSupported] is `false`.
  Future<void> resumeAudioPlayout() async {
    if (!isAudioPlayoutPauseSupported) return;

    _tracer.trace(TraceTag.resumeAudioPlayout, null);
    await nativeResumeAudioPlayout();
    rtc_audio.setAudioPlayoutPaused(paused: false);
    _setAudioPlayoutPaused(false);
  }

  void _setAudioPlayoutPaused(bool paused) {
    if (_audioPlayoutPausedController.value == paused) return;
    _audioPlayoutPausedController.add(paused);
  }

  /// Emits whenever the browser's autoplay policy starts or stops blocking
  /// remote audio playback.
  ///
  /// The remote audio elements are page-global, so this reflects playback
  /// across every call running on the page. Consumed by [Call] to keep
  /// [CallState.isWebAudioPlaybackBlocked] up to date; integrators observe
  /// `call.state` instead.
  @internal
  Stream<bool> get webAudioPlaybackBlockedChanges =>
      rtc_audio.audioPlaybackBlockedChanges;

  /// Retries playback of the remote audio elements the browser's autoplay
  /// policy blocked. Must be called from within a user gesture (e.g. a button
  /// tap) for the browser to allow it.
  ///
  /// Observe [CallState.isWebAudioPlaybackBlocked] to know when it is needed.
  /// Within a call, prefer `Call.resumeWebAudioPlayback()`, which forwards
  /// here; this entry point exists for code that has no `Call` at hand.
  ///
  /// Web only; a no-op on other platforms. Unrelated to [resumeAudioPlayout],
  /// which unmutes playout paused via [pauseAudioPlayout].
  Future<void> resumeWebAudioPlayback() => rtc_audio.resumeAudioPlayback();

  /// Regains Android audio focus if it was lost.
  ///
  /// Note: On Android, audio focus may not be restored automatically.
  /// To ensure you receive `onInterruptionEnd`, explicitly call
  /// [resumeAudioPlayout] (e.g., when the app resumes from background).
  Future<void> regainAndroidAudioFocus() {
    _tracer.trace(TraceTag.regainAndroidAudioFocus, null);
    return rtc.Helper.regainAndroidAudioFocus();
  }

  /// Refreshes the snapshot the implicit native peer-connection factory will
  /// use the next time it is built.
  ///
  /// Already-built factories keep their original configuration: the new
  /// snapshot only takes effect on subsequent factory builds.
  Future<void> reinitializeAudioConfiguration(
    AudioConfigurationPolicy policy,
  ) async {
    // Leaves the Apple audio session as it is; iOS gets the stereo playout
    // preference below.
    final options = policy.toFactoryOptions();
    await rtc.WebRTC.initialize(
      refresh: true,
      factoryOptions: rtc.PeerConnectionFactoryOptions(
        bypassVoiceProcessing: options.bypassVoiceProcessing,
        androidAudioConfiguration: options.androidAudioConfiguration,
      ),
    );

    // On iOS, configure stereo playout preference based on the policy.
    // When voice processing is bypassed (e.g. ViewerAudioPolicy), stereo
    // playout is preferred for high-fidelity audio.
    if (CurrentPlatform.isIos) {
      await rtc.Helper.setiOSStereoPlayoutPreferred(
        policy.bypassVoiceProcessing,
      );
    }
  }
}
