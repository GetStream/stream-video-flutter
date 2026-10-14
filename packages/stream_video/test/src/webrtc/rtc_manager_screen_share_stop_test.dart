// ignore_for_file: missing_override_of_must_be_overridden

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/media/media_constraints.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
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

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  _FakeMediaStreamTrack(this.id, {required this.kind});

  @override
  final String id;

  @override
  final String kind;

  @override
  bool enabled = true;

  bool stopped = false;
  int _clones = 0;

  @override
  Future<void> stop() async => stopped = true;

  @override
  Future<rtc.MediaStreamTrack> clone() async =>
      _FakeMediaStreamTrack('$id-clone-${_clones++}', kind: kind);
}

class _FakeMediaStream extends Fake implements rtc.MediaStream {
  @override
  Future<void> dispose() async {}
}

/// A sender that holds whatever track it was last given, as a real one does.
class _FakeSender extends Fake implements rtc.RTCRtpSender {
  _FakeSender(this.track);

  @override
  rtc.MediaStreamTrack? track;

  @override
  Future<void> replaceTrack(rtc.MediaStreamTrack? track) async {
    this.track = track;
  }
}

const _videoCodec = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

const _audioCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

final _micOption = SfuPublishOptions(
  id: 1,
  codec: _audioCodec,
  trackType: SfuTrackType.audio,
);

final _screenShareOption = SfuPublishOptions(
  id: 2,
  codec: _videoCodec,
  trackType: SfuTrackType.screenShare,
);

final _screenShareAudioOption = SfuPublishOptions(
  id: 3,
  codec: _audioCodec,
  trackType: SfuTrackType.screenShareAudio,
);

RtcLocalTrack<T> _localTrack<T extends MediaConstraints>(
  String mediaId, {
  required SfuTrackType trackType,
  required T constraints,
  required String kind,
}) {
  return RtcLocalTrack(
    trackIdPrefix: 'test-publisher',
    trackType: trackType,
    mediaStream: _FakeMediaStream(),
    mediaTrack: _FakeMediaStreamTrack(mediaId, kind: kind),
    mediaConstraints: constraints,
  );
}

RtcLocalScreenShareTrack _screenShareTrack(String mediaId) => _localTrack(
  mediaId,
  trackType: SfuTrackType.screenShare,
  constraints: const ScreenShareConstraints(),
  kind: 'video',
);

RtcLocalAudioTrack _audioTrack(String mediaId, SfuTrackType trackType) =>
    _localTrack(
      mediaId,
      trackType: trackType,
      constraints: const AudioConstraints(),
      kind: 'audio',
    );

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  ({
    RtcManager manager,
    _MockPeerConnection pc,
    List<StreamPeerConnection> renegotiations,
  })
  buildManager() {
    final pc = _MockPeerConnection();
    when(pc.getLocalDescription).thenAnswer((_) async => null);

    final publisher = _MockTracedStreamPeerConnection();
    final renegotiations = <StreamPeerConnection>[];
    when(() => publisher.pc).thenReturn(pc);
    when(() => publisher.tracer).thenReturn(Tracer(null));
    when(() => publisher.isReconnecting).thenReturn(false);
    when(() => publisher.onRenegotiationNeeded).thenReturn(renegotiations.add);

    final manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: _MockTracedStreamPeerConnection(),
      publishOptions: [_micOption, _screenShareOption, _screenShareAudioOption],
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
    );

    return (manager: manager, pc: pc, renegotiations: renegotiations);
  }

  /// Registers [track] as published on [option], sending a clone of it on a
  /// transceiver with [mid] that the SFU has acknowledged.
  Future<({rtc.RTCRtpTransceiver transceiver, _FakeSender sender})> publish(
    RtcManager manager,
    RtcLocalTrack track,
    SfuPublishOptions option, {
    required String mid,
  }) async {
    final clone = await track.mediaTrack.clone();
    final sender = _FakeSender(clone);
    final transceiver = _MockTransceiver();
    when(() => transceiver.sender).thenReturn(sender);
    when(() => transceiver.mid).thenReturn(mid);

    final published = track.copyWith(clonedTracks: [clone]);
    manager.tracks[track.trackId] = published;
    manager.transceiversManager
      ..add(
        published.copyWith(mediaTrack: clone),
        option,
        transceiver,
        const RtcTrackPublishOptions(),
      )
      ..markNegotiated([
        RtcTrackInfo(
          trackId: clone.id,
          trackType: option.trackType,
          publishOptionId: option.id,
          mid: mid,
          layers: const [],
          codec: option.codec,
          muted: false,
          dtx: false,
          stereo: false,
          red: false,
        ),
      ]);

    return (transceiver: transceiver, sender: sender);
  }

  group('stopping a screen share', () {
    test('takes the screen share and its audio off their senders', () async {
      final wires = buildManager();
      final video = await publish(
        wires.manager,
        _screenShareTrack('screen'),
        _screenShareOption,
        mid: '0',
      );
      final audio = await publish(
        wires.manager,
        _audioTrack('screen-audio', SfuTrackType.screenShareAudio),
        _screenShareAudioOption,
        mid: '1',
      );

      final result = await wires.manager.setScreenShareEnabled(enabled: false);

      expect(result.isSuccess, isTrue);
      expect(video.sender.track, isNull);
      expect(audio.sender.track, isNull);
    });

    test(
      'leaves it out of the reconnect announce while a muted microphone stays '
      'in it',
      () async {
        final wires = buildManager();
        final mic = await publish(
          wires.manager,
          _audioTrack('mic', SfuTrackType.audio),
          _micOption,
          mid: '0',
        );
        final screen = await publish(
          wires.manager,
          _screenShareTrack('screen'),
          _screenShareOption,
          mid: '1',
        );
        when(wires.pc.getTransceivers).thenAnswer(
          (_) async => [mic.transceiver, screen.transceiver],
        );

        await wires.manager.muteTrack(
          trackId: 'test-publisher:${SfuTrackType.audio}',
          stopTrackOnMute: false,
        );
        await wires.manager.setScreenShareEnabled(enabled: false);

        final announced = await wires.manager.getAnnouncedTracksForReconnect();

        expect(announced.map((it) => it.trackType), [SfuTrackType.audio]);
        expect(announced.single.muted, isTrue);
      },
    );

    test('sharing again renegotiates, so the SFU learns of it', () async {
      final wires = buildManager();
      final screen = await publish(
        wires.manager,
        _screenShareTrack('screen'),
        _screenShareOption,
        mid: '0',
      );

      await wires.manager.setScreenShareEnabled(enabled: false);
      final result = await wires.manager.publishVideoTrack(
        track: _screenShareTrack('screen-2'),
      );

      expect(result.isSuccess, isTrue);
      expect(screen.sender.track?.id, startsWith('screen-2'));
      expect(wires.renegotiations, hasLength(1));
    });

    test(
      'is what triggers that renegotiation: replacing a live, acknowledged '
      'track does not',
      () async {
        final wires = buildManager();
        await publish(
          wires.manager,
          _screenShareTrack('screen'),
          _screenShareOption,
          mid: '0',
        );

        final result = await wires.manager.publishVideoTrack(
          track: _screenShareTrack('screen-2'),
        );

        expect(result.isSuccess, isTrue);
        expect(wires.renegotiations, isEmpty);
      },
    );
  });
}
