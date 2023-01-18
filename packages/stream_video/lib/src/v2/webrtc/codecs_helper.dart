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
  var videoEncoding = options.videoEncoding;

  if ((videoEncoding == null && !options.simulcast) || dimension == null) {
    // don't set encoding when we are not simulcasting and user isn't
    // restricting encoding parameters.
    return [rtc.RTCRtpEncoding()];
  }

  final presets = _presetsForDimensions(
    isScreenShare: isScreenShare,
    dimensions: dimension,
  );

  videoEncoding ??= _findAppropriateEncoding(
    isScreenShare: isScreenShare,
    dimensions: dimension,
    presets: presets,
  );

  if (!options.simulcast) {
    // not using simulcast
    return [videoEncoding.toRTCRtpEncoding()];
  }

  final original = RtcVideoParameters(
    dimension: dimension,
    encoding: videoEncoding,
  );

  final userParams = isScreenShare
      ? options.screenShareSimulcastLayers
      : options.videoSimulcastLayers;

  final params = (userParams.isNotEmpty
          ? userParams
          : _computeDefaultSimulcastParams(
              isScreenShare: isScreenShare,
              original: original,
            ))
      .sorted();

  final lowPreset = params.first;
  RtcVideoParameters? midPreset;
  if (params.length > 1) {
    midPreset = params[1];
  }

  final size = dimension.max();
  var computedParams = <RtcVideoParameters>[original];

  if (size >= 960 && midPreset != null) {
    computedParams = [lowPreset, midPreset, original];
  } else if (size >= 480) {
    computedParams = [lowPreset, original];
  }

  return _encodingsFromPresets(
    dimension,
    presets: computedParams,
  );
}

List<RtcVideoParameters> _presetsForDimensions({
  required bool isScreenShare,
  required RtcVideoDimension dimensions,
}) {
  if (isScreenShare) {
    return RtcVideoParametersPresets.allScreenShare;
  }

  final a = dimensions.aspect();
  if ((a - RtcVideoDimensionHelpers.aspect169).abs() <
      (a - RtcVideoDimensionHelpers.aspect43).abs()) {
    return RtcVideoParametersPresets.all169;
  }

  return RtcVideoParametersPresets.all43;
}

RtcVideoEncoding _findAppropriateEncoding({
  required bool isScreenShare,
  required RtcVideoDimension dimensions,
  required List<RtcVideoParameters> presets,
}) {
  assert(presets.isNotEmpty, 'presets should not be empty');
  var result = presets.first.encoding;

  // handle portrait by swapping dimensions
  final size = dimensions.max();

  for (final preset in presets) {
    result = preset.encoding;
    if (preset.dimension.width >= size) break;
  }

  return result;
}

List<RtcVideoParameters> _computeDefaultSimulcastParams({
  required bool isScreenShare,
  required RtcVideoParameters original,
}) {
  if (isScreenShare) {
    return _computeDefaultScreenShareSimulcastParams(original: original);
  }
  final a = original.dimension.aspect();
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

List<RtcVideoParameters> _computeDefaultScreenShareSimulcastParams({
  required RtcVideoParameters original,
}) {
  final layers = [
    rtc.RTCRtpEncoding(scaleResolutionDownBy: 2, maxFramerate: 3),
  ];
  return layers.map((e) {
    final scale = e.scaleResolutionDownBy ?? 1;
    final fps = e.maxFramerate ?? 3;

    return RtcVideoParameters(
      dimension: RtcVideoDimension(
        width: (original.dimension.width / scale).floor(),
        height: (original.dimension.height / scale).floor(),
      ),
      encoding: RtcVideoEncoding(
        maxBitrate: math.max(
          150 * 1000,
          (original.encoding.maxBitrate /
                  (math.pow(scale, 2) * (original.encoding.maxFramerate / fps)))
              .floor(),
        ),
        maxFramerate: fps,
      ),
    );
  }).toList();
}
