import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/codecs_helper.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';

void main() {
  group('getComputedMaxBitrate', () {
    const target = RtcVideoDimension(width: 1280, height: 720);
    const maxBitrate = 1000000;

    test('keeps the bitrate for a capture at or above the target', () {
      expect(getComputedMaxBitrate(target, maxBitrate, 1280, 720), maxBitrate);
      expect(getComputedMaxBitrate(target, maxBitrate, 1920, 1080), maxBitrate);
    });

    test('keeps the bitrate for a portrait capture above the target', () {
      // A landscape target must not read the portrait short side (1080 < 1280)
      // as below it, which would scale the bitrate up by 2.25.
      expect(getComputedMaxBitrate(target, maxBitrate, 1080, 1920), maxBitrate);
      expect(getComputedMaxBitrate(target, maxBitrate, 720, 1280), maxBitrate);
    });

    test('reduces the bitrate for a smaller capture in either orientation', () {
      // 640x360 is a quarter of the target's pixels.
      expect(getComputedMaxBitrate(target, maxBitrate, 640, 360), 250000);
      expect(getComputedMaxBitrate(target, maxBitrate, 360, 640), 250000);
    });

    test('reduces a portrait capture the same as its landscape equivalent', () {
      // A 4:3 camera captures 960x720 for a 1280x720 request.
      expect(
        getComputedMaxBitrate(target, maxBitrate, 720, 960),
        getComputedMaxBitrate(target, maxBitrate, 960, 720),
      );
    });
  });

  group('findOptimalVideoLayers', () {
    test('caps a portrait capture at the same bitrate as a landscape one', () {
      // Defaults: 1280x720 target at the preset bitrate.
      final publishOptions = _publishOptions();

      final landscape = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1920, height: 1080),
        publishOptions: publishOptions,
      );
      final portrait = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1080, height: 1920),
        publishOptions: publishOptions,
      );

      expect(
        portrait.map((l) => l.maxBitrate),
        landscape.map((l) => l.maxBitrate),
      );
    });
  });
}

SfuPublishOptions _publishOptions() => SfuPublishOptions(
  id: 1,
  codec: const SfuCodec(
    name: 'h264',
    payloadType: 96,
    fmtpLine: '',
    clockRate: 90000,
    encodingParameters: '',
  ),
  trackType: SfuTrackType.video,
);
