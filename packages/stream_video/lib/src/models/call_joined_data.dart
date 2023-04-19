import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_cid.dart';
import 'call_credentials.dart';
import 'call_metadata.dart';

@immutable
class CallJoinedData with EquatableMixin {
  const CallJoinedData({
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
