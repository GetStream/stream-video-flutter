import 'dart:async';

import '../stream_video.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/models/coordinator_inputs.dart' as input;
import 'coordinator/models/coordinator_inputs.dart';
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'coordinator/retry/coordinator_client_retry.dart';
import 'errors/video_error_composer.dart';
import 'internal/_instance_holder.dart';
import 'logger/impl/external_logger.dart';
import 'models/call_device.dart';
import 'models/call_permission.dart';
import 'models/call_reaction.dart';
import 'models/queried_calls.dart';
import 'models/queried_members.dart';
import 'retry/retry_policy.dart';
import 'shared_emitter.dart';
import 'state_emitter.dart';
import 'token/token_manager.dart';
import 'utils/none.dart';
import 'webrtc/sdp/policy/sdp_policy.dart';

const _tag = 'SV:Client';
const _defaultCoordinatorRpcUrl = 'https://video.stream-io-api.com/video';
const _defaultCoordinatorWsUrl = 'wss://video.stream-io-api.com/video/connect';

/// Handler function used for logging.
typedef LogHandlerFunction = void Function(
  Priority priority,
  String tag,
  MessageBuilder message, [
  Object? error,
  StackTrace? stk,
]);

/// The client responsible for handling config and maintaining calls
class StreamVideo {
  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideo(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    RetryPolicy retryPolicy = const RetryPolicy(),
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
  }) {
    return StreamVideo._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
    );
  }

  StreamVideo._(
    this.apiKey, {
    required this.coordinatorRpcUrl,
    required this.coordinatorWsUrl,
    required this.latencyMeasurementRounds,
    required this.retryPolicy,
    required this.sdpPolicy,
  }) {
    _client = buildCoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      retryPolicy: retryPolicy,
      rpcUrl: coordinatorRpcUrl,
      wsUrl: coordinatorWsUrl,
    );
  }

  static final InstanceHolder _instanceHolder = InstanceHolder();

  static StreamVideo init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    RetryPolicy retryPolicy = const RetryPolicy(),
    Priority logPriority = Priority.none,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
  }) {
    _setupLogger(logPriority, logHandlerFunction);
    return _instanceHolder.init(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
    );
  }

  /// The singleton instance of the Stream Video client.
  static StreamVideo get instance {
    return _instanceHolder.instance;
  }

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnectUser = false}) async {
    if (disconnectUser) {
      await _instanceHolder.instance.disconnectUser();
    }
    return _instanceHolder.reset();
  }

  /// Return if the singleton instance of the Stream Video Client has already
  /// been initialized.
  static bool isInitialized() {
    return _instanceHolder.isInitialized();
  }

  final _logger = taggedLogger(tag: _tag);

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final int latencyMeasurementRounds;

  /// Returns the current [RetryPolicy].
  final RetryPolicy retryPolicy;

  /// Returns the current [SdpPolicy].
  final SdpPolicy sdpPolicy;

  final _tokenManager = TokenManager();
  late final CoordinatorClient _client;
  PushNotificationManager? _pushNotificationManager;

  var _state = _StreamVideoState();

  StreamSubscription<CoordinatorEvent>? _eventSubscription;

  set pushNotificationManager(PushNotificationManager pushNotificationManager) {
    _pushNotificationManager = pushNotificationManager;
  }

  /// Returns the current user if exists.
  UserInfo? get currentUser => _state.currentUser.valueOrNull;

  /// You can subscribe to WebSocket events provided by the API.
  /// Please note that subscribing to WebSocket events is an advanced use-case,
  /// for most use-cases it should be enough to watch for changes
  /// in the reactive [Call.state].
  SharedEmitter<CoordinatorEvent> get events => _client.events;

  /// Invoked when a call was created by another user.
  void Function(CallCreatedData)? onCallCreated;

  /// Connects the [user] to the Stream Video service using a [TokenProvider].
  /// This method is great if your service requires tokens to be refreshed.
  ///
  /// For applications outside of test and development, this method may be more
  /// suitable as token refreshes are handled for you.
  Future<Result<String>> connectUserWithProvider(
    UserInfo user, {
    required TokenProvider tokenProvider,
  }) async {
    _logger.i(() => '[connectUser] user.id : ${user.id}');
    if (currentUser != null) {
      _logger.w(() => '[connectUser] rejected (already set): $currentUser');
      return _tokenManager.getToken();
    }
    final tokenResult = await _tokenManager.setTokenProvider(
      user.id,
      tokenProvider: tokenProvider,
    );
    if (tokenResult.isFailure) {
      return tokenResult;
    }
    _state.currentUser.value = user;

    try {
      _eventSubscription = _client.events.listen((event) {
        _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
        if (event is CoordinatorCallCreatedEvent &&
            event.metadata.details.createdBy.id != user.id) {
          _logger.v(() => '[onCoordinatorEvent] onCallCreated: ${event.data}');
          onCallCreated?.call(event.data);
        }
      });

      final result = await _client.onUserLogin(user);
      await _pushNotificationManager?.onUserLoggedIn();
      if (result is Failure) {
        return result;
      }
      return tokenResult;
    } catch (e, stk) {
      _logger.e(() => '[connectUser] failed(${user.id}): $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnectUser() async {
    _logger.i(() => '[disconnectUser] currentUser.id: ${currentUser?.id}');
    if (currentUser == null) {
      _logger.w(() => '[disconnectUser] rejected (no user): $currentUser');
      return Result.success(None());
    }
    try {
      await _client.onUserLogout();
      await _eventSubscription?.cancel();
      _eventSubscription = null;
      _tokenManager.reset();

      // Resetting the state.
      await _state.close();
      _state = _StreamVideoState();
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[disconnectUser] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Receives a call or creates it with given information. You can then use
  /// the [CallReceivedOrCreatedData] in order to create a [Call] object.
  Future<Result<CallReceivedOrCreatedData>> getOrCreateCall({
    required StreamCallCid cid,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    _logger.d(
      () => '[getOrCreateCall] cid: $cid, ringing: $ringing, '
          'participantIds: $participantIds',
    );

    final currentUserId = _state.currentUser.value?.id;
    if (currentUserId == null) {
      _logger.e(() => '[getOrCreateCall] failed (no userId)');
      return Result.error('[createCall] failed; no user_id found');
    }

    final response = await _client.getOrCreateCall(
      input.GetOrCreateCallInput(
        callCid: cid,
        ringing: ringing,
        members: participantIds.map((id) {
          return input.MemberInput(
            userId: id,
            role: 'admin',
          );
        }),
      ),
    );

    return response.fold(
      success: (it) {
        _logger.v(() => '[getOrCreateCall] completed: ${it.data}');
        return it;
      },
      failure: (it) {
        _logger.e(() => '[getOrCreateCall] failed: ${it.error}');
        return it;
      },
    );
  }

  /// Allows you to create a new call with the given parameters
  /// and joins the call immediately.
  ///
  /// If a call with the same [cid] already exists,
  /// it will join the existing call.
  Future<Result<CallJoinedData>> joinCall({
    required StreamCallCid cid,
    bool create = false,
    void Function(CallReceivedOrCreatedData)? onReceivedOrCreated,
  }) async {
    _logger.d(() => '[joinCall] cid: $cid');
    final joinResult = await _client.joinCall(
      input.JoinCallInput(callCid: cid, create: create),
    );
    if (joinResult is! Success<CoordinatorJoined>) {
      _logger.e(() => '[joinCall] join failed: $joinResult');
      return joinResult as Failure;
    }
    onReceivedOrCreated?.call(
      CallReceivedOrCreatedData(
        wasCreated: joinResult.data.wasCreated,
        data: CallCreatedData(
          callCid: cid,
          ringing: false,
          metadata: joinResult.data.metadata,
        ),
      ),
    );
    _logger.v(() => '[joinCall] joinedMetadata: ${joinResult.data.metadata}');
    final edgeResult = await _client.findBestCallEdgeServer(
      callCid: cid,
      edges: joinResult.data.edges,
    );
    if (edgeResult is! Success<SfuServerSelected>) {
      _logger.e(() => '[joinCall] edge finding failed: $joinResult');
      return joinResult as Failure;
    }
    final call = CallJoinedData(
      callCid: cid,
      wasCreated: joinResult.data.wasCreated,
      metadata: edgeResult.data.metadata,
      credentials: edgeResult.data.credentials,
    );
    _logger.v(() => '[joinCall] completed: $call');
    return Result.success(call);
  }

  /// Signals other users that I have accepted the incoming call.
  /// Causes the [CoordinatorCallAcceptedEvent] event to be emitted
  /// to all the call members.
  Future<Result<None>> acceptCall({
    required StreamCallCid cid,
  }) async {
    return _sendEvent(
      cid: cid,
      eventType: input.EventTypeInput.accepted,
    );
  }

  /// Signals other users that I have rejected the incoming call.
  /// Causes the [CoordinatorCallRejectedEvent] event to be emitted
  /// to all the call members.
  Future<Result<None>> rejectCall({
    required StreamCallCid cid,
  }) async {
    return _sendEvent(
      cid: cid,
      eventType: input.EventTypeInput.rejected,
    );
  }

  Future<Result<None>> _sendEvent({
    required StreamCallCid cid,
    required input.EventTypeInput eventType,
  }) async {
    final result = await _client.sendUserEvent(
      input.EventInput(
        callCid: cid,
        eventType: eventType,
      ),
    );

    return result.fold(
      success: (_) => Result.success(None()),
      failure: (it) => it,
    );
  }

  /// Sends a custom event to the API to notify if we've changed something
  /// in the state of the call.
  Future<Result<None>> sendCustomEvent({
    required StreamCallCid cid,
    required String eventType,
    required Map<String, Object> extraData,
  }) async {
    final result = await _client.sendCustomEvent(
      input.CustomEventInput(
        callCid: cid,
        eventType: eventType,
        custom: extraData,
      ),
    );

    return result.fold(
      success: (_) => Result.success(None()),
      failure: (it) => it,
    );
  }

  /// Queries the API for members of a call.
  Future<Result<QueriedMembers>> queryMembers({
    required StreamCallCid callCid,
    required Set<String> userIds,
  }) async {
    _logger.d(() => '[queryMembers] callCid: $callCid, userIds: $userIds');
    final usersResult = await _client.queryMembers(
      input.QueryUsersInput(
        callCid: callCid,
        filterConditions: {
          'user_id': {r'$in': userIds.toList()},
        },
        sorts: const [
          input.SortInput(field: 'user_id', direction: input.DirectionInput.asc)
        ],
        limit: userIds.length,
      ),
    );
    return usersResult.fold(
      success: (it) {
        _logger.v(() => '[queryMembers] completed: ${it.data}');
        return Result.success(it.data);
      },
      failure: (it) {
        _logger.e(() => '[queryMembers] failed: $it');
        return it;
      },
    );
  }

  /// Queries the API for calls.
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    int? limit,
  }) {
    return _client.queryCalls(
      input.QueryCallsInput(
        filterConditions: filterConditions,
        next: next,
        limit: limit,
      ),
    );
  }

  // TODO: Not supported
  Future<Result<None>> inviteUsers({
    required String callCid,
    required List<UserInfo> users,
  }) async {
    return _client.inviteUsers(
      input.UpsertCallMembersInput(
        callCid: StreamCallCid(cid: callCid),
        members: users.map((user) {
          return input.MemberInput(userId: user.id, role: user.role);
        }).toList(),
      ),
    );
  }

  /// Sends a `call.permission_request` event to all users connected
  /// to the call. The call settings object contains information about
  /// which permissions can be requested during a call (for example a user
  /// might be allowed to request permission to publish audio, but not video).
  Future<Result<None>> requestPermissions({
    required StreamCallCid callCid,
    required List<CallPermission> permissions,
  }) async {
    final result = await _client.requestPermissions(
      input.RequestPermissionsInput(
        callCid: callCid,
        permissions: permissions,
      ),
    );

    return result;
  }

  /// Allows you to grant or revoke a specific permission to a user in a call.
  /// The permissions are specific to the call experience and
  /// do not survive the call itself.
  ///
  /// When revoking a permission, this endpoint will also mute the relevant
  /// track from the user. This is similar to muting a user with the
  /// difference that the user will not be able to unmute afterwards.
  ///
  /// Supported permissions that can be granted or revoked:
  /// `send-audio`, `send-video` and `screenshare`.
  ///
  /// `call.permissions_updated` event is sent to all members of the call.
  Future<Result<None>> updateUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    List<CallPermission> grantPermissions = const [],
    List<CallPermission> revokePermissions = const [],
  }) async {
    final result = await _client.updateUserPermissions(
      input.UpdateUserPermissionsInput(
        callCid: callCid,
        userId: userId,
        grantPermissions: grantPermissions,
        revokePermissions: revokePermissions,
      ),
    );

    return result;
  }

  /// Starts recording for the call described by the given [callCid].
  Future<Result<None>> startRecording({
    required StreamCallCid callCid,
  }) async {
    return _client.startRecording(callCid);
  }

  /// Stops recording for the call described by the given [callCid].
  Future<Result<None>> stopRecording({
    required StreamCallCid callCid,
  }) {
    return _client.stopRecording(callCid);
  }

  /// Starts broadcasting for the call described by the given [callCid].
  Future<Result<None>> startBroadcasting({
    required StreamCallCid callCid,
  }) async {
    return _client.startBroadcasting(callCid);
  }

  /// Stops broadcasting for the call described by the given [callCid].
  Future<Result<None>> stopBroadcasting({
    required StreamCallCid callCid,
  }) async {
    return _client.stopBroadcasting(callCid);
  }

  Future<Result<None>> blockUser({
    required StreamCallCid callCid,
    required String userId,
  }) async {
    return _client.blockUser(BlockUserInput(callCid: callCid, userId: userId));
  }

  Future<Result<None>> unblockUser({
    required StreamCallCid callCid,
    required String userId,
  }) async {
    return _client.unblockUser(
      UnblockUserInput(
        callCid: callCid,
        userId: userId,
      ),
    );
  }

  Future<Result<CallMetadata>> goLive({
    required StreamCallCid callCid,
  }) async {
    return _client.goLive(callCid);
  }

  Future<Result<CallMetadata>> stopLive({
    required StreamCallCid callCid,
  }) async {
    return _client.stopLive(callCid);
  }

  /// Signals other users that I have cancelled my call to them before
  /// they accepted it.
  /// Causes the [CoordinatorCallEndedEvent] event to be emitted
  /// to all the call members.
  ///
  /// Cancelling a call is only possible before the local participant
  /// joined the call.
  Future<Result<None>> endCall({
    required StreamCallCid callCid,
  }) async {
    return _client.endCall(callCid);
  }

  Future<Result<None>> muteUsers({
    required StreamCallCid callCid,
    required List<String> userIds,
  }) async {
    return _client.muteUsers(
      input.MuteUsersInput(
        callCid: callCid,
        userIds: userIds,
      ),
    );
  }

  Future<Result<CallReaction>> sendReaction({
    required StreamCallCid callCid,
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) {
    return _client.sendReaction(
      input.ReactionInput(
        callCid: callCid,
        reactionType: reactionType,
        emojiCode: emojiCode,
        custom: custom,
      ),
    );
  }

  Future<Result<CallDevice>> createDevice({
    required String token,
    required String pushProviderId,
  }) async {
    return _client.createDevice(
      CreateDeviceInput(
        pushToken: token,
        pushProviderId: pushProviderId,
      ),
    );
  }

  Future<bool> handlePushNotification(Map<String, dynamic> payload) {
    return _pushNotificationManager?.handlePushNotification(payload) ??
        Future.value(false);
  }

  Future<CallCreatedData?> consumeIncomingCall() {
    return _pushNotificationManager?.consumeIncomingCall() ?? Future.value();
  }
}

class _StreamVideoState {
  final MutableStateEmitter<UserInfo?> currentUser =
      MutableStateEmitterImpl(null);

  Future<void> close() async {
    await currentUser.close();
  }
}

CoordinatorClient buildCoordinatorClient({
  required String rpcUrl,
  required String wsUrl,
  required String apiKey,
  required TokenManager tokenManager,
  required RetryPolicy retryPolicy,
}) {
  streamLog.i(_tag, () => '[buildCoordinatorClient] rpcUrl: $rpcUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] wsUrl: $wsUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] apiKey: $apiKey');
  return CoordinatorClientRetry(
    retryPolicy: retryPolicy,
    delegate: CoordinatorClientOpenApi(
      apiKey: apiKey,
      tokenManager: tokenManager,
      retryPolicy: retryPolicy,
      rpcUrl: rpcUrl,
      wsUrl: wsUrl,
    ),
  );
}

void _setupLogger(Priority logPriority, LogHandlerFunction logHandlerFunction) {
  if (logPriority != Priority.none) {
    StreamLog().priority = logPriority;
    StreamLog().logger = CompositeStreamLogger([
      const ConsoleStreamLogger(),
      ExternalStreamLogger(logHandlerFunction),
    ]);
  }
}

/// Default log handler function for the [StreamVideo] logger.
void _defaultLogHandler(
  Priority priority,
  String tag,
  MessageBuilder message, [
  Object? error,
  StackTrace? stk,
]) {
  /* no-op */
}

const _defaultSdpPolicy = SdpPolicy();

extension StreamVideoX on StreamVideo {
  /// Connects the [user] to the Stream Video service using a static token.
  Future<Result<String>> connectUser(
    UserInfo user,
    String token,
  ) {
    return connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.static(token),
    );
  }

  /// Grants the [permissions] to the [userId] in the [callCid].
  Future<Result<None>> grantUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    required List<CallPermission> permissions,
  }) {
    return updateUserPermissions(
      callCid: callCid,
      userId: userId,
      grantPermissions: permissions,
    );
  }

  /// Revokes the [permissions] from the [userId] in the [callCid].
  Future<Result<None>> revokeUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    required List<CallPermission> permissions,
  }) {
    return updateUserPermissions(
      callCid: callCid,
      userId: userId,
      revokePermissions: permissions,
    );
  }
}
