import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/src/sfu/data/events/sfu_event_mapper_extensions.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/webrtc/codecs_helper.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';

/// Round-trips [option] through protobuf serialization so the decoded message
/// has exactly the field presence a real SFU payload would.
SfuPublishOptions _decode(sfu_models.PublishOption option) {
  final event = sfu_events.SfuEvent(
    changePublishOptions: sfu_events.ChangePublishOptions(
      publishOptions: [option],
    ),
  );

  final decoded = sfu_events.SfuEvent.fromBuffer(event.writeToBuffer());
  final mapped = decoded.toDomain() as SfuChangePublishOptionsEvent;
  return mapped.publishOptions.single;
}

sfu_models.PublishOption _h264({
  int? fps,
  int? bitrate,
  int? maxSpatialLayers,
  int? maxTemporalLayers,
}) {
  return sfu_models.PublishOption(
    id: 1,
    trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
    codec: sfu_models.Codec(name: 'h264', payloadType: 96),
    fps: fps,
    bitrate: bitrate,
    maxSpatialLayers: maxSpatialLayers,
    maxTemporalLayers: maxTemporalLayers,
  );
}

void main() {
  const dimensions = RtcVideoDimension(width: 1280, height: 720);

  group('SfuPublishOptions proto3 presence', () {
    test('omitted scalars decode as null, not 0', () {
      final options = _decode(_h264());

      expect(options.fps, isNull);
      expect(options.bitrate, isNull);
      expect(options.maxSpatialLayers, isNull);
      expect(options.maxTemporalLayers, isNull);
      expect(options.videoDimension, isNull);
    });

    test('explicitly sent scalars survive the round trip', () {
      final options = _decode(
        _h264(fps: 24, bitrate: 500000, maxSpatialLayers: 2),
      );

      expect(options.fps, 24);
      expect(options.bitrate, 500000);
      expect(options.maxSpatialLayers, 2);
    });
  });

  group('findOptimalVideoLayers falls back to documented defaults', () {
    test('omitted options yield the full 3-layer ladder at 30 fps', () {
      final layers = findOptimalVideoLayers(
        dimensions: dimensions,
        publishOptions: _decode(_h264()),
      );

      expect(layers, hasLength(3));
      expect(layers.map((l) => l.rid), ['q', 'h', 'f']);
      for (final layer in layers) {
        expect(layer.maxFramerate, 30);
        expect(layer.maxBitrate, greaterThan(0));
      }
    });

    test('an explicit 0 is treated as absent, not published verbatim', () {
      // The SFU is not expected to send zeroes, but a `0` on the wire is
      // indistinguishable from a bug on their side — never propagate it.
      final layers = findOptimalVideoLayers(
        dimensions: dimensions,
        publishOptions: _decode(
          _h264(fps: 0, bitrate: 0, maxSpatialLayers: 0, maxTemporalLayers: 0),
        ),
      );

      expect(layers, hasLength(3));
      for (final layer in layers) {
        expect(layer.maxFramerate, 30);
        expect(layer.maxBitrate, greaterThan(0));
      }
    });

    test('a spatial layer count above the rid count does not overflow', () {
      final layers = findOptimalVideoLayers(
        dimensions: dimensions,
        publishOptions: _decode(_h264(maxSpatialLayers: 9)),
      );

      expect(layers, hasLength(3));
    });

    test('an explicit spatial layer count is honoured', () {
      final layers = findOptimalVideoLayers(
        dimensions: dimensions,
        publishOptions: _decode(_h264(maxSpatialLayers: 1)),
      );

      // `withSimulcastConstraints` reassigns rids by index, so the single
      // full-resolution layer comes back named 'q'.
      expect(layers, hasLength(1));
      expect(layers.single.scaleResolutionDownBy, 1.0);
    });
  });

  group('SVC scalability mode', () {
    test('never produces a T0 mode when temporal layers are absent', () {
      final vp9 = sfu_models.PublishOption(
        id: 1,
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
        codec: sfu_models.Codec(name: 'vp9', payloadType: 98),
      );

      final layers = findOptimalVideoLayers(
        dimensions: dimensions,
        publishOptions: _decode(vp9),
      );

      for (final layer in layers) {
        expect(layer.scalabilityMode, 'L3T3_KEY');
      }
    });
  });
}
