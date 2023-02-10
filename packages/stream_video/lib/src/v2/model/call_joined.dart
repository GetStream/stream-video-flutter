import '../../../stream_video.dart';
import '../coordinator/models/coordinator_models.dart';

class CallJoined {
  const CallJoined({
    required this.callCid,
    required this.wasCreated,
    required this.metadata,
    required this.credentials,
  });
  final StreamCallCid callCid;
  final bool wasCreated;
  final CallMetadata metadata;
  final CallCredentials credentials;

  @override
  String toString() {
    return 'CallJoined{callCid: $callCid, wasCreated: $wasCreated, '
        'metadata: $metadata, credentials: $credentials}';
  }
}
