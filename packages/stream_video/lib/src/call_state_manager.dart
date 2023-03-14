import 'action/action.dart';
import 'action/call_control_action.dart';
import 'action/coordinator_call_action.dart';
import 'action/lifecycle_action.dart';
import 'action/rtc_action.dart';
import 'action/sfu_action.dart';
import 'call_state.dart';
import 'coordinator/coordinator_socket_listener.dart';
import 'coordinator/models/coordinator_events.dart';
import 'errors/video_error.dart';
import 'logger/impl/tagged_logger.dart';
import 'logger/stream_log.dart';
import 'models/call_created.dart';
import 'models/call_joined.dart';
import 'models/call_metadata.dart';
import 'models/call_received_created.dart';
import 'models/queried_members.dart';
import 'reducer/call_state_reducer.dart';
import 'sfu/data/events/sfu_events.dart';
import 'sfu/data/models/sfu_track_type.dart';
import 'state_emitter.dart';
import 'stream_video.dart';
import 'utils/result.dart';

const _tag = 'SV:StateManager';
int _stateSeq = 1;
bool _verbose = false;

abstract class CoordinatorCallEventListener extends CoordinatorEventListener {
  @override
  Future<void> onCoordinatorEvent(CoordinatorCallEvent event);
}

abstract class CallStateManager implements CoordinatorCallEventListener {
  const CallStateManager();
  StateEmitter<CallState> get state;
  Future<void> onUserIdSet(String userId);
  Future<void> onCallCreated(CallCreated data);
  Future<void> onCallReceivedOrCreated(CallReceivedOrCreated data);
  Future<void> onCallJoining();
  Future<void> onCallJoined(CallJoined data);
  Future<void> onSessionStart(String sessionId);
  Future<void> onConnected();
  Future<void> onDisconnect();
  Future<void> onCallControlAction(CallControlAction action);
  Future<void> onSfuEvent(SfuEvent event);
  Future<void> onWaitingTimeout(Duration dropTimeout);
  Future<void> onConnectFailed(VideoError error);

  void onSubscriberTrackReceived(String trackIdPrefix, SfuTrackType trackType);
}

class CallStateManagerImpl extends CallStateManager {
  CallStateManagerImpl({
    required CallState initialState,
    required StreamVideo streamVideo,
  })  : _streamVideo = streamVideo,
        _state = MutableStateEmitterImpl(initialState),
        _stateReducer = CallStateReducer() {
    streamLog.i(_tag, () => '<init> initialState: $initialState');
  }

  late final _logger = taggedLogger(tag: '$_tag-$_stateSeq');

  final StreamVideo _streamVideo;
  final CallStateReducer _stateReducer;
  final MutableStateEmitter<CallState> _state;

  @override
  StateEmitter<CallState> get state => _state;

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
  Future<void> onCallJoining() async {
    _logger.d(() => '[onJoining] no args');
    _postReduced(const CallJoiningAction());
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
  Future<void> onSfuEvent(SfuEvent event) async {
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
      _postReduced(
        CoordinatorCallUsersAction(users: users.toUnmodifiableMap()),
      );
    } else if (event is SfuParticipantJoinedEvent) {
      final users = await _queryUsersByIds({event.participant.userId});
      _logger.v(() => '[onSfuEvent] received coord users: $users');
      _postReduced(
          CoordinatorCallUsersAction(users: users.toUnmodifiableMap()));
    }
  }

  @override
  Future<void> onCoordinatorEvent(CoordinatorCallEvent event) async {
    _logger.d(() => '[onCoordinatorEvent] event: $event');
    _postReduced(CoordinatorCallEventAction(event));
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

  Future<List<CallUser>> _queryUsersByIds(
    Set<String> userIds,
  ) async {
    final callCid = state.value.callCid;
    final usersResult =
        await _streamVideo.queryMembers(callCid: callCid, userIds: userIds);
    if (usersResult is! Success<QueriedMembers>) {
      return List.empty();
    }
    return usersResult.data.users.values.toList();
  }

  void _postReduced(StreamAction action) {
    if (_verbose) _logger.v(() => '[postReduced] state: ${_state.value}');
    final reduced = _stateReducer.reduce(_state.value, action);
    if (_verbose) _logger.v(() => '[postReduced] reduced: $reduced');
    _postState(state: reduced);
  }

  void _postState({required CallState state}) {
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
