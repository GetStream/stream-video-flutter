import 'package:meta/meta.dart';

import '../../../../stream_video.dart';
import '../policy/sdp_policy.dart';
import '../sdp.dart';
import 'action/sdp_edit_action_factory.dart';
import 'sdp_editor.dart';

@internal
class SdpEditorImpl implements SdpEditor {
  SdpEditorImpl(this.policy);

  final SdpPolicy policy;

  final _actionFactory = SdpEditActionFactory();

  final _logger = taggedLogger(tag: 'SV:SdpEditor');

  late final platform = CurrentPlatform.type;

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
      if (!rule.platforms.contains(platform)) {
        _logger.w(() => '[edit] rejected (mismatched platform): $platform');
        continue;
      }
      if (!rule.types.contains(sdp.type)) {
        _logger.w(() => '[edit] rejected (mismatched sdpType): ${sdp.type}');
        continue;
      }
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
