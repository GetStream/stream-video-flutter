import '../../../stream_video.dart';
import '../coordinator/models/coordinator_models.dart';

class CallJoined {
  const CallJoined({
    required this.callCid,
    required this.metadata,
    required this.credentials,
  });
  final StreamCallCid callCid;
  final CallMetadata metadata;
  final CallCredentials credentials;

  @override
  String toString() {
    return 'CallJoined{callCid: $callCid, metadata: $metadata, '
        'credentials: $credentials}';
  }
}
