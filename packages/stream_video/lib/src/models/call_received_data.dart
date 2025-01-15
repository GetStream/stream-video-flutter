import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class CallReceivedData with EquatableMixin {
  const CallReceivedData({
    required this.callCid,
    required this.metadata,
  });

  final StreamCallCid callCid;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [callCid, metadata];

  @override
  String toString() {
    return 'CallReceivedData{callCid: $callCid, metadata: $metadata}';
  }
}
