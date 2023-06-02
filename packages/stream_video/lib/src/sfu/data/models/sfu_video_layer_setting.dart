import 'package:equatable/equatable.dart';

import 'sfu_codec.dart';

class SfuVideoLayerSetting with EquatableMixin {
  SfuVideoLayerSetting({
    required this.name,
    required this.active,
    required this.maxBitrate,
    required this.scaleResolutionDownBy,
    required this.priority,
    required this.codec,
  });

  final String name;
  final bool active;
  final int maxBitrate;
  final double scaleResolutionDownBy;
  final SfuVideoLayerSettingPriority priority;
  final SfuCodec codec;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        name,
        active,
        maxBitrate,
        scaleResolutionDownBy,
        priority,
        codec,
      ];
}

enum SfuVideoLayerSettingPriority {
  high,
  medium,
  low,
  veryLow;

  @override
  String toString() => name;
}
