import 'package:equatable/equatable.dart';
import '../../../../stream_video.dart';
import 'sfu_codec.dart';

import 'sfu_video_layer_setting.dart';

class SfuVideoSender with EquatableMixin {
  SfuVideoSender({
    required this.codec,
    required this.layers,
    required this.trackType,
    required this.publishOptionId,
  });

  final SfuCodec codec;
  final List<SfuVideoLayerSetting> layers;
  final SfuTrackType trackType;
  final int publishOptionId;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [codec, layers, trackType, publishOptionId];
}
