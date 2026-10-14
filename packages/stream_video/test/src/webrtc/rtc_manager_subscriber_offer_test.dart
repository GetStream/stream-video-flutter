// ignore_for_file: missing_override_of_must_be_overridden

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockPeerConnection extends Mock implements rtc.RTCPeerConnection {}

const _testCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

/// A subscriber offer with an audio section per entry of [audioMsids], each
/// `sendonly` from the SFU, plus one video section.
String _offer(List<String> audioMsids) {
  return [
    'v=0\r\n',
    'o=- 1 2 IN IP4 127.0.0.1\r\n',
    's=-\r\n',
    't=0 0\r\n',
    for (final (index, msid) in audioMsids.indexed) ...[
      'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
      'c=IN IP4 0.0.0.0\r\n',
      'a=mid:$index\r\n',
      'a=sendonly\r\n',
      'a=msid:$msid\r\n',
    ],
    'm=video 9 UDP/TLS/RTP/SAVPF 96\r\n',
    'c=IN IP4 0.0.0.0\r\n',
    'a=mid:${audioMsids.length}\r\n',
    'a=sendonly\r\n',
    'a=msid:alice:TRACK_TYPE_VIDEO v1\r\n',
  ].join();
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late _MockTracedStreamPeerConnection subscriber;
  late RtcManager manager;
  late List<String> reattachReasons;

  setUp(() {
    final publisher = _MockTracedStreamPeerConnection();
    when(() => publisher.pc).thenReturn(_MockPeerConnection());
    when(() => publisher.tracer).thenReturn(Tracer(null));

    subscriber = _MockTracedStreamPeerConnection();
    when(
      () => subscriber.setRemoteOffer(any()),
    ).thenAnswer((_) async => const Result<void>.success(null));
    when(() => subscriber.createAnswer(any())).thenAnswer(
      (_) async => Result.success(rtc.RTCSessionDescription('v=0', 'answer')),
    );

    manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: subscriber,
      publishOptions: [
        SfuPublishOptions(
          id: 1,
          codec: _testCodec,
          trackType: SfuTrackType.audio,
        ),
      ],
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
    );

    reattachReasons = [];
    // The WebKit path, which is the one with something to test.
    manager.needsRemoteAudioReattach = () => true;
    manager.reattachRemoteAudio = ({required reason}) async {
      reattachReasons.add(reason);
    };
  });

  group('RtcManager.onSubscriberOffer', () {
    test('answers the offer', () async {
      final answer = await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));

      expect(answer, 'v=0');
      verify(() => subscriber.setRemoteOffer(any())).called(1);
      verify(() => subscriber.createAnswer(any())).called(1);
    });

    test('does not re-attach remote audio on the first offer', () async {
      await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));

      expect(reattachReasons, isEmpty);
    });

    test(
      're-attaches remote audio once a renegotiation adds an audio source',
      () async {
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2']));

        expect(reattachReasons, ['subscriberOffer']);
      },
    );

    test(
      'does not re-attach when the renegotiation adds no audio source',
      () async {
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2']));
        // Same sources again, then one fewer.
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2']));
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));

        expect(reattachReasons, isEmpty);
      },
    );

    test('compares against the last offer that was applied', () async {
      await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));

      when(
        () => subscriber.setRemoteOffer(any()),
      ).thenAnswer((_) async => failureWithError('rejected'));
      expect(
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2'])),
        isNull,
      );
      expect(reattachReasons, isEmpty);

      // The rejected offer must not count as applied: the same sources are
      // still new relative to the first offer.
      when(
        () => subscriber.setRemoteOffer(any()),
      ).thenAnswer((_) async => const Result<void>.success(null));
      await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2']));

      expect(reattachReasons, ['subscriberOffer']);
    });

    test('does not re-attach when the answer fails', () async {
      await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));

      when(
        () => subscriber.createAnswer(any()),
      ).thenAnswer((_) async => failureWithError('no answer'));
      expect(
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2'])),
        isNull,
      );

      expect(reattachReasons, isEmpty);
    });

    test('a failing re-attach does not fail the offer', () async {
      manager.reattachRemoteAudio = ({required reason}) async {
        throw StateError('boom');
      };
      await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));

      final answer = await manager.onSubscriberOffer(
        _offer(['a:AUDIO 1', 'b:AUDIO 2']),
      );
      // Let the unawaited re-attach run and be caught.
      await Future<void>.delayed(Duration.zero);

      expect(answer, 'v=0');
    });

    group('off WebKit', () {
      setUp(() => manager.needsRemoteAudioReattach = () => false);

      test('answers without re-attaching', () async {
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));
        final answer = await manager.onSubscriberOffer(
          _offer(['a:AUDIO 1', 'b:AUDIO 2']),
        );

        expect(answer, 'v=0');
        expect(reattachReasons, isEmpty);
      });

      // Had the offers been kept, the third would be compared against the
      // second and count as adding audio.
      test('keeps no offer to compare against', () async {
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1']));
        await manager.onSubscriberOffer(_offer(['a:AUDIO 1', 'b:AUDIO 2']));

        manager.needsRemoteAudioReattach = () => true;
        await manager.onSubscriberOffer(
          _offer(['a:AUDIO 1', 'b:AUDIO 2', 'c:AUDIO 3']),
        );

        expect(reattachReasons, isEmpty);
      });
    });
  });
}
