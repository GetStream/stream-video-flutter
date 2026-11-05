import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_layer_setting.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_sender.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'fixtures/rtc_manager_fakes.dart';

final _vp8Option = publishOption(1, SfuTrackType.video);
final _vp9Option = publishOption(2, SfuTrackType.video, codec: vp9Codec);

SfuVideoLayerSetting _layer(
  String name, {
  bool active = true,
  int maxBitrate = 0,
  int maxFramerate = 0,
  double scaleResolutionDownBy = 0,
  String scalabilityMode = '',
  SfuCodec codec = vp8Codec,
}) {
  return SfuVideoLayerSetting(
    name: name,
    active: active,
    maxBitrate: maxBitrate,
    maxFramerate: maxFramerate,
    scaleResolutionDownBy: scaleResolutionDownBy,
    scalabilityMode: scalabilityMode,
    codec: codec,
  );
}

SfuVideoSender _videoSender(
  List<SfuVideoLayerSetting> layers, {
  int publishOptionId = 1,
  SfuCodec codec = vp8Codec,
  rtc.RTCDegradationPreference? degradationPreference,
}) {
  return SfuVideoSender(
    codec: codec,
    layers: layers,
    trackType: SfuTrackType.video,
    publishOptionId: publishOptionId,
    degradationPreference: degradationPreference,
  );
}

rtc.RTCRtpEncoding _encoding(
  String? rid, {
  bool active = true,
  int? maxBitrate,
  int? maxFramerate,
  double? scaleResolutionDownBy,
  String? scalabilityMode,
}) {
  return rtc.RTCRtpEncoding(
    rid: rid,
    active: active,
    maxBitrate: maxBitrate,
    maxFramerate: maxFramerate,
    scaleResolutionDownBy: scaleResolutionDownBy,
    scalabilityMode: scalabilityMode,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  /// A manager publishing the camera with [option], whose sender is set to
  /// [encodings].
  Future<({RtcManager manager, FakeSender sender})> publishing(
    List<rtc.RTCRtpEncoding> encodings, {
    rtc.RTCDegradationPreference? degradationPreference,
  }) async {
    final fixture = RtcManagerFixture(publishOptions: [_vp8Option]);
    final result = await fixture.manager.publishVideoTrack(
      track: fakeCameraTrack('cam'),
    );
    expect(result.isSuccess, isTrue);

    final sender = fixture.transceivers.single.sender
      ..parameters = rtc.RTCRtpParameters(
        encodings: encodings,
        degradationPreference: degradationPreference,
      );
    return (manager: fixture.manager, sender: sender);
  }

  group('onPublishQualityChanged', () {
    test(
      'a simulcast sender activates and deactivates its layers by rid',
      () async {
        final wires = await publishing([
          _encoding('q'),
          _encoding('h'),
          _encoding('f', active: false),
        ]);

        await wires.manager.onPublishQualityChanged(
          _videoSender([
            _layer('q', active: false),
            _layer('h', maxBitrate: 500000),
            _layer('f', maxBitrate: 1200000),
          ]),
          'vp8',
        );

        final encodings = wires.sender.setParametersCalls.single.encodings!;
        expect(encodings.map((e) => e.active), [false, true, true]);
        expect(encodings.map((e) => e.maxBitrate), [null, 500000, 1200000]);
      },
    );

    test(
      'a simulcast encoding whose rid the SFU does not mention is '
      'deactivated and left otherwise untouched',
      () async {
        final wires = await publishing([
          _encoding('q', maxBitrate: 100),
          _encoding('h', maxBitrate: 200),
        ]);

        await wires.manager.onPublishQualityChanged(
          _videoSender([_layer('h', maxBitrate: 300)]),
          'vp8',
        );

        final encodings = wires.sender.setParametersCalls.single.encodings!;
        expect(encodings.map((e) => e.active), [false, true]);
        expect(encodings.map((e) => e.maxBitrate), [100, 300]);
      },
    );

    test(
      'an SVC sender applies the first active layer to its single encoding, '
      'whatever its rid',
      () async {
        // Matched by rid, as a simulcast sender would be, this encoding would
        // take the 'h' layer instead.
        final wires = await publishing([_encoding('h')]);

        await wires.manager.onPublishQualityChanged(
          _videoSender(
            [
              _layer('q', active: false, maxBitrate: 1),
              _layer(
                'f',
                maxBitrate: 1500000,
                maxFramerate: 30,
                scalabilityMode: 'L3T3_KEY',
              ),
              _layer('h', maxBitrate: 700000, maxFramerate: 15),
            ],
            codec: vp9Codec,
          ),
          'vp9',
        );

        final encoding =
            wires.sender.setParametersCalls.single.encodings!.single;
        expect(encoding.active, isTrue);
        expect(encoding.maxBitrate, 1500000);
        expect(encoding.maxFramerate, 30);
        expect(encoding.scalabilityMode, 'L3T3_KEY');
      },
    );

    test(
      'a single non-SVC encoding whose rid does not match falls back to the '
      'first active layer',
      () async {
        final wires = await publishing([_encoding('x', active: false)]);

        await wires.manager.onPublishQualityChanged(
          _videoSender([_layer('q', maxBitrate: 250000)]),
          'vp8',
        );

        final encoding =
            wires.sender.setParametersCalls.single.encodings!.single;
        expect(encoding.active, isTrue);
        expect(encoding.maxBitrate, 250000);
      },
    );

    test(
      'scale, bitrate, framerate and scalability mode apply only when set '
      'and different',
      () async {
        final wires = await publishing([
          _encoding(
            'f',
            maxBitrate: 1000,
            maxFramerate: 30,
            scaleResolutionDownBy: 2,
            scalabilityMode: 'L1T3',
          ),
        ]);

        // Unset values (0, empty, a scale below 1) leave the encoding alone.
        await wires.manager.onPublishQualityChanged(
          _videoSender([_layer('f', scaleResolutionDownBy: 0.5)]),
          'vp8',
        );
        expect(wires.sender.setParametersCalls, isEmpty);

        await wires.manager.onPublishQualityChanged(
          _videoSender([
            _layer(
              'f',
              maxBitrate: 2000,
              maxFramerate: 15,
              scaleResolutionDownBy: 1,
              scalabilityMode: 'L1T2',
            ),
          ]),
          'vp8',
        );

        final encoding =
            wires.sender.setParametersCalls.single.encodings!.single;
        expect(encoding.maxBitrate, 2000);
        expect(encoding.maxFramerate, 15);
        expect(encoding.scaleResolutionDownBy, 1);
        expect(encoding.scalabilityMode, 'L1T2');
      },
    );

    test('nothing that differs skips setParameters', () async {
      final wires = await publishing([
        _encoding(
          'f',
          maxBitrate: 1000,
          maxFramerate: 30,
          scaleResolutionDownBy: 2,
          scalabilityMode: 'L1T3',
        ),
      ]);

      await wires.manager.onPublishQualityChanged(
        _videoSender([
          _layer(
            'f',
            maxBitrate: 1000,
            maxFramerate: 30,
            scaleResolutionDownBy: 2,
            scalabilityMode: 'L1T3',
          ),
        ]),
        'vp8',
      );

      expect(wires.sender.setParametersCalls, isEmpty);
    });

    test('the degradation preference applies only when it differs', () async {
      final wires = await publishing(
        [_encoding('f')],
        degradationPreference: rtc.RTCDegradationPreference.BALANCED,
      );

      await wires.manager.onPublishQualityChanged(
        _videoSender(
          [_layer('f')],
          degradationPreference: rtc.RTCDegradationPreference.BALANCED,
        ),
        'vp8',
      );
      expect(wires.sender.setParametersCalls, isEmpty);

      // A null preference from the SFU leaves the current one in place.
      await wires.manager.onPublishQualityChanged(
        _videoSender([_layer('f')]),
        'vp8',
      );
      expect(wires.sender.setParametersCalls, isEmpty);

      await wires.manager.onPublishQualityChanged(
        _videoSender(
          [_layer('f')],
          degradationPreference:
              rtc.RTCDegradationPreference.MAINTAIN_RESOLUTION,
        ),
        'vp8',
      );
      expect(wires.sender.setParametersCalls, hasLength(1));
      expect(
        wires.sender.parameters.degradationPreference,
        rtc.RTCDegradationPreference.MAINTAIN_RESOLUTION,
      );
    });

    test('a sender with no encodings is left alone', () async {
      final wires = await publishing([]);

      await wires.manager.onPublishQualityChanged(
        _videoSender([_layer('f', maxBitrate: 1000)]),
        'vp8',
      );

      expect(wires.sender.setParametersCalls, isEmpty);
    });

    test('a publish option with no sender is ignored', () async {
      final wires = await publishing([_encoding('f')]);

      await wires.manager.onPublishQualityChanged(
        _videoSender(
          [_layer('f', maxBitrate: 1000)],
          publishOptionId: _vp9Option.id,
        ),
        'vp9',
      );

      expect(wires.sender.setParametersCalls, isEmpty);
    });
  });
}
