import 'package:sdp_transform/sdp_transform.dart';

import '../../logger/impl/tagged_logger.dart';

final _logger = taggedLogger(tag: 'SV:IncomingAudioSources');

/// The incoming audio sources an SFU subscriber offer describes, or null when
/// [sdp] could not be read.
///
/// One entry per audio m-section the SFU sends on (`sendonly` or `sendrecv`),
/// keyed by mid, msid and SSRCs: a reused m-line that now carries another
/// participant's track counts as a new source, and one turned `inactive` as
/// gone. The SSRCs catch that swap even where an offer leaves `a=msid` out,
/// since a new track always arrives under new ones. Text that is not SDP
/// yields an empty set, which is how the parser reads it.
Set<String>? incomingAudioSources(String sdp) {
  // The whole read is guarded, not only the parse: the casts below run lazily,
  // inside the set comprehension.
  try {
    final media = (parse(sdp)['media'] as List? ?? const [])
        .cast<Map<String, dynamic>>();

    return {
      for (final (index, section) in media.indexed)
        if (section['type'] == 'audio' && _sendsToUs(section))
          _sourceKey(section, index),
    };
  } catch (e, stk) {
    _logger.w(
      () => '[incomingAudioSources] could not read the offer: $e\n$stk',
    );
    return null;
  }
}

String _sourceKey(Map<String, dynamic> section, int index) {
  final mid = section['mid'] ?? index;
  final msid = section['msid'] ?? '';
  return '$mid|$msid|${_ssrcsOf(section).join(',')}';
}

/// The SSRCs the `a=ssrc:` lines of [section] name, in order and without
/// repeats: each SSRC has a line per attribute.
List<String> _ssrcsOf(Map<String, dynamic> section) {
  final ssrcs = section['ssrcs'] as List? ?? const [];
  return {for (final line in ssrcs) '${(line as Map)['id']}'}.toList()..sort();
}

bool _sendsToUs(Map<String, dynamic> section) {
  // An m-section without a direction attribute is sendrecv.
  final direction = section['direction'] as String? ?? 'sendrecv';
  return direction == 'sendonly' || direction == 'sendrecv';
}

/// Whether the subscriber offer [next] brings in an incoming audio source that
/// [previous], the offer applied before it, did not have.
///
/// True when either offer could not be read. A needless re-attach costs the
/// remote audio a short gap; a missed one leaves it silent until a rejoin.
bool offerAddsIncomingAudio({required String previous, required String next}) {
  final nextSources = incomingAudioSources(next);
  if (nextSources == null) return true;

  final previousSources = incomingAudioSources(previous);
  if (previousSources == null) return nextSources.isNotEmpty;

  return nextSources.difference(previousSources).isNotEmpty;
}
