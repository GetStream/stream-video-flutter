import 'package:equatable/equatable.dart';

import 'sfu_codec.dart';

class SfuVideoLayerSetting with EquatableMixin {
  SfuVideoLayerSetting({
    required this.name,
    required this.active,
    required this.maxBitrate,
    required this.maxFramerate,
    required this.scaleResolutionDownBy,
    required this.scalabilityMode,
    required this.codec,
  });

  final String name;
  final bool active;
  final int maxBitrate;
  final int maxFramerate;
  final double scaleResolutionDownBy;
  final String scalabilityMode;
  final SfuCodec codec;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
    name,
    active,
    maxBitrate,
    maxFramerate,
    scaleResolutionDownBy,
    scalabilityMode,
    codec,
  ];
}
