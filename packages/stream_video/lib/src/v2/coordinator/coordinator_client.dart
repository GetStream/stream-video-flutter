import '../model/call_cid.dart';
import '../model/call_created.dart';
import '../model/call_device.dart';
import '../model/call_metadata.dart';
import '../model/call_received_created.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'models/coordinator_inputs.dart' as inputs;
import 'models/coordinator_models.dart' as models;

abstract class CoordinatorClientV2 {
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

  Future<Result<List<CallUser>>> queryUsers(
    inputs.QueryUsersInput input,
  );
}
