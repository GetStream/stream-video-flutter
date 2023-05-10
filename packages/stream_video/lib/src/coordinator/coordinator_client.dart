import '../lifecycle/lifecycle_state.dart';
import '../models/call_cid.dart';
import '../models/call_device.dart';
import '../models/call_metadata.dart';
import '../models/call_reaction.dart';
import '../models/call_received_created_data.dart';
import '../models/queried_calls.dart';
import '../models/queried_members.dart';
import '../models/user_info.dart';
import '../shared_emitter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'models/coordinator_events.dart';
import 'models/coordinator_inputs.dart' as inputs;
import 'models/coordinator_models.dart' as models;

abstract class CoordinatorClient {

  SharedEmitter<CoordinatorEvent> get events;

  Future<Result<None>> connectUser(UserInfo user);

  Future<Result<None>> openConnection();

  Future<Result<None>> closeConnection();

  Future<Result<None>> disconnectUser();

  Future<Result<CallDevice>> createDevice(
    inputs.CreateDeviceInput input,
  );

  Future<Result<None>> deleteDevice(inputs.DeleteDeviceInput input);

  Future<Result<CallReceivedOrCreatedData>> getOrCreateCall(
    inputs.GetOrCreateCallInput input,
  );

  Future<Result<models.CoordinatorJoined>> joinCall(inputs.JoinCallInput input);

  Future<Result<models.SfuServerSelected>> findBestCallEdgeServer({
    required StreamCallCid callCid,
    required List<models.SfuEdge> edges,
  });

  Future<Result<models.SfuServerSelected>> selectCallEdgeServer({
    required StreamCallCid callCid,
    required Map<String, models.SfuLatency> latencyByEdge,
  });

  Future<Result<None>> sendUserEvent(
    inputs.EventInput input,
  );

  /// Sends a custom event to the API to notify if we've changed something
  /// in the state of the call.
  Future<Result<None>> sendCustomEvent(
    inputs.CustomEventInput input,
  );

  Future<Result<None>> inviteUsers(inputs.UpsertCallMembersInput input);

  /// Sends a `call.permission_request` event to all users connected
  /// to the call. The call settings object contains information about
  /// which permissions can be requested during a call (for example a user
  /// might be allowed to request permission to publish audio, but not video).
  Future<Result<None>> requestPermissions(inputs.RequestPermissionsInput input);

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
  Future<Result<None>> updateUserPermissions(
    inputs.UpdateUserPermissionsInput input,
  );

  /// Starts recording for the call described by the given [callCid].
  Future<Result<None>> startRecording(StreamCallCid callCid);

  /// Stops recording for the call described by the given [callCid].
  Future<Result<None>> stopRecording(StreamCallCid callCid);

  /// Starts broadcasting for the call described by the given [callCid].
  Future<Result<None>> startBroadcasting(StreamCallCid callCid);

  /// Stops broadcasting for the call described by the given [callCid].
  Future<Result<None>> stopBroadcasting(StreamCallCid callCid);

  Future<Result<CallReaction>> sendReaction(inputs.ReactionInput input);

  /// Queries the API for members of a call.
  Future<Result<QueriedMembers>> queryMembers(inputs.QueryUsersInput input);

  Future<Result<QueriedCalls>> queryCalls(inputs.QueryCallsInput input);

  Future<Result<None>> blockUser(inputs.BlockUserInput input);

  Future<Result<None>> unblockUser(inputs.UnblockUserInput input);

  /// Signals other users that I have cancelled my call to them before
  /// they accepted it.
  /// Causes the [CoordinatorCallEndedEvent] event to be emitted
  /// to all the call members.
  ///
  /// Cancelling a call is only possible before the local participant
  /// joined the call.
  Future<Result<None>> endCall(StreamCallCid callCid);

  Future<Result<CallMetadata>> goLive(StreamCallCid callCid);

  Future<Result<CallMetadata>> stopLive(StreamCallCid callCid);

  Future<Result<None>> muteUsers(inputs.MuteUsersInput input);

  Future<Result<CallMetadata>> updateCall(inputs.UpdateCallInput input);
}

extension CoordinatorClientX on CoordinatorClient {
  /// Signals other users that I have accepted the incoming call.
  /// Causes the [CoordinatorCallAcceptedEvent] event to be emitted
  /// to all the call members.
  Future<Result<None>> acceptCall({
    required StreamCallCid cid,
  }) async {
    return sendUserEvent(
      inputs.EventInput(
        callCid: cid,
        eventType: inputs.EventTypeInput.accepted,
      ),
    );
  }

  /// Signals other users that I have rejected the incoming call.
  /// Causes the [CoordinatorCallRejectedEvent] event to be emitted
  /// to all the call members.
  Future<Result<None>> rejectCall({
    required StreamCallCid cid,
  }) async {
    return sendUserEvent(
      inputs.EventInput(
        callCid: cid,
        eventType: inputs.EventTypeInput.rejected,
      ),
    );
  }
}
