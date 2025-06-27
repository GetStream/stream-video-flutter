// import 'dart:math' as math;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../sfu/data/models/sfu_publish_options.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_parameters.dart';

class RTCRtpEncodingWithDimensions extends rtc.RTCRtpEncoding {
  RTCRtpEncodingWithDimensions({
    required this.width,
    required this.height,
    super.rid,
    super.active,
    super.maxBitrate,
    super.maxFramerate,
    super.minBitrate,
    super.numTemporalLayers,
    super.scaleResolutionDownBy,
    super.ssrc,
    super.scalabilityMode,
  });

  final double width;
  final double height;
}

List<RTCRtpEncodingWithDimensions> findOptimalVideoLayers({
  required RtcVideoDimension dimensions,
  required SfuPublishOptions publishOptions,
}) {
  final optimalVideoLayers = <RTCRtpEncodingWithDimensions>[];
  const defaultVideoPreset = RtcVideoParametersPresets.h720_16x9;

  final maxBitrate = getComputedMaxBitrate(
    publishOptions.videoDimension ?? defaultVideoPreset.dimension,
    publishOptions.bitrate ?? defaultVideoPreset.encoding.maxBitrate,
    dimensions.width,
    dimensions.height,
  );

  final svcCodec = isSvcCodec(publishOptions.codec.name);
  final maxSpatialLayers = publishOptions.maxSpatialLayers ?? 3;
  final maxTemporalLayers = publishOptions.maxTemporalLayers ?? 3;

  var downscaleFactor = 1;
  var bitrateFactor = 1;

  final rids = ['f', 'h', 'q'].sublist(0, maxSpatialLayers);
  for (final rid in rids) {
    final layer = RTCRtpEncodingWithDimensions(
      rid: rid,
      maxBitrate: (maxBitrate / bitrateFactor).round(),
      maxFramerate: publishOptions.fps,
      width: dimensions.width / downscaleFactor,
      height: dimensions.height / downscaleFactor,
    );

    if (svcCodec) {
      // for SVC codecs, we need to set the scalability mode, and the
      // codec will handle the rest (layers, temporal layers, etc.)
      layer.scalabilityMode = toScalabilityMode(
        publishOptions.useSingleLayer ? 1 : maxSpatialLayers,
        maxTemporalLayers,
      );
    } else {
      // for non-SVC codecs, we need to downscale proportionally (simulcast)
      layer.scaleResolutionDownBy = downscaleFactor.toDouble();
    }

    downscaleFactor *= 2;
    bitrateFactor *= 2;

    // Reversing the order [f, h, q] to [q, h, f] as Chrome uses encoding index
    // when deciding which layer to disable when CPU or bandwidth is constrained.
    // Encodings should be ordered in increasing spatial resolution order.
    optimalVideoLayers.insert(0, layer);
  }

  return withSimulcastConstraints(
    dimensions: dimensions,
    optimalVideoLayers: optimalVideoLayers,
    useSingleLayer: publishOptions.useSingleLayer,
  );
}

int getComputedMaxBitrate(
  RtcVideoDimension videoDimension,
  int maxBitrate,
  int currentWidth,
  int currentHeight,
) {
  // if the current resolution is lower than the target resolution,
  // we want to proportionally reduce the target bitrate
  final targetWidth = videoDimension.width;
  final targetHeight = videoDimension.height;

  if (currentWidth < targetWidth || currentHeight < targetHeight) {
    final currentPixels = currentWidth * currentHeight;
    final targetPixels = targetWidth * targetHeight;
    final reductionFactor = currentPixels / targetPixels;

    return (maxBitrate * reductionFactor).round();
  }

  return maxBitrate;
}

List<RTCRtpEncodingWithDimensions> withSimulcastConstraints({
  required RtcVideoDimension dimensions,
  required List<RTCRtpEncodingWithDimensions> optimalVideoLayers,
  required bool useSingleLayer,
}) {
  var layers = <RTCRtpEncodingWithDimensions>[];

  final size = max(dimensions.width, dimensions.height);
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
        (index, layer) => RTCRtpEncodingWithDimensions(
          rid: ridMapping[index],
          scaleResolutionDownBy: layer.scaleResolutionDownBy,
          scalabilityMode: layer.scalabilityMode,
          maxFramerate: layer.maxFramerate,
          maxBitrate: layer.maxBitrate,
          minBitrate: layer.minBitrate,
          numTemporalLayers: layer.numTemporalLayers,
          ssrc: layer.ssrc,
          width: layer.width,
          height: layer.height,
          active:
              layer.active && !(useSingleLayer && index < layers.length - 1),
        ),
      )
      .toList();
}

List<rtc.RTCRtpEncoding> findOptimalScreenSharingLayers({
  required RtcVideoDimension dimensions,
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

bool isSvcCodec(String? codecOrMimeType) {
  if (codecOrMimeType == null) return false;
  final lowerCaseCodec = codecOrMimeType.toLowerCase();
  return lowerCaseCodec == 'vp9' ||
      lowerCaseCodec == 'av1' ||
      lowerCaseCodec == 'video/vp9' ||
      lowerCaseCodec == 'video/av1';
}

String toScalabilityMode(int spatialLayers, int temporalLayers) =>
    'L${spatialLayers}T$temporalLayers${spatialLayers > 1 ? '_KEY' : ''}';
