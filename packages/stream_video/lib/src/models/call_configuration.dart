import '../../stream_video.dart';

class CallConfiguration {
  const CallConfiguration({
    required this.type,
    required this.id,
    required this.participantIds,
    this.ringing = false,
    this.callOptions = const CallOptions(),
  });

  final String type;
  final String id;
  final List<String> participantIds;
  final bool ringing;
  final CallOptions callOptions;
}
