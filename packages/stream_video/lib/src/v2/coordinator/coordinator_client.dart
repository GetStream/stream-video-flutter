import 'package:tart/tart.dart';

import '../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import '../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pbtwirp.dart';
import '../../../protobuf/video/coordinator/edge_v1/edge.pb.dart';
import '../../latency_service/latency.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../token/token_manager.dart';
import '../errors/video_error_composer.dart';
import '../utils/result.dart';

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClientV2 {
  CoordinatorClientV2({
    required String baseUrl,
    required this.apiKey,
    required this.tokenManager,
  }) : _rpclient = ClientRPCProtobufClient(baseUrl, '');

  final _logger = taggedLogger(tag: 'SV:CoordClient');
  final String apiKey;
  final TokenManager tokenManager;

  final ClientRPC _rpclient;

  /// Create a new Device used to receive Push Notifications.
  Future<Result<CreateDeviceResponse>> createDevice(
    CreateDeviceRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.createDevice(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Deletes a Device used to receive Push Notifications.
  Future<Result<void>> deleteDevice(DeleteDeviceRequest request) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.deleteDevice(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Attempts to create a new call.
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
  Future<Result<SendEventResponse>> sendUserEvent(
    SendEventRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.sendEvent(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends a custom event with encoded JSON data.
  Future<Result<SendCustomEventResponse>> sendCustomEvent(
    SendCustomEventRequest request,
  ) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.sendCustomEvent(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends invite to people for an existing call.
  Future<Result<void>> inviteUsers(UpsertCallMembersRequest request) async {
    try {
      final result = await _withAuthHeaders().then((ctx) {
        return _rpclient.upsertCallMembers(ctx, request).then(Result.success);
      });

      return result;
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Queries users based on the given [request].
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
