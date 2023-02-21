import 'dart:math' as math;

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../logger/stream_log.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_parameters.dart';

// 16:9 default
const _defaultSimulcast_16x9 = {
  'f': RtcVideoParametersPresets.h720_16x9,
  'h': RtcVideoParametersPresets.h360_16x9,
  'q': RtcVideoParametersPresets.h180_16x9,
};

// 4:3 default
const _defaultSimulcast_4x3 = {
  'f': RtcVideoParametersPresets.h720_4x3,
  'h': RtcVideoParametersPresets.h360_4x3,
  'q': RtcVideoParametersPresets.h180_4x3,
};

List<rtc.RTCRtpEncoding> computeVideoEncodings({
  required RtcVideoDimension dimension,
  required bool isScreenShare,
}) {
  final presets = _presetsForDimension(
    isScreenShare: isScreenShare,
    dimension: dimension,
  );
  presets.forEach((rid, preset) {
    streamLog.v(
      'SV:RtcManager',
      () => '[publishVideoTrack] #$rid; preset: $preset',
    );
  });

  return _encodingsFromPresets(dimension, presets: presets);
}

Map<String, RtcVideoParameters> _presetsForDimension({
  required bool isScreenShare,
  required RtcVideoDimension dimension,
}) {
  if (isScreenShare) {
    return _defaultSimulcast_16x9;
  }

  final aspectRatio = dimension.aspect();
  streamLog.v(
    'SV:RtcManager',
    () => '[publishVideoTrack] aspectRatio: $aspectRatio',
  );
  if (_is16x9ratio(aspectRatio)) {
    streamLog.v(
      'SV:RtcManager',
      () => '[publishVideoTrack] defaultSimulcast_16x9',
    );
    return _defaultSimulcast_16x9;
  }
  streamLog.v(
    'SV:RtcManager',
    () => '[publishVideoTrack] defaultSimulcast_4x3',
  );
  return _defaultSimulcast_4x3;
}

List<rtc.RTCRtpEncoding> _encodingsFromPresets(
  RtcVideoDimension dimension, {
  required Map<String, RtcVideoParameters> presets,
}) {
  final result = <rtc.RTCRtpEncoding>[];

  presets.forEach((rid, preset) {
    final double scaleResolutionDownBy =
        math.max(1, dimension.min() / preset.dimension.min());
    streamLog.v(
      'SV:RtcManager',
      () => '[publishVideoTrack] #$rid; scaleResolutionDownBy: '
          '$scaleResolutionDownBy',
    );
    result.add(
      rtc.RTCRtpEncoding(
        rid: rid,
        scaleResolutionDownBy: scaleResolutionDownBy,
        maxFramerate: preset.encoding.maxFramerate,
        maxBitrate: preset.encoding.maxBitrate,
      ),
    );
  });
  return result;
}

bool _is16x9ratio(double aspectRatio) {
  return (aspectRatio - RtcVideoDimensionHelpers.aspect_16x9).abs() <
      (aspectRatio - RtcVideoDimensionHelpers.aspect_4x3).abs();
}
