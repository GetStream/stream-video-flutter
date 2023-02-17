import '../coordinator/models/coordinator_models.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_participant.dart';
import 'action.dart';

abstract class SfuAction extends StreamAction {
  const SfuAction();
}

class SfuEventAction extends SfuAction {
  const SfuEventAction(this.event);

  final SfuEvent event;
}

class SfuParticipantJoinedAction extends SfuAction {
  const SfuParticipantJoinedAction({
    required this.participant,
    this.user,
    this.isLocalUser = false,
  });

  final SfuParticipant participant;
  final CallUser? user;
  final bool isLocalUser;
}

class SfuJoinedAction extends SfuAction {
  factory SfuJoinedAction({
    required List<SfuParticipant> participants,
    required List<CallUser> users,
  }) {
    return SfuJoinedAction._(
      participants: List.unmodifiable(participants),
      users: Map.unmodifiable(
        <String, CallUser>{
          for (var it in users) it.id: it,
        },
      ),
    );
  }
  const SfuJoinedAction._({
    required this.participants,
    required this.users,
  });
  final List<SfuParticipant> participants;
  final Map<String, CallUser> users;
}
