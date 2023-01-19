import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import 'model/rtc_tracks_info.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_encoding.dart';
import 'model/rtc_video_parameters.dart';
import 'rtc_track_publish_options.dart';

/// order of rids
final videoRids = ['q', 'h', 'f'];

List<rtc.RTCRtpEncoding> computeVideoEncodings({
  required bool isScreenShare,
  RtcVideoDimension? dimension,
  VideoTrackPublishOptions options = const VideoTrackPublishOptions(),
}) {
  final videoEncoding = options.videoEncoding;

  if ((videoEncoding == null && !options.simulcast) || dimension == null) {
    // don't set encoding when we are not simulcasting and user isn't
    // restricting encoding parameters.
    return [rtc.RTCRtpEncoding()];
  }

  final presets = _presetsForDimension(
    isScreenShare: isScreenShare,
    dimension: dimension,
  );

  return _encodingsFromPresets(dimension, presets: presets);
}

List<RtcVideoParameters> _presetsForDimension({
  required bool isScreenShare,
  required RtcVideoDimension dimension,
}) {
  if (isScreenShare) {
    return RtcVideoParametersPresets.defaultSimulcastScreenShare;
  }

  final a = dimension.aspect();
  if ((a - RtcVideoDimensionHelpers.aspect169).abs() <
      (a - RtcVideoDimensionHelpers.aspect43).abs()) {
    return RtcVideoParametersPresets.defaultSimulcast169;
  }

  return RtcVideoParametersPresets.defaultSimulcast43;
}

List<rtc.RTCRtpEncoding> _encodingsFromPresets(
  RtcVideoDimension dimensions, {
  required List<RtcVideoParameters> presets,
}) {
  final result = <rtc.RTCRtpEncoding>[];
  presets.forEachIndexed((i, e) {
    if (i >= videoRids.length) {
      return;
    }
    final size = dimensions.min();
    final rid = videoRids[i];

    result.add(e.encoding.toRTCRtpEncoding(
      rid: rid,
      scaleResolutionDownBy: math.max(1, size / e.dimension.min()),
    ));
  });
  return result;
}
