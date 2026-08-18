// ignore_for_file: missing_override_of_must_be_overridden

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_track_publish_options.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockSender extends Mock implements rtc.RTCRtpSender {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

const _testCodec = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

const _trackId = 'test-track-id';
const _mediaTrackId = 'test-media-track-id';

final _publishOption = SfuPublishOptions(
  id: 1,
  codec: _testCodec,
  trackType: SfuTrackType.video,
);

rtc.RTCRtpTransceiver _transceiverWithTrack(rtc.MediaStreamTrack? track) {
  final sender = _MockSender();
  when(() => sender.track).thenReturn(track);

  final transceiver = _MockTransceiver();
  when(() => transceiver.sender).thenReturn(sender);
  return transceiver;
}

/// The track info the cached transceiver would be announced with, i.e. what
/// `getAnnouncedTracks` hands to `markNegotiated` after a completed negotiation.
final _announcedTrackInfo = RtcTrackInfo(
  trackId: _mediaTrackId,
  trackType: SfuTrackType.video,
  publishOptionId: 1,
  mid: '0',
  layers: const [],
  codec: _testCodec,
  muted: false,
  dtx: false,
  stereo: false,
  red: false,
);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  ({
    RtcManager manager,
    _MockTracedStreamPeerConnection publisher,
    List<StreamPeerConnection> renegotiations,
  })
  buildManager({required bool isReconnecting}) {
    final publisher = _MockTracedStreamPeerConnection();
    final subscriber = _MockTracedStreamPeerConnection();

    final renegotiations = <StreamPeerConnection>[];
    when(() => publisher.isReconnecting).thenReturn(isReconnecting);
    when(() => publisher.onRenegotiationNeeded).thenReturn(renegotiations.add);

    final manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: subscriber,
      publishOptions: const [],
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
    );

    return (
      manager: manager,
      publisher: publisher,
      renegotiations: renegotiations,
    );
  }

  /// Registers [track] with the manager and caches a transceiver for it
  /// whose sender exposes [senderTrack].
  MockRtcLocalTrack addUnmutableTrack(
    RtcManager manager, {
    required rtc.MediaStreamTrack? senderTrack,
  }) {
    final mediaTrack = _MockMediaStreamTrack();
    when(() => mediaTrack.id).thenReturn(_mediaTrackId);

    final track = MockRtcLocalTrack();
    when(() => track.trackId).thenReturn(_trackId);
    when(() => track.trackType).thenReturn(SfuTrackType.audio);
    when(() => track.stopTrackOnMute).thenReturn(false);
    when(() => track.mediaTrack).thenReturn(mediaTrack);
    manager.tracks[_trackId] = track;

    manager.transceiversManager.add(
      track,
      _publishOption,
      _transceiverWithTrack(senderTrack),
      const RtcTrackPublishOptions(),
    );

    return track;
  }

  group('unmuteTrack renegotiation of unacknowledged transceivers', () {
    test(
      'forces a publisher renegotiation when a sending transceiver was never '
      'acknowledged by the SFU',
      () async {
        final wires = buildManager(isReconnecting: false);
        addUnmutableTrack(wires.manager, senderTrack: _MockMediaStreamTrack());

        final result = await wires.manager.unmuteTrack(trackId: _trackId);

        expect(result.isSuccess, isTrue);
        expect(wires.renegotiations, hasLength(1));
        expect(wires.renegotiations.single, same(wires.publisher));
      },
    );

    test(
      'does NOT renegotiate when the transceiver is already acknowledged',
      () async {
        final wires = buildManager(isReconnecting: false);
        addUnmutableTrack(wires.manager, senderTrack: _MockMediaStreamTrack());

        // Simulate a completed negotiation (SFU answered) that announced the
        // cached transceiver.
        wires.manager.transceiversManager.markNegotiated(
          [_announcedTrackInfo],
        );

        final result = await wires.manager.unmuteTrack(trackId: _trackId);

        expect(result.isSuccess, isTrue);
        expect(wires.renegotiations, isEmpty);
      },
    );

    test(
      'does NOT renegotiate when the transceiver has no sending track '
      '(nothing to announce)',
      () async {
        final wires = buildManager(isReconnecting: false);
        addUnmutableTrack(wires.manager, senderTrack: null);

        final result = await wires.manager.unmuteTrack(trackId: _trackId);

        expect(result.isSuccess, isTrue);
        expect(wires.renegotiations, isEmpty);
      },
    );

    test(
      'does NOT force a renegotiation while a reconnect is in progress — the '
      'post-reconnect renegotiation announces all tracks anyway',
      () async {
        final wires = buildManager(isReconnecting: true);
        addUnmutableTrack(wires.manager, senderTrack: _MockMediaStreamTrack());

        final result = await wires.manager.unmuteTrack(trackId: _trackId);

        expect(result.isSuccess, isTrue);
        expect(wires.renegotiations, isEmpty);
      },
    );
  });
}
