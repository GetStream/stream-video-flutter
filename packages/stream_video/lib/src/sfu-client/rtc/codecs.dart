import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart' as sfu;
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/sdp-transform/parse.dart';
import 'package:stream_video/src/types/video_dimensions.dart';
import 'package:stream_video/src/types/video_encoding.dart';
import 'package:stream_video/src/types/video_parameters.dart';

final defaultVideoPublishEncodings = [
  rtc.RTCRtpEncoding(
    rid: 'f',
    active: true,
    maxBitrate: 1200000,
  ),
  rtc.RTCRtpEncoding(
    rid: 'h',
    active: true,
    scaleResolutionDownBy: 2,
    maxBitrate: 500000,
  ),
  rtc.RTCRtpEncoding(
    rid: 'q',
    active: true,
    scaleResolutionDownBy: 4,
    maxBitrate: 125000,
  ),
];

Future<List<sfu.Codec>> getSenderCodecs(
  rtc.RTCRtpMediaType kind, [
  rtc.RTCPeerConnection? pc,
]) {
  return _getCodecsFromPeerConnection(
    kind,
    pc,
    rtc.TransceiverDirection.SendOnly,
  );
}

Future<List<sfu.Codec>> getReceiverCodecs(
  rtc.RTCRtpMediaType kind, [
  rtc.RTCPeerConnection? pc,
]) {
  return _getCodecsFromPeerConnection(
    kind,
    pc,
    rtc.TransceiverDirection.RecvOnly,
  );
}

Future<List<sfu.Codec>> _getCodecsFromPeerConnection(
  rtc.RTCRtpMediaType kind,
  rtc.RTCPeerConnection? pc,
  rtc.TransceiverDirection direction,
) async {
  var sdp = direction == rtc.TransceiverDirection.SendOnly
      ? (await pc?.getLocalDescription())?.sdp
      : direction == rtc.TransceiverDirection.RecvOnly
          ? (await pc?.getRemoteDescription())?.sdp
          : null;

  if (sdp == null) {
    final tempPc = await rtc.createPeerConnection({});
    final transceiver = await tempPc.addTransceiver(kind: kind);
    await transceiver.setDirection(direction);
    final offer = await tempPc.createOffer();
    sdp = offer.sdp;
    await tempPc.close();
  }

  final parsedSdp = parseSdp(sdp!);
  final supportedCodecs = <sfu.Codec>[];
  parsedSdp.media.forEach((media) {
    if (media.type == rtc.typeRTCRtpMediaTypetoString[kind]) {
      media.rtp.forEach((rtp) {
        final fmtpLine =
            media.fmtp?.firstWhereOrNull((f) => f.payload == rtp.payload);
        supportedCodecs.add(sfu.Codec(
          hwAccelerated: true,
          clockRate: rtp.rate ?? 0,
          fmtpLine: fmtpLine?.config ?? '',
          mime: '$kind/${rtp.codec}',
        ));
      });
    }
  });

  return supportedCodecs;
}

/// order of rids
final videoRids = ['q', 'h', 'f'];

List<VideoParameters> _presetsForDimensions({
  required bool isScreenShare,
  required VideoDimensions dimensions,
}) {
  if (isScreenShare) {
    return VideoParametersPresets.allScreenShare;
  }

  final a = dimensions.aspect();
  if ((a - VideoDimensionsHelpers.aspect169).abs() <
      (a - VideoDimensionsHelpers.aspect43).abs()) {
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
      dimensions: VideoDimensions(
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
  if ((a - VideoDimensionsHelpers.aspect169).abs() <
      (a - VideoDimensionsHelpers.aspect43).abs()) {
    return VideoParametersPresets.defaultSimulcast169;
  }

  return VideoParametersPresets.defaultSimulcast43;
}

VideoEncoding _findAppropriateEncoding({
  required bool isScreenShare,
  required VideoDimensions dimensions,
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
  VideoDimensions dimensions, {
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
  VideoDimensions sourceDimensions,
  VideoDimensions targetDimensions,
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
  VideoDimensions? dimensions,
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

List<sfu.VideoLayer> computeVideoLayers(
  VideoDimensions dimensions,
  List<rtc.RTCRtpEncoding>? encodings,
) {
  // default to a single layer, HQ
  if (encodings == null) {
    return [
      sfu.VideoLayer(
        rid: 'f',
        bitrate: 0,
        videoDimension: sfu.VideoDimension(
          width: dimensions.width,
          height: dimensions.height,
        ),
      ),
    ];
  }

  return encodings.map((e) {
    final scale = e.scaleResolutionDownBy ?? 1;
    return sfu.VideoLayer(
      rid: e.rid ?? 'f',
      bitrate: e.maxBitrate ?? 0,
      videoDimension: sfu.VideoDimension(
        width: (dimensions.width / scale).floor(),
        height: (dimensions.height / scale).floor(),
      ),
    );
  }).toList();
}
