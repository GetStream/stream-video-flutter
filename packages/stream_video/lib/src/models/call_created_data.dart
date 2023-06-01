import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_cid.dart';
import 'call_metadata.dart';

@immutable
class CallCreatedData with EquatableMixin {
  const CallCreatedData({
    required this.callCid,
    required this.ringing,
    required this.metadata,
  });

  final StreamCallCid callCid;
  final bool ringing;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [callCid, ringing, metadata];

  @override
  String toString() {
    return 'CallCreated{callCid: $callCid, ringing: $ringing, '
        'metadata: $metadata}';
  }
}
