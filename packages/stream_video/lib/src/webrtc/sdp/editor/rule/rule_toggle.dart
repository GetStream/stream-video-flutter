import 'sdp_munging_rule.dart';

class SdpRuleToggle {
  SdpRuleToggle({
    required this.rule,
    this.enabled = false,
  });

  final SdpMungingRule rule;
  bool enabled;

  @override
  String toString() {
    return 'SdpRuleToggle{enabled: $enabled, rule: $rule}';
  }
}
