import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/e2ee/e2ee_mapping.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

SfuCodec codec(String name) => SfuCodec(
  payloadType: 96,
  name: name,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

void main() {
  group('e2eeCodecPin', () {
    test('pins the four codecs the frame transform understands', () {
      expect(codec('opus').e2eeCodecPin, 'opus');
      expect(codec('vp8').e2eeCodecPin, 'vp8');
      expect(codec('vp9').e2eeCodecPin, 'vp9');
      expect(codec('h264').e2eeCodecPin, 'h264');
    });

    test('normalises case, since the pin must be exact lowercase', () {
      expect(codec('VP8').e2eeCodecPin, 'vp8');
      expect(codec('H264').e2eeCodecPin, 'h264');
      expect(codec('Opus').e2eeCodecPin, 'opus');
    });

    test('passes through a codec the transform cannot frame', () {
      // AV1 has no framing scheme in this format, and the spec wants the client
      // to fail closed on it. That only works if the transform is told the
      // codec is AV1 — reporting no pin would have it read the codec from the
      // frame and encrypt on a guessed clear-byte count instead.
      expect(codec('av1').e2eeCodecPin, 'av1');
      expect(codec('AV1').e2eeCodecPin, 'av1');
    });

    test('leaves a nameless codec for native to read from the frame', () {
      expect(codec('').e2eeCodecPin, isNull);
      expect(codec('   ').e2eeCodecPin, isNull);
    });
  });

  group('e2eeTrackType', () {
    test('maps every published track type', () {
      expect(SfuTrackType.audio.e2eeTrackType, rtc.E2eeTrackType.audio);
      expect(SfuTrackType.video.e2eeTrackType, rtc.E2eeTrackType.video);
      expect(
        SfuTrackType.screenShare.e2eeTrackType,
        rtc.E2eeTrackType.screenShare,
      );
      expect(
        SfuTrackType.screenShareAudio.e2eeTrackType,
        rtc.E2eeTrackType.screenShareAudio,
      );
    });

    test('keeps screenshare distinct from camera video', () {
      // Collapsing the two would make one replay window cover both tracks.
      expect(
        SfuTrackType.screenShare.e2eeTrackType,
        isNot(SfuTrackType.video.e2eeTrackType),
      );
    });

    test('leaves an unspecified track for native to classify', () {
      expect(SfuTrackType.unspecified.e2eeTrackType, isNull);
    });
  });
}
