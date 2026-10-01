import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import '../../call/stats/trace_tag.dart';
import '../../call/stats/tracer.dart';
import '../../errors/video_error_composer.dart';
import '../../utils/extensions.dart';
import '../rtc_audio_api/rtc_audio_api.dart' as rtc_audio;
import 'device_enumeration_trigger.dart';

abstract class InterruptionEvent {}

class InterruptionBeginEvent extends InterruptionEvent {}

class InterruptionEndEvent extends InterruptionEvent {}

abstract class NativeWebRtcEvent {}

class ScreenSharingStoppedEvent extends NativeWebRtcEvent {
  ScreenSharingStoppedEvent({this.data});
  final Map<dynamic, dynamic>? data;
}

class ScreenSharingStartedEvent extends NativeWebRtcEvent {
  ScreenSharingStartedEvent({this.data});
  final Map<dynamic, dynamic>? data;
}

/// Emitted (iOS) when the active audio output route changes outside of an
/// explicit [Call.setAudioOutputDevice] call, e.g. when the user picks a
/// different output through the native route-selection UI
/// ([RtcMediaDeviceNotifier.triggeriOSAudioRouteSelectionUI]).
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

class RtcMediaDeviceNotifier {
  RtcMediaDeviceNotifier._internal() {
    rtc.navigator.mediaDevices.ondevicechange = _onDeviceChange;
    // Reads the initial devices list.
    enumerateDevicesFor(DeviceEnumerationTrigger.initial);

    // Routes remote audio playback traces (web only).
    rtc_audio.setAudioTraceHandler(_tracer.trace);

    _listenForAudioProcessingStateChanges();
    _listenForSpeechActivityChanges();
  }

  static final instance = RtcMediaDeviceNotifier._internal();

  Stream<List<RtcMediaDevice>> get onDeviceChange => _devicesController.stream;
  final _devicesController = BehaviorSubject<List<RtcMediaDevice>>();

  Stream<SpeechActivityEvent> get speechActivityStream =>
      _speechActivityController.stream;
  final _speechActivityController =
      StreamController<SpeechActivityEvent>.broadcast();

  final _tracer = Tracer(null);

  /// How long device-change events are collected before the devices are
  /// enumerated once for all of them.
  @visibleForTesting
  static const deviceChangeDebounce = Duration(milliseconds: 250);

  Timer? _deviceChangeTimer;

  /// The enumeration currently running on the platform, shared by every
  /// caller that asks for the devices while it runs.
  Future<Result<List<RtcMediaDevice>>>? _pendingEnumeration;

  @internal
  TraceSlice getTrace() {
    return _tracer.take();
  }

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
    @Deprecated(
      'Audio focus is now handled in a way that does not require this parameter. It will be removed in the next major version.',
    )
    rtc.AndroidAudioAttributesUsageType? androidAudioAttributesUsageType,
    @Deprecated(
      'Audio focus is now handled in a way that does not require this parameter. It will be removed in the next major version.',
    )
    rtc.AndroidAudioAttributesContentType? androidAudioAttributesContentType,
  }) {
    return rtc.handleCallInterruptionCallbacks(
      onInterruptionStart,
      onInterruptionEnd,
      androidInterruptionSource: androidInterruptionSource,
    );
  }

  Stream<NativeWebRtcEvent> nativeWebRtcEventsStream() {
    return rtc.eventStream
        .map<NativeWebRtcEvent?>((data) {
          if (data.isEmpty) return null;

          final event = data.keys.first;
          final values = data.values.first;

          if (values is! Map<dynamic, dynamic>?) return null;

          switch (event) {
            case 'screenSharingStopped':
              return ScreenSharingStoppedEvent(data: values);
            case 'screenSharingStarted':
              return ScreenSharingStartedEvent(data: values);
            case 'onAudioRouteChange':
              final deviceId = values?['deviceId'] as String?;
              if (deviceId == null || deviceId.isEmpty) return null;
              return AudioRouteChangedEvent(
                device: RtcMediaDevice(
                  id: deviceId,
                  label: values?['label'] as String? ?? deviceId,
                  groupId: values?['groupId'] as String?,
                  kind: RtcMediaDeviceKind.audioOutput,
                ),
              );
            default:
              return null;
          }
        })
        .whereNotNull()
        .asBroadcastStream();
  }

  void _listenForAudioProcessingStateChanges() {
    rtc.eventStream.listen((data) {
      if (data.isEmpty) return;

      final event = data.keys.first;
      if (event != 'onAudioProcessingStateChanged') return;

      final values = data.values.first;
      if (values is! Map<dynamic, dynamic>) return;

      final stereoPlayoutEnabled =
          values['stereoPlayoutEnabled'] as bool? ?? false;
      final voiceProcessingEnabled =
          values['voiceProcessingEnabled'] as bool? ?? false;
      final voiceProcessingBypassed =
          values['voiceProcessingBypassed'] as bool? ?? false;
      final voiceProcessingAGCEnabled =
          values['voiceProcessingAGCEnabled'] as bool? ?? false;

      _tracer.trace(
        TraceTag.audioProcessingStateChanged,
        {
          'stereoPlayoutEnabled': stereoPlayoutEnabled,
          'voiceProcessingEnabled': voiceProcessingEnabled,
          'voiceProcessingBypassed': voiceProcessingBypassed,
          'voiceProcessingAGCEnabled': voiceProcessingAGCEnabled,
        },
      );
    });
  }

  void _listenForSpeechActivityChanges() {
    rtc.eventStream.listen((data) {
      if (data.isEmpty) return;

      final event = data.keys.first;
      if (event != 'onSpeechActivityChanged') return;

      final values = data.values.first;
      if (values is! Map<dynamic, dynamic>) return;

      switch (values['type']) {
        case 'started':
          _speechActivityController.add(const SpeechActivityStarted());
        case 'ended':
          _speechActivityController.add(const SpeechActivityEnded());
      }
    });
  }

  void _onDeviceChange(_) {
    // A single physical change (e.g. a headset connecting) can arrive as
    // several events, and enumerating is expensive on some platforms (on
    // Android it blocks the main thread), so enumerate once per burst.
    _deviceChangeTimer?.cancel();
    _deviceChangeTimer = Timer(deviceChangeDebounce, () {
      enumerateDevicesFor(DeviceEnumerationTrigger.deviceChange);
    });
  }

  /// Returns the available media devices, optionally filtered by [kind], and
  /// emits the full list on [onDeviceChange].
  ///
  /// Calls made while an enumeration is already running share its result
  /// instead of starting another one.
  Future<Result<List<RtcMediaDevice>>> enumerateDevices({
    RtcMediaDeviceKind? kind,
  }) {
    return enumerateDevicesFor(DeviceEnumerationTrigger.explicit, kind: kind);
  }

  /// [enumerateDevices], recording [trigger] in the RTC trace as the reason
  /// the devices are read.
  @internal
  Future<Result<List<RtcMediaDevice>>> enumerateDevicesFor(
    DeviceEnumerationTrigger trigger, {
    RtcMediaDeviceKind? kind,
  }) async {
    var pending = _pendingEnumeration;

    // A device change that lands while an enumeration runs may not be
    // reflected in its result, so wait for it and read the devices again.
    if (pending != null && trigger == DeviceEnumerationTrigger.deviceChange) {
      await pending;
      pending = _pendingEnumeration;
    }

    _tracer.trace(TraceTag.enumerateDevicesTrigger, {
      'trigger': trigger.name,
      'coalesced': pending != null,
    });

    final result = await (pending ?? _startEnumeration());

    final allDevices = result.getDataOrNull();
    if (allDevices == null) return result;

    if (kind == null) {
      if (allDevices.isEmpty) return Result.error('No devices found');
      // The shared list is unmodifiable, so give each caller its own copy.
      return Result.success(allDevices.toList());
    }

    final devices = allDevices.where((d) => d.kind == kind).toList();
    if (devices.isEmpty) {
      return Result.error('No devices found for kind: $kind');
    }
    return Result.success(devices);
  }

  Future<Result<List<RtcMediaDevice>>> _startEnumeration() {
    final enumeration = _enumerateAllDevices();
    _pendingEnumeration = enumeration;
    enumeration.whenComplete(() {
      if (identical(_pendingEnumeration, enumeration)) {
        _pendingEnumeration = null;
      }
    }).ignore();
    return enumeration;
  }

  Future<Result<List<RtcMediaDevice>>> _enumerateAllDevices() async {
    try {
      final devices = await rtc.navigator.mediaDevices.enumerateDevices();

      // Shared by every caller of a coalesced enumeration and every
      // [onDeviceChange] listener, so it must not be mutated.
      final mediaDevices = List<RtcMediaDevice>.unmodifiable([
        ...devices.map((it) {
          return RtcMediaDevice(
            id: it.deviceId,
            label: it.label,
            groupId: it.groupId,
            kind: RtcMediaDeviceKind.fromAlias(it.kind),
          );
        }),

        if (CurrentPlatform.isIos &&
            devices.none(
              (d) => d.deviceId.equalsIgnoreCase(
                AudioSettingsRequestDefaultDeviceEnum.earpiece.value,
              ),
            ))
          RtcMediaDevice(
            id: AudioSettingsRequestDefaultDeviceEnum.earpiece.value,
            label: AudioSettingsRequestDefaultDeviceEnum.earpiece.value
                .capitalizeFirstLetter(),
            kind: RtcMediaDeviceKind.audioOutput,
          ),
      ]);

      _tracer.trace(
        TraceTag.enumerateDevices,
        mediaDevices.map((device) => device.toJson()).toList(),
      );

      _devicesController.add(mediaDevices);

      return Result.success(mediaDevices);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<List<RtcMediaDevice>>> audioInputs() {
    return enumerateDevices(kind: RtcMediaDeviceKind.audioInput);
  }

  Future<Result<List<RtcMediaDevice>>> audioOutputs() {
    return enumerateDevices(kind: RtcMediaDeviceKind.audioOutput);
  }

  Future<Result<List<RtcMediaDevice>>> videoInputs() {
    return enumerateDevices(kind: RtcMediaDeviceKind.videoInput);
  }

  Future<void> triggeriOSAudioRouteSelectionUI() {
    return rtc.Helper.triggeriOSAudioRouteSelectionUI();
  }

  /// Temporarily mutes all audio output (playout) from the app.
  /// This does not affect the microphone or remote track subscriptions.
  /// Use as a global "mute all sounds" toggle or when the app goes to background.
  Future<void> pauseAudioPlayout() {
    _tracer.trace(TraceTag.pauseAudioPlayout, null);
    return rtc.Helper.pauseAudioPlayout();
  }

  /// Resumes audio output (playout) muted via [pauseAudioPlayout].
  /// Does not change microphone state or remote track subscriptions.
  Future<void> resumeAudioPlayout() {
    _tracer.trace(TraceTag.resumeAudioPlayout, null);
    return rtc.Helper.resumeAudioPlayout();
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
    await rtc.WebRTC.initialize(
      refresh: true,
      options: {
        'bypassVoiceProcessing': policy.bypassVoiceProcessing,
        if (CurrentPlatform.isAndroid)
          'androidAudioConfiguration': policy.getAndroidConfiguration().toMap(),
      },
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
