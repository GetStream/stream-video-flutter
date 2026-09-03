// ignore_for_file: avoid_redundant_argument_values

import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';

import '../../../logger/impl/tagged_logger.dart';
import '../policy/sdp_policy.dart';
import '../sdp.dart';
import 'action/sdp_edit_action_factory.dart';
import 'rule/rule_toggle.dart';
import 'rule/sdp_munging_rule.dart';
import 'sdp_editor.dart';

@internal
class NoOpSdpEditor implements SdpEditor {
  @override
  String? edit(Sdp? sdp) {
    return sdp?.value;
  }
}

@internal
class SdpEditorImpl implements SdpEditor {
  SdpEditorImpl(this.policy);

  final SdpPolicy policy;

  late final _logger = taggedLogger(tag: 'SV:SdpEditor');

  late final _actionFactory = SdpEditActionFactory();

  late final internalRules = _createRules();

  PlatformType get platform => CurrentPlatform.type;

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
    applyRules(sdp.type, lines, sdp: sdp);

    if (policy.mungingEnabled) {
      policy.munging(sdp.type, lines);
    }

    final buffer = StringBuffer();
    buffer.writeLines(lines);
    return buffer.toString();
  }

  void applyRules(
    SdpType sdpType,
    List<SdpLine> lines, {
    Sdp? sdp,
  }) {
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
      _actionFactory.create(rule, sdp: sdp).execute(lines);
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
    // Opus DTX/RED are negotiated by signalling `dtx`/`red` in the published
    // TrackInfo (see RtcManager), matching the JS SDK. They must not be munged
    // into the SDP.
    SdpRuleToggle(
      enabled: true,
      rule: const SdpMungingRule.mirrorSpropStereo(
        types: [SdpType.localAnswer],
      ),
    ),
  ];
}
