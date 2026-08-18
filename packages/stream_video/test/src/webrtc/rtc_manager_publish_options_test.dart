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

// ignore: missing_override_of_must_be_overridden
class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockSender extends Mock implements rtc.RTCRtpSender {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

SfuPublishOptions _videoOption(int id, String codecName) {
  return SfuPublishOptions(
    id: id,
    codec: SfuCodec(
      name: codecName,
      payloadType: 96,
      fmtpLine: '',
      clockRate: 90000,
      encodingParameters: '',
    ),
    trackType: SfuTrackType.video,
  );
}

final _vp8 = _videoOption(1, 'vp8');
final _vp9 = _videoOption(2, 'vp9');

/// A media track that can be cloned indefinitely, like a real one.
rtc.MediaStreamTrack _mediaTrack(String id, {String kind = 'video'}) {
  final track = _MockMediaStreamTrack();
  var clones = 0;
  when(() => track.id).thenReturn(id);
  when(() => track.kind).thenReturn(kind);
  when(() => track.enabled).thenReturn(true);
  when(track.stop).thenAnswer((_) async {});
  when(track.clone).thenAnswer(
    (_) async => _mediaTrack('$id-c${clones++}', kind: kind),
  );
  return track;
}

/// A transceiver whose sender starts out sending [senderTrack] and follows
/// `replaceTrack`, so `sender.track` reflects reality across a codec switch.
rtc.RTCRtpTransceiver _transceiver(rtc.MediaStreamTrack? senderTrack) {
  var current = senderTrack;

  final sender = _MockSender();
  when(() => sender.track).thenAnswer((_) => current);
  when(() => sender.replaceTrack(any())).thenAnswer((invocation) async {
    current = invocation.positionalArguments.first as rtc.MediaStreamTrack?;
  });

  final transceiver = _MockTransceiver();
  when(() => transceiver.sender).thenReturn(sender);
  when(() => transceiver.mid).thenReturn('');
  when(transceiver.stop).thenAnswer((_) async {});
  return transceiver;
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
    registerFallbackValue(<rtc.RTCRtpEncoding>[]);
  });

  ({RtcManager manager, int Function() addCalls}) buildManager() {
    final pc = _MockPeerConnection();
    final publisher = _MockTracedStreamPeerConnection();
    when(() => publisher.pc).thenReturn(pc);
    when(() => publisher.isReconnecting).thenReturn(false);
    when(() => publisher.onRenegotiationNeeded).thenReturn(null);

    // A distinct transceiver per call, each tracking its own sender track.
    var calls = 0;
    when(
      () => publisher.addVideoTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
        degradationPreference: any(named: 'degradationPreference'),
      ),
    ).thenAnswer((invocation) async {
      calls++;
      final track = invocation.namedArguments[#track] as rtc.MediaStreamTrack?;
      return Result.success(_transceiver(track));
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
    );

    return (manager: manager, addCalls: () => calls);
  }

  group('onPublishOptionsChanged', () {
    test(
      'a codec switched away and back is published again — retiring an option '
      'must free its key, not leave it occupied by a trackless transceiver',
      () async {
        final wires = buildManager();

        final published = await wires.manager.publishVideoTrack(
          track: _videoTrack('cam'),
        );
        expect(published.isSuccess, isTrue);
        expect(wires.addCalls(), 1);

        // vp8 -> vp9: vp9 gets its own sender, vp8 is retired.
        await wires.manager.onPublishOptionsChanged([_vp9]);
        expect(wires.addCalls(), 2);
        expect(wires.manager.transceiversManager.get(_vp9), isNotNull);
        expect(
          wires.manager.transceiversManager.get(_vp8),
          isNull,
          reason: 'the retired option must not keep its cache slot',
        );

        // ...and back. Without freeing the slot this reads as "already
        // publishing in vp8" and the codec is silently never republished.
        await wires.manager.onPublishOptionsChanged([_vp8]);

        expect(wires.addCalls(), 3);
        final revived = wires.manager.transceiversManager.get(_vp8);
        expect(revived, isNotNull);
        expect(
          revived!.transceiver.sender.track,
          isNotNull,
          reason: 'the revived transceiver must actually be sending',
        );
      },
    );

    test('retiring an option stops its sender and clears the cache', () async {
      final wires = buildManager();

      await wires.manager.publishVideoTrack(track: _videoTrack('cam'));
      final retired = wires.manager.transceiversManager.get(_vp8)!.transceiver;

      await wires.manager.onPublishOptionsChanged([_vp9]);

      expect(retired.sender.track, isNull);
      expect(wires.manager.transceiversManager.get(_vp8), isNull);
      expect(wires.manager.transceiversManager.items(), hasLength(1));
      // The cache entry is gone, so the transceiver has to be stopped as well:
      // `replaceTrack(null)` alone keeps its m-line sending, so it could never
      // be recycled and every codec flip would append another one.
      verify(retired.stop).called(1);
    });

    test(
      'a transceiver that refuses to stop still leaves the retirement '
      'complete — a closed peer connection must not strand the update',
      () async {
        final wires = buildManager();

        await wires.manager.publishVideoTrack(track: _videoTrack('cam'));
        final retired = wires.manager.transceiversManager
            .get(_vp8)!
            .transceiver;
        when(retired.stop).thenThrow(StateError('peer connection is closed'));

        await wires.manager.onPublishOptionsChanged([_vp9]);

        expect(wires.manager.transceiversManager.get(_vp8), isNull);
        expect(wires.manager.transceiversManager.get(_vp9), isNotNull);
      },
    );
  });
}
