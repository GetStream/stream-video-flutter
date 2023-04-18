import 'package:meta/meta.dart';

import '../../../logger/impl/tagged_logger.dart';
import '../../../platform_detector/platform_detector.dart';
import '../../../utils/standard.dart';
import '../codec/sdp_codec.dart';
import '../policy/rule/sdp_munging_rule.dart';
import '../policy/sdp_policy.dart';
import '../sdp.dart';
import 'action/sdp_edit_action_factory.dart';
import 'sdp_editor.dart';

@internal
class SdpEditorImpl implements SdpEditor {
  SdpEditorImpl(this.policy) {
    const rule = SdpMungingRule.prioritizeCodec(
      platforms: [PlatformType.android],
      types: [SdpType.localOffer],
      codec: VideoCodec.vp8,
    );
    internalRules[rule.key] = rule;
  }

  final SdpPolicy policy;

  final _logger = taggedLogger(tag: 'SV:SdpEditor');

  final _actionFactory = SdpEditActionFactory();

  final internalRules = <String, SdpMungingRule>{};

  late final platform = CurrentPlatform.type;

  @override
  void upsert(SdpMungingRule rule) {
    final removed = internalRules.remove(rule.key);
    internalRules[rule.key] = rule;
    if (removed != null) {
      _logger.v(() => '[add] replaced: $removed');
    }
    _logger.v(() => '[add] added: $rule');
  }

  @override
  void removeWhereType<T extends SdpMungingRule>() {
    internalRules.removeWhere((key, rule) {
      return (rule is T).also((removed) {
        if (removed) {
          _logger.v(() => '[removeWhereType] removed: $rule');
        }
      });
    });
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
    applyRules(sdp.type, lines, internalRules.values);

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
    Iterable<SdpMungingRule> rules,
  ) {
    for (final rule in rules) {
      _logger.d(() => '[edit] rule: $rule');
      if (rule.platforms.isNotEmpty && !rule.platforms.contains(platform)) {
        _logger.w(() => '[edit] rejected (mismatched platform): $platform');
        continue;
      }
      if (rule.types.isNotEmpty && !rule.types.contains(sdpType)) {
        _logger.w(() => '[edit] rejected (mismatched sdpType): $sdpType');
        continue;
      }
      _actionFactory.create(rule)?.execute(lines);
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
