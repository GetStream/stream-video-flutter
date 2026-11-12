import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../fixtures/webrtc_capabilities.dart';
import '../call/fixtures/data.dart';
import 'fixtures/rtc_manager_fakes.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  late FakeWebRtcPlatform platform;

  setUp(() {
    // A platform without per-call factories, so the global entrypoints run
    // through the fake channel.
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.linux;
    overrideWebRtcCapabilities(platform: PlatformType.linux);
    platform = FakeWebRtcPlatform()..install();
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    platform.uninstall();
  });

  StreamPeerConnectionFactory factory() {
    return StreamPeerConnectionFactory(callCid: SampleCallData.defaultCid);
  }

  group('StreamPeerConnectionFactory.getGenericSdp', () {
    test(
      'makes the offer on a throwaway peer connection it disposes',
      () async {
        final sdp = await factory().getGenericSdp(
          rtc.TransceiverDirection.SendOnly,
        );

        expect(sdp, 'v=0 pc-0');
        final directions = platform
            .callsOf('addTransceiver')
            .map((call) => (call.arguments as Map)['transceiverInit'] as Map)
            .map((init) => init['direction']);
        expect(directions, ['sendonly', 'sendonly']);
        expect(platform.callsOf('peerConnectionDispose'), hasLength(1));
      },
    );

    test('reuses the offer per direction', () async {
      final pcFactory = factory();

      final first = await pcFactory.getGenericSdp(
        rtc.TransceiverDirection.SendOnly,
      );
      final again = await pcFactory.getGenericSdp(
        rtc.TransceiverDirection.SendOnly,
      );
      await pcFactory.getGenericSdp(rtc.TransceiverDirection.RecvOnly);

      expect(again, first);
      expect(platform.callsOf('createPeerConnection'), hasLength(2));
    });

    test('shares an offer still being made', () async {
      final pcFactory = factory();

      final results = await Future.wait([
        pcFactory.getGenericSdp(rtc.TransceiverDirection.SendOnly),
        pcFactory.getGenericSdp(rtc.TransceiverDirection.SendOnly),
      ]);

      expect(results[0], results[1]);
      expect(platform.callsOf('createPeerConnection'), hasLength(1));
    });

    test('each factory makes its own offer', () async {
      await factory().getGenericSdp(rtc.TransceiverDirection.SendOnly);
      await factory().getGenericSdp(rtc.TransceiverDirection.SendOnly);

      expect(platform.callsOf('createPeerConnection'), hasLength(2));
    });

    test(
      'a failed offer is not cached and its peer connection is disposed',
      () async {
        final pcFactory = factory();
        platform.createOfferError = PlatformException(code: 'failed');

        await expectLater(
          pcFactory.getGenericSdp(rtc.TransceiverDirection.SendOnly),
          throwsA(anything),
        );
        expect(platform.callsOf('peerConnectionDispose'), hasLength(1));

        platform.createOfferError = null;
        final sdp = await pcFactory.getGenericSdp(
          rtc.TransceiverDirection.SendOnly,
        );

        expect(sdp, isNotEmpty);
        expect(platform.callsOf('createPeerConnection'), hasLength(2));
      },
    );

    test(
      'an empty offer fails, naming the direction, and is not cached',
      () async {
        final pcFactory = factory();
        platform.createOfferWithEmptySdp = true;

        await expectLater(
          pcFactory.getGenericSdp(rtc.TransceiverDirection.SendOnly),
          throwsA(
            isA<StateError>().having(
              (it) => it.message,
              'message',
              contains('SendOnly'),
            ),
          ),
        );

        platform.createOfferWithEmptySdp = false;
        final sdp = await pcFactory.getGenericSdp(
          rtc.TransceiverDirection.SendOnly,
        );

        expect(sdp, isNotEmpty);
        expect(platform.callsOf('createPeerConnection'), hasLength(2));
      },
    );

    test('a failed dispose keeps the offer', () async {
      platform.peerConnectionDisposeError = PlatformException(code: 'failed');

      final sdp = await factory().getGenericSdp(
        rtc.TransceiverDirection.SendOnly,
      );

      expect(sdp, 'v=0 pc-0');
    });

    test('a failed dispose does not hide why the offer failed', () async {
      platform
        ..createOfferError = PlatformException(
          code: 'failed',
          message: 'offer-failed',
        )
        ..peerConnectionDisposeError = PlatformException(code: 'dispose');

      await expectLater(
        factory().getGenericSdp(rtc.TransceiverDirection.SendOnly),
        throwsA(contains('offer-failed')),
      );
    });
  });
}
