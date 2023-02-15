import 'dart:convert';

import 'package:tart/tart.dart';

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pbtwirp.dart';
import '../../../../protobuf/video/coordinator/edge_v1/edge.pb.dart';
import '../../../../protobuf/video/coordinator/push_v1/push.pb.dart';
import '../../../../protobuf/video/coordinator/user_v1/user.pb.dart';
import '../../../latency_service/latency.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../token/token_manager.dart';
import '../../errors/video_error_composer.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../utils/standard.dart';
import '../coordinator_client.dart';
import '../models/coordinator_input.dart' as input;
import '../models/coordinator_models.dart' as model;
import 'mapper_extensions.dart';

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClientProtobuf extends CoordinatorClientV2 {
  CoordinatorClientProtobuf({
    required String baseUrl,
    required this.apiKey,
    required this.tokenManager,
  }) : _rpclient = ClientRPCProtobufClient(baseUrl, '');

  final _logger = taggedLogger(tag: 'SV:CoordClient');
  final String apiKey;
  final TokenManager tokenManager;

  final ClientRPC _rpclient;

  /// Create a new Device used to receive Push Notifications.
  @override
  Future<Result<model.Device>> createDevice(
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
        (data) => model.Device(
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
  Future<Result<CreateCallResponse>> createCall(
    CreateCallRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.createCall(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Gets the call if already exists or attempts to create a new call.
  @override
  Future<Result<GetOrCreateCallResponse>> getOrCreateCall(
    GetOrCreateCallRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.getOrCreateCall(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Attempts to join a [Call]. If successful, gives us more information
  /// about the user and the call itself.
  @override
  Future<Result<JoinCallResponse>> joinCall(JoinCallRequest request) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.joinCall(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<GetCallEdgeServerResponse>> findBestCallEdgeServer({
    required String callCid,
    required List<Edge> edges,
  }) async {
    _logger.d(
      () => '[findBestCallEdgeServer] callCid: $callCid, '
          'edges.length: ${edges.length}',
    );
    final latencyByEdge = await measureEdgeLatencies(edges: edges);
    _logger.v(() => '[findBestCallEdgeServer] latencyByEdge: $latencyByEdge');
    final response = await selectCallEdgeServer(
      GetCallEdgeServerRequest(
        callCid: callCid,
        measurements: LatencyMeasurements(
          measurements: latencyByEdge,
        ),
      ),
    );
    response.when(
      success: (data) {
        final server = data.credentials.server;
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
  Future<Result<GetCallEdgeServerResponse>> selectCallEdgeServer(
    GetCallEdgeServerRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.getCallEdgeServer(ctx, request).then(Result.success);
      });

      return result;
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
                members: input.members.map((member) {
                  return MemberInput(
                    userId: member.userId,
                    role: member.role,
                    customJson: utf8.encode(
                      json.encode(member.customJson),
                    ),
                    userInput: UserInput(
                      id: member.userInput?.id,
                      name: member.userInput?.name,
                      role: member.userInput?.role,
                      teams: member.userInput?.teams,
                      imageUrl: member.userInput?.imageUrl,
                      customJson: member.userInput?.customJson?.let(
                        (it) => utf8.encode(
                          json.encode(it),
                        ),
                      ),
                    ),
                  );
                }),
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

  /// Queries users based on the given [request].
  @override
  Future<Result<QueryUsersResponse>> queryUsers(
    QueryUsersRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.queryUsers(ctx, request).then(Result.success);
      });

      return result;
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
