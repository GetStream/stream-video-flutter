import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_encoding.dart';
import 'package:stream_video/src/webrtc/publisher/announced_tracks.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_track_publish_options.dart';
import 'package:stream_video/src/webrtc/transceiver_cache.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../fixtures/rtc_manager_fakes.dart';

final _micOption = publishOption(1, SfuTrackType.audio);
final _screenAudioOption = publishOption(2, SfuTrackType.screenShareAudio);
final _cameraOption = SfuPublishOptions(
  id: 3,
  codec: vp8Codec,
  trackType: SfuTrackType.video,
  bitrate: 1000000,
  videoDimension: const RtcVideoDimension(width: 1280, height: 720),
);

/// An offer naming [trackId] in an m-section of [kind] with [mid].
String _offer({
  required String trackId,
  String kind = 'audio',
  String? mid,
}) {
  return [
    'v=0',
    'o=- 1 2 IN IP4 127.0.0.1',
    's=-',
    't=0 0',
    'm=$kind 9 UDP/TLS/RTP/SAVPF 111',
    'c=IN IP4 0.0.0.0',
    'a=sendonly',
    'a=msid:stream-id $trackId',
    if (mid != null) 'a=mid:$mid',
    '',
  ].join('\r\n');
}

TransceiverCache _cache(
  RtcLocalTrack track,
  SfuPublishOptions option, {
  bool sending = true,
  bool negotiated = false,
  String? negotiatedMid,
}) {
  return TransceiverCache(
    track: track,
    publishOption: option,
    transceiver: FakeTransceiver(
      FakeSender(sending ? track.mediaTrack : null),
    ),
    trackPublishOptions: const RtcTrackPublishOptions(),
    negotiated: negotiated,
    negotiatedMid: negotiatedMid,
  );
}

RtcTrackInfo? _info(
  TransceiverCache cache, {
  List<rtc.RTCRtpTransceiver> liveTransceivers = const [],
  String? sdp,
  StreamAudioSettings audioSettings = const StreamAudioSettings(),
  RtcVideoDimension dimension = const RtcVideoDimension(
    width: 1280,
    height: 720,
  ),
  void Function(Map<String, Object?>)? onMidUnresolved,
}) {
  return transceiverToTrackInfo(
    cache,
    liveTransceivers: liveTransceivers,
    sdp: sdp,
    audioSettings: audioSettings,
    dimensionOf: (_) => dimension,
    onMidUnresolved: onMidUnresolved,
  );
}

/// A transceiver as the peer connection reports it, with a negotiated mid.
class _LiveTransceiver extends FakeTransceiver {
  _LiveTransceiver(super.sender, {required this.mid});

  @override
  final String mid;
}

void main() {
  group('isMidFlightPublish', () {
    test('is true when the offer names none of the sent track ids', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);

      expect(isMidFlightPublish(cache, _offer(trackId: 'other')), isTrue);
    });

    test('is false when the offer names the current track id', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);

      expect(isMidFlightPublish(cache, _offer(trackId: 'mic')), isFalse);
    });

    test('is false when the offer names an earlier sent track id', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);
      // A replaceTrack after createOffer: the offer still names 'mic'.
      cache.transceiver.sender.replaceTrack(
        FakeMediaStreamTrack('mic-2', kind: 'audio'),
      );

      expect(isMidFlightPublish(cache, _offer(trackId: 'mic')), isFalse);
    });

    test('is false without an offer or once negotiated', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);
      final negotiated = _cache(
        fakeAudioTrack('mic'),
        _micOption,
        negotiated: true,
      );

      expect(isMidFlightPublish(cache, null), isFalse);
      expect(
        isMidFlightPublish(negotiated, _offer(trackId: 'other')),
        isFalse,
      );
    });
  });

  group('transceiverToTrackInfo', () {
    test('announces an audio track with the mid from the offer', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);

      final info = _info(
        cache,
        sdp: _offer(trackId: 'mic', mid: '2'),
      );

      expect(info, isNotNull);
      expect(info!.trackId, 'mic');
      expect(info.mid, '2');
      expect(info.trackType, SfuTrackType.audio);
      expect(info.publishOptionId, _micOption.id);
      expect(info.layers, isEmpty);
      expect(info.muted, isFalse);
    });

    test('takes stereo, DTX and RED for audio from the audio settings', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);
      final sdp = _offer(trackId: 'mic', mid: '0');

      final plain = _info(cache, sdp: sdp)!;
      expect((plain.stereo, plain.dtx, plain.red), (false, false, false));

      final configured = _info(
        cache,
        sdp: sdp,
        audioSettings: const StreamAudioSettings(
          hifiAudioEnabled: true,
          opusDtxEnabled: true,
          redundantCodingEnabled: true,
        ),
      )!;
      expect(
        (configured.stereo, configured.dtx, configured.red),
        (true, true, true),
      );
    });

    test('announces screen share audio in stereo', () {
      final track = fakeLocalTrack(
        'screen-audio',
        trackType: SfuTrackType.screenShareAudio,
        constraints: const AudioConstraints(),
        kind: 'audio',
      );
      final cache = _cache(track, _screenAudioOption);

      final info = _info(
        cache,
        sdp: _offer(trackId: 'screen-audio', mid: '1'),
      );

      expect(info!.stereo, isTrue);
    });

    test('reports a sender with a disabled track as muted', () {
      final mic = fakeAudioTrack('mic');
      fakeMediaOf(mic).enabled = false;
      final cache = _cache(mic, _micOption);

      final info = _info(
        cache,
        sdp: _offer(trackId: 'mic', mid: '0'),
      );

      expect(info!.muted, isTrue);
    });

    test('announces video layers worked out from the given dimension', () {
      final cache = _cache(fakeCameraTrack('cam'), _cameraOption);

      // A capture size other than the publish option's 1280x720.
      final info = _info(
        cache,
        sdp: _offer(trackId: 'cam', kind: 'video', mid: '0'),
        dimension: const RtcVideoDimension(width: 640, height: 360),
      );

      final layers = info!.layers!;
      // Two layers fit a 640x360 capture; the publish option alone gives three.
      expect(layers.map((it) => it.rid), ['q', 'h']);
      expect(
        layers.last.parameters.dimension,
        const RtcVideoDimension(width: 640, height: 360),
      );
      expect(
        layers.map((it) => it.parameters.encoding.quality),
        [RtcVideoQuality.lowUnspecified, RtcVideoQuality.mid],
      );
    });

    test('takes the mid of the live transceiver sending the track', () {
      final mic = fakeAudioTrack('mic');
      final cache = _cache(mic, _micOption);
      final live = _LiveTransceiver(FakeSender(mic.mediaTrack), mid: '7');

      final info = _info(cache, liveTransceivers: [live]);

      expect(info!.mid, '7');
    });

    test('falls back to the last acknowledged mid', () {
      final cache = _cache(
        fakeAudioTrack('mic'),
        _micOption,
        negotiated: true,
        negotiatedMid: '4',
      );

      expect(_info(cache)!.mid, '4');
    });

    test(
      'returns null and reports a track in the offer whose mid is unresolved',
      () {
        final cache = _cache(fakeAudioTrack('mic'), _micOption);
        final reports = <Map<String, Object?>>[];

        final info = _info(
          cache,
          sdp: _offer(trackId: 'mic'),
          onMidUnresolved: reports.add,
        );

        expect(info, isNull);
        expect(reports.single, containsPair('trackId', 'mic'));
        expect(reports.single, containsPair('hasSdp', true));
      },
    );

    test('returns null without a report for a publish not in the offer', () {
      final cache = _cache(fakeAudioTrack('mic'), _micOption);
      final reports = <Map<String, Object?>>[];

      final info = _info(
        cache,
        sdp: _offer(trackId: 'other', mid: '0'),
        onMidUnresolved: reports.add,
      );

      expect(info, isNull);
      expect(reports, isEmpty);
    });
  });
}
