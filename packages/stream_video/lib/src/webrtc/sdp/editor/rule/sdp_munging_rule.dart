import 'package:equatable/equatable.dart';
import 'package:stream_core/stream_core.dart';

import '../../sdp.dart';
import 'rule_mirror_sprop_stereo.dart';

abstract class SdpMungingRule extends Equatable {
  const SdpMungingRule({
    this.platforms = const [],
    this.types = const [],
  });

  const factory SdpMungingRule.mirrorSpropStereo({
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = MirrorSpropStereoRule;

  String get key;

  final List<SdpType> types;
  final List<PlatformType> platforms;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [key];
}
