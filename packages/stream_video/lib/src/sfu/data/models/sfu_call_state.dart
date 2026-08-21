import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'sfu_participant.dart';
import 'sfu_pin.dart';

@immutable
class SfuCallState extends Equatable {
  const SfuCallState({
    required this.participants,
    required this.participantCount,
    required this.startedAt,
    required this.pins,
    required this.e2eeEnabled,
  });

  final List<SfuParticipant> participants;
  final SfuParticipantCount participantCount;
  final DateTime startedAt;
  final List<SfuPin> pins;

  /// Whether the SFU negotiated this call as end-to-end encrypted.
  final bool e2eeEnabled;

  @override
  String toString() {
    return 'SfuCallState{participants: $participants, '
        'participantCount: $participantCount, e2eeEnabled: $e2eeEnabled}';
  }

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [participants, participantCount, e2eeEnabled];
}
