import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/codecs_helper.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

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

    test('keeps the bitrate for a capture equal to the target in either '
        'orientation', () {
      expect(getComputedMaxBitrate(target, maxBitrate, 1280, 720), maxBitrate);
      expect(getComputedMaxBitrate(target, maxBitrate, 720, 1280), maxBitrate);
    });

    test('keeps the bitrate for a non-native 1280x2560 capture', () {
      // A 1:2 capture with 3.5x the target's pixels; the bound must not be
      // reduced.
      expect(getComputedMaxBitrate(target, maxBitrate, 1280, 2560), maxBitrate);
      expect(getComputedMaxBitrate(target, maxBitrate, 2560, 1280), maxBitrate);
    });

    test('never falls below a quarter of the bitrate for a capture at or '
        'above the target pixel count', () {
      const captures = [
        (1280, 720), (720, 1280), // equal
        (1920, 1080), (1080, 1920), // 16:9 above
        (1920, 1440), (1440, 1920), // 4:3 above
        (2560, 1440), (1440, 2560), // 2K
        (1280, 2560), (2560, 1280), // non-native 1:2
        (960, 960), // square, equal pixel count
        (1280, 960), (960, 1280), // 4:3, above
      ];
      for (final (width, height) in captures) {
        expect(
          width * height >= target.width * target.height,
          isTrue,
          reason: '$width x $height is a capture at or above the target',
        );
        expect(
          getComputedMaxBitrate(target, maxBitrate, width, height),
          greaterThanOrEqualTo(maxBitrate ~/ 4),
          reason: 'bound for $width x $height',
        );
      }
    });

    test('reduces the bitrate for a capture below the target in either '
        'orientation', () {
      // 960x540 has 56.25% of the target's pixels.
      expect(getComputedMaxBitrate(target, maxBitrate, 960, 540), 562500);
      expect(getComputedMaxBitrate(target, maxBitrate, 540, 960), 562500);
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

    test('halves the bitrate per layer from the publish option', () {
      final layers = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1280, height: 720),
        publishOptions: _publishOptions(bitrate: 1000000),
      );

      expect(layers.map((l) => l.rid), ['q', 'h', 'f']);
      expect(layers.map((l) => l.maxBitrate), [250000, 500000, 1000000]);
    });

    test('falls back to the per-layer defaults when the publish option '
        'bitrate is 0', () {
      // The SFU's protobuf decodes an unset bitrate as 0.
      final layers = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1280, height: 720),
        publishOptions: _publishOptions(bitrate: 0),
      );

      expect(layers.map((l) => l.maxBitrate), [300000, 750000, 1250000]);
      expect(layers.every((l) => l.maxBitrate! > 0), isTrue);
    });

    test('treats an empty publish option dimension as the 1280x720 default', () {
      // The SFU's protobuf decodes an unset dimension as 0x0.
      final empty = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 640, height: 360),
        publishOptions: _publishOptions(
          bitrate: 1000000,
          videoDimension: const RtcVideoDimension(width: 0, height: 0),
        ),
      );
      final absent = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 640, height: 360),
        publishOptions: _publishOptions(bitrate: 1000000),
      );

      expect(empty.map((l) => l.maxBitrate), absent.map((l) => l.maxBitrate));
      // 640x360 is a quarter of 1280x720, so the f layer is bound to a quarter.
      expect(absent.last.maxBitrate, 250000);
    });

    test('gives SVC layers a scalability mode and the full bitrate on f', () {
      final layers = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1440, height: 2560),
        publishOptions: _publishOptions(codec: 'vp9', bitrate: 2000000),
      );

      expect(layers.map((l) => l.scalabilityMode), [
        'L3T3_KEY',
        'L3T3_KEY',
        'L3T3_KEY',
      ]);
      expect(layers.last.rid, 'f');
      expect(layers.last.maxBitrate, 2000000);
    });

    test('keeps only the f layer active for a single-layer SVC publish', () {
      final layers = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1440, height: 2560),
        publishOptions: _publishOptions(
          codec: 'vp9',
          bitrate: 2000000,
          useSingleLayer: true,
        ),
      );

      expect(layers.map((l) => l.scalabilityMode), ['L1T3', 'L1T3', 'L1T3']);
      expect(layers.map((l) => l.active), [false, false, true]);
      expect(layers.last.maxBitrate, 2000000);
    });
  });

  group('toSvcEncodings', () {
    test('emits one q encoding carrying the f layer bitrate, frame rate and '
        'scalability mode', () {
      final layers = findOptimalVideoLayers(
        dimensions: const RtcVideoDimension(width: 1440, height: 2560),
        publishOptions: _publishOptions(
          codec: 'vp9',
          bitrate: 2000000,
          useSingleLayer: true,
        ),
      );

      final encodings = toSvcEncodings(layers);

      expect(encodings, hasLength(1));
      final encoding = encodings.single;
      expect(encoding.rid, 'q');
      expect(encoding.active, isTrue);
      expect(encoding.maxBitrate, 2000000);
      expect(encoding.maxFramerate, 30);
      expect(encoding.scalabilityMode, 'L1T3');
    });

    test('falls back to h, then q, when higher layers are absent', () {
      final h = toSvcEncodings([
        rtc.RTCRtpEncoding(rid: 'q', maxBitrate: 1),
        rtc.RTCRtpEncoding(rid: 'h', maxBitrate: 2),
      ]).single;
      expect(h.rid, 'q');
      expect(h.maxBitrate, 2);

      final q = toSvcEncodings([
        rtc.RTCRtpEncoding(rid: 'q', maxBitrate: 1),
      ]).single;
      expect(q.maxBitrate, 1);

      expect(toSvcEncodings([]), isEmpty);
    });
  });
}

SfuPublishOptions _publishOptions({
  String codec = 'h264',
  int? bitrate,
  RtcVideoDimension? videoDimension,
  bool useSingleLayer = false,
}) => SfuPublishOptions(
  id: 1,
  codec: SfuCodec(
    name: codec,
    payloadType: 96,
    fmtpLine: '',
    clockRate: 90000,
    encodingParameters: '',
  ),
  trackType: SfuTrackType.video,
  bitrate: bitrate,
  videoDimension: videoDimension,
  fps: 30,
  useSingleLayer: useSingleLayer,
);
