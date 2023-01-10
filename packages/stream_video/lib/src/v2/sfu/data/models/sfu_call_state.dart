import 'package:stream_video/src/v2/sfu/data/models/sfu_participant.dart';

class SfuCallState {
  SfuCallState({
    required this.participants,
  });

  final List<SfuParticipant> participants;

  @override
  String toString() {
    return 'SfuCallState{participants: $participants}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuCallState &&
          runtimeType == other.runtimeType &&
          participants == other.participants;

  @override
  int get hashCode => participants.hashCode;
}
