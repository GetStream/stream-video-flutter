import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../protobuf/video/coordinator/user_v1/user.pb.dart' as coord_users;
import 'action/action.dart';
import 'action/sfu_action.dart';
import 'call_state.dart';
import 'coordinator/coordinator_client.dart';
import 'reducer/call_state_reducer.dart';
import 'sfu/data/events/sfu_events.dart';
import 'state_emitter.dart';
import 'utils/result.dart';

class CallStateManager {
  CallStateManager(
    this.getCurrentUserId,
    this.callCid,
    this.coordinatorClient,
  );

  final String? Function() getCurrentUserId;
  final String callCid;
  final CoordinatorClientV2 coordinatorClient;

  late final _state = MutableStateEmitterImpl(CallStateV2(callCid: callCid));
  late final _stateReducer = CallStateReducer(getCurrentUserId);

  StateEmitter<CallStateV2> get state => _state;

  Future<void> onSfuEvent(SfuEventV2 event) async {
    if (event is SfuJoinResponseEvent) {
      reduceState(
        SfuJoinedAction(
          participants: event.callState.participants,
          users: await queryUsersByIds(
                event.callState.participants.map((it) => it.userId).toSet(),
              ) ??
              List.empty(),
        ),
      );
    } else if (event is SfuParticipantJoinedEvent) {
      if (event.callCid != callCid) {
        return;
      }
      reduceState(
        SfuParticipantJoinedAction(
          participant: event.participant,
          user: await queryUserById(event.participant.userId),
        ),
      );
    } else {
      reduceState(SfuAction(event));
    }
  }

  void reduceState(StreamAction action) {
    _stateReducer.reduce(_state.value, action);
  }

  Future<coord_users.User?> queryUserById(String userId) async {
    final result = await queryUsersByIds({userId});
    return result?.firstOrNull;
  }

  Future<List<coord_users.User>?> queryUsersByIds(Set<String> userIds) async {
    final mqJson = {'id': userIds};
    final request = rpc.QueryUsersRequest(
      // TODO
      mqJson: [1],
    );
    final usersResult = await coordinatorClient.queryUsers(request);
    if (usersResult is! Success<rpc.QueryUsersResponse>) {
      return null;
    }
    return usersResult.data.users;
  }
}
