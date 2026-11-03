import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/data.dart';
import 'fixtures/rtc_manager_fakes.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  late FakeWebRtcPlatform platform;

  setUp(() {
    // A platform without per-call factories, so the global entrypoints run
    // through the fake channel.
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.linux;
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
        expect(platform.callsOf('addTransceiver'), hasLength(2));
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
  });
}
