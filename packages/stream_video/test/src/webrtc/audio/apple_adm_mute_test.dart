import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/audio/apple_adm_mute.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/rtc_manager_fakes.dart';

void main() {
  late MockPcFactory pcFactory;
  late AppleAdmMute admMute;
  bool? admMuted;

  setUp(() {
    admMuted = false;
    pcFactory = MockPcFactory();
    when(() => pcFactory.isAppleAdmMicrophoneMuteSupported).thenReturn(true);
    when(() => pcFactory.setAppleAdmMicrophoneMuted(any())).thenAnswer((
      invocation,
    ) async {
      admMuted = invocation.positionalArguments.first as bool;
    });
    when(pcFactory.isAppleAdmMicrophoneMuted).thenAnswer((_) async => admMuted);
    admMute = AppleAdmMute(pcFactory);
  });

  /// A microphone track, live when [enabled], muted by stopping it when
  /// [stopTrackOnMute].
  RtcLocalAudioTrack mic({bool enabled = true, bool stopTrackOnMute = true}) {
    final track = fakeAudioTrack('mic').copyWith(
      stopTrackOnMute: stopTrackOnMute,
    );
    fakeMediaOf(track).enabled = enabled;
    return track;
  }

  group('isSupported', () {
    test('holds for a microphone track when the factory supports it', () {
      expect(admMute.isSupported(mic()), isTrue);
      expect(admMute.isSupported(fakeCameraTrack('cam')), isFalse);
    });

    test('never holds when the factory does not support it', () {
      when(() => pcFactory.isAppleAdmMicrophoneMuteSupported).thenReturn(false);

      expect(admMute.isSupported(mic()), isFalse);
    });
  });

  group('setMuted and isMuted', () {
    test('a failing factory call is swallowed', () async {
      when(
        () => pcFactory.setAppleAdmMicrophoneMuted(any()),
      ).thenThrow(StateError('adm gone'));
      when(pcFactory.isAppleAdmMicrophoneMuted).thenThrow(StateError('gone'));

      await expectLater(admMute.setMuted(true), completes);
      expect(await admMute.isMuted(), isNull);
    });
  });

  group('reconcile', () {
    test('unmutes the ADM for a live track', () async {
      admMuted = true;

      await admMute.reconcile(mic());

      expect(admMuted, isFalse);
    });

    test('mutes the ADM for a disabled track not stopped on mute', () async {
      await admMute.reconcile(mic(enabled: false, stopTrackOnMute: false));

      expect(admMuted, isTrue);
    });

    test('leaves the ADM alone when it already matches', () async {
      await admMute.reconcile(mic());

      verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
    });

    test('re-applies when the ADM state cannot be read', () async {
      when(pcFactory.isAppleAdmMicrophoneMuted).thenAnswer((_) async => null);

      await admMute.reconcile(mic());

      verify(() => pcFactory.setAppleAdmMicrophoneMuted(false)).called(1);
    });

    test('leaves the ADM alone for a track stopped on mute', () async {
      admMuted = true;

      await admMute.reconcile(mic(enabled: false));

      verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
      expect(admMuted, isTrue);
    });

    test('does nothing without a track or ADM support', () async {
      admMuted = true;
      await admMute.reconcile(null);

      when(() => pcFactory.isAppleAdmMicrophoneMuteSupported).thenReturn(false);
      await admMute.reconcile(mic());

      verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
    });
  });
}
