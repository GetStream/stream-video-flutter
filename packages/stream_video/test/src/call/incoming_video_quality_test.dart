import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

class _MockDynascaleManager extends Mock implements DynascaleManager {}

IncomingVideoSettings _settings({bool? enabled, int? height}) =>
    IncomingVideoSettings(
      enabled: enabled,
      preferredResolution: height == null
          ? null
          : RtcVideoDimension(width: height * 16 ~/ 9, height: height),
      participants: const {},
    );

void main() {
  group('IncomingVideoQuality', () {
    test('auto and off ask for no resolution', () {
      expect(IncomingVideoQuality.auto.resolution, isNull);
      expect(IncomingVideoQuality.off.resolution, isNull);
      expect(
        IncomingVideoQuality.p720.resolution,
        const RtcVideoDimension(width: 1280, height: 720),
      );
    });

    test('reads settings as the quality they amount to', () {
      expect(IncomingVideoQuality.of(null), IncomingVideoQuality.auto);
      expect(
        IncomingVideoQuality.of(_settings(enabled: false, height: 720)),
        IncomingVideoQuality.off,
      );
      expect(
        IncomingVideoQuality.of(_settings(height: 1080)),
        IncomingVideoQuality.p1080,
      );
    });

    test('rounds a resolution set some other way down to a choice', () {
      expect(
        IncomingVideoQuality.of(_settings(height: 900)),
        IncomingVideoQuality.p720,
      );
      expect(
        IncomingVideoQuality.of(_settings(height: 4320)),
        IncomingVideoQuality.p2160,
      );
      expect(
        IncomingVideoQuality.of(_settings(height: 100)),
        IncomingVideoQuality.auto,
      );
    });
  });

  group('IncomingVideoQualityCall', () {
    late MockCall call;
    late _MockDynascaleManager dynascale;

    setUpAll(() {
      registerFallbackValue(const RtcVideoDimension(width: 0, height: 0));
    });

    setUp(() {
      call = MockCall();
      dynascale = _MockDynascaleManager();
      when(() => call.dynascaleManager).thenReturn(dynascale);
      when(
        () => call.setPreferredIncomingVideoResolution(any()),
      ).thenAnswer((_) async => const Result.success(none));
      when(
        () => call.setIncomingVideoEnabled(any()),
      ).thenAnswer((_) async => const Result.success(none));
    });

    test('reads the quality from the incoming video settings', () async {
      when(
        () => dynascale.incomingVideoSettings,
      ).thenReturn(_settings(height: 480));
      when(() => dynascale.incomingVideoSettingsStream).thenAnswer(
        (_) => Stream.fromIterable([
          _settings(height: 480),
          _settings(height: 480),
          _settings(enabled: false),
        ]),
      );

      expect(call.incomingVideoQuality, IncomingVideoQuality.p480);
      expect(
        await call.incomingVideoQualityStream.toList(),
        [IncomingVideoQuality.p480, IncomingVideoQuality.off],
      );
    });

    test('a resolution is asked for as one', () async {
      await call.setIncomingVideoQuality(IncomingVideoQuality.p720);

      verify(
        () => call.setPreferredIncomingVideoResolution(
          const RtcVideoDimension(width: 1280, height: 720),
        ),
      ).called(1);
      verifyNever(() => call.setIncomingVideoEnabled(any()));
    });

    test('off turns incoming video off', () async {
      await call.setIncomingVideoQuality(IncomingVideoQuality.off);

      verify(() => call.setIncomingVideoEnabled(false)).called(1);
    });
  });
}
