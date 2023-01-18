import '../../../protobuf/video/coordinator/user_v1/user.pb.dart' as coord;
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_participant.dart';
import 'action.dart';

class SfuAction extends StreamAction {
  const SfuAction(this.event);

  final SfuEventV2 event;
}

class SfuParticipantJoinedAction extends StreamAction {
  const SfuParticipantJoinedAction({
    required this.participant,
    this.user,
    this.isLocalUser,
  });

  final SfuParticipant participant;
  final coord.User? user;
  final isLocalUser;
}

class SfuJoinedAction extends StreamAction {
  factory SfuJoinedAction({
    required List<SfuParticipant> participants,
    required List<coord.User> users,
  }) {
    return SfuJoinedAction._(
      participants: Map.unmodifiable(
        <String, SfuParticipant>{
          for (var it in participants) it.userId: it,
        },
      ),
      users: Map.unmodifiable(
        <String, coord.User>{
          for (var it in users) it.id: it,
        },
      ),
    );
  }
  const SfuJoinedAction._({
    required this.participants,
    required this.users,
  });
  final Map<String, SfuParticipant> participants;
  final Map<String, coord.User> users;
}
