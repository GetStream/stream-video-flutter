// import 'dart:math' as math;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_parameters.dart';

List<rtc.RTCRtpEncoding> findOptimalVideoLayers({
  required RtcVideoDimension dimentions,
  RtcVideoParameters targetResolution = RtcVideoParametersPresets.h720_16x9,
}) {
  final optimalVideoLayers = <rtc.RTCRtpEncoding>[];

  final maxBitrate = getComputedMaxBitrate(
    targetResolution,
    dimentions.width,
    dimentions.height,
  );

  var downscaleFactor = 1;
  for (final rid in ['f', 'h', 'q'].reversed) {
    optimalVideoLayers.insert(
      0,
      rtc.RTCRtpEncoding(
        rid: rid,
        scaleResolutionDownBy: downscaleFactor.toDouble(),
        maxFramerate: 30,
        maxBitrate: (maxBitrate / downscaleFactor).round(),
      ),
    );

    downscaleFactor *= 2;
  }

  return withSimulcastConstraints(
    dimentions: dimentions,
    optimalVideoLayers: optimalVideoLayers,
  );
}

int getComputedMaxBitrate(
  RtcVideoParameters targetResolution,
  int currentWidth,
  int currentHeight,
) {
  // if the current resolution is lower than the target resolution,
  // we want to proportionally reduce the target bitrate
  final targetWidth = targetResolution.dimension.width;
  final targetHeight = targetResolution.dimension.height;

  if (currentWidth < targetWidth || currentHeight < targetHeight) {
    final currentPixels = currentWidth * currentHeight;
    final targetPixels = targetWidth * targetHeight;
    final reductionFactor = currentPixels / targetPixels;

    return (targetResolution.encoding.maxBitrate * reductionFactor).round();
  }

  return targetResolution.encoding.maxBitrate;
}

List<rtc.RTCRtpEncoding> withSimulcastConstraints({
  required RtcVideoDimension dimentions,
  required List<rtc.RTCRtpEncoding> optimalVideoLayers,
}) {
  var layers = <rtc.RTCRtpEncoding>[];

  final size = max(dimentions.width, dimentions.height);
  if (size <= 320) {
    // provide only one layer 320x240 (q), the one with the highest quality
    layers = optimalVideoLayers.where((layer) => layer.rid == 'f').toList();
  } else if (size <= 640) {
    // provide two layers, 160x120 (q) and 640x480 (h)
    layers = optimalVideoLayers.where((layer) => layer.rid != 'h').toList();
  } else {
    // provide three layers for sizes > 640x480
    layers = optimalVideoLayers;
  }

  final ridMapping = ['q', 'h', 'f'];
  return layers
      .mapIndexed(
        (index, layer) => rtc.RTCRtpEncoding(
          rid: ridMapping[index],
          scaleResolutionDownBy: layer.scaleResolutionDownBy,
          maxFramerate: layer.maxFramerate,
          maxBitrate: layer.maxBitrate,
        ),
      )
      .toList();
}

List<rtc.RTCRtpEncoding> findOptimalScreenSharingLayers({
  required RtcVideoDimension dimentions,
  RtcVideoParameters targetResolution = RtcVideoParametersPresets.h1080_16x9,
}) {
  final optimalVideoLayers = <rtc.RTCRtpEncoding>[];

  for (final rid in ['f', 'h', 'q'].reversed) {
    optimalVideoLayers.insert(
      0,
      rtc.RTCRtpEncoding(
        rid: rid,
        maxFramerate: targetResolution.encoding.maxFramerate,
        maxBitrate: targetResolution.encoding.maxBitrate,
      ),
    );
  }

  return optimalVideoLayers;
}
