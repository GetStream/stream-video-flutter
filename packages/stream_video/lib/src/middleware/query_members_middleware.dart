import '../../stream_video.dart';
import '../action/action.dart';
import '../action/internal/coordinator_action.dart';
import '../action/internal/sfu_action.dart';
import '../models/queried_members.dart';
import '../sfu/data/events/sfu_events.dart';
import 'middleware.dart';

class QueryMembersMiddleware extends Middleware {
  QueryMembersMiddleware({
    required StreamVideo streamVideo,
  }) : _streamVideo = streamVideo;

  final StreamVideo _streamVideo;

  late final _logger = taggedLogger(tag: 'SV:QueryMembersMW');

  @override
  Future<void> dispatch(StreamAction action) async {
    if (action is! SfuEventAction) {
      return next.dispatch(action);
    }
    final event = action.event;
    if (event is SfuJoinResponseEvent) {
      _logger.d(() => '[execute] event: $event');
      final participants = event.callState.participants;
      final users = await _queryMembersByIds(
        participants.map((it) => it.userId).toSet(),
      );
      reduce(
        UpdateUsers(users: users.toUnmodifiableMap()),
      );
    } else if (event is SfuParticipantJoinedEvent) {
      _logger.d(() => '[execute] event: $event');
      final users = await _queryMembersByIds({event.participant.userId});
      reduce(
        UpdateUsers(users: users.toUnmodifiableMap()),
      );
    }
    next.dispatch(action);
  }

  Future<List<CallUser>> _queryMembersByIds(
    Set<String> userIds,
  ) async {
    _logger.d(() => '[queryMembersByIds] userIds: $userIds');
    final callCid = getState().callCid;
    final result = await _streamVideo.queryMembers(
      callCid: callCid,
      userIds: userIds,
    );
    _logger.v(() => '[queryMembersByIds] result: $result');
    if (result is! Success<QueriedMembers>) {
      return List.empty();
    }
    return result.data.users.values.toList();
  }
}

extension on List<CallUser> {
  Map<String, CallUser> toUnmodifiableMap() {
    return Map.unmodifiable(
      <String, CallUser>{
        for (var it in this) it.id: it,
      },
    );
  }
}
