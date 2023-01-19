import '../coordinator/models/coordinator_models.dart';

class CallCreated {
  const CallCreated({
    required this.ringing,
    required this.metadata,
  });
  final bool ringing;
  final CallMetadata metadata;

  @override
  String toString() {
    return 'CallCreated{ringing: $ringing, metadata: $metadata}';
  }
}
