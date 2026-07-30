import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_local_track.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_track_publish_options.dart';
import 'package:stream_video/src/webrtc/transceiver_cache.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

const _testCodec = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockSender extends Mock implements rtc.RTCRtpSender {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockLocalTrack extends Mock implements RtcLocalTrack {}

/// Builds a transceiver whose sender exposes [track] (nullable).
rtc.RTCRtpTransceiver _transceiverWithTrack(rtc.MediaStreamTrack? track) {
  final sender = _MockSender();
  when(() => sender.track).thenReturn(track);

  final transceiver = _MockTransceiver();
  when(() => transceiver.sender).thenReturn(sender);
  return transceiver;
}

SfuPublishOptions _option(int id, SfuTrackType trackType) {
  return SfuPublishOptions(id: id, codec: _testCodec, trackType: trackType);
}

/// Builds a local track whose underlying media track reports [mediaTrackId].
RtcLocalTrack _localTrack(String mediaTrackId) {
  final mediaTrack = _MockMediaStreamTrack();
  when(() => mediaTrack.id).thenReturn(mediaTrackId);

  final track = _MockLocalTrack();
  when(() => track.mediaTrack).thenReturn(mediaTrack);
  return track;
}

/// Builds the announced track info for [option] and [mediaTrackId], matching
/// what `getAnnouncedTracks` sends to the SFU.
RtcTrackInfo _trackInfo(String mediaTrackId, SfuPublishOptions option) {
  return RtcTrackInfo(
    trackId: mediaTrackId,
    trackType: option.trackType,
    publishOptionId: option.id,
    mid: '0',
    layers: const [],
    codec: option.codec,
    muted: false,
    dtx: false,
    stereo: false,
    red: false,
  );
}

void main() {
  group('TransceiverCache.negotiated', () {
    test('defaults to false when a transceiver is added to the cache', () {
      final manager = TransceiverManager();
      final option = _option(1, SfuTrackType.video);

      manager.add(
        _MockLocalTrack(),
        option,
        _transceiverWithTrack(_MockMediaStreamTrack()),
        const RtcTrackPublishOptions(),
      );

      expect(manager.get(option)!.negotiated, isFalse);
    });
  });

  group('TransceiverManager.markNegotiated', () {
    test('marks only the transceivers that were announced to the SFU', () {
      final manager = TransceiverManager();

      final announcedOption = _option(1, SfuTrackType.video);
      final idleOption = _option(2, SfuTrackType.audio);

      // A transceiver actively sending a track — this is what gets announced
      // to the SFU, so it should be marked negotiated.
      manager.add(
        _localTrack('media-1'),
        announcedOption,
        _transceiverWithTrack(_MockMediaStreamTrack()),
        const RtcTrackPublishOptions(),
      );

      // A transceiver without a sending track — never announced, so it must
      // stay unnegotiated.
      manager.add(
        _localTrack('media-2'),
        idleOption,
        _transceiverWithTrack(null),
        const RtcTrackPublishOptions(),
      );

      manager.markNegotiated([_trackInfo('media-1', announcedOption)]);

      expect(manager.get(announcedOption)!.negotiated, isTrue);
      expect(manager.get(idleOption)!.negotiated, isFalse);
    });

    test('leaves an idle transceiver renegotiable on the next republish', () {
      final manager = TransceiverManager();
      final option = _option(1, SfuTrackType.video);

      // The transceiver had no track when the previous negotiation ran (e.g.
      // SetPublisher timed out before a track was attached), so it was never
      // part of the announced tracks.
      manager.add(
        _localTrack('media-1'),
        option,
        _transceiverWithTrack(null),
        const RtcTrackPublishOptions(),
      );

      manager.markNegotiated(const []);

      // Still unnegotiated, so a later republish knows it must renegotiate.
      expect(manager.get(option)!.negotiated, isFalse);
    });

    test('ignores a transceiver added while the negotiation was in flight', () {
      final manager = TransceiverManager();

      final announcedOption = _option(1, SfuTrackType.video);
      final lateOption = _option(2, SfuTrackType.audio);

      manager.add(
        _localTrack('media-1'),
        announcedOption,
        _transceiverWithTrack(_MockMediaStreamTrack()),
        const RtcTrackPublishOptions(),
      );

      // Announced set is captured when the offer is created.
      final announced = [_trackInfo('media-1', announcedOption)];

      // A track published while SetPublisher was still in flight: it is sending,
      // but the SFU never saw it in this offer.
      manager.add(
        _localTrack('media-2'),
        lateOption,
        _transceiverWithTrack(_MockMediaStreamTrack()),
        const RtcTrackPublishOptions(),
      );

      manager.markNegotiated(announced);

      expect(manager.get(announcedOption)!.negotiated, isTrue);
      expect(manager.get(lateOption)!.negotiated, isFalse);
    });

    test('ignores an announced track whose transceiver was since replaced', () {
      final manager = TransceiverManager();
      final option = _option(1, SfuTrackType.video);

      manager.add(
        _localTrack('media-new'),
        option,
        _transceiverWithTrack(_MockMediaStreamTrack()),
        const RtcTrackPublishOptions(),
      );

      // The offer announced the previous (now replaced) media track.
      manager.markNegotiated([_trackInfo('media-old', option)]);

      expect(manager.get(option)!.negotiated, isFalse);
    });
  });
}
