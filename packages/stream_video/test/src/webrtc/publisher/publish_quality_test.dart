import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_layer_setting.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_sender.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_encoding.dart';
import 'package:stream_video/src/webrtc/publisher/publish_quality.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

const _vp8 = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

SfuVideoLayerSetting _layer(
  String name, {
  bool active = true,
  int maxBitrate = 0,
  int maxFramerate = 0,
  double scaleResolutionDownBy = 0,
  String scalabilityMode = '',
}) {
  return SfuVideoLayerSetting(
    name: name,
    active: active,
    maxBitrate: maxBitrate,
    maxFramerate: maxFramerate,
    scaleResolutionDownBy: scaleResolutionDownBy,
    scalabilityMode: scalabilityMode,
    codec: _vp8,
  );
}

SfuVideoSender _sender(
  List<SfuVideoLayerSetting> layers, {
  rtc.RTCDegradationPreference? degradationPreference,
}) {
  return SfuVideoSender(
    codec: _vp8,
    layers: layers,
    trackType: SfuTrackType.video,
    publishOptionId: 1,
    degradationPreference: degradationPreference,
  );
}

rtc.RTCRtpParameters _params(
  List<rtc.RTCRtpEncoding> encodings, {
  rtc.RTCDegradationPreference? degradationPreference,
}) {
  return rtc.RTCRtpParameters(
    encodings: encodings,
    degradationPreference: degradationPreference,
  );
}

void main() {
  group('applyPublishQuality', () {
    test('simulcast matches each encoding to its layer by rid', () {
      final params = _params([
        rtc.RTCRtpEncoding(rid: 'q'),
        rtc.RTCRtpEncoding(rid: 'h', active: false),
        rtc.RTCRtpEncoding(rid: 'f'),
      ]);

      final changed = applyPublishQuality(
        params,
        _sender([
          _layer('q', active: false),
          _layer('h', maxBitrate: 500),
          _layer('f', maxBitrate: 1500),
        ]),
        usesSvcCodec: false,
      );

      expect(changed, isTrue);
      expect(params.encodings!.map((e) => e.active), [false, true, true]);
      expect(params.encodings!.map((e) => e.maxBitrate), [null, 500, 1500]);
    });

    test('an encoding whose layer is paused is deactivated', () {
      final params = _params([rtc.RTCRtpEncoding(rid: 'f')]);

      final changed = applyPublishQuality(
        params,
        _sender([_layer('f', active: false)]),
        usesSvcCodec: false,
      );

      expect(changed, isTrue);
      expect(params.encodings!.single.active, isFalse);
    });

    test('activating an encoding alone counts as a change', () {
      final params = _params([rtc.RTCRtpEncoding(rid: 'f', active: false)]);

      final changed = applyPublishQuality(
        params,
        _sender([_layer('f')]),
        usesSvcCodec: false,
      );

      expect(changed, isTrue);
      expect(params.encodings!.single.active, isTrue);
    });

    test('simulcast deactivates an encoding whose rid matches nothing', () {
      final params = _params([
        rtc.RTCRtpEncoding(rid: 'q', maxBitrate: 100),
        rtc.RTCRtpEncoding(rid: 'f'),
      ]);

      applyPublishQuality(
        params,
        _sender([_layer('f')]),
        usesSvcCodec: false,
      );

      expect(params.encodings!.map((e) => e.active), [false, true]);
      expect(params.encodings!.first.maxBitrate, 100);
    });

    test(
      'a single simulcast encoding whose rid matches nothing takes the first '
      'active layer',
      () {
        final params = _params([rtc.RTCRtpEncoding(rid: 'x', active: false)]);

        applyPublishQuality(
          params,
          _sender([_layer('q', active: false), _layer('h', maxBitrate: 700)]),
          usesSvcCodec: false,
        );

        expect(params.encodings!.single.active, isTrue);
        expect(params.encodings!.single.maxBitrate, 700);
      },
    );

    test('SVC applies the first active layer whatever the rid', () {
      final params = _params([rtc.RTCRtpEncoding(rid: 'h')]);

      applyPublishQuality(
        params,
        _sender([
          _layer('q', active: false, maxBitrate: 1),
          _layer('f', maxBitrate: 1500, scalabilityMode: 'L3T3_KEY'),
          _layer('h', maxBitrate: 700),
        ]),
        usesSvcCodec: true,
      );

      final encoding = params.encodings!.single;
      expect(encoding.maxBitrate, 1500);
      expect(encoding.scalabilityMode, 'L3T3_KEY');
    });

    test('SVC deactivates its encoding when every layer is paused', () {
      final params = _params([rtc.RTCRtpEncoding(rid: 'q')]);

      final changed = applyPublishQuality(
        params,
        _sender([_layer('q', active: false), _layer('f', active: false)]),
        usesSvcCodec: true,
      );

      expect(changed, isTrue);
      expect(params.encodings!.single.active, isFalse);
    });

    test('SVC applies the same layer to every encoding', () {
      final params = _params([
        rtc.RTCRtpEncoding(rid: 'q'),
        rtc.RTCRtpEncoding(rid: 'f'),
      ]);

      applyPublishQuality(
        params,
        _sender([_layer('f', maxBitrate: 1500)]),
        usesSvcCodec: true,
      );

      expect(params.encodings!.map((e) => e.maxBitrate), [1500, 1500]);
    });

    group('applies each field only when set and different', () {
      rtc.RTCRtpParameters current() => _params([
        rtc.RTCRtpEncoding(
          rid: 'f',
          maxBitrate: 1000,
          maxFramerate: 30,
          scaleResolutionDownBy: 2,
          scalabilityMode: 'L1T3',
        ),
      ]);

      final cases =
          <
            String,
            (
              SfuVideoLayerSetting,
              Object? Function(rtc.RTCRtpEncoding),
              Object?,
            )
          >{
            'maxBitrate': (
              _layer('f', maxBitrate: 2000),
              (e) => e.maxBitrate,
              2000,
            ),
            'maxFramerate': (
              _layer('f', maxFramerate: 15),
              (e) => e.maxFramerate,
              15,
            ),
            'scaleResolutionDownBy': (
              _layer('f', scaleResolutionDownBy: 1),
              (e) => e.scaleResolutionDownBy,
              1.0,
            ),
            'scalabilityMode': (
              _layer('f', scalabilityMode: 'L1T2'),
              (e) => e.scalabilityMode,
              'L1T2',
            ),
          };

      for (final MapEntry(key: field, value: (layer, read, expected))
          in cases.entries) {
        test(field, () {
          final params = current();

          final changed = applyPublishQuality(
            params,
            _sender([layer]),
            usesSvcCodec: false,
          );

          expect(changed, isTrue);
          expect(read(params.encodings!.single), expected);
        });
      }

      test('unset values leave the encoding alone', () {
        final params = current();

        final changed = applyPublishQuality(
          params,
          _sender([_layer('f', scaleResolutionDownBy: 0.5)]),
          usesSvcCodec: false,
        );

        expect(changed, isFalse);
        expect(params.encodings!.single.scaleResolutionDownBy, 2);
      });

      test('equal values report no change', () {
        final params = current();

        final changed = applyPublishQuality(
          params,
          _sender([
            _layer(
              'f',
              maxBitrate: 1000,
              maxFramerate: 30,
              scaleResolutionDownBy: 2,
              scalabilityMode: 'L1T3',
            ),
          ]),
          usesSvcCodec: false,
        );

        expect(changed, isFalse);
      });
    });

    test(
      'the degradation preference applies only when given and different',
      () {
        final params = _params(
          [rtc.RTCRtpEncoding(rid: 'f')],
          degradationPreference: rtc.RTCDegradationPreference.BALANCED,
        );

        expect(
          applyPublishQuality(
            params,
            _sender([_layer('f')]),
            usesSvcCodec: false,
          ),
          isFalse,
        );
        expect(
          applyPublishQuality(
            params,
            _sender(
              [_layer('f')],
              degradationPreference: rtc.RTCDegradationPreference.BALANCED,
            ),
            usesSvcCodec: false,
          ),
          isFalse,
        );
        expect(
          applyPublishQuality(
            params,
            _sender(
              [_layer('f')],
              degradationPreference:
                  rtc.RTCDegradationPreference.MAINTAIN_RESOLUTION,
            ),
            usesSvcCodec: false,
          ),
          isTrue,
        );
        expect(
          params.degradationPreference,
          rtc.RTCDegradationPreference.MAINTAIN_RESOLUTION,
        );
      },
    );
  });

  group('applyAudioBitrate', () {
    test('sets the first encoding to the target bitrate', () {
      final params = _params([
        rtc.RTCRtpEncoding(maxBitrate: 64000),
        rtc.RTCRtpEncoding(maxBitrate: 1),
      ]);

      final apply = applyAudioBitrate(params, [
        rtc.RTCRtpEncoding(maxBitrate: 128000),
      ]);

      expect(apply, isTrue);
      expect(params.encodings!.map((e) => e.maxBitrate), [128000, 1]);
    });

    test('still asks to apply an unchanged bitrate', () {
      final params = _params([rtc.RTCRtpEncoding(maxBitrate: 64000)]);

      expect(
        applyAudioBitrate(params, [rtc.RTCRtpEncoding(maxBitrate: 64000)]),
        isTrue,
      );
    });

    test('does nothing without a target encoding', () {
      final params = _params([rtc.RTCRtpEncoding(maxBitrate: 64000)]);

      expect(applyAudioBitrate(params, const []), isFalse);
      expect(params.encodings!.single.maxBitrate, 64000);
    });

    test('does nothing when the sender has no encodings', () {
      expect(
        applyAudioBitrate(_params([]), [rtc.RTCRtpEncoding(maxBitrate: 1)]),
        isFalse,
      );
      expect(
        applyAudioBitrate(rtc.RTCRtpParameters(), [
          rtc.RTCRtpEncoding(maxBitrate: 1),
        ]),
        isFalse,
      );
    });
  });

  group('ridToVideoQuality', () {
    test('maps the simulcast rids', () {
      expect(ridToVideoQuality('q'), RtcVideoQuality.lowUnspecified);
      expect(ridToVideoQuality('h'), RtcVideoQuality.mid);
      expect(ridToVideoQuality('f'), RtcVideoQuality.high);
      expect(ridToVideoQuality(''), RtcVideoQuality.high);
    });
  });
}
