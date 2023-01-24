import 'package:collection/collection.dart';

import '../logger/stream_logger.dart';
import 'action/action.dart';
import 'action/call_control_action.dart';
import 'action/coordinator_action.dart';
import 'action/lifecycle_action.dart';
import 'action/sfu_action.dart';
import 'call_state.dart';
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/ws/coordinator_events.dart';
import 'errors/video_error.dart';
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
  Future<void> onUserIdSet(String userId);
  Future<void> onCallCreated(CallCreated data);
  Future<void> onCallReceivedOrCreated(CallReceivedOrCreated data);
  Future<void> onCallAccepted();
  Future<void> onCallRejected();
  Future<void> onCallCancelled();
  Future<void> onConnect();
  Future<void> onJoined(CallJoined data);
  Future<void> onSessionStart(String sessionId);
  Future<void> onConnected();
  Future<void> onDisconnect();
  Future<void> onCallControlAction(CallControlAction action);
  Future<void> onSfuEvent(SfuEventV2 event);
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event);
  Future<void> onWaitingTimeout(Duration dropTimeout);
  Future<void> onConnectFailed(VideoError error);
}

class CallStateManagerImpl extends CallStateManager {
  CallStateManagerImpl({
    required CallStateV2 initialState,
    required StreamVideoV2 streamVideo,
  })  : _streamVideo = streamVideo,
        _state = MutableStateEmitterImpl(initialState),
        _stateReducer = CallStateReducer();

  late final _logger = taggedLogger(tag: 'SV:StateManager');

  final StreamVideoV2 _streamVideo;
  final CallStateReducer _stateReducer;
  final MutableStateEmitter<CallStateV2> _state;

  @override
  StateEmitter<CallStateV2> get state => _state;

  @override
  Future<void> onUserIdSet(String userId) async {
    _logger.d(() => '[onUserIdSet] userId: $userId');
    _postReduced(CallUserIdAction(userId: userId));
  }

  @override
  Future<void> onCallControlAction(CallControlAction action) async {
    _logger.d(() => '[onUpdateCallAction] action: $action');
    _postReduced(action);
  }

  @override
  Future<void> onCallCreated(CallCreated data) async {
    _logger.d(() => '[onCallCreated] data: $data');
    _postReduced(CallCreatedAction(data: data));
  }

  @override
  Future<void> onCallReceivedOrCreated(CallReceivedOrCreated data) async {
    _logger.d(() => '[onCallReceivedOrCreated] data: $data');
    _postReduced(CallCreatedAction(data: data.data));
  }

  @override
  Future<void> onCallAccepted() async {
    _logger.d(() => '[onCallAccepted] no args');
    _postReduced(const CallAcceptedAction());
  }

  @override
  Future<void> onCallCancelled() async {
    _logger.d(() => '[onCallCancelled] no args');
    _postReduced(const CallCancelledAction());
  }

  @override
  Future<void> onCallRejected() async {
    _logger.d(() => '[onCallRejected] no args');
    _postReduced(const CallRejectedAction());
  }

  @override
  Future<void> onWaitingTimeout(Duration dropTimeout) async {
    _logger.d(() => '[onWaitingTimeout] dropTimeout: $dropTimeout');
    _postReduced(CallTimeoutAction(dropTimeout));
  }

  @override
  Future<void> onConnectFailed(VideoError error) async {
    _logger.e(() => '[onConnectFailed] error: $error');
    _postReduced(CallConnectFailedAction(error));
  }

  @override
  Future<void> onConnect() async {
    _logger.d(() => '[onConnect] no args');
    _postReduced(const CallConnectAction());
  }

  @override
  Future<void> onJoined(CallJoined data) async {
    _logger.d(() => '[onJoined] data: $data');
    _postReduced(CallJoinedAction(data));
  }

  @override
  Future<void> onSessionStart(String sessionId) async {
    _logger.d(() => '[onSessionStart] sessionId: $sessionId');
    _postReduced(CallSessionStartAction(sessionId: sessionId));
  }

  @override
  Future<void> onConnected() async {
    _logger.d(() => '[onConnected] no args');
    _postReduced(const CallConnectedAction());
  }

  @override
  Future<void> onDisconnect() async {
    _logger.d(() => '[onDisconnect] no args');
    _postReduced(const CallDestroyedAction());
  }

  @override
  Future<void> onSfuEvent(SfuEventV2 event) async {
    if (event is SfuHealthCheckResponseEvent) {
      return;
    }
    _logger.d(() => '[onSfuEvent] event: $event');
    if (event is SfuJoinResponseEvent) {
      final participants = event.callState.participants;
      final users = await _queryUsersByIds(
        participants.map((it) => it.userId).toSet(),
      );
      _postReduced(SfuJoinedAction(participants: participants, users: users));
    } else if (event is SfuParticipantJoinedEvent) {
      final user = await _queryUserById(event.participant.userId);
      _postReduced(
        SfuParticipantJoinedAction(participant: event.participant, user: user),
      );
    } else {
      _postReduced(SfuEventAction(event));
    }
  }

  @override
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event) async {
    if (event is CoordinatorHealthCheckEvent) {
      return;
    }
    _logger.d(() => '[onCoordinatorEvent] event: $event');
    _postReduced(CoordinatorAction(event));
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

  void _postReduced(StreamAction action) {
    final reduced = _stateReducer.reduce(_state.value, action);
    _post(state: reduced);
  }

  void _post({required CallStateV2 state}) {
    if (state != _state.value) {
      _logger.v(() => '[post] state: $state');
      _state.value = state;
    }
  }
}
