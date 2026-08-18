import 'dart:async';

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

class _MockPcFactory extends Mock implements StreamPeerConnectionFactory {}

const _audioCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

const _videoCodec = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

final _videoOption = SfuPublishOptions(
  id: 1,
  codec: _videoCodec,
  trackType: SfuTrackType.video,
);

final _audioOption = SfuPublishOptions(
  id: 2,
  codec: _audioCodec,
  trackType: SfuTrackType.audio,
);

rtc.MediaStreamTrack _mediaTrack(String id, {required String kind}) {
  final track = _MockMediaStreamTrack();
  when(() => track.id).thenReturn(id);
  when(() => track.kind).thenReturn(kind);
  when(() => track.enabled).thenReturn(true);
  when(track.stop).thenAnswer((_) async {});
  return track;
}

/// A transceiver whose sender currently exposes [senderTrack], returned
/// together with the sender so tests can stub/verify it directly (mocktail
/// forbids stubbing through the `transceiver.sender.track` chain).
({rtc.RTCRtpTransceiver transceiver, rtc.RTCRtpSender sender}) _transceiver(
  rtc.MediaStreamTrack? senderTrack,
) {
  final sender = _MockSender();
  when(() => sender.track).thenReturn(senderTrack);
  when(() => sender.replaceTrack(any())).thenAnswer((_) async {});

  final transceiver = _MockTransceiver();
  when(() => transceiver.sender).thenReturn(sender);
  when(() => transceiver.mid).thenReturn('');
  return (transceiver: transceiver, sender: sender);
}

/// A real local track backed by mocks, cloning to a fresh media track on
/// every publish just like a real one.
RtcLocalTrack<T> _localTrack<T extends MediaConstraints>(
  String mediaId, {
  required SfuTrackType trackType,
  required T constraints,
  required String kind,
}) {
  final mediaTrack = _mediaTrack(mediaId, kind: kind);
  var cloneCount = 0;
  when(mediaTrack.clone).thenAnswer(
    (_) async => _mediaTrack('$mediaId-clone-${cloneCount++}', kind: kind),
  );

  final mediaStream = _MockMediaStream();
  when(mediaStream.dispose).thenAnswer((_) async {});

  return RtcLocalTrack(
    trackIdPrefix: 'pub',
    trackType: trackType,
    mediaStream: mediaStream,
    mediaTrack: mediaTrack,
    mediaConstraints: constraints,
  );
}

RtcLocalVideoTrack _videoTrack(String mediaId) => _localTrack(
  mediaId,
  trackType: SfuTrackType.video,
  constraints: const CameraConstraints(),
  kind: 'video',
);

RtcLocalAudioTrack _audioTrack(String mediaId) => _localTrack(
  mediaId,
  trackType: SfuTrackType.audio,
  constraints: const AudioConstraints(),
  kind: 'audio',
);

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
    _MockTracedStreamPeerConnection publisher,
    _MockPeerConnection pc,
  })
  buildManager({
    required List<SfuPublishOptions> publishOptions,
    StreamPeerConnectionFactory? pcFactory,
  }) {
    final pc = _MockPeerConnection();
    final publisher = _MockTracedStreamPeerConnection();
    when(() => publisher.pc).thenReturn(pc);
    when(() => publisher.isReconnecting).thenReturn(false);
    when(() => publisher.onRenegotiationNeeded).thenReturn(null);
    when(publisher.dispose).thenAnswer((_) async {});

    final subscriber = _MockTracedStreamPeerConnection();
    when(subscriber.dispose).thenAnswer((_) async {});

    final manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: subscriber,
      publishOptions: publishOptions,
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory:
          pcFactory ??
          StreamPeerConnectionFactory(callCid: SampleCallData.defaultCid),
    );

    return (manager: manager, publisher: publisher, pc: pc);
  }

  /// Stubs [publisher]'s addVideoTransceiver to block on [gate] before
  /// returning, counting invocations via the returned callable.
  int Function() gateVideoTransceiver(
    _MockTracedStreamPeerConnection publisher, {
    required rtc.RTCRtpTransceiver transceiver,
    Completer<void>? gate,
  }) {
    var calls = 0;
    when(
      () => publisher.addVideoTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
        degradationPreference: any(named: 'degradationPreference'),
      ),
    ).thenAnswer((_) async {
      calls++;
      if (gate != null) await gate.future;
      return Result.success(transceiver);
    });
    return () => calls;
  }

  group('concurrent publish serialization', () {
    test(
      'two concurrent publishes of the same type create exactly one '
      'transceiver — the loser reuses the winner instead of duplicating',
      () async {
        final wires = buildManager(publishOptions: [_videoOption]);

        final gate = Completer<void>();
        // The winner's clone appears as the sender's current track, which the
        // loser replaces (and stops) on its reuse path.
        final wired = _transceiver(_mediaTrack('winner-clone', kind: 'video'));
        final addCalls = gateVideoTransceiver(
          wires.publisher,
          transceiver: wired.transceiver,
          gate: gate,
        );

        // Both publishes race, as when a double camera-enable fires two
        // getUserMedia flows.
        final first = wires.manager.publishVideoTrack(track: _videoTrack('a'));
        final second = wires.manager.publishVideoTrack(track: _videoTrack('b'));

        // Let the winner reach the gated addVideoTransceiver.
        await Future<void>.delayed(Duration.zero);
        expect(addCalls(), 1);

        gate.complete();
        final results = await Future.wait([
          first,
          second,
        ]).timeout(const Duration(seconds: 5));

        expect(results.every((r) => r.isSuccess), isTrue);
        // One platform transceiver; the second publish went through
        // replaceTrack on the cached one.
        expect(addCalls(), 1);
        expect(wires.manager.transceiversManager.items(), hasLength(1));
        verify(() => wired.sender.replaceTrack(any())).called(1);
      },
    );

    test(
      'audio and video publishes do not serialize against each other',
      () async {
        final wires = buildManager(
          publishOptions: [_videoOption, _audioOption],
        );

        final videoGate = Completer<void>();
        gateVideoTransceiver(
          wires.publisher,
          transceiver: _transceiver(null).transceiver,
          gate: videoGate,
        );
        when(
          () => wires.publisher.addAudioTransceiver(
            track: any(named: 'track'),
            encodings: any(named: 'encodings'),
          ),
        ).thenAnswer(
          (_) async => Result.success(_transceiver(null).transceiver),
        );

        var videoDone = false;
        final videoFuture = wires.manager
            .publishVideoTrack(track: _videoTrack('cam'))
            .then((r) {
              videoDone = true;
              return r;
            });

        // The audio publish must complete while the video publish is still
        // blocked in the platform: claims are per `(trackType,
        // publishOptionId)`, so camera and microphone acquisition stay
        // parallel at join.
        final audioResult = await wires.manager
            .publishAudioTrack(track: _audioTrack('mic'))
            .timeout(const Duration(seconds: 5));

        expect(audioResult.isSuccess, isTrue);
        expect(videoDone, isFalse);

        videoGate.complete();
        final videoResult = await videoFuture.timeout(
          const Duration(seconds: 5),
        );
        expect(videoResult.isSuccess, isTrue);
        expect(wires.manager.transceiversManager.items(), hasLength(2));
      },
    );

    test(
      'a publish landing while another is still creating its transceiver '
      'reuses it instead of adding a second sender',
      () async {
        final wires = buildManager(publishOptions: [_videoOption]);

        final gate = Completer<void>();
        final wired = _transceiver(_mediaTrack('winner-clone', kind: 'video'));
        final addCalls = gateVideoTransceiver(
          wires.publisher,
          transceiver: wired.transceiver,
          gate: gate,
        );

        final first = wires.manager.publishVideoTrack(track: _videoTrack('a'));

        // Let the first publish claim the key and suspend inside the platform
        // call, then start the second — the window the old code duplicated in.
        // The claim, not a lock, is what makes the second one wait.
        await Future<void>.delayed(Duration.zero);
        expect(addCalls(), 1);

        final second = wires.manager.publishVideoTrack(track: _videoTrack('b'));
        await Future<void>.delayed(Duration.zero);

        // The second publish is parked on the claim, not creating its own.
        expect(addCalls(), 1);

        gate.complete();
        final results = await Future.wait([
          first,
          second,
        ]).timeout(const Duration(seconds: 5));

        expect(results.every((r) => r.isSuccess), isTrue);
        expect(addCalls(), 1);
        expect(wires.manager.transceiversManager.items(), hasLength(1));
        verify(() => wired.sender.replaceTrack(any())).called(1);
      },
    );

    test(
      'a publish landing after dispose discards its track instead of '
      'stranding it with the camera still captured',
      () async {
        final wires = buildManager(publishOptions: [_videoOption]);
        when(() => wires.pc.removeTrack(any())).thenAnswer((_) async => true);

        final gate = Completer<void>();
        final source = _videoTrack('cam');
        gateVideoTransceiver(
          wires.publisher,
          transceiver: _transceiver(
            _mediaTrack('sent', kind: 'video'),
          ).transceiver,
          gate: gate,
        );

        final publishing = wires.manager.publishVideoTrack(track: source);
        await Future<void>.delayed(Duration.zero);

        final disposing = wires.manager.dispose();
        gate.complete();

        final result = await publishing.timeout(const Duration(seconds: 5));
        await disposing.timeout(const Duration(seconds: 5));

        expect(result.isFailure, isTrue);
        expect(wires.manager.tracks, isEmpty);
        // The source the publish was holding is released, not left running.
        verify(source.mediaTrack.stop).called(greaterThanOrEqualTo(1));
      },
    );

    test(
      'getAnnouncedTracks waits for a transceiver still being created, so the '
      'offer never carries an m-line the announce omits',
      () async {
        final wires = buildManager(publishOptions: [_videoOption]);

        final gate = Completer<void>();
        final sent = _mediaTrack('sent', kind: 'video');
        final wired = _transceiver(sent);
        when(() => wired.transceiver.mid).thenReturn('0');
        gateVideoTransceiver(
          wires.publisher,
          transceiver: wired.transceiver,
          gate: gate,
        );
        when(
          wires.pc.getTransceivers,
        ).thenAnswer((_) async => [wired.transceiver]);
        when(wires.pc.getLocalDescription).thenAnswer(
          (_) async => rtc.RTCSessionDescription('v=0\r\n', 'offer'),
        );

        unawaited(wires.manager.publishVideoTrack(track: _videoTrack('cam')));
        await Future<void>.delayed(Duration.zero);

        var announced = false;
        final announcing = wires.manager.getAnnouncedTracks().then((it) {
          announced = true;
          return it;
        });

        await Future<void>.delayed(Duration.zero);
        expect(
          announced,
          isFalse,
          reason: 'must not announce while a sender is mid-creation',
        );

        gate.complete();
        final tracks = await announcing.timeout(const Duration(seconds: 5));

        expect(tracks, isNotNull);
        expect(tracks!.single.trackId, 'sent');
      },
    );
  });

  group('media acquisition single-flight', () {
    /// A factory whose native-factory build never resolves, so the camera
    /// acquisition behind `setCameraEnabled` stays in flight.
    ({_MockPcFactory factory, Completer<void> release}) stalledFactory() {
      final release = Completer<void>();
      final factory = _MockPcFactory();
      when(factory.ensureNativeFactory).thenAnswer((_) async {
        await release.future;
        return null;
      });
      return (factory: factory, release: release);
    }

    test(
      'a disable arriving mid-acquisition waits for it rather than being '
      'dropped as "track not found"',
      () async {
        final stalled = stalledFactory();
        final wires = buildManager(
          publishOptions: [_videoOption],
          pcFactory: stalled.factory,
        );

        unawaited(wires.manager.setCameraEnabled());
        await Future<void>.delayed(Duration.zero);

        var disabled = false;
        final disabling = wires.manager.setCameraEnabled(enabled: false).then((
          it,
        ) {
          disabled = true;
          return it;
        });

        await Future<void>.delayed(Duration.zero);
        expect(
          disabled,
          isFalse,
          reason: 'the disable must join the in-flight enable, not give up',
        );

        stalled.release.complete();
        await disabling.timeout(const Duration(seconds: 5));
        expect(disabled, isTrue);
      },
    );
  });
}
