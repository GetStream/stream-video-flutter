import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../third_party/flutter_webrtc/native/event_channel.dart';
import '../third_party/flutter_webrtc/native/utils.dart';

/// The [WebRtcPlatformEvents] read from the plugin's `FlutterWebRTC.Event`
/// channel.
@internal
class NativeWebRtcPlatformEvents implements WebRtcPlatformEvents {
  NativeWebRtcPlatformEvents._(this._events);

  static final NativeWebRtcPlatformEvents instance =
      NativeWebRtcPlatformEvents._(
        FlutterWebRTCEventChannel.instance.handleEvents.stream,
      );

  /// The raw events, each a single-entry map from the event name to the
  /// native payload.
  final Stream<Map<String, dynamic>> _events;

  /// The payloads of the events named [name].
  Stream<Map<dynamic, dynamic>> _payloads(String name) {
    return _events
        .where((event) => event.length == 1 && event.keys.first == name)
        .map((event) => event.values.first)
        .whereType<Map<dynamic, dynamic>>();
  }

  @override
  late final Stream<AudioRoute> onAudioRouteChanged =
      _payloads('onAudioRouteChange').map((payload) {
        final deviceId = payload['deviceId'] as String? ?? '';
        return AudioRoute(
          deviceId: deviceId,
          label: payload['label'] as String? ?? deviceId,
          groupId: payload['groupId'] as String?,
        );
      });

  @override
  late final Stream<SpeechActivity> onSpeechActivity =
      _payloads('onSpeechActivityChanged')
          .map(
            (payload) => switch (payload['type']) {
              'started' => SpeechActivity.started,
              'ended' => SpeechActivity.ended,
              _ => null,
            },
          )
          .whereType<SpeechActivity>();

  @override
  late final Stream<AudioProcessingState> onAudioProcessingStateChanged =
      _payloads('onAudioProcessingStateChanged').map(
        (payload) => AudioProcessingState(
          stereoPlayoutEnabled:
              payload['stereoPlayoutEnabled'] as bool? ?? false,
          voiceProcessingEnabled:
              payload['voiceProcessingEnabled'] as bool? ?? false,
          voiceProcessingBypassed:
              payload['voiceProcessingBypassed'] as bool? ?? false,
          voiceProcessingAGCEnabled:
              payload['voiceProcessingAGCEnabled'] as bool? ?? false,
        ),
      );

  @override
  late final Stream<void> onScreenSharingStarted = _payloads(
    'screenSharingStarted',
  ).map((_) {});

  @override
  late final Stream<ScreenSharingStopped> onScreenSharingStopped =
      _payloads(
        'screenSharingStopped',
      ).map(
        (payload) =>
            ScreenSharingStopped(trackId: payload['trackId'] as String?),
      );

  @override
  late final Stream<AudioInterruption> onInterruption = _events
      .where((event) => event.length == 1)
      .map(
        (event) => switch (event.keys.first) {
          'onInterruptionStart' => AudioInterruption.started,
          'onInterruptionEnd' => AudioInterruption.ended,
          _ => null,
        },
      )
      .whereType<AudioInterruption>();

  @override
  Future<void> enableInterruptionEvents({
    AndroidInterruptionSource androidInterruptionSource =
        AndroidInterruptionSource.audioFocusAndTelephony,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnimplementedError(
        'Audio interruptions are only reported on Android and iOS',
      );
    }

    await WebRTC.invokeMethod(
      'handleCallInterruptionCallbacks',
      <String, dynamic>{
        if (Platform.isAndroid)
          'androidInterruptionSource': androidInterruptionSource.name,
      },
    );
  }
}

extension on Stream<Object?> {
  Stream<T> whereType<T>() => where((it) => it is T).cast<T>();
}
