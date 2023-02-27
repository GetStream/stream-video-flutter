import 'dart:async';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../errors/video_error_composer.dart';
import '../../latency_service/latency.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_created.dart';
import '../../models/call_device.dart';
import '../../models/call_metadata.dart';
import '../../models/call_received_created.dart';
import '../../models/user_info.dart';
import '../../shared_emitter.dart';
import '../../token/token_manager.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../coordinator_client.dart';
import '../models/coordinator_events.dart';
import '../models/coordinator_inputs.dart' as input;
import '../models/coordinator_inputs.dart';
import '../models/coordinator_models.dart';
import 'coordinator_ws_open_api.dart';
import 'open_api_extensions.dart';
import 'open_api_mapper_extensions.dart';

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClientOpenApi extends CoordinatorClient {
  CoordinatorClientOpenApi({
    required String rpcUrl,
    required this.wsUrl,
    required this.apiKey,
    required this.tokenManager,
  }) : _apiClient = open.ApiClient(
          basePath: rpcUrl,
          authentication:
              _Authentication(apiKey: apiKey, tokenManager: tokenManager),
        );

  final _logger = taggedLogger(tag: 'SV:CoordClient');
  final String apiKey;
  final String wsUrl;
  final TokenManager tokenManager;

  String? userId = null;

  final open.ApiClient _apiClient;
  late final videoApi = open.VideoCallsApi(_apiClient);
  late final eventsApi = open.EventsApi(_apiClient);
  late final usersApi = open.UsersApi(_apiClient);

  @override
  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEvent>();

  CoordinatorWebSocketOpenApi? _ws;
  StreamSubscription<CoordinatorEvent>? _wsSubscription;

  @override
  Future<Result<None>> onUserLogin(UserInfo user) async {
    try {
      _logger.d(() => '[onUserLogin] user: $user');
      userId = user.id;
      final ws = CoordinatorWebSocketOpenApi(
        wsUrl,
        apiKey: apiKey,
        userInfo: user,
        tokenManager: tokenManager,
      );
      _ws = ws;
      _wsSubscription = ws.events.listen((event) {
        _logger.v(() => '[onWsEvent] event.type: ${event.runtimeType}');

        _events.emit(event);
      });

      await ws.connect();
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[onUserLogin] failed(${user.id}): $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> onUserLogout() async {
    if (_ws == null) {
      return Result.success(None());
    }
    try {
      userId = null;
      await _ws?.disconnect();
      _ws = null;
      await _wsSubscription?.cancel();
      _wsSubscription = null;
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[onUserLogout] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

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
        ringing: input.ringing,
        members: input.members,
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
      _logger.d(() => '[getOrCreateCall] input: $input');
      final result = await videoApi.getOrCreateCall(
        input.callCid.type,
        input.callCid.id,
        open.GetOrCreateCallRequest(
          data: open.CallRequest(
            members: [...?input.members?.toOpenDto()],
          ),
          ring: input.ringing,
        ),
      );
      _logger.v(() => '[getOrCreateCall] completed: $result');
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
      _logger.v(() => '[getOrCreateCall] failed: $e; $stk');
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
          connectionId: _ws?.clientId,
        ),
        connectionId: _ws?.clientId,
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
      _logger.d(() => '[sendUserEvent] input: $input');
      final result = await eventsApi.sendEvent(
        input.callCid.type,
        input.callCid.id,
        open.SendEventRequest(eventType: input.eventType.alias),
      );
      _logger.v(() => '[sendUserEvent] completed: $result');
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[sendUserEvent] failed: $e; $stk');
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
      final result = await videoApi.queryMembers(
        open.QueryMembersRequest(
          type: input.callCid.type,
          id: input.callCid.id,
          filterConditions: input.mqJson,
        ),
      );
      if (result == null) {
        return Result.error('message');
      }
      return Result.success(result.members.toCallUsers().values.toList());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
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
    headerParams['Authorization'] = token.rawValue;
    headerParams['stream-auth-type'] = 'jwt';
  }
}
