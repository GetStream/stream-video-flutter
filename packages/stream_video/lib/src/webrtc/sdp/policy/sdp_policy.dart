import '../../../platform_detector/platform_detector.dart';
import '../codec/sdp_codec.dart';
import '../sdp.dart';

class SdpPolicy {
  const SdpPolicy({
    this.mungingEnabled = false,
    this.rules = const [],
  });

  final bool mungingEnabled;
  final List<SdpMungingRule> rules;
}

abstract class SdpMungingRule {
  const SdpMungingRule({
    this.platforms = const [],
    this.types = const [],
  });

  factory SdpMungingRule.prioritizeCodec({
    required SdpCodec codec,
    List<PlatformType> platforms = const [],
    List<SdpType> types = const [],
  }) {
    return PrioritizeCodecRule(
      codec: codec,
      platforms: platforms,
      types: types,
    );
  }

  final List<SdpType> types;
  final List<PlatformType> platforms;
}

class PrioritizeCodecRule extends SdpMungingRule {
  const PrioritizeCodecRule({
    required this.codec,
    super.platforms,
    super.types,
  });

  final SdpCodec codec;
}
