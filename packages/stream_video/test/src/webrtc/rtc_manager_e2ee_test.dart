import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/utils/result.dart';
import 'package:stream_video/src/webrtc/media/media_constraints.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_local_track.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockSender extends Mock implements rtc.RTCRtpSender {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

class _MockEncryptionManager extends Mock implements rtc.EncryptionManager {}

final _vp8 = SfuPublishOptions(
  id: 1,
  codec: const SfuCodec(
    name: 'vp8',
    payloadType: 96,
    fmtpLine: '',
    clockRate: 90000,
    encodingParameters: '',
  ),
  trackType: SfuTrackType.video,
);

rtc.MediaStreamTrack _mediaTrack(String id) {
  var clones = 0;
  final track = _MockMediaStreamTrack();
  when(() => track.id).thenReturn(id);
  when(() => track.kind).thenReturn('video');
  when(() => track.enabled).thenReturn(true);
  when(track.stop).thenAnswer((_) async {});
  when(track.clone).thenAnswer((_) async => _mediaTrack('$id-c${clones++}'));
  return track;
}

RtcLocalVideoTrack _videoTrack(String mediaId) {
  final mediaStream = _MockMediaStream();
  when(mediaStream.dispose).thenAnswer((_) async {});

  return RtcLocalTrack(
    trackIdPrefix: 'pub',
    trackType: SfuTrackType.video,
    mediaStream: mediaStream,
    mediaTrack: _mediaTrack(mediaId),
    mediaConstraints: const CameraConstraints(),
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(_MockMediaStreamTrack());
    registerFallbackValue(_MockSender());
    registerFallbackValue(<rtc.RTCRtpEncoding>[]);
  });

  ({
    RtcManager manager,
    int Function() stopCalls,
  })
  buildManager(rtc.EncryptionManager? e2ee) {
    final pc = _MockPeerConnection();
    final publisher = _MockTracedStreamPeerConnection();
    when(() => publisher.pc).thenReturn(pc);
    when(() => publisher.isReconnecting).thenReturn(false);
    when(() => publisher.onRenegotiationNeeded).thenReturn(null);

    var stops = 0;
    when(
      () => publisher.addVideoTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
        degradationPreference: any(named: 'degradationPreference'),
      ),
    ).thenAnswer((invocation) async {
      final track = invocation.namedArguments[#track] as rtc.MediaStreamTrack?;

      final sender = _MockSender();
      when(() => sender.track).thenReturn(track);
      when(() => sender.replaceTrack(any())).thenAnswer((_) async {});

      final transceiver = _MockTransceiver();
      when(() => transceiver.sender).thenReturn(sender);
      when(() => transceiver.mid).thenReturn('');
      when(transceiver.stop).thenAnswer((_) async {
        stops++;
      });
      return Result.success(transceiver);
    });

    final manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: _MockTracedStreamPeerConnection(),
      publishOptions: [_vp8],
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
      e2eeManager: e2ee,
    );

    return (manager: manager, stopCalls: () => stops);
  }

  group('encryptor attach', () {
    test('a publish whose encryptor cannot attach fails', () async {
      final e2ee = _MockEncryptionManager();
      when(
        () => e2ee.encrypt(
          any(),
          codec: any(named: 'codec'),
          trackType: any(named: 'trackType'),
        ),
      ).thenThrow(StateError('manager is disposed'));

      final wires = buildManager(e2ee);

      final published = await wires.manager.publishVideoTrack(
        track: _videoTrack('cam'),
      );

      // Publishing cleartext on a call the user was told is encrypted is worse
      // than not publishing at all, so the sender must not survive.
      expect(published.isFailure, isTrue);
      expect(wires.stopCalls(), 1);
    });

    test('a publish with no manager attached is unaffected', () async {
      final wires = buildManager(null);

      final published = await wires.manager.publishVideoTrack(
        track: _videoTrack('cam'),
      );

      expect(published.isSuccess, isTrue);
      expect(wires.stopCalls(), 0);
    });

    test('a publish whose encryptor attaches succeeds', () async {
      final e2ee = _MockEncryptionManager();
      when(
        () => e2ee.encrypt(
          any(),
          codec: any(named: 'codec'),
          trackType: any(named: 'trackType'),
        ),
      ).thenAnswer((_) async {});

      final wires = buildManager(e2ee);

      final published = await wires.manager.publishVideoTrack(
        track: _videoTrack('cam'),
      );

      expect(published.isSuccess, isTrue);
      expect(wires.stopCalls(), 0);
      verify(
        () => e2ee.encrypt(
          any(),
          codec: 'vp8',
          trackType: rtc.E2eeTrackType.video,
        ),
      ).called(1);
    });
  });
}
