import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/audio/adm_microphone_mute.dart';
import 'package:stream_video/src/webrtc/audio/apple_adm_microphone_mute.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/rtc_manager_fakes.dart';

void main() {
  late MockPcFactory pcFactory;
  late AppleAdmMicrophoneMute admMute;
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
    admMute = AppleAdmMicrophoneMute(pcFactory);
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

  group('forFactory', () {
    test('picks the Apple ADM mute when the factory supports it', () {
      expect(
        AdmMicrophoneMute.forFactory(pcFactory),
        isA<AppleAdmMicrophoneMute>(),
      );
    });

    test('picks no ADM mute when the factory does not support it', () {
      when(() => pcFactory.isAppleAdmMicrophoneMuteSupported).thenReturn(false);

      expect(
        AdmMicrophoneMute.forFactory(pcFactory),
        isA<NoAdmMicrophoneMute>(),
      );
    });
  });

  group('NoAdmMicrophoneMute', () {
    test('supports no track and does nothing', () async {
      const none = NoAdmMicrophoneMute();

      expect(none.isSupported(mic()), isFalse);
      await none.setMuted(true);
      await none.reconcile(mic());
      expect(await none.isMuted(), isNull);
      verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
    });
  });

  group('AppleAdmMicrophoneMute.isSupported', () {
    test('holds for the microphone track only', () {
      expect(admMute.isSupported(mic()), isTrue);
      expect(admMute.isSupported(fakeCameraTrack('cam')), isFalse);
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

    test('does nothing without a track or for a camera track', () async {
      admMuted = true;
      await admMute.reconcile(null);
      await admMute.reconcile(fakeCameraTrack('cam'));

      verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
    });
  });
}
