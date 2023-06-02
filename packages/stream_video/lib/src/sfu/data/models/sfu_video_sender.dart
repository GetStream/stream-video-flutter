import 'package:equatable/equatable.dart';
import 'sfu_codec.dart';

import 'sfu_video_layer_setting.dart';

class SfuVideoSender with EquatableMixin {
  SfuVideoSender({
    required this.mediaRequest,
    required this.codec,
    required this.layers,
  });

  final SfuVideoMediaRequest mediaRequest;
  final SfuCodec codec;
  final List<SfuVideoLayerSetting> layers;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [mediaRequest, codec, layers];
}

class SfuVideoMediaRequest with EquatableMixin {
  SfuVideoMediaRequest({
    required this.idealHeight,
    required this.idealWidth,
    required this.idealFrameRate,
  });

  final int idealHeight;
  final int idealWidth;
  final int idealFrameRate;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [idealHeight, idealWidth, idealFrameRate];
}
