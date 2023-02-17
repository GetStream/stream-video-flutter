import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import 'call_credentials.dart';
import 'call_metadata.dart';

@immutable
class CallJoined with EquatableMixin {
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
  List<Object?> get props => [callCid, wasCreated, metadata, credentials];

  @override
  String toString() {
    return 'CallJoined{callCid: $callCid, wasCreated: $wasCreated, '
        'metadata: $metadata, credentials: $credentials}';
  }
}
