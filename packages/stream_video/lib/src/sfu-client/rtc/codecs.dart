import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/types/video_dimensions.dart';
import 'package:stream_video/src/types/video_encoding.dart';
import 'package:stream_video/src/types/video_parameters.dart';

/// Returns a generic sdp for the given [direction].
Future<String> getGenericSdp({
  required rtc.TransceiverDirection direction,
}) async {
  final tempPc = await rtc.createPeerConnection({});

  // Add 'audio' transceiver
  final audioTransceiver = await tempPc.addTransceiver(
    kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
    init: rtc.RTCRtpTransceiverInit(direction: direction),
  );

  // Add 'video' transceiver
  final videoTransceiver = await tempPc.addTransceiver(
    kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
    init: rtc.RTCRtpTransceiverInit(direction: direction),
  );

  final offer = await tempPc.createOffer();
  final sdp = offer.sdp;

  // await audioTransceiver.stop();
  // await videoTransceiver.stop();
  await tempPc.close();

  return sdp!;
}

/// order of rids
final videoRids = ['q', 'h', 'f'];

List<VideoParameters> _presetsForDimensions({
  required bool isScreenShare,
  required VideoDimension dimensions,
}) {
  if (isScreenShare) {
    return VideoParametersPresets.allScreenShare;
  }

  final a = dimensions.aspect();
  if ((a - VideoDimensionHelpers.aspect169).abs() <
      (a - VideoDimensionHelpers.aspect43).abs()) {
    return VideoParametersPresets.all169;
  }

  return VideoParametersPresets.all43;
}

List<VideoParameters> _computeDefaultScreenShareSimulcastParams({
  required VideoParameters original,
}) {
  final layers = [
    rtc.RTCRtpEncoding(scaleResolutionDownBy: 2, maxFramerate: 3),
  ];
  return layers.map((e) {
    final scale = e.scaleResolutionDownBy ?? 1;
    final fps = e.maxFramerate ?? 3;

    return VideoParameters(
      dimensions: VideoDimension(
        (original.dimensions.width / scale).floor(),
        (original.dimensions.height / scale).floor(),
      ),
      encoding: VideoEncoding(
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

List<VideoParameters> _computeDefaultSimulcastParams({
  required bool isScreenShare,
  required VideoParameters original,
}) {
  if (isScreenShare) {
    return _computeDefaultScreenShareSimulcastParams(original: original);
  }
  final a = original.dimensions.aspect();
  if ((a - VideoDimensionHelpers.aspect169).abs() <
      (a - VideoDimensionHelpers.aspect43).abs()) {
    return VideoParametersPresets.defaultSimulcast169;
  }

  return VideoParametersPresets.defaultSimulcast43;
}

VideoEncoding _findAppropriateEncoding({
  required bool isScreenShare,
  required VideoDimension dimensions,
  required List<VideoParameters> presets,
}) {
  assert(presets.isNotEmpty, 'presets should not be empty');
  var result = presets.first.encoding;

  // handle portrait by swapping dimensions
  final size = dimensions.max();

  for (final preset in presets) {
    result = preset.encoding;
    if (preset.dimensions.width >= size) break;
  }

  return result;
}

List<rtc.RTCRtpEncoding> encodingsFromPresets(
  VideoDimension dimensions, {
  required List<VideoParameters> presets,
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
      scaleResolutionDownBy: math.max(1, size / e.dimensions.min()),
    ));
  });
  return result;
}

double findEvenScaleDownBy(
  VideoDimension sourceDimensions,
  VideoDimension targetDimensions,
) {
  final sourceSize = sourceDimensions.max();
  final targetSize = targetDimensions.max();

  for (var i = 0; i <= 30; i++) {
    final scaleDownBy = sourceSize.toDouble() / (targetSize + i);
    // Internally, WebRTC casts directly to int without rounding.
    // https://github.com/webrtc-sdk/webrtc/blob/8c7139f8e6fa19ddf2c91510c177a19746e1ded3/media/engine/webrtc_video_engine.cc#L3676
    final scaledWidth = sourceDimensions.width ~/ scaleDownBy;
    final scaledHeight = sourceDimensions.height ~/ scaleDownBy;

    if (scaledWidth.isEven && scaledHeight.isEven) {
      return scaleDownBy;
    }
  }

  // couldn't find an even scale, just return original scale and hope it works.
  return sourceSize / targetSize;
}

List<rtc.RTCRtpEncoding>? computeVideoEncodings({
  required bool isScreenShare,
  VideoDimension? dimensions,
  VideoPublishOptions? options,
}) {
  options ??= const VideoPublishOptions();

  var videoEncoding = options.videoEncoding;

  if ((videoEncoding == null && !options.simulcast) || dimensions == null) {
    // don't set encoding when we are not simulcasting and user isn't
    // restricting encoding parameters.
    return [rtc.RTCRtpEncoding()];
  }

  final presets = _presetsForDimensions(
    isScreenShare: isScreenShare,
    dimensions: dimensions,
  );

  videoEncoding ??= _findAppropriateEncoding(
    isScreenShare: isScreenShare,
    dimensions: dimensions,
    presets: presets,
  );

  if (!options.simulcast) {
    // not using simulcast
    return [videoEncoding.toRTCRtpEncoding()];
  }

  final original = VideoParameters(
    dimensions: dimensions,
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
  VideoParameters? midPreset;
  if (params.length > 1) {
    midPreset = params[1];
  }

  final size = dimensions.max();
  var computedParams = <VideoParameters>[original];

  if (size >= 960 && midPreset != null) {
    computedParams = [lowPreset, midPreset, original];
  } else if (size >= 480) {
    computedParams = [lowPreset, original];
  }

  return encodingsFromPresets(
    dimensions,
    presets: computedParams,
  );
}

List<sfu_models.VideoLayer> computeVideoLayers(
  VideoDimension dimensions,
  List<rtc.RTCRtpEncoding>? encodings,
) {
  // default to a single layer, HQ
  if (encodings == null) {
    return [
      sfu_models.VideoLayer(
        rid: 'f',
        bitrate: 0,
        videoDimension: sfu_models.VideoDimension(
          width: dimensions.width,
          height: dimensions.height,
        ),
      ),
    ];
  }

  return encodings.map((e) {
    final scale = e.scaleResolutionDownBy ?? 1;
    return sfu_models.VideoLayer(
      rid: e.rid ?? 'f',
      bitrate: e.maxBitrate ?? 0,
      videoDimension: sfu_models.VideoDimension(
        width: (dimensions.width / scale).floor(),
        height: (dimensions.height / scale).floor(),
      ),
    );
  }).toList();
}
