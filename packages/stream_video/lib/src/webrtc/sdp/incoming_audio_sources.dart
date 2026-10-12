import 'package:sdp_transform/sdp_transform.dart';

/// The incoming audio sources an SFU subscriber offer describes.
///
/// One entry per audio m-section the SFU sends on (`sendonly` or `sendrecv`),
/// keyed by mid and msid: a reused m-line that now carries another
/// participant's track counts as a new source, and one turned `inactive` as
/// gone. Malformed SDP yields an empty set.
Set<String> incomingAudioSources(String sdp) {
  final List<Map<String, dynamic>> media;
  try {
    media = (parse(sdp)['media'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
  } catch (_) {
    return const {};
  }

  return {
    for (final (index, section) in media.indexed)
      if (section['type'] == 'audio' && _sendsToUs(section))
        '${section['mid'] ?? index}|${section['msid'] ?? ''}',
  };
}

bool _sendsToUs(Map<String, dynamic> section) {
  // An m-section without a direction attribute is sendrecv.
  final direction = section['direction'] as String? ?? 'sendrecv';
  return direction == 'sendonly' || direction == 'sendrecv';
}

/// Whether the subscriber offer [next] brings in an incoming audio source that
/// [previous], the offer applied before it, did not have.
bool offerAddsIncomingAudio({required String previous, required String next}) {
  return incomingAudioSources(
    next,
  ).difference(incomingAudioSources(previous)).isNotEmpty;
}
