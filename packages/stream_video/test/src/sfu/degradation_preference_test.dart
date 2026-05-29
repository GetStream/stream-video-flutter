import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart'
    as sfu_enums;
import 'package:stream_video/src/sfu/data/events/sfu_event_mapper_extensions.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_model_mapper_extensions.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_sender.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

const _testCodec = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

void main() {
  group('VideoSender.toDomain() degradationPreference', () {
    test('maps BALANCED degradationPreference from protobuf VideoSender', () {
      final protoVideoSender = sfu_events.VideoSender(
        codec: sfu_models.Codec(name: 'vp8'),
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
        publishOptionId: 1,
        degradationPreference:
            sfu_enums.DegradationPreference.DEGRADATION_PREFERENCE_BALANCED,
        layers: [
          sfu_events.VideoLayerSetting(
            name: 'q',
            active: true,
            maxBitrate: 100000,
            maxFramerate: 30,
            scaleResolutionDownBy: 1,
            scalabilityMode: '',
            codec: sfu_models.Codec(name: 'vp8'),
          ),
        ],
      );

      final domain = protoVideoSender.toDomain();

      expect(domain.degradationPreference, RTCDegradationPreference.BALANCED);
      expect(domain.publishOptionId, 1);
      expect(domain.layers.length, 1);
    });

    test('maps null when degradationPreference is UNSPECIFIED', () {
      final protoVideoSender = sfu_events.VideoSender(
        codec: sfu_models.Codec(name: 'vp8'),
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
        publishOptionId: 1,
        degradationPreference:
            sfu_enums.DegradationPreference.DEGRADATION_PREFERENCE_UNSPECIFIED,
        layers: [],
      );

      final domain = protoVideoSender.toDomain();

      expect(domain.degradationPreference, isNull);
    });

    test('maps MAINTAIN_RESOLUTION from protobuf VideoSender', () {
      final protoVideoSender = sfu_events.VideoSender(
        codec: sfu_models.Codec(name: 'vp9'),
        trackType: sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE,
        publishOptionId: 2,
        degradationPreference: sfu_enums
            .DegradationPreference
            .DEGRADATION_PREFERENCE_MAINTAIN_RESOLUTION,
        layers: [],
      );

      final domain = protoVideoSender.toDomain();

      expect(
        domain.degradationPreference,
        RTCDegradationPreference.MAINTAIN_RESOLUTION,
      );
    });

    test(
      'maps MAINTAIN_FRAMERATE_AND_RESOLUTION from protobuf VideoSender',
      () {
        final protoVideoSender = sfu_events.VideoSender(
          codec: sfu_models.Codec(name: 'av1'),
          trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
          publishOptionId: 3,
          degradationPreference: sfu_enums
              .DegradationPreference
              .DEGRADATION_PREFERENCE_MAINTAIN_FRAMERATE_AND_RESOLUTION,
          layers: [],
        );

        final domain = protoVideoSender.toDomain();

        expect(
          domain.degradationPreference,
          RTCDegradationPreference.MAINTAIN_FRAMERATE_AND_RESOLUTION,
        );
      },
    );
  });

  group('SfuVideoSender equatable includes degradationPreference', () {
    test('two SfuVideoSenders with same preference are equal', () {
      final sender1 = SfuVideoSender(
        codec: _testCodec,
        layers: const [],
        trackType: SfuTrackType.video,
        publishOptionId: 1,
        degradationPreference: RTCDegradationPreference.BALANCED,
      );
      final sender2 = SfuVideoSender(
        codec: _testCodec,
        layers: const [],
        trackType: SfuTrackType.video,
        publishOptionId: 1,
        degradationPreference: RTCDegradationPreference.BALANCED,
      );
      expect(sender1, equals(sender2));
    });

    test('two SfuVideoSenders with different preference are not equal', () {
      final sender1 = SfuVideoSender(
        codec: _testCodec,
        layers: const [],
        trackType: SfuTrackType.video,
        publishOptionId: 1,
        degradationPreference: RTCDegradationPreference.BALANCED,
      );
      final sender2 = SfuVideoSender(
        codec: _testCodec,
        layers: const [],
        trackType: SfuTrackType.video,
        publishOptionId: 1,
        degradationPreference: RTCDegradationPreference.MAINTAIN_FRAMERATE,
      );
      expect(sender1, isNot(equals(sender2)));
    });
  });

  group('SfuPublishOptions degradationPreference', () {
    test('stores degradationPreference when provided', () {
      final options = SfuPublishOptions(
        id: 1,
        codec: _testCodec,
        trackType: SfuTrackType.video,
        degradationPreference: RTCDegradationPreference.MAINTAIN_RESOLUTION,
      );

      expect(
        options.degradationPreference,
        RTCDegradationPreference.MAINTAIN_RESOLUTION,
      );
    });

    test('degradationPreference defaults to null', () {
      final options = SfuPublishOptions(
        id: 1,
        codec: _testCodec,
        trackType: SfuTrackType.video,
      );

      expect(options.degradationPreference, isNull);
    });

    test('toString includes degradationPreference', () {
      final options = SfuPublishOptions(
        id: 1,
        codec: _testCodec,
        trackType: SfuTrackType.video,
        degradationPreference: RTCDegradationPreference.BALANCED,
      );

      expect(options.toString(), contains('degradationPreference'));
      expect(options.toString(), contains('BALANCED'));
    });
  });
}
