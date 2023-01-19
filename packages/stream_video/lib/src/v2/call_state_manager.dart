import 'package:collection/collection.dart';

import 'action/action.dart';
import 'action/coordinator_action.dart';
import 'action/sfu_action.dart';
import 'action/update_call_action.dart';
import 'call_state.dart';
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/ws/coordinator_events.dart';
import 'model/call_created.dart';
import 'model/call_joined.dart';
import 'model/call_received_created.dart';
import 'reducer/call_state_reducer.dart';
import 'sfu/data/events/sfu_events.dart';
import 'state_emitter.dart';
import 'stream_video_v2.dart';
import 'utils/result.dart';

abstract class CallStateManager {
  const CallStateManager();
  StateEmitter<CallStateV2> get state;
  Future<void> onConnect();
  Future<void> onConnected(CallJoined data);
  Future<void> onSessionStart(String sessionId);
  Future<void> onSessionStarted(String sessionId);
  Future<void> onDisconnect();
  Future<void> onUserAction(UpdateCallAction action);
  Future<void> onSfuEvent(SfuEventV2 event);
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event);
  Future<void> onCallReceivedOrCreated(CallReceivedOrCreated data);
  Future<void> onCallCreated(CallCreated data);
  Future<void> onCallAccepted();
  Future<void> onCallRejected();
  Future<void> onCallCancelled();
}

class CallStateManagerImpl extends CallStateManager {
  CallStateManagerImpl({
    required String currentUserId,
    required CallStateV2 initialState,
    required StreamVideoV2 streamVideo,
  })  : _streamVideo = streamVideo,
        _state = MutableStateEmitterImpl(initialState),
        _stateReducer = CallStateReducer(currentUserId);

  final StreamVideoV2 _streamVideo;
  final CallStateReducer _stateReducer;
  final MutableStateEmitter<CallStateV2> _state;

  @override
  StateEmitter<CallStateV2> get state => _state;

  @override
  Future<void> onUserAction(UpdateCallAction action) async {
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
        ),
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

  Future<CallUser?> _queryUserById(String userId) async {
    final result = await _queryUsersByIds({userId});
    return result.firstOrNull;
  }

  Future<List<CallUser>> _queryUsersByIds(Set<String> userIds) async {
    final usersResult = await _streamVideo.queryUsers(userIds: userIds);
    if (usersResult is! Success<List<CallUser>>) {
      return List.empty();
    }
    return usersResult.data;
  }

  @override
  Future<void> onCallCreated(CallCreated data) {
    // TODO: implement onCallCreated
    throw UnimplementedError();
  }

  @override
  Future<void> onCallReceivedOrCreated(CallReceivedOrCreated data) {
    // TODO: implement onCallReceivedOrCreated
    throw UnimplementedError();
  }

  @override
  Future<void> onCallAccepted() {
    // TODO: implement onCallAccepted
    throw UnimplementedError();
  }

  @override
  Future<void> onCallCancelled() {
    // TODO: implement onCallCancelled
    throw UnimplementedError();
  }

  @override
  Future<void> onCallRejected() {
    // TODO: implement onCallRejected
    throw UnimplementedError();
  }

  @override
  Future<void> onConnected(CallJoined data) {
    // TODO: implement onConnected
    throw UnimplementedError();
  }

  @override
  Future<void> onSessionStart(String sessionId) {
    // TODO: implement onStarted
    throw UnimplementedError();
  }

  @override
  Future<void> onSessionStarted(String sessionId) {
    // TODO: implement onStarted
    throw UnimplementedError();
  }
}
