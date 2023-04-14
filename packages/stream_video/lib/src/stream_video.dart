import 'dart:async';

import '../stream_video.dart';
import 'coordinator/models/coordinator_events.dart';
import 'internal/_instance_holder.dart';
import 'logger/impl/external_logger.dart';
import 'models/call_device.dart';
import 'models/call_permission.dart';
import 'models/call_reaction.dart';
import 'models/queried_calls.dart';
import 'models/queried_members.dart';
import 'retry/retry_policy.dart';
import 'shared_emitter.dart';
import 'stream_video_impl.dart';
import 'utils/none.dart';
import 'webrtc/sdp/codec/sdp_codec.dart';
import 'webrtc/sdp/policy/sdp_policy.dart';
import 'webrtc/sdp/sdp.dart';

/// Handler function used for logging.
typedef LogHandlerFunction = void Function(
  Priority priority,
  String tag,
  MessageBuilder message, [
  Object? error,
  StackTrace? stk,
]);

const _defaultCoordinatorRpcUrl = 'https://video.stream-io-api.com/video';
const _defaultCoordinatorWsUrl = 'wss://video.stream-io-api.com/video/connect';

/// The client responsible for handling config and maintaining calls
abstract class StreamVideo {
  factory StreamVideo(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    RetryPolicy retryPolicy = const RetryPolicy(),
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
  }) {
    return StreamVideoImpl(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
    );
  }

  static final InstanceHolder _instanceHolder = InstanceHolder();

  set pushNotificationManager(PushNotificationManager pushNotificationManager);

  /// Returns the current [RetryPolicy].
  RetryPolicy get retryPolicy;

  /// Returns the current [SdpPolicy].
  SdpPolicy get sdpPolicy;

  /// Returns the current user if exists.
  UserInfo? get currentUser;

  /// You can subscribe to WebSocket events provided by the API.
  /// Please note that subscribing to WebSocket events is an advanced use-case,
  /// for most use-cases it should be enough to watch for changes
  /// in the reactive [Call.state].
  SharedEmitter<CoordinatorEvent> get events;

  /// Invoked when a call was created by another user.
  void Function(CallCreated)? onCallCreated;

  /// Connects the [user] to the Stream Video service.
  Future<Result<String>> connectUser(
    UserInfo user, {
    required TokenProvider tokenProvider,
  });

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnectUser();

  /// Receives a call or creates it with given information. You can then use
  /// the [CallReceivedOrCreated] in order to create a [Call] object.
  Future<Result<CallReceivedOrCreated>> getOrCreateCall({
    required StreamCallCid cid,
    List<String> participantIds = const [],
    bool ringing = false,
  });

  /// Allows you to create a new call with the given parameters
  /// and joins the call immediately.
  ///
  /// If a call with the same [cid] already exists,
  /// it will join the existing call.
  Future<Result<CallJoined>> joinCall({
    required StreamCallCid cid,
    bool create = false,
    void Function(CallReceivedOrCreated)? onReceivedOrCreated,
  });

  /// Signals other users that I have accepted the incoming call.
  /// Causes the [CoordinatorCallAcceptedEvent] event to be emitted
  /// to all the call members.
  Future<Result<None>> acceptCall({
    required StreamCallCid cid,
  });

  /// Signals other users that I have rejected the incoming call.
  /// Causes the [CoordinatorCallRejectedEvent] event to be emitted
  /// to all the call members.
  Future<Result<None>> rejectCall({
    required StreamCallCid cid,
  });

  /// Sends a custom event to the API to notify if we've changed something
  /// in the state of the call.
  Future<Result<None>> sendCustomEvent({
    required StreamCallCid cid,
    required String eventType,
    required Map<String, Object> extraData,
  });

  /// Queries the API for members of a call.
  Future<Result<QueriedMembers>> queryMembers({
    required StreamCallCid callCid,
    required Set<String> userIds,
  });

  /// Queries the API for calls.
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    int? limit,
  });

  // TODO not supported
  Future<Result<None>> inviteUsers({
    required String callCid,
    required List<UserInfo> users,
  });

  /// Sends a `call.permission_request` event to all users connected
  /// to the call. The call settings object contains information about
  /// which permissions can be requested during a call (for example a user
  /// might be allowed to request permission to publish audio, but not video).
  Future<Result<None>> requestPermissions({
    required StreamCallCid callCid,
    required List<CallPermission> permissions,
  });

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
  });

  /// Starts recording for the call described by the given [callCid].
  Future<Result<None>> startRecording({
    required StreamCallCid callCid,
  });

  /// Stops recording for the call described by the given [callCid].
  Future<Result<None>> stopRecording({
    required StreamCallCid callCid,
  });

  /// Starts broadcasting for the call described by the given [callCid].
  Future<Result<None>> startBroadcasting({
    required StreamCallCid callCid,
  });

  /// Stops broadcasting for the call described by the given [callCid].
  Future<Result<None>> stopBroadcasting({
    required StreamCallCid callCid,
  });

  Future<Result<None>> blockUser({
    required StreamCallCid callCid,
    required String userId,
  });

  Future<Result<None>> unblockUser({
    required StreamCallCid callCid,
    required String userId,
  });

  Future<Result<CallMetadata>> goLive({
    required StreamCallCid callCid,
  });

  Future<Result<CallMetadata>> stopLive({
    required StreamCallCid callCid,
  });

  /// Signals other users that I have cancelled my call to them before
  /// they accepted it.
  /// Causes the [CoordinatorCallEndedEvent] event to be emitted
  /// to all the call members.
  ///
  /// Cancelling a call is only possible before the local participant
  /// joined the call.
  Future<Result<None>> endCall({
    required StreamCallCid callCid,
  });

  Future<Result<None>> muteUsers({
    required StreamCallCid callCid,
    required List<String> userIds,
  });

  Future<Result<CallReaction>> sendReaction({
    required StreamCallCid callCid,
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  });

  Future<Result<CallDevice>> createDevice({
    required String token,
    required String pushProviderId,
  });

  Future<bool> handlePushNotification(Map<String, dynamic> payload);

  Future<CallCreated?> consumeIncomingCall();

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

const _defaultSdpPolicy = SdpPolicy(
  mungingEnabled: true,
  rules: [
    PrioritizeCodecRule(
      platforms: [PlatformType.android],
      types: [SdpType.localOffer],
      codec: VideoCodec.vp8,
    ),
  ],
);

extension StreamVideoX on StreamVideo {
  /// Connects the [user] to the Stream Video service.
  Future<Result<String>> connectUserWithToken(
    UserInfo user,
    String token,
  ) {
    return connectUser(user, tokenProvider: TokenProvider.static(token));
  }

  /// Connects the [user] to the Stream Video service.
  Future<Result<String>> connectUserWithProvider(
    UserInfo user,
    TokenProvider provider,
  ) {
    return connectUser(user, tokenProvider: provider);
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
