import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
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
    test('marks only the transceivers that currently have a sending track', () {
      final manager = TransceiverManager();

      final sending = _option(1, SfuTrackType.video);
      final idle = _option(2, SfuTrackType.audio);

      // A transceiver actively sending a track — this is what gets announced
      // to the SFU, so it should be marked negotiated.
      manager.add(
        _MockLocalTrack(),
        sending,
        _transceiverWithTrack(_MockMediaStreamTrack()),
        const RtcTrackPublishOptions(),
      );

      // A transceiver without a sending track — never announced, so it must
      // stay unnegotiated.
      manager.add(
        _MockLocalTrack(),
        idle,
        _transceiverWithTrack(null),
        const RtcTrackPublishOptions(),
      );

      manager.markNegotiated();

      expect(manager.get(sending)!.negotiated, isTrue);
      expect(manager.get(idle)!.negotiated, isFalse);
    });

    test('leaves an idle transceiver renegotiable on the next republish', () {
      final manager = TransceiverManager();
      final option = _option(1, SfuTrackType.video);

      // The transceiver had no track when the previous negotiation ran (e.g.
      // SetPublisher timed out before a track was attached).
      manager.add(
        _MockLocalTrack(),
        option,
        _transceiverWithTrack(null),
        const RtcTrackPublishOptions(),
      );

      manager.markNegotiated();

      // Still unnegotiated, so a later republish knows it must renegotiate.
      expect(manager.get(option)!.negotiated, isFalse);
    });
  });
}
