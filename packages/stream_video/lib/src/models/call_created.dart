import '../coordinator/models/coordinator_models.dart';
import 'call_cid.dart';

class CallCreated {
  const CallCreated({
    required this.callCid,
    required this.ringing,
    required this.metadata,
  });
  final StreamCallCid callCid;
  final bool ringing;
  final CallMetadata metadata;

  @override
  String toString() {
    return 'CallCreated{callCid: $callCid, ringing: $ringing, '
        'metadata: $metadata}';
  }
}
