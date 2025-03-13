import 'package:equatable/equatable.dart';

class CallParticipantPin with EquatableMixin {
  const CallParticipantPin({
    required this.isLocalPin,
    required this.pinnedAt,
  });

  final bool isLocalPin;
  final DateTime pinnedAt;

  @override
  List<Object?> get props => [isLocalPin, pinnedAt];
}
