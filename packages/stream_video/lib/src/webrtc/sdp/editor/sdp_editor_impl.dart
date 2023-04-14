import 'package:meta/meta.dart';

import '../../../../stream_video.dart';
import '../policy/sdp_policy.dart';
import '../sdp.dart';
import 'action/sdp_edit_action_factory.dart';
import 'sdp_editor.dart';

@internal
class SdpEditorImpl implements SdpEditor {
  SdpEditorImpl(this.policy);

  SdpPolicy policy;

  final _actionFactory = SdpEditActionFactory();

  final _logger = taggedLogger(tag: 'SV:SdpEditor');

  late final platform = CurrentPlatform.type;

  @override
  void addRule(SdpMungingRule rule) {
    _logger.d(() => '[addRule] rule: ${rule.runtimeType}');
    if (!policy.rules.contains(rule)) {
      policy = policy.copyWith(
        rules: [...policy.rules, rule],
      );
      _logger.v(() => '[addRule] added: $rule');
    }
  }

  @override
  void removeRule<T extends SdpMungingRule>() {
    _logger.d(() => '[removeRule] rule: ${T.runtimeType}');
    final ruleIndex = policy.rules.indexWhere((it) => it is T);
    if (ruleIndex != -1) {
      final rules = [...policy.rules];
      final removed = rules.removeAt(ruleIndex);
      policy = policy.copyWith(
        rules: rules,
      );
      _logger.v(() => '[removeRule] removed: $removed');
    }
  }

  @override
  String? edit(Sdp? sdp) {
    if (sdp == null) {
      _logger.w(() => '[edit] rejected (sdp is null)');
      return null;
    }
    if (!policy.mungingEnabled) {
      _logger.w(() => '[edit] rejected (munging disabled)');
      return sdp.value;
    }

    final lines = sdp.value.split('\r\n');
    for (final rule in policy.rules) {
      _logger.i(() => '[edit] rule: $rule');

      if (rule.platforms.isNotEmpty && !rule.platforms.contains(platform)) {
        _logger.w(() => '[edit] rejected (mismatched platform): $platform');
        continue;
      }
      if (rule.types.isNotEmpty && !rule.types.contains(sdp.type)) {
        _logger.w(() => '[edit] rejected (mismatched sdpType): ${sdp.type}');
        continue;
      }
      _logger.w(() => '[edit] apply rule: $rule');
      _actionFactory.create(rule)?.execute(lines);
    }

    final buffer = StringBuffer();
    buffer.writeLines(lines);
    return buffer.toString();
  }
}

extension on StringBuffer {
  void writeLines(List<String> sdpLines) {
    for (var index = 0; index < sdpLines.length; index++) {
      final line = sdpLines[index];
      write(line);
      if (index != (sdpLines.length - 1)) {
        write('\n');
      }
    }
  }
}
