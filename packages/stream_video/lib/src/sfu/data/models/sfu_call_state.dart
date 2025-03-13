import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'sfu_participant.dart';
import 'sfu_pin.dart';

@immutable
class SfuCallState with EquatableMixin {
  const SfuCallState({
    required this.participants,
    required this.participantCount,
    required this.startedAt,
    required this.pins,
  });

  final List<SfuParticipant> participants;
  final SfuParticipantCount participantCount;
  final DateTime startedAt;
  final List<SfuPin> pins;

  @override
  String toString() {
    return 'SfuCallState{participants: $participants, '
        'participantCount: $participantCount}';
  }

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [participants, participantCount];
}
