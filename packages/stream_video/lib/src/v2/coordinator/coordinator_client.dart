import '../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../../protobuf/video/coordinator/edge_v1/edge.pb.dart' as edge;
import '../utils/none.dart';
import '../utils/result.dart';
import 'models/coordinator_input.dart' as input;
import 'models/coordinator_models.dart' as model;

abstract class CoordinatorClientV2 {
  Future<Result<model.Device>> createDevice(
    input.CreateDeviceInput input,
  );

  Future<Result<None>> deleteDevice(input.DeleteDeviceInput input);

  Future<Result<rpc.CreateCallResponse>> createCall(
    rpc.CreateCallRequest request,
  );

  Future<Result<rpc.GetOrCreateCallResponse>> getOrCreateCall(
    rpc.GetOrCreateCallRequest request,
  );

  Future<Result<rpc.JoinCallResponse>> joinCall(rpc.JoinCallRequest request);

  Future<Result<rpc.GetCallEdgeServerResponse>> findBestCallEdgeServer({
    required String callCid,
    required List<edge.Edge> edges,
  });

  Future<Result<rpc.GetCallEdgeServerResponse>> selectCallEdgeServer(
    rpc.GetCallEdgeServerRequest request,
  );

  Future<Result<None>> sendUserEvent(
    input.EventInput input,
  );

  Future<Result<None>> sendCustomEvent(
    input.CustomEventInput input,
  );

  Future<Result<None>> inviteUsers(input.UpsertCallMembersInput input);

  Future<Result<rpc.QueryUsersResponse>> queryUsers(
    rpc.QueryUsersRequest request,
  );
}
