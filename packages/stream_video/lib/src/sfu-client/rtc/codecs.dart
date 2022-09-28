import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_models/models.pb.dart';
// import 'package:stream_video/protobuf/video/coordinator/broadcast_v1/broadcast.pbenum.dart';
import 'package:stream_video/src/sdp-transform/parse.dart';

extension RTCRtpMediaTypeX on RTCRtpMediaType {
  String toStr() {
    switch (this) {
      case RTCRtpMediaType.RTCRtpMediaTypeAudio:
        return 'audio';
      case RTCRtpMediaType.RTCRtpMediaTypeVideo:
        return 'video';
      default:
        return 'data';
    }
  }
}

class OptimalVideoLayer {
  final RTCRtpEncoding encoding;
  final int width;
  final int height;
  OptimalVideoLayer({
    required this.width,
    required this.height,
    required this.encoding,
  });
}

Future<List<Codec>> getSenderCodecs(
  RTCRtpMediaType kind,
  RTCPeerConnection pc,
) async {
  return _getCodecsFromPeerConnection(kind, pc, TransceiverDirection.SendOnly);
}

Future<List<Codec>> getReceiverCodecs(
  RTCRtpMediaType kind,
  RTCPeerConnection pc,
) async {
  return _getCodecsFromPeerConnection(kind, pc, TransceiverDirection.RecvOnly);
}

Future<List<Codec>> _getCodecsFromPeerConnection(
  RTCRtpMediaType kind,
  RTCPeerConnection pc,
  TransceiverDirection direction,
) async {
  var sdp = direction == TransceiverDirection.SendOnly
      ? (await pc.getLocalDescription())?.sdp
      : direction == TransceiverDirection.RecvOnly
          ? (await pc.getRemoteDescription())?.sdp
          : null;
  if (sdp == null) {
    final tempPc = await createPeerConnection({});
    final transceiver = await tempPc.addTransceiver(kind: kind);
    transceiver.setDirection(direction);
    final offer = await tempPc.createOffer();
    sdp = offer.sdp;
    tempPc.close();
  }
  final parsedSdp = parseSdp(sdp!);
  final supportedCodecs = <Codec>[];
  parsedSdp.media.forEach((media) {
    if (media.type == kind.toStr()) {
      media.rtp.forEach((rtp) {
        final fmtpLine =
            media.fmtp?.firstWhere((f) => f.payload == rtp.payload);
        supportedCodecs.add(Codec(
          hwAccelerated: true,
          clockRate: rtp.rate ?? 0,
          fmtpLine: fmtpLine?.config ?? '',
          mime: '${kind}/${rtp.codec}',
        ));
      });
    }
  });
  return supportedCodecs;
}

List<OptimalVideoLayer> findOptimalVideoLayers(MediaStream mediaStream) {
  final steps = [
    // [4096, 2160], // 4K
    // [1920, 1080, 3_072_000], // Full-HD
    [1280, 720, 1536000], // HD
    [640, 480, 768000], // VGA
    [320, 240, 384000], // QVGA
    [160, 120, 128000],
  ];
  final optimalVideoLayers = <OptimalVideoLayer>[];
  for (var step = 0; step < steps.length; step++) {
    final wh = steps[step];

    final videoTracks = mediaStream.getVideoTracks();
    final settings = videoTracks[0].getSettings();
    final width = wh[0];
    final height = wh[1];
    if (width == settings['width'] && height == settings['height']) {
      var scaleFactor = 1.0;
      ['f', 'h', 'q'].asMap().forEach((i, rid) {
        final width_height_bitrate = steps[step + i];
        final width = width_height_bitrate[0];
        final height = width_height_bitrate[1];
        final bitrate = width_height_bitrate[2];
        optimalVideoLayers.add(OptimalVideoLayer(
          width: width,
          height: height,
          encoding: RTCRtpEncoding(
            rid: rid,
            maxBitrate: bitrate,
            scaleResolutionDownBy: scaleFactor,
          ),
        ));
        scaleFactor *= 2.0;
      });

      break;
    }
  }
  return optimalVideoLayers;
}

final defaultVideoLayers = <OptimalVideoLayer>[
  OptimalVideoLayer(
    encoding: RTCRtpEncoding(
      rid: 'f',
      maxBitrate: 1000000,
    ),
    width: 1280,
    height: 720,
  ),
  OptimalVideoLayer(
    encoding: RTCRtpEncoding(
      rid: 'h',
      maxBitrate: 500000,
    ),
    width: 640,
    height: 480,
  ),
  OptimalVideoLayer(
    encoding: RTCRtpEncoding(rid: 'q', maxBitrate: 300000),
    width: 480,
    height: 360,
  ),
];
