import 'package:meta/meta.dart';

import '../../../logger/impl/tagged_logger.dart';
import '../../../platform_detector/platform_detector.dart';
import '../codec/sdp_codec.dart';
import '../policy/sdp_policy.dart';
import '../sdp.dart';
import 'action/sdp_edit_action_factory.dart';
import 'rule/rule_set_opus_dtx_enabled.dart';
import 'rule/rule_set_opus_red_enabled.dart';
import 'rule/rule_toggle.dart';
import 'rule/sdp_munging_rule.dart';
import 'sdp_editor.dart';

@internal
class SdpEditorImpl implements SdpEditor {
  SdpEditorImpl(this.policy);

  final SdpPolicy policy;

  late final _logger = taggedLogger(tag: 'SV:SdpEditor');

  late final _actionFactory = SdpEditActionFactory();

  late final internalRules = _createRules();

  PlatformType get platform => CurrentPlatform.type;

  @override
  set opusDtxEnabled(bool value) {
    for (final toggle in internalRules) {
      if (toggle.rule is SetOpusDtxEnabledRule) {
        toggle.enabled = value;
        break;
      }
    }
  }

  @override
  set opusRedEnabled(bool value) {
    for (final toggle in internalRules) {
      if (toggle.rule is SetOpusRedEnabledRule) {
        toggle.enabled = value;
        break;
      }
    }
  }

  @override
  String? edit(Sdp? sdp) {
    if (sdp == null) {
      _logger.w(() => '[edit] rejected (sdp is null)');
      return null;
    }
    if (!policy.mungingEnabled && internalRules.isEmpty) {
      _logger.w(() => '[edit] rejected (disabled & no-internal-rules)');
      return sdp.value;
    }

    _logger.i(() => '[edit] sdp.type: ${sdp.type}');
    final lines = sdp.value.split('\r\n');
    applyRules(sdp.type, lines);

    if (policy.mungingEnabled) {
      policy.munging(sdp.type, lines);
    }

    final buffer = StringBuffer();
    buffer.writeLines(lines);
    return buffer.toString();
  }

  void applyRules(
    SdpType sdpType,
    List<SdpLine> lines,
  ) {
    for (final toggle in internalRules) {
      _logger.d(() => '[edit] rule: $toggle');
      if (!toggle.enabled) {
        _logger.w(() => '[edit] rejected (rule is disabled)');
        continue;
      }
      final rule = toggle.rule;
      if (rule.platforms.isNotEmpty && !rule.platforms.contains(platform)) {
        _logger.w(() => '[edit] rejected (mismatched platform): $platform');
        continue;
      }
      if (rule.types.isNotEmpty && !rule.types.contains(sdpType)) {
        _logger.w(() => '[edit] rejected (mismatched sdpType): $sdpType');
        continue;
      }
      _actionFactory.create(rule).execute(lines);
    }
  }
}

extension on StringBuffer {
  void writeLines(List<SdpLine> sdpLines) {
    for (var index = 0; index < sdpLines.length; index++) {
      final line = sdpLines[index];
      write(line);
      if (index != (sdpLines.length - 1)) {
        write('\n');
      }
    }
  }
}

List<SdpRuleToggle> _createRules() {
  return <SdpRuleToggle>[
    SdpRuleToggle(
      enabled: true,
      rule: const SdpMungingRule.prioritizeCodec(
        platforms: [PlatformType.android],
        types: [SdpType.localOffer],
        codec: VideoCodec.vp8,
      ),
    ),
    SdpRuleToggle(
      rule: const SdpMungingRule.setOpusDtxEnabled(
        enabled: true,
        types: [SdpType.localOffer],
      ),
    ),
    SdpRuleToggle(
      rule: const SdpMungingRule.setOpusRedEnabled(
        enabled: true,
        types: [SdpType.localOffer],
      ),
    ),
  ];
}
