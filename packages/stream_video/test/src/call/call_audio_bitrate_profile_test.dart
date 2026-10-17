import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

const _hifiSettings = CallSettings(
  audio: StreamAudioSettings(hifiAudioEnabled: true),
);

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  late MockStreamVideo streamVideo;
  late MockPermissionsManager permissionsManager;

  setUp(() {
    streamVideo = setupMockStreamVideo();
    permissionsManager = MockPermissionsManager();
    when(streamVideo.isAudioProcessorConfigured).thenReturn(false);
  });

  Call makeCall({
    CallSettings settings = const CallSettings(),
    bool isAudioProcessing = false,
  }) {
    return createTestCall(
      streamVideo: streamVideo,
      permissionManager: permissionsManager,
      stateManager: CallStateNotifier(
        createTestCallState().copyWith(
          settings: settings,
          isAudioProcessing: isAudioProcessing,
        ),
      ),
    );
  }

  group('setAudioBitrateProfile HiFi check', () {
    test('allows voiceStandard without HiFi', () {
      final call = makeCall();

      final result = call.setAudioBitrateProfile(
        SfuAudioBitrateProfile.voiceStandard,
      );

      expect(result.isSuccess, isTrue);
    });

    test('rejects the other profiles without HiFi', () {
      final call = makeCall();

      final result = call.setAudioBitrateProfile(
        SfuAudioBitrateProfile.musicHighQuality,
      );

      expect(result.isFailure, isTrue);
      expect(
        call.state.value.audioBitrateProfile,
        SfuAudioBitrateProfile.voiceStandard,
      );
    });

    test('applies the profile when HiFi is enabled', () {
      final call = makeCall(settings: _hifiSettings);

      final result = call.setAudioBitrateProfile(
        SfuAudioBitrateProfile.musicHighQuality,
      );

      expect(result.isSuccess, isTrue);
      expect(
        call.state.value.audioBitrateProfile,
        SfuAudioBitrateProfile.musicHighQuality,
      );
    });
  });

  group('setAudioBitrateProfile noise cancellation', () {
    setUp(() {
      when(streamVideo.isAudioProcessorConfigured).thenReturn(true);
      when(
        () => streamVideo.setAudioProcessingEnabled(any()),
      ).thenAnswer((_) async => const Result.success(none));
      when(
        () => permissionsManager.hasPermission(
          CallPermission.enableNoiseCancellation,
        ),
      ).thenReturn(true);
    });

    test('turns it off for music and back on after, when it was on', () async {
      final call = makeCall(settings: _hifiSettings, isAudioProcessing: true);

      call.setAudioBitrateProfile(SfuAudioBitrateProfile.musicHighQuality);
      await Future<void>.delayed(Duration.zero);
      verify(() => streamVideo.setAudioProcessingEnabled(false)).called(1);

      call.setAudioBitrateProfile(SfuAudioBitrateProfile.voiceStandard);
      await Future<void>.delayed(Duration.zero);
      verify(() => streamVideo.setAudioProcessingEnabled(true)).called(1);
    });

    test('leaves it off after music when it was off before', () async {
      final call = makeCall(settings: _hifiSettings);

      call
        ..setAudioBitrateProfile(SfuAudioBitrateProfile.musicHighQuality)
        ..setAudioBitrateProfile(SfuAudioBitrateProfile.voiceStandard);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => streamVideo.setAudioProcessingEnabled(true));
    });

    test('remembers the state from before the first music switch', () async {
      final call = makeCall(settings: _hifiSettings, isAudioProcessing: true);

      call.setAudioBitrateProfile(SfuAudioBitrateProfile.musicHighQuality);
      await Future<void>.delayed(Duration.zero);
      // A repeated music request must not overwrite "on" with the "off" that
      // music itself caused.
      call
        ..setAudioBitrateProfile(SfuAudioBitrateProfile.musicHighQuality)
        ..setAudioBitrateProfile(SfuAudioBitrateProfile.voiceStandard);
      await Future<void>.delayed(Duration.zero);

      verify(() => streamVideo.setAudioProcessingEnabled(true)).called(1);
    });

    test('does not touch it when switching between voice profiles', () async {
      final call = makeCall(settings: _hifiSettings);

      call
        ..setAudioBitrateProfile(SfuAudioBitrateProfile.voiceHighQuality)
        ..setAudioBitrateProfile(SfuAudioBitrateProfile.voiceStandard);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => streamVideo.setAudioProcessingEnabled(any()));
    });
  });
}
