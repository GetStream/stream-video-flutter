// import 'dart:math' as math;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../sfu/data/models/sfu_audio_bitrate.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import 'model/rtc_audio_bitrate_preset.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_parameters.dart';
import 'rtc_track/rtc_track_publish_options.dart';

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

/// The bitrate a layer falls back to when the publish option gives none, as
/// in the JS and Android SDKs.
const defaultBitratePerRid = {'q': 300000, 'h': 750000, 'f': 1250000};

/// Determines the most optimal video layers for the given track.
List<RTCRtpEncodingWithDimensions> findOptimalVideoLayers({
  required RtcVideoDimension dimensions,
  required SfuPublishOptions publishOptions,
}) {
  final optimalVideoLayers = <RTCRtpEncodingWithDimensions>[];
  const defaultVideoPreset = RtcVideoParametersPresets.h720_16x9;

  // The SFU's protobuf decodes an unset dimension as 0x0, so an empty one is
  // as absent as a null one. JS and Android fall back to 1280x720 for it too.
  final targetDimension = publishOptions.videoDimension;
  final maxBitrate = getComputedMaxBitrate(
    targetDimension == null || targetDimension.isEmpty
        ? defaultVideoPreset.dimension
        : targetDimension,
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
    // An unset bitrate decodes as 0 and a tiny capture can round down to 0;
    // neither must reach the encoder as a 0 bps bound. JS and Android fall
    // back to a per-layer default in that case.
    final layerBitrate = (maxBitrate / bitrateFactor).round();
    final layer = RTCRtpEncodingWithDimensions(
      rid: rid,
      maxBitrate: layerBitrate > 0 ? layerBitrate : defaultBitratePerRid[rid],
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
  // we want to proportionally reduce the target bitrate.
  // The target is compared in the capture's orientation: the publish option
  // target is landscape, so a portrait capture would otherwise read its short
  // side as below the target and scale the bitrate up instead.
  final target = videoDimension.orientedLike(
    RtcVideoDimension(width: currentWidth, height: currentHeight),
  );
  final targetWidth = target.width;
  final targetHeight = target.height;

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
    // provide two layers, 320x240 (h) and 640x480 (f)
    layers = optimalVideoLayers.where((layer) => layer.rid != 'q').toList();
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

/// In SVC, only one video encoding (layer) is sent: the highest-quality one,
/// renamed to `q`. The codec handles the spatial and temporal layers through
/// its `scalabilityMode`. Mirrors `toSvcEncodings` in the JS and Android SDKs,
/// which also keep the `f` layer's bitrate, frame rate and scalability mode.
List<rtc.RTCRtpEncoding> toSvcEncodings(List<rtc.RTCRtpEncoding> layers) {
  rtc.RTCRtpEncoding? findByRid(String rid) =>
      layers.firstWhereOrNull((layer) => layer.rid == rid);

  final highestLayer = findByRid('f') ?? findByRid('h') ?? findByRid('q');
  if (highestLayer == null) return [];

  return [
    rtc.RTCRtpEncoding(
      rid: 'q',
      active: highestLayer.active,
      maxBitrate: highestLayer.maxBitrate,
      maxFramerate: highestLayer.maxFramerate,
      minBitrate: highestLayer.minBitrate,
      numTemporalLayers: highestLayer.numTemporalLayers,
      scaleResolutionDownBy: highestLayer.scaleResolutionDownBy,
      ssrc: highestLayer.ssrc,
      scalabilityMode: highestLayer.scalabilityMode,
    ),
  ];
}

/// One encoding on a log line, with the fields the SFU and the encoder act on.
String describeEncoding(rtc.RTCRtpEncoding encoding) =>
    '${encoding.rid ?? '-'}('
    'active: ${encoding.active}, '
    'maxBitrate: ${encoding.maxBitrate}, '
    'maxFramerate: ${encoding.maxFramerate}, '
    'scaleResolutionDownBy: ${encoding.scaleResolutionDownBy}, '
    'scalabilityMode: ${encoding.scalabilityMode})';

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

/// Prepares the audio layer for the given track.
/// Based on the provided audio bitrate profile, we apply the appropriate bitrate.
List<rtc.RTCRtpEncoding> findOptimalAudioLayers({
  required SfuPublishOptions publishOptions,
  required RtcTrackPublishOptions trackPublishOptions,
}) {
  final profileConfig = publishOptions.audioBitrateProfiles?.firstWhereOrNull(
    (config) => config.profile == trackPublishOptions.audioBitrateProfile,
  );
  final maxBitrate =
      profileConfig?.bitrate ??
      {
        SfuAudioBitrateProfile.voiceStandard: AudioBitrate.voiceStandard,
        SfuAudioBitrateProfile.voiceHighQuality: AudioBitrate.voiceHighQuality,
        SfuAudioBitrateProfile.musicHighQuality: AudioBitrate.musicHighQuality,
      }[trackPublishOptions.audioBitrateProfile];

  return [rtc.RTCRtpEncoding(maxBitrate: maxBitrate)];
}
