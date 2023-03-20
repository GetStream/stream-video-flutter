import 'dart:async';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../errors/video_error_composer.dart';
import '../../latency_service/latency.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_created.dart';
import '../../models/call_device.dart';
import '../../models/call_metadata.dart';
import '../../models/call_reaction.dart';
import '../../models/call_received_created.dart';
import '../../models/queried_calls.dart';
import '../../models/queried_members.dart';
import '../../models/user_info.dart';
import '../../shared_emitter.dart';
import '../../token/token_manager.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../coordinator_client.dart';
import '../models/coordinator_events.dart';
import '../models/coordinator_inputs.dart' as inputs;
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

  String? userId;

  final open.ApiClient _apiClient;
  late final defaultApi = open.DefaultApi(_apiClient);
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
    inputs.CreateDeviceInput input,
  ) async {
    return Result.error('not implemented');
  }

  /// Deletes a Device used to receive Push Notifications.
  @override
  Future<Result<None>> deleteDevice(inputs.DeleteDeviceInput input) async {
    return Result.error('not implemented');
  }

  /// Gets the call if already exists or attempts to create a new call.
  @override
  Future<Result<CallReceivedOrCreated>> getOrCreateCall(
    inputs.GetOrCreateCallInput input,
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
        return Result.error('getOrCreateCall result is null');
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

  /// Attempts to join a Call. If successful, gives us more information
  /// about the user and the call itself.
  @override
  Future<Result<CoordinatorJoined>> joinCall(inputs.JoinCallInput input) async {
    try {
      final result = await videoApi.joinCallTypeId0(
        input.callCid.type,
        input.callCid.id,
        open.JoinCallRequest(
          connectionId: _ws?.clientId,
        ),
        connectionId: _ws?.clientId,
      );
      if (result == null) {
        return Result.error('joinCall result is null');
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

  /// Finds the correct server to connect to for given user and request.
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
        return Result.error('selectCallEdgeServer result is null');
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
    inputs.EventInput input,
  ) async {
    try {
      _logger.d(() => '[sendUserEvent] input: $input');
      final result = await eventsApi.sendEvent(
        input.callCid.type,
        input.callCid.id,
        open.SendEventRequest(type: input.eventType.alias),
      );
      _logger.v(() => '[sendUserEvent] completed: $result');
      if (result == null) {
        return Result.error('sendUserEvent result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[sendUserEvent] failed: $e; $stk');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends a custom event with encoded JSON data.
  @override
  Future<Result<None>> sendCustomEvent(
    inputs.CustomEventInput input,
  ) async {
    try {
      _logger.d(() => '[sendCustomEvent] input: $input');
      final result = await eventsApi.sendEvent(
        input.callCid.type,
        input.callCid.id,
        open.SendEventRequest(
          type: input.eventType,
          custom: input.custom,
        ),
      );
      _logger.v(() => '[sendCustomEvent] completed: $result');
      if (result == null) {
        return Result.error('sendCustomEvent result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[sendCustomEvent] failed: $e; $stk');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sends invite to people for an existing call.
  @override
  Future<Result<None>> inviteUsers(inputs.UpsertCallMembersInput input) async {
    try {
      // TODO

      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> requestPermissions(
    inputs.RequestPermissionsInput input,
  ) async {
    try {
      final result = await defaultApi.requestPermission(
        input.callCid.type,
        input.callCid.id,
        open.RequestPermissionRequest(
          permissions: [...input.permissions.map((e) => e.alias)],
        ),
      );
      if (result == null) {
        return Result.error('requestPermissions result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> updateUserPermissions(
    inputs.UpdateUserPermissionsInput input,
  ) async {
    try {
      final result = await defaultApi.updateUserPermissions(
        input.callCid.type,
        input.callCid.id,
        open.UpdateUserPermissionsRequest(
          userId: input.userId,
          grantPermissions: [...input.grantPermissions.map((e) => e.alias)],
          revokePermissions: [...input.revokePermissions.map((e) => e.alias)],
        ),
      );
      if (result == null) {
        return Result.error('updateUserPermissions result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> startRecording(StreamCallCid callCid) async {
    try {
      await defaultApi.startRecording(callCid.type, callCid.id);
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> stopRecording(StreamCallCid callCid) async {
    try {
      await defaultApi.stopRecording(callCid.type, callCid.id);
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> startBroadcasting(StreamCallCid callCid) async {
    try {
      await defaultApi.startBroadcasting(callCid.type, callCid.id);
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> stopBroadcasting(StreamCallCid callCid) async {
    try {
      await defaultApi.stopBroadcasting(callCid.type, callCid.id);
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<CallReaction>> sendReaction(inputs.ReactionInput input) async {
    try {
      final result = await defaultApi.sendVideoReaction(
        input.callCid.type,
        input.callCid.id,
        open.SendReactionRequest(
          type: input.reactionType,
          emojiCode: input.emojiCode,
          custom: input.custom,
        ),
      );
      if (result == null) {
        return Result.error('sendReaction result is null');
      }
      return Result.success(result.reaction.toCallReaction());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Queries users based on the given [input].
  @override
  Future<Result<QueriedMembers>> queryMembers(
    inputs.QueryUsersInput input,
  ) async {
    try {
      final result = await videoApi.queryMembers(
        open.QueryMembersRequest(
          type: input.callCid.type,
          id: input.callCid.id,
          filterConditions: input.filterConditions,
          next: input.next,
          prev: input.prev,
          sort: input.sorts.toOpenDto(),
          limit: input.limit,
        ),
      );
      if (result == null) {
        return Result.error('queryMembers result is null');
      }
      return Result.success(result.toQueriedMembers(input.callCid));
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Queries calls based on the given [input].
  @override
  Future<Result<QueriedCalls>> queryCalls(
    inputs.QueryCallsInput input,
  ) async {
    try {
      final result = await defaultApi.queryCalls(
        open.QueryCallsRequest(
          filterConditions: input.filterConditions,
          next: input.next,
          prev: input.prev,
          sort: input.sorts.toOpenDto(),
          limit: input.limit,
        ),
      );
      if (result == null) {
        return Result.error('queryCalls result is null');
      }
      return Result.success(result.toQueriedCalls());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> blockUser(inputs.BlockUserInput input) async {
    try {
      final result = await videoApi.blockUser(
        input.callCid.type,
        input.callCid.id,
        open.BlockUserRequest(userId: input.userId),
      );
      if (result == null) {
        return Result.error('blockUser result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> unblockUser(inputs.UnblockUserInput input) async {
    try {
      final result = await videoApi.unblockUser(
        input.callCid.type,
        input.callCid.id,
        open.UnblockUserRequest(userId: input.userId),
      );
      if (result == null) {
        return Result.error('unblockUser result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> endCall(StreamCallCid callCid) async {
    try {
      final result = await videoApi.endCall(callCid.type, callCid.id);
      if (result == null) {
        return Result.error('endCall result is null');
      }
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<CallMetadata>> goLive(StreamCallCid callCid) async {
    try {
      final result = await videoApi.goLive(callCid.type, callCid.id);
      if (result == null) {
        return Result.error('goLive result is null');
      }

      return Result.success(result.call.toCallMetadata());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<CallMetadata>> stopLive(StreamCallCid callCid) async {
    try {
      final result = await videoApi.stopLive(callCid.type, callCid.id);
      if (result == null) {
        return Result.error('stopLive result is null');
      }

      return Result.success(result.call.toCallMetadata());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<None>> muteUsers(MuteUsersInput input) async {
    try {
      final result = await videoApi.muteUsers(
        input.callCid.type,
        input.callCid.id,
        open.MuteUsersRequest(
          userIds: input.userIds,
          muteAllUsers: input.muteAllUsers,
          audio: input.audio,
          video: input.video,
          screenshare: input.screenshare,
        ),
      );
      if (result == null) {
        return Result.error('stopLive result is null');
      }

      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<CallMetadata>> updateCall(inputs.UpdateCallInput input) async {
    try {
      final result = await videoApi.updateCall(
        input.callCid.type,
        input.callCid.id,
        open.UpdateCallRequest(
          settingsOverride: input.settingsOverride?.toOpenDto(),
          custom: input.custom,
        ),
      );
      if (result == null) {
        return Result.error('updateCall result is null');
      }
      return Result.success(result.call.toCallMetadata());
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
