import 'package:tart/tart.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../../latency_service/latency.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../token/token_manager.dart';
import '../../errors/video_error_composer.dart';
import '../../model/call_cid.dart';
import '../../model/call_created.dart';
import '../../model/call_device.dart';
import '../../model/call_metadata.dart';
import '../../model/call_received_created.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../coordinator_client.dart';
import '../models/coordinator_inputs.dart' as input;
import '../models/coordinator_inputs.dart';
import '../models/coordinator_models.dart';
import 'open_api_mapper_extensions.dart';

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClientOpenApi extends CoordinatorClientV2 {
  CoordinatorClientOpenApi({
    required String baseUrl,
    required this.apiKey,
    required this.tokenManager,
  }) : _apiClient = open.ApiClient(
          basePath: baseUrl,
          authentication:
              _Authentication(apiKey: apiKey, tokenManager: tokenManager),
        );

  final _logger = taggedLogger(tag: 'SV:CoordClient');
  final String apiKey;
  final TokenManager tokenManager;

  final open.ApiClient _apiClient;
  late final videoApi = open.VideoCallsApi(_apiClient);
  late final eventsApi = open.EventsApi(_apiClient);
  late final usersApi = open.UsersApi(_apiClient);

  /// Create a new Device used to receive Push Notifications.
  @override
  Future<Result<CallDevice>> createDevice(
    input.CreateDeviceInput input,
  ) async {
    return Result.error('not implemented');
  }

  /// Deletes a Device used to receive Push Notifications.
  @override
  Future<Result<None>> deleteDevice(input.DeleteDeviceInput input) async {
    return Result.error('not implemented');
  }

  /// Attempts to create a new call.
  @override
  Future<Result<CallCreated>> createCall(
    input.CreateCallInput input,
  ) async {
    final result = await getOrCreateCall(
      GetOrCreateCallInput(
        callCid: input.callCid,
      ),
    );

    return result.map((data) => data.data);
  }

  /// Gets the call if already exists or attempts to create a new call.
  @override
  Future<Result<CallReceivedOrCreated>> getOrCreateCall(
    input.GetOrCreateCallInput input,
  ) async {
    try {
      final result = await videoApi.getOrCreateCall(
        input.callCid.type,
        input.callCid.id,
        open.GetOrCreateCallRequest(
          data: open.CallRequest(
            members: [
              // TODO
            ],
          ),
          ring: input.ringing,
        ),
      );

      if (result == null) {
        return Result.error('message');
      }

      return Result.success(
        CallReceivedOrCreated(
          wasCreated: result.created,
          data: CallCreated(
            callCid: input.callCid,
            ringing: input.ringing ?? false,
            metadata: result.call.toCallMetadata(),
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
      final result = await videoApi.joinCall(
        input.callCid.type,
        input.callCid.id,
        open.JoinCallRequest(
          // TODO get from health.check event
          connectionId: '',
        ),
      );
      if (result == null) {
        return Result.error('message');
      }

      return Result.success(
        CoordinatorJoined(
          wasCreated: result.created,
          metadata: result.call.toCallMetadata(),
          edges: result.edges.map((edge) {
            return SfuEdge(
              name: edge.name,
              latencyUrl: edge.latencyUrl,
            );
          }).toList(),
        ),
      );
    } catch (e, stk) {
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
      final result = await videoApi.getCallEdgeServer(
        callCid.type,
        callCid.id,
        open.GetCallEdgeServerRequest(
          latencyMeasurements: latencyByEdge.map(
            (name, latency) => MapEntry(name, latency.measurementsSeconds),
          ),
        ),
      );
      if (result == null) {
        return Result.error('message');
      }
      return Result.success(
        SfuServerSelected(
          metadata: result.call.toCallMetadata(),
          credentials: result.credentials.toCallCredentials(),
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
      await eventsApi.sendEvent(
        input.callCid.type,
        input.callCid.id,
        open.SendEventRequest(eventType: input.eventType.alias),
      );
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
      await eventsApi.sendEvent(
        input.callCid.type,
        input.callCid.id,
        open.SendEventRequest(
          eventType: input.eventType,
          custom: input.dataJson,
        ),
      );
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends invite to people for an existing call.
  @override
  Future<Result<None>> inviteUsers(input.UpsertCallMembersInput input) async {
    try {
      // TODO

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
      // TODO
      return const Result.success([]);
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

class _Authentication extends open.Authentication {
  _Authentication({required this.apiKey, required this.tokenManager});

  final String apiKey;
  final TokenManager tokenManager;

  @override
  Future<void> applyToParams(
    List<open.QueryParam> queryParams,
    Map<String, String> headerParams,
  ) async {
    final token = await tokenManager.loadToken();
    headerParams['api_key'] = apiKey;
    headerParams['Authorization'] = 'Bearer ${token.rawValue}';
  }
}
