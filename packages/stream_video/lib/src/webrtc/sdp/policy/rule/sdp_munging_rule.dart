import 'package:equatable/equatable.dart';

import '../../../../platform_detector/platform_detector.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import 'rule_prioritize_codec.dart';
import 'rule_set_opus_dtx_enabled.dart';
import 'rule_set_opus_red_enabled.dart';

abstract class SdpMungingRule with EquatableMixin {
  const SdpMungingRule({
    this.platforms = const [],
    this.types = const [],
  });

  const factory SdpMungingRule.prioritizeCodec({
    required SdpCodec codec,
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = PrioritizeCodecRule;

  const factory SdpMungingRule.setOpusDtxEnabled({
    required bool enabled,
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = SetOpusDtxEnabledRule;

  const factory SdpMungingRule.setOpusRedEnabled({
    required bool enabled,
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = SetOpusRedEnabledRule;

  final List<SdpType> types;
  final List<PlatformType> platforms;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [types, platforms];
}
