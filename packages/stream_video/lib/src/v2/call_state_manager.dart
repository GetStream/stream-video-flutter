import 'package:collection/collection.dart';

import '../logger/impl/tagged_logger.dart';
import '../logger/stream_log.dart';
import 'action/action.dart';
import 'action/call_control_action.dart';
import 'action/coordinator_action.dart';
import 'action/lifecycle_action.dart';
import 'action/rtc_action.dart';
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
import 'sfu/data/models/sfu_track_type.dart';
import 'state_emitter.dart';
import 'stream_video_v2.dart';
import 'utils/result.dart';

const _tag = 'SV:StateManager';
int _stateSeq = 1;

abstract class CallStateManager {
  const CallStateManager();
  StateEmitter<CallStateV2> get state;
  Future<void> onUserIdSet(String userId);
  Future<void> onCallCreated(CallCreated data);
  Future<void> onCallJoined(CallJoined data);
  Future<void> onCallReceivedOrCreated(CallReceivedOrCreated data);
  Future<void> onSessionStart(String sessionId);
  Future<void> onConnected();
  Future<void> onDisconnect();
  Future<void> onCallControlAction(CallControlAction action);
  Future<void> onSfuEvent(SfuEventV2 event);
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event);
  Future<void> onWaitingTimeout(Duration dropTimeout);
  Future<void> onConnectFailed(VideoError error);

  void onSubscriberTrackReceived(String trackIdPrefix, SfuTrackType trackType);
}

class CallStateManagerImpl extends CallStateManager {
  CallStateManagerImpl({
    required CallStateV2 initialState,
    required StreamVideoV2 streamVideo,
  })  : _streamVideo = streamVideo,
        _state = MutableStateEmitterImpl(initialState),
        _stateReducer = CallStateReducer() {
    streamLog.i(_tag, () => '<init> initialState: $initialState');
  }

  late final _logger = taggedLogger(tag: '$_tag-$_stateSeq');

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
    _logger.d(() => '[onCallControlAction] action: $action');
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
  Future<void> onCallJoined(CallJoined data) async {
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
    _postReduced(const CallDisconnectedAction());
  }

  @override
  Future<void> onSfuEvent(SfuEventV2 event) async {
    if (event is SfuHealthCheckResponseEvent) {
      return;
    }
    _logger.d(() => '[onSfuEvent] event: $event');
    _postReduced(SfuEventAction(event));
    if (event is SfuJoinResponseEvent) {
      final participants = event.callState.participants;
      final users = await _queryUsersByIds(
        participants.map((it) => it.userId).toSet(),
      );
      _logger.v(() => '[onSfuEvent] received coord users: $users');
      _postReduced(CoordinatorUsersAction(users: users.toUnmodifiableMap()));
    } else if (event is SfuParticipantJoinedEvent) {
      final users = await _queryUsersByIds({event.participant.userId});
      _logger.v(() => '[onSfuEvent] received coord users: $users');
      _postReduced(CoordinatorUsersAction(users: users.toUnmodifiableMap()));
    }
  }

  @override
  Future<void> onCoordinatorEvent(CoordinatorEventV2 event) async {
    if (event is CoordinatorHealthCheckEvent) {
      return;
    }
    _logger.d(() => '[onCoordinatorEvent] event: $event');
    _postReduced(CoordinatorEventAction(event));
  }

  @override
  void onSubscriberTrackReceived(String trackIdPrefix, SfuTrackType trackType) {
    _logger.d(
      () => '[onSubscriberTrackReceived] trackIdPrefix: $trackIdPrefix,'
          ' trackType: $trackType',
    );
    _postReduced(
      SubscriberTrackReceivedAction(
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      ),
    );
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
    _logger.v(() => '[postReduced] state: ${_state.value}');
    final reduced = _stateReducer.reduce(_state.value, action);
    _logger.v(() => '[postReduced] reduced: $reduced');
    _postState(state: reduced);
  }

  void _postState({required CallStateV2 state}) {
    if (state != _state.value) {
      _logger.v(() => '[postState] state: $state');
      _state.value = state;
    }
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
