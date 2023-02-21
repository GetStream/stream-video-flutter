import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_created.dart';

@immutable
class CallReceivedOrCreated with EquatableMixin {
  const CallReceivedOrCreated({
    required this.wasCreated,
    required this.data,
  });
  final bool wasCreated;
  final CallCreated data;

  @override
  List<Object?> get props => [wasCreated, data];

  @override
  String toString() {
    return 'CallReceivedOrCreated{wasCreated: $wasCreated, data: $data}';
  }
}
