import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_local_track.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_track_publish_options.dart';
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

class _MockLocalAudioTrack extends Mock implements RtcLocalAudioTrack {}

const _testCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

/// A cached transceiver sending [trackId], reporting [mid] as its own.
///
/// [mid] stands in for the value a native transceiver captured when it was
/// created — the last-resort source, only reached once the live lookup and the
/// SDP both come up empty.
rtc.RTCRtpTransceiver _transceiver({required String trackId, String mid = ''}) {
  final mediaTrack = _MockMediaStreamTrack();
  when(() => mediaTrack.id).thenReturn(trackId);
  when(() => mediaTrack.kind).thenReturn('audio');
  when(() => mediaTrack.enabled).thenReturn(true);

  final sender = _MockSender();
  when(() => sender.track).thenReturn(mediaTrack);

  final transceiver = _MockTransceiver();
  when(() => transceiver.sender).thenReturn(sender);
  when(() => transceiver.mid).thenReturn(mid);
  return transceiver;
}

SfuPublishOptions _option(int id) {
  return SfuPublishOptions(
    id: id,
    codec: _testCodec,
    trackType: SfuTrackType.audio,
  );
}

/// The announce the SFU acknowledged for [option], as `markNegotiated` sees it.
RtcTrackInfo _announced(
  SfuPublishOptions option, {
  required String trackId,
  required String mid,
}) {
  return RtcTrackInfo(
    trackId: trackId,
    trackType: option.trackType,
    publishOptionId: option.id,
    mid: mid,
    layers: const [],
    codec: option.codec,
    muted: false,
    dtx: false,
    stereo: false,
    red: false,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  ({RtcManager manager, _MockPeerConnection pc}) buildManager() {
    final pc = _MockPeerConnection();
    final publisher = _MockTracedStreamPeerConnection();
    when(() => publisher.pc).thenReturn(pc);
    when(() => publisher.tracer).thenReturn(Tracer(null));

    final manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: _MockTracedStreamPeerConnection(),
      publishOptions: [_option(1), _option(2)],
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
    );

    return (manager: manager, pc: pc);
  }

  /// Caches a sending transceiver for [option] under [trackId].
  void cacheTrack(
    RtcManager manager, {
    required SfuPublishOptions option,
    required String trackId,
    String cachedMid = '',
  }) {
    final mediaTrack = _MockMediaStreamTrack();
    when(() => mediaTrack.id).thenReturn(trackId);
    when(() => mediaTrack.kind).thenReturn('audio');

    final track = _MockLocalAudioTrack();
    when(() => track.trackId).thenReturn('track-$trackId');
    when(() => track.trackType).thenReturn(SfuTrackType.audio);
    when(() => track.mediaTrack).thenReturn(mediaTrack);

    manager.transceiversManager.add(
      track,
      option,
      _transceiver(trackId: trackId, mid: cachedMid),
      const RtcTrackPublishOptions(),
    );
  }

  void stubPeerConnection(
    _MockPeerConnection pc, {
    List<rtc.RTCRtpTransceiver> liveTransceivers = const [],
    String? sdp,
    bool failing = false,
  }) {
    if (failing) {
      when(pc.getTransceivers).thenThrow(Exception('pc is closed'));
      when(pc.getLocalDescription).thenThrow(Exception('pc is closed'));
      return;
    }

    when(pc.getTransceivers).thenAnswer((_) async => liveTransceivers);
    when(pc.getLocalDescription).thenAnswer(
      (_) async => sdp == null ? null : rtc.RTCSessionDescription(sdp, 'offer'),
    );
  }

  group('getAnnouncedTracks', () {
    test('announces every track once all mids resolve', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
      cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

      stubPeerConnection(
        wires.pc,
        liveTransceivers: [
          _transceiver(trackId: 'track-a', mid: '0'),
          _transceiver(trackId: 'track-b', mid: '1'),
        ],
      );

      final announced = await wires.manager.getAnnouncedTracks();

      expect(announced, isNotNull);
      expect(announced!.map((it) => it.trackId), ['track-a', 'track-b']);
      expect(announced.map((it) => it.mid), ['0', '1']);
    });

    test('returns null rather than announcing a subset', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
      cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

      // Only the first track has a live transceiver, and there is no SDP to
      // fall back on for the second.
      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'track-a', mid: '0')],
      );

      expect(await wires.manager.getAnnouncedTracks(), isNull);
    });

    test('returns an empty list when nothing is sending', () async {
      final wires = buildManager();
      stubPeerConnection(wires.pc);

      // Distinct from null: nothing to publish is a no-op, not a failure.
      expect(await wires.manager.getAnnouncedTracks(), isEmpty);
    });

    test('resolves from the offer SDP when no mid is assigned yet', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');

      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'track-a')],
      );

      final announced = await wires.manager.getAnnouncedTracks(
        sdp: [
          'v=0\r\n',
          'o=- 1 2 IN IP4 127.0.0.1\r\n',
          's=-\r\n',
          't=0 0\r\n',
          'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
          'c=IN IP4 0.0.0.0\r\n',
          'a=mid:5\r\n',
          'a=sendonly\r\n',
          'a=msid:stream-id track-a\r\n',
        ].join(),
      );

      expect(announced?.single.mid, '5');
    });
  });

  group('getAnnouncedTracksForReconnect', () {
    test('reports the resolvable tracks instead of failing the '
        'reconnect', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
      cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'track-b', mid: '1')],
      );

      final announced = await wires.manager.getAnnouncedTracksForReconnect();

      expect(announced.map((it) => it.trackId), ['track-b']);
    });

    test('falls back to the cached mid when the peer connection is '
        'already gone', () async {
      final wires = buildManager();
      cacheTrack(
        wires.manager,
        option: _option(1),
        trackId: 'track-a',
        cachedMid: '4',
      );

      // A rejoin builds ReconnectDetails from the previous session, whose
      // publisher is closed: both live sources fail.
      stubPeerConnection(wires.pc, failing: true);

      final announced = await wires.manager.getAnnouncedTracksForReconnect();

      expect(announced.single.trackId, 'track-a');
      expect(announced.single.mid, '4');
    });

    test('falls back to the last acknowledged mid when the peer connection '
        'is gone and the transceiver reports none', () async {
      final wires = buildManager();
      final option = _option(1);

      // What a native rejoin actually looks like: the cached transceiver's mid
      // was captured before it had one and is never refreshed, so the mid
      // recorded when the SFU acknowledged the announce is all that is left.
      cacheTrack(wires.manager, option: option, trackId: 'track-a');
      wires.manager.transceiversManager.markNegotiated([
        _announced(option, trackId: 'track-a', mid: '2'),
      ]);

      stubPeerConnection(wires.pc, failing: true);

      final announced = await wires.manager.getAnnouncedTracksForReconnect();

      expect(announced.single.trackId, 'track-a');
      expect(announced.single.mid, '2');
    });

    test('drops a track that never negotiated a mid', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');

      stubPeerConnection(wires.pc, failing: true);

      expect(await wires.manager.getAnnouncedTracksForReconnect(), isEmpty);
    });

    test(
      'still describes a track published before the publisher died',
      () async {
        final wires = buildManager();
        final option = _option(1);
        cacheTrack(wires.manager, option: option, trackId: 'track-a');

        // Publish: the mid resolves off the live publisher and the SFU
        // acknowledges the announce.
        stubPeerConnection(
          wires.pc,
          liveTransceivers: [_transceiver(trackId: 'track-a', mid: '2')],
        );

        final announced = await wires.manager.getAnnouncedTracks();
        wires.manager.transceiversManager.markNegotiated(announced!);

        // The publisher then goes away and a rejoin has to describe it.
        stubPeerConnection(wires.pc, failing: true);

        final reported = await wires.manager.getAnnouncedTracksForReconnect();

        expect(reported.single.mid, '2');
      },
    );
  });
}
