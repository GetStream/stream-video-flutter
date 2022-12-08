import 'package:stream_video/stream_video.dart';

class CallConfiguration {
  final String type;
  final String id;
  final List<String> participantIds;
  final bool ringing;
  final CallOptions? callOptions;

  const CallConfiguration({
    required this.type,
    required this.id,
    required this.participantIds,
    this.ringing = false,
    this.callOptions,
  });
}
