import 'package:equatable/equatable.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'sfu_codec.dart';
import 'sfu_track_type.dart';
import 'sfu_video_layer_setting.dart';

class SfuVideoSender extends Equatable {
  const SfuVideoSender({
    required this.codec,
    required this.layers,
    required this.trackType,
    required this.publishOptionId,
    this.degradationPreference,
  });

  final SfuCodec codec;
  final List<SfuVideoLayerSetting> layers;
  final SfuTrackType trackType;
  final int publishOptionId;

  /// The degradation preference for video encoding, as instructed by the SFU.
  /// When null, no change to the current preference is applied.
  final RTCDegradationPreference? degradationPreference;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
    codec,
    layers,
    trackType,
    publishOptionId,
    degradationPreference,
  ];
}
