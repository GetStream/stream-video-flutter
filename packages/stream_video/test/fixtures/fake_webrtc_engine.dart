// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'webrtc_capabilities.dart';

// ignore: subtype_of_sealed_class, a fake for the tests
/// A [WebRtcEngine] that records what the SDK asks of it. Members a test
/// does not set up throw.
class FakeWebRtcEngine extends Fake implements WebRtcEngine {
  FakeWebRtcEngine({WebRtcPlatformEvents? events, this.fixedCapabilities})
    : events = events ?? FakePlatformEvents();

  /// The capabilities to report. When null, the test's
  /// [debugWebRtcCapabilitiesOverride] or else Android's.
  WebRtcCapabilities? fixedCapabilities;

  @override
  WebRtcCapabilities get capabilities =>
      fixedCapabilities ??
      debugWebRtcCapabilitiesOverride ??
      webRtcCapabilitiesOf(PlatformType.android);

  @override
  final WebRtcPlatformEvents events;

  @override
  final FakeWebRtcAudio audio = FakeWebRtcAudio();

  /// The options of each [configureDefaultFactory], in order.
  final defaultFactoryOptions = <PeerConnectionFactoryOptions?>[];

  @override
  Future<void> configureDefaultFactory({
    PeerConnectionFactoryOptions? options,
    bool refresh = false,
  }) async {
    defaultFactoryOptions.add(options);
  }

  @override
  bool get supportsEncryption => false;
}

/// The [WebRtcAudio] of a [FakeWebRtcEngine]: records each call by name.
// ignore: subtype_of_sealed_class, a fake for the tests
class FakeWebRtcAudio extends Fake implements WebRtcAudio {
  /// Every call, as its name and, where it has one, its argument.
  final calls = <String>[];

  /// Runs on each [setPlayoutPaused], after it is recorded.
  Future<void> Function(bool paused)? onSetPlayoutPaused;

  @override
  Future<void> setPlayoutPaused(bool paused) async {
    calls.add(paused ? 'pause' : 'resume');
    await onSetPlayoutPaused?.call(paused);
  }

  @override
  Future<void> selectAudioOutput(String deviceId) async {
    calls.add('selectAudioOutput $deviceId');
  }

  @override
  Future<void> selectAudioInput(String deviceId) async {
    calls.add('selectAudioInput $deviceId');
  }

  @override
  bool hasAudioSession = false;

  @override
  Future<void> setAppleAudioConfiguration(
    AppleAudioConfiguration configuration,
  ) async {
    calls.add('setAppleAudioConfiguration');
  }

  @override
  Future<void> setStereoPlayoutPreferred(bool preferred) async {
    calls.add('setStereoPlayoutPreferred $preferred');
  }

  @override
  Future<void> regainAndroidAudioFocus() async {
    calls.add('regainAndroidAudioFocus');
  }

  @override
  Future<void> setAndroidAudioFocusHandledBySystem(
    bool handledBySystem,
  ) async {
    calls.add('setAndroidAudioFocusHandledBySystem $handledBySystem');
  }

  @override
  Future<void> showAudioRoutePicker() async {
    calls.add('showAudioRoutePicker');
  }

  @override
  bool isExternalDevice(String? groupId) =>
      groupId?.toLowerCase().contains('bluetooth') ?? false;
}

// ignore: subtype_of_sealed_class, a fake for the tests
/// [WebRtcPlatformEvents] whose events a test adds. Interruptions are always
/// enabled.
class FakePlatformEvents implements WebRtcPlatformEvents {
  final audioRoutes = StreamController<AudioRoute>.broadcast(sync: true);
  final speechActivity = StreamController<SpeechActivity>.broadcast(
    sync: true,
  );
  final audioProcessingStates =
      StreamController<AudioProcessingState>.broadcast(sync: true);
  final screenSharingStarts = StreamController<void>.broadcast(sync: true);
  final screenSharingStops = StreamController<ScreenSharingStopped>.broadcast(
    sync: true,
  );
  final interruptions = StreamController<AudioInterruption>.broadcast(
    sync: true,
  );

  /// Closes every stream.
  Future<void> close() async {
    await Future.wait([
      audioRoutes.close(),
      speechActivity.close(),
      audioProcessingStates.close(),
      screenSharingStarts.close(),
      screenSharingStops.close(),
      interruptions.close(),
    ]);
  }

  @override
  Stream<AudioRoute> get onAudioRouteChanged => audioRoutes.stream;

  @override
  Stream<SpeechActivity> get onSpeechActivity => speechActivity.stream;

  @override
  SpeechActivityDetector createSpeechActivityDetector() {
    throw UnimplementedError();
  }

  @override
  Stream<AudioProcessingState> get onAudioProcessingStateChanged =>
      audioProcessingStates.stream;

  @override
  Stream<void> get onScreenSharingStarted => screenSharingStarts.stream;

  @override
  Stream<ScreenSharingStopped> get onScreenSharingStopped =>
      screenSharingStops.stream;

  @override
  Stream<AudioInterruption> get onInterruption => interruptions.stream;

  @override
  Future<void> enableInterruptionEvents() async {}
}
