import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';

const _testCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

RtcTrackInfo _trackInfo({required bool muted}) {
  return RtcTrackInfo(
    trackId: 'audio-track',
    trackType: SfuTrackType.audio,
    mid: '0',
    layers: const [],
    codec: _testCodec,
    muted: muted,
    publishOptionId: 1,
    dtx: false,
    stereo: false,
    red: false,
  );
}

void main() {
  group('RtcTracksInfoMapper.toDTO', () {
    // The SFU reads `TrackInfo.muted` from SetPublisher, the join request and
    // UpdatePublish, so a disabled track still attached to its sender has to
    // go out as muted.
    test('announces a muted track as muted', () {
      final dto = [_trackInfo(muted: true)].toDTO();

      expect(dto.single.muted, isTrue);
    });

    test('announces an unmuted track as unmuted', () {
      final dto = [_trackInfo(muted: false)].toDTO();

      expect(dto.single.muted, isFalse);
    });
  });
}
