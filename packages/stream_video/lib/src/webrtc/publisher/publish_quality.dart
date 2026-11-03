import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../sfu/data/models/sfu_video_layer_setting.dart';
import '../../sfu/data/models/sfu_video_sender.dart';
import '../model/rtc_video_encoding.dart';

/// Applies the layers the SFU asked for in [sender] to [params], and returns
/// whether anything changed.
///
/// Each encoding is matched to a layer: an SVC sender applies the first
/// active layer, a simulcast sender matches by rid, and a single simulcast
/// encoding whose rid matches nothing takes the first active layer. An
/// encoding without a layer is deactivated. Scale, bitrate, framerate,
/// scalability mode and the degradation preference are set only when given
/// and different.
@internal
bool applyPublishQuality(
  rtc.RTCRtpParameters params,
  SfuVideoSender sender, {
  required bool usesSvcCodec,
}) {
  final encodings = params.encodings ?? const [];
  final enabledLayers = sender.layers.where((e) => e.active).toList();

  var changed = false;
  for (final encoding in encodings) {
    final layer = _layerFor(
      encoding,
      enabledLayers,
      usesSvcCodec: usesSvcCodec,
      encodingCount: encodings.length,
    );

    if (_applyLayer(encoding, layer)) changed = true;
  }

  final degradationPreference = sender.degradationPreference;
  if (degradationPreference != null &&
      params.degradationPreference != degradationPreference) {
    params.degradationPreference = degradationPreference;
    changed = true;
  }

  return changed;
}

SfuVideoLayerSetting? _layerFor(
  rtc.RTCRtpEncoding encoding,
  List<SfuVideoLayerSetting> enabledLayers, {
  required bool usesSvcCodec,
  required int encodingCount,
}) {
  SfuVideoLayerSetting? byRid() {
    return enabledLayers.firstWhereOrNull((l) => l.name == encoding.rid);
  }

  return switch ((usesSvcCodec, encodingCount)) {
    // SVC has a single layer, and the rid is often omitted.
    (true, _) => enabledLayers.firstOrNull,
    (false, 1) => byRid() ?? enabledLayers.firstOrNull,
    (false, _) => byRid(),
  };
}

/// Applies [layer] to [encoding], deactivating it when there is none, and
/// returns whether anything changed.
bool _applyLayer(rtc.RTCRtpEncoding encoding, SfuVideoLayerSetting? layer) {
  var changed = false;

  final shouldActivate = layer != null;
  if (shouldActivate != encoding.active) {
    encoding.active = shouldActivate;
    changed = true;
  }

  if (layer == null) return changed;

  final scaleResolutionDownBy = layer.scaleResolutionDownBy;
  if (scaleResolutionDownBy >= 1 &&
      scaleResolutionDownBy != encoding.scaleResolutionDownBy) {
    encoding.scaleResolutionDownBy = scaleResolutionDownBy;
    changed = true;
  }

  final maxBitrate = layer.maxBitrate;
  if (maxBitrate > 0 && maxBitrate != encoding.maxBitrate) {
    encoding.maxBitrate = maxBitrate;
    changed = true;
  }

  final maxFramerate = layer.maxFramerate;
  if (maxFramerate > 0 && maxFramerate != encoding.maxFramerate) {
    encoding.maxFramerate = maxFramerate;
    changed = true;
  }

  final scalabilityMode = layer.scalabilityMode;
  if (scalabilityMode.isNotEmpty &&
      scalabilityMode != encoding.scalabilityMode) {
    encoding.scalabilityMode = scalabilityMode;
    changed = true;
  }

  return changed;
}

/// Sets the max bitrate of the first encoding of [params] to that of the
/// first encoding of [target], and returns whether [params] should be sent
/// to the sender: true whenever both have an encoding.
@internal
bool applyAudioBitrate(
  rtc.RTCRtpParameters params,
  List<rtc.RTCRtpEncoding> target,
) {
  final targetEncoding = target.firstOrNull;
  if (targetEncoding == null) return false;

  final currentEncoding = params.encodings?.firstOrNull;
  if (currentEncoding == null) return false;

  currentEncoding.maxBitrate = targetEncoding.maxBitrate;
  return true;
}

/// The video quality a simulcast layer with [rid] is announced with.
@internal
RtcVideoQuality ridToVideoQuality(String rid) {
  switch (rid) {
    case 'q':
      return RtcVideoQuality.lowUnspecified;
    case 'h':
      return RtcVideoQuality.mid;
    default:
      return RtcVideoQuality.high; // default to HIGH
  }
}
