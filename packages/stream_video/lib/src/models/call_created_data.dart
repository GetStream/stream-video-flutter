import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/models/call_metadata.dart';

@immutable
class CallCreatedData with EquatableMixin {
  const CallCreatedData({
    required this.callCid,
    required this.metadata,
  });

  final StreamCallCid callCid;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [callCid, metadata];

  @override
  String toString() {
    return 'CallCreated{callCid: $callCid, metadata: $metadata}';
  }
}
