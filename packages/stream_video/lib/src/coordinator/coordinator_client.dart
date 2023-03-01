import '../models/call_cid.dart';
import '../models/call_created.dart';
import '../models/call_device.dart';
import '../models/call_metadata.dart';
import '../models/call_reaction.dart';
import '../models/call_received_created.dart';
import '../models/user_info.dart';
import '../shared_emitter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'models/coordinator_events.dart';
import 'models/coordinator_inputs.dart' as inputs;
import 'models/coordinator_models.dart' as models;

abstract class CoordinatorClient {
  SharedEmitter<CoordinatorEvent> get events;

  Future<Result<None>> onUserLogin(UserInfo user);

  Future<Result<None>> onUserLogout();

  Future<Result<CallDevice>> createDevice(
    inputs.CreateDeviceInput input,
  );

  Future<Result<None>> deleteDevice(inputs.DeleteDeviceInput input);

  Future<Result<CallCreated>> createCall(
    inputs.CreateCallInput input,
  );

  Future<Result<CallReceivedOrCreated>> getOrCreateCall(
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

  Future<Result<None>> sendCustomEvent(
    inputs.CustomEventInput input,
  );

  Future<Result<None>> inviteUsers(inputs.UpsertCallMembersInput input);

  Future<Result<None>> requestPermissions(inputs.RequestPermissionsInput input);

  Future<Result<None>> updateUserPermissions(
    inputs.UpdateUserPermissionsInput input,
  );

  Future<Result<None>> startRecording(StreamCallCid callCid);

  Future<Result<None>> stopRecording(StreamCallCid callCid);

  Future<Result<CallReaction>> sendReaction(inputs.ReactionInput input);

  Future<Result<List<CallUser>>> queryUsers(
    inputs.QueryUsersInput input,
  );
}
