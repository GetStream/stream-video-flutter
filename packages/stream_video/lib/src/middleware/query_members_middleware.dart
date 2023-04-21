import '../../stream_video.dart';
import '../action/action.dart';
import '../action/internal/coordinator_action.dart';
import '../action/internal/sfu_action.dart';
import '../models/queried_members.dart';
import '../sfu/data/events/sfu_events.dart';
import '../store/store.dart';

class QueryMembersMiddleware extends Middleware<CallState, StreamAction> {
  QueryMembersMiddleware({
    required StreamVideo streamVideo,
  }) : _streamVideo = streamVideo;

  final StreamVideo _streamVideo;

  late final _logger = taggedLogger(tag: 'SV:QueryMembersMW');

  @override
  Future<void> intercept(
    Store<CallState, StreamAction> store,
    StreamAction action,
    NextDispatcher<StreamAction> next,
  ) async {
    if (action is! SfuEventAction) {
      return next(action);
    }

    final event = action.event;
    if (event is SfuJoinResponseEvent) {
      _logger.d(() => '[execute] event: $event');

      // Update the state before querying members.
      next(action);

      final cid = store.state.value.callCid;
      final participants = event.callState.participants;
      final users = await _queryMembersByIds(
        cid: cid,
        userIds: {...participants.map((it) => it.userId)},
      );

      // Update the state after querying members.
      return next(UpdateUsers(users: users.toUnmodifiableMap()));
    }

    if (event is SfuParticipantJoinedEvent) {
      _logger.d(() => '[execute] event: $event');

      // Update the state before querying members.
      next(action);

      final cid = store.state.value.callCid;
      final users = await _queryMembersByIds(
        cid: cid,
        userIds: {event.participant.userId},
      );

      // Update the state after querying members.
      return next(UpdateUsers(users: users.toUnmodifiableMap()));
    }

    return next(action);
  }

  Future<List<CallUser>> _queryMembersByIds({
    required StreamCallCid cid,
    required Set<String> userIds,
  }) async {
    _logger.d(() => '[queryMembersByIds] userIds: $userIds');
    final result = await _streamVideo.queryMembers(
      callCid: cid,
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
