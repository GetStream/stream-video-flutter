import '../../stream_video.dart';
import '../action/action.dart';
import '../action/internal/coordinator_action.dart';
import '../action/internal/sfu_action.dart';
import '../models/queried_members.dart';
import '../sfu/data/events/sfu_events.dart';
import '../store/store.dart';

class QueryMembersMiddleware extends Middleware<CallState, StreamAction> {
  QueryMembersMiddleware({
    required CoordinatorClient client,
  }) : _client = client;

  final CoordinatorClient _client;

  late final _logger = taggedLogger(tag: 'SV:QueryMembersMW');

  @override
  void intercept(
    Store<CallState, StreamAction> store,
    StreamAction action,
    NextDispatcher<StreamAction> next,
  ) {
    if (action is! SfuEventAction) {
      // Ignore non-SFU events.
      next(action);
      return;
    }

    final event = action.event;
    if (event is SfuJoinResponseEvent) {
      _logger.d(() => '[execute] event: $event');

      final cid = store.state.value.callCid;
      final participants = event.callState.participants;

      _queryMembersByIds(
        cid: cid,
        userIds: {...participants.map((it) => it.userId)},
      ).then((users) {
        if (users.isEmpty) return;

        // Update the store after querying members.
        store.dispatch(UpdateUsers(users: users.toUnmodifiableMap()));
      }).catchError((_) {});
    } else if (event is SfuParticipantJoinedEvent) {
      _logger.d(() => '[execute] event: $event');

      final cid = store.state.value.callCid;
      _queryMembersByIds(
        cid: cid,
        userIds: {event.participant.userId},
      ).then((users) {
        if (users.isEmpty) return;

        // Update the store after querying members.
        store.dispatch(UpdateUsers(users: users.toUnmodifiableMap()));
      }).catchError((_) {});
    }

    // Continue the action chain.
    next(action);
    return;
  }

  Future<List<CallUser>> _queryMembersByIds({
    required StreamCallCid cid,
    required Set<String> userIds,
  }) async {
    _logger.d(() => '[queryMembersByIds] userIds: $userIds');
    final input = QueryUsersInput(
      callCid: cid,
      filterConditions: {
        'user_id': {r'$in': userIds.toList()},
      },
      sorts: const [
        SortInput(field: 'user_id', direction: DirectionInput.asc)
      ],
      limit: userIds.length,
    );
    final result = await _client.queryMembers(input);
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
