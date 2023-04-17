import 'package:equatable/equatable.dart';

import 'rule/sdp_munging_rule.dart';

class SdpPolicy with EquatableMixin {
  const SdpPolicy({
    this.mungingEnabled = false,
    this.rules = const {},
  });

  final bool mungingEnabled;
  final Set<SdpMungingRule> rules;

  SdpPolicy copyWith({
    bool? mungingEnabled,
    Set<SdpMungingRule>? rules,
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
