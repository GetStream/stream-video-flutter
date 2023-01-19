import '../coordinator/models/coordinator_models.dart';

class CallJoined {
  const CallJoined({
    required this.metadata,
    required this.credentials,
  });
  final CallMetadata metadata;
  final CallCredentials credentials;

  @override
  String toString() {
    return 'CallJoined{metadata: $metadata, credentials: $credentials}';
  }
}
