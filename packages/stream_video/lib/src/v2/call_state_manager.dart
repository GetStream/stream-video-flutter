import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../protobuf/video/coordinator/user_v1/user.pb.dart' as coord_users;
import 'action/action.dart';
import 'action/coordinator_action.dart';
import 'action/sfu_action.dart';
import 'action/user_action.dart';
import 'call_state.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/ws/coordinator_events.dart';
import 'reducer/call_state_reducer.dart';
import 'sfu/data/events/sfu_events.dart';
import 'state_emitter.dart';
import 'utils/result.dart';

abstract class CallStateManager {
  const CallStateManager();
  StateEmitter<CallStateV2> get state;
  Future<void> onConnect();
  Future<void> onDisconnect();
  Future<void> onUserAction(UserAction action);
  Future<void> onSfuEvent(SfuEventV2 event);
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event);
}

class CallStateManagerImpl extends CallStateManager {
  CallStateManagerImpl({
    required String currentUserId,
    required CallStateV2 initialState,
    required CoordinatorClientV2 coordinatorClient,
  })  : _coordinatorClient = coordinatorClient,
        _state = MutableStateEmitterImpl(initialState),
        _stateReducer = CallStateReducer(currentUserId);

  final CoordinatorClientV2 _coordinatorClient;
  final CallStateReducer _stateReducer;
  final MutableStateEmitter<CallStateV2> _state;

  @override
  StateEmitter<CallStateV2> get state => _state;

  @override
  Future<void> onUserAction(UserAction action) async {
    // TODO implement
  }

  @override
  Future<void> onConnect() async {
    // TODO implement
  }

  @override
  Future<void> onDisconnect() async {
    // TODO implement
    // drop state
  }

  @override
  Future<void> onSfuEvent(SfuEventV2 event) async {
    if (event is SfuJoinResponseEvent) {
      await _dispatchSfuJoined(event);
    } else if (event is SfuParticipantJoinedEvent) {
      await _dispatchSfuParticipantJoined(event);
    } else {
      await _dispatchSfu(event);
    }
  }

  @override
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event) async {
    await _dispatchCoordinator(event);
  }

  Future<void> _dispatchSfuJoined(SfuJoinResponseEvent event) async {
    await _dispatch(
      SfuJoinedAction(
        participants: event.callState.participants,
        users: await _queryUsersByIds(
              event.callState.participants.map((it) => it.userId).toSet(),
            ) ??
            List.empty(),
      ),
    );
  }

  Future<void> _dispatchSfuParticipantJoined(
    SfuParticipantJoinedEvent event,
  ) async {
    if (event.callCid != _state.value.callCid) {
      return;
    }
    await _dispatch(
      SfuParticipantJoinedAction(
        participant: event.participant,
        user: await _queryUserById(event.participant.userId),
      ),
    );
  }

  Future<void> _dispatchSfu(SfuEventV2 event) async {
    await _dispatch(SfuEventAction(event));
  }

  Future<void> _dispatchCoordinator(CoordinatorEventV2 event) async {
    await _dispatch(CoordinatorAction(event));
  }

  Future<void> _dispatch(StreamAction action) async {
    _state.value = _stateReducer.reduce(_state.value, action);
  }

  Future<coord_users.User?> _queryUserById(String userId) async {
    final result = await _queryUsersByIds({userId});
    return result?.firstOrNull;
  }

  Future<List<coord_users.User>?> _queryUsersByIds(Set<String> userIds) async {
    final mqJson = {'id': userIds};
    final request = rpc.QueryUsersRequest(
      // TODO
      mqJson: [1],
    );
    final usersResult = await _coordinatorClient.queryUsers(request);
    if (usersResult is! Success<rpc.QueryUsersResponse>) {
      return null;
    }
    return usersResult.data.users;
  }
}
