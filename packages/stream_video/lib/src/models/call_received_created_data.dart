import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_created_data.dart';

@immutable
class CallReceivedOrCreatedData with EquatableMixin {
  const CallReceivedOrCreatedData({
    required this.wasCreated,
    required this.data,
  });

  final bool wasCreated;
  final CallCreatedData data;

  @override
  List<Object?> get props => [wasCreated, data];

  @override
  String toString() {
    return 'CallReceivedOrCreated{wasCreated: $wasCreated, data: $data}';
  }
}
