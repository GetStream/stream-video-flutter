import '../../open_api/video/coordinator/api.dart' as open;
import '../models/call_cid.dart';
import '../models/call_metadata.dart';
import '../models/call_permission.dart';
import '../models/call_reaction.dart';
import '../models/call_received_created_data.dart';
import '../models/call_received_data.dart';
import '../models/call_settings.dart';
import '../models/guest_created_data.dart';
import '../models/push_device.dart';
import '../models/push_provider.dart';
import '../models/queried_calls.dart';
import '../models/queried_members.dart';
import '../models/user_info.dart';
import '../shared_emitter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'models/coordinator_events.dart';
import 'models/coordinator_models.dart' as models;

abstract class CoordinatorClient {
  SharedEmitter<CoordinatorEvent> get events;

  Future<Result<None>> connectUser(UserInfo user);

  Future<Result<None>> openConnection();

  Future<Result<None>> closeConnection();

  Future<Result<None>> disconnectUser();

  Future<Result<None>> createDevice({
    required String id,
    required PushProvider pushProvider,
    String? pushProviderName,
    String? userId,
    bool? voipToken,
  });

  Future<Result<List<PushDevice>>> listDevices({
    required String userId,
  });

  Future<Result<None>> deleteDevice({
    required String id,
    String? userId,
  });

  Future<Result<CallReceivedData>> getCall({
    required StreamCallCid callCid,
    int? membersLimit,
    bool? ringing,
    bool? notify,
  });

  Future<Result<CallReceivedOrCreatedData>> getOrCreateCall({
    required StreamCallCid callCid,
    bool? ringing,
    List<open.MemberRequest>? members,
  });

  Future<Result<models.CoordinatorJoined>> joinCall({
    required StreamCallCid callCid,
    String? datacenterId,
    bool? ringing,
    bool? create,
  });

  Future<Result<None>> acceptCall({required StreamCallCid cid});

  Future<Result<None>> rejectCall({required StreamCallCid cid});

  /// Sends a custom event to the API to notify if we've changed something
  /// in the state of the call.
  Future<Result<None>> sendCustomEvent({
    required StreamCallCid callCid,
    required String eventType,
    Map<String, Object> custom = const {},
  });

  Future<Result<None>> addMembers({
    required StreamCallCid callCid,
    required Iterable<open.MemberRequest> members,
  });

  Future<Result<None>> removeMembers({
    required StreamCallCid callCid,
    required Iterable<String> removeIds,
  });

  Future<Result<None>> updateCallMembers({
    required StreamCallCid callCid,
    Iterable<open.MemberRequest> updateMembers = const [],
    Iterable<String> removeIds = const [],
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
    required List<CallPermission> grantPermissions,
    required List<CallPermission> revokePermissions,
  });

  /// Starts recording for the call described by the given [callCid].
  Future<Result<None>> startRecording(StreamCallCid callCid);

  /// Returns a list of recording for the associated [callCid] and [sessionId].
  Future<Result<List<open.CallRecording>>> listRecordings(
    StreamCallCid callCid,
    String sessionId,
  );

  /// Stops recording for the call described by the given [callCid].
  Future<Result<None>> stopRecording(StreamCallCid callCid);

  /// Starts broadcasting for the call described by the given [callCid].
  Future<Result<String?>> startBroadcasting(StreamCallCid callCid);

  /// Stops broadcasting for the call described by the given [callCid].
  Future<Result<None>> stopBroadcasting(StreamCallCid callCid);

  Future<Result<CallReaction>> sendReaction({
    required StreamCallCid callCid,
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  });

  /// Queries the API for members of a call.
  Future<Result<QueriedMembers>> queryMembers({
    required StreamCallCid callCid,
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<open.SortParamRequest> sorts = const [],
    int? limit,
  });

  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<open.SortParamRequest> sorts = const [],
    int? limit,
  });

  Future<Result<None>> blockUser({
    required StreamCallCid callCid,
    required String userId,
  });

  Future<Result<None>> unblockUser({
    required StreamCallCid callCid,
    required String userId,
  });

  /// Signals other users that I have cancelled my call to them before
  /// they accepted it.
  /// Causes the [CoordinatorCallEndedEvent] event to be emitted
  /// to all the call members.
  ///
  /// Cancelling a call is only possible before the local participant
  /// joined the call.
  Future<Result<None>> endCall(StreamCallCid callCid);

  Future<Result<CallMetadata>> goLive({
    required StreamCallCid callCid,
    bool? startHls,
    bool? startRecording,
    bool? startTranscription,
  });

  Future<Result<CallMetadata>> stopLive(StreamCallCid callCid);

  Future<Result<None>> muteUsers({
    required StreamCallCid callCid,
    required List<String> userIds,
    bool? muteAllUsers,
    bool? audio,
    bool? video,
    bool? screenshare,
  });

  Future<Result<CallMetadata>> updateCall({
    required StreamCallCid callCid,
    Map<String, Object> custom = const {},
    StreamRingSettings? ring,
    StreamAudioSettings? audio,
    StreamVideoSettings? video,
    StreamScreenShareSettings? screenShare,
    StreamRecordingSettings? recording,
    StreamTranscriptionSettings? transcription,
    StreamBackstageSettings? backstage,
    StreamGeofencingSettings? geofencing,
  });

  Future<Result<GuestCreatedData>> loadGuest({
    required String id,
    String? name,
    String? role,
    String? image,
    List<String>? teams,
    Map<String, Object> custom = const {},
  });
}
