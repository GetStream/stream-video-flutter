import 'package:equatable/equatable.dart';

import '../../../platform_detector/platform_detector.dart';
import '../codec/sdp_codec.dart';
import '../sdp.dart';

class SdpPolicy with EquatableMixin {
  const SdpPolicy({
    this.mungingEnabled = false,
    this.rules = const [],
  });

  final bool mungingEnabled;
  final List<SdpMungingRule> rules;

  SdpPolicy copyWith({
    bool? mungingEnabled,
    List<SdpMungingRule>? rules,
  }) {
    return SdpPolicy(
      mungingEnabled: mungingEnabled ?? this.mungingEnabled,
      rules: rules ?? this.rules,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [mungingEnabled, rules];
}

abstract class SdpMungingRule with EquatableMixin {
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

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [types, platforms];
}

class PrioritizeCodecRule extends SdpMungingRule {
  const PrioritizeCodecRule({
    required this.codec,
    super.platforms,
    super.types = const [SdpType.localOffer],
  });

  final SdpCodec codec;

  @override
  List<Object> get props => [types, platforms, codec];
}

class EnableOpusDtxRule extends SdpMungingRule {
  const EnableOpusDtxRule({
    super.platforms,
    super.types = const [SdpType.localOffer],
  });
}
