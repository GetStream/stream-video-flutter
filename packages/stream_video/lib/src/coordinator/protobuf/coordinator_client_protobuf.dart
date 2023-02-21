import 'dart:convert';

import 'package:tart/tart.dart';

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pbtwirp.dart';
import '../../../../protobuf/video/coordinator/edge_v1/edge.pb.dart';
import '../../../../protobuf/video/coordinator/push_v1/push.pb.dart';
import '../../errors/video_error_composer.dart';
import '../../latency_service/latency.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_created.dart';
import '../../models/call_device.dart';
import '../../models/call_metadata.dart';
import '../../models/call_received_created.dart';
import '../../token/token_manager.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../coordinator_client.dart';
import '../models/coordinator_inputs.dart' as input;
import '../models/coordinator_models.dart';
import 'mapper_extensions.dart';

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClientProtobuf extends CoordinatorClient {
  CoordinatorClientProtobuf({
    required String baseUrl,
    required this.apiKey,
    required this.tokenManager,
  }) : _rpclient = ClientRPCProtobufClient(baseUrl, '');

  final _logger = taggedLogger(tag: 'SV:CoordClientProto');
  final String apiKey;
  final TokenManager tokenManager;

  final ClientRPC _rpclient;

  /// Create a new Device used to receive Push Notifications.
  @override
  Future<Result<CallDevice>> createDevice(
    input.CreateDeviceInput input,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient
            .createDevice(
              ctx,
              CreateDeviceRequest(
                input: DeviceInput(
                  id: input.pushToken,
                  pushProviderId: input.pushProviderId,
                ),
              ),
            )
            .then(Result.success);
      });

      return result.map(
        (data) => CallDevice(
          userId: data.device.userId,
          pushToken: data.device.id,
          pushProviderName: data.device.pushProviderName,
          createdAt: data.device.createdAt.toDateTime(),
          updatedAt: data.device.updatedAt.toDateTime(),
        ),
      );
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Deletes a Device used to receive Push Notifications.
  @override
  Future<Result<None>> deleteDevice(input.DeleteDeviceInput input) async {
    try {
      await _withAuthHeaders().then((ctx) {
        return _rpclient
            .deleteDevice(
              ctx,
              DeleteDeviceRequest(
                id: input.pushToken,
              ),
            )
            .then(Result.success);
      });

      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Attempts to create a new call.
  @override
  Future<Result<CallCreated>> createCall(
    input.CreateCallInput input,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient
            .createCall(
              ctx,
              CreateCallRequest(
                type: input.callCid.type,
                id: input.callCid.id,
                input: CreateCallInput(
                  ring: input.ringing,
                  members: input.members?.map((it) => it.toDto()),
                ),
              ),
            )
            .then(Result.success);
      });
      return result.map(
        (data) => CallCreated(
          callCid: input.callCid,
          ringing: input.ringing ?? false,
          metadata: data.call.toCallMetadata(),
        ),
      );
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Gets the call if already exists or attempts to create a new call.
  @override
  Future<Result<CallReceivedOrCreated>> getOrCreateCall(
    input.GetOrCreateCallInput input,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient
            .getOrCreateCall(
              ctx,
              GetOrCreateCallRequest(
                type: input.callCid.type,
                id: input.callCid.id,
                input: CreateCallInput(
                  ring: input.ringing,
                  members: input.members?.map((it) => it.toDto()),
                ),
              ),
            )
            .then(Result.success);
      });

      return result.map(
        (data) => CallReceivedOrCreated(
          wasCreated: data.created,
          data: CallCreated(
            callCid: input.callCid,
            ringing: input.ringing ?? false,
            metadata: data.call.toCallMetadata(),
          ),
        ),
      );
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Attempts to join a [Call]. If successful, gives us more information
  /// about the user and the call itself.
  @override
  Future<Result<CoordinatorJoined>> joinCall(input.JoinCallInput input) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient
            .joinCall(
              ctx,
              JoinCallRequest(
                type: input.callCid.type,
                id: input.callCid.id,
              ),
            )
            .then(Result.success);
      });

      return result.map((data) {
        return CoordinatorJoined(
          wasCreated: data.created,
          metadata: data.call.toCallMetadata(),
          edges: data.edges.map((edge) {
            return SfuEdge(
              name: edge.name,
              latencyUrl: edge.latencyUrl,
            );
          }).toList(),
        );
      });
    } catch (e, stk) {
      _logger.e(() => '[joinCall] failed: $e, stk: $stk');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<SfuServerSelected>> findBestCallEdgeServer({
    required StreamCallCid callCid,
    required List<SfuEdge> edges,
  }) async {
    _logger.d(
      () => '[findBestCallEdgeServer] callCid: $callCid, '
          'edges.length: ${edges.length}',
    );
    final latencyByEdge = await measureEdgeLatencies(edges: edges);
    _logger.v(() => '[findBestCallEdgeServer] latencyByEdge: $latencyByEdge');
    final response = await selectCallEdgeServer(
      callCid: callCid,
      latencyByEdge: latencyByEdge,
    );
    response.when(
      success: (data) {
        final server = data.credentials.sfuServer;
        _logger.v(() => '[findBestCallEdgeServer] selectedEdge: $server');
      },
      failure: (error) {
        _logger.e(() => '[findBestCallEdgeServer] failed: $error');
      },
    );
    return response;
  }

  /// Finds the correct server to connect to for given user and [request].
  @override
  Future<Result<SfuServerSelected>> selectCallEdgeServer({
    required StreamCallCid callCid,
    required Map<String, SfuLatency> latencyByEdge,
  }) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient
            .getCallEdgeServer(
              ctx,
              GetCallEdgeServerRequest(
                callCid: callCid.value,
                measurements: LatencyMeasurements(
                  measurements: latencyByEdge.map(
                    (name, latency) => MapEntry(
                      name,
                      Latency(
                        measurementsSeconds: latency.measurementsSeconds,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .then(Result.success);
      });

      return result.map(
        (data) => SfuServerSelected(
          metadata: data.call.toCallMetadata(),
          credentials: data.credentials.toCallCredentials(),
        ),
      );
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends a user-based event to the API to notify if we've changed something
  /// in the state of the call.
  @override
  Future<Result<None>> sendUserEvent(
    input.EventInput input,
  ) async {
    try {
      await _withAuthHeaders().then((ctx) {
        return _rpclient
            .sendEvent(
              ctx,
              SendEventRequest(
                callCid: input.callCid.value,
                eventType: input.eventType.toDto(),
              ),
            )
            .then(Result.success);
      });

      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends a custom event with encoded JSON data.
  @override
  Future<Result<None>> sendCustomEvent(
    input.CustomEventInput input,
  ) async {
    try {
      await _withAuthHeaders().then((ctx) {
        return _rpclient
            .sendCustomEvent(
              ctx,
              SendCustomEventRequest(
                callCid: input.callCid.value,
                type: input.eventType,
                dataJson: utf8.encode(
                  json.encode(input.dataJson),
                ),
              ),
            )
            .then(Result.success);
      });

      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends invite to people for an existing call.
  @override
  Future<Result<None>> inviteUsers(input.UpsertCallMembersInput input) async {
    try {
      await _withAuthHeaders().then((ctx) {
        return _rpclient
            .upsertCallMembers(
              ctx,
              UpsertCallMembersRequest(
                callCid: input.callCid.value,
                members: input.members.map((member) => member.toDto()),
                ring: input.ringing,
              ),
            )
            .then(Result.success);
      });

      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Queries users based on the given [input].
  @override
  Future<Result<List<CallUser>>> queryUsers(
    input.QueryUsersInput input,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient
            .queryUsers(
              ctx,
              QueryUsersRequest(
                mqJson: utf8.encode(
                  json.encode(input.mqJson),
                ),
                limit: input.limit,
                sorts: input.sorts?.map((it) => it.toDto()),
              ),
            )
            .then(Result.success);
      });
      return result.map((data) => data.users.toCallUsers());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Context> _withAuthHeaders([Context? ctx]) async {
    ctx ??= Context();
    final token = await tokenManager.loadToken();
    return withHttpRequestHeaders(ctx, {
      'api_key': apiKey,
      'Authorization': 'Bearer ${token.rawValue}',
    });
  }
}
