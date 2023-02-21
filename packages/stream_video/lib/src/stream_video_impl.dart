import 'dart:async';

import 'package:logging/logging.dart';

import '../stream_video.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/coordinator_ws.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/models/coordinator_inputs.dart' as input;
import 'coordinator/models/coordinator_inputs.dart';
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'coordinator/open_api/coordinator_ws_open_api.dart';
import 'coordinator/protobuf/coordinator_client_protobuf.dart';
import 'coordinator/protobuf/coordinator_ws_protobuf.dart';
import 'logger/logger.dart';
import 'models/call_device.dart';
import 'models/call_metadata.dart';
import 'push_notification/no_op_push_notification.dart';
import 'shared_emitter.dart';
import 'state_emitter.dart';
import 'token/token_manager.dart';
import 'utils/none.dart';

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
  Level.SHOUT: '📣',
  Level.FINE: '🔍',
  Level.FINER: '🔎',
  Level.FINEST: '🔎',
  Level.CONFIG: '🔧',
};

const _defaultCoordinatorRpcUrl =
    'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc';
const _defaultCoordinatorWsUrl =
    'wss://wss-video-coordinator.oregon-v1.stream-io-video.com:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect';

/// The client responsible for handling config and maintaining calls
class StreamVideoImpl implements StreamVideo {
  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideoImpl(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = StreamVideoImpl.defaultLogHandler,
    PushNotificationFactory pushNotificationFactrory =
        defaultPushNotificationManager,
  }) {
    return StreamVideoImpl._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
      pushNotificationFactrory: pushNotificationFactrory,
    );
  }

  StreamVideoImpl._(
    this.apiKey, {
    required this.coordinatorRpcUrl,
    required this.coordinatorWsUrl,
    required this.latencyMeasurementRounds,
    required Level logLevel,
    required LogHandlerFunction logHandlerFunction,
    required PushNotificationFactory pushNotificationFactrory,
  }) {
    // Preparing logger
    setLogLevel(logLevel);
    setLogHandler(logHandlerFunction);

    _client = buildCoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      baseUrl: coordinatorRpcUrl,
    );
    _initPushNotificationManager(pushNotificationFactrory);
  }

  final _logger = taggedLogger(tag: 'SV:Client');

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final int latencyMeasurementRounds;

  final _tokenManager = TokenManager();
  late final CoordinatorClient _client;
  late final PushNotificationManager _pushNotificationManager;

  var _state = _StreamVideoState();

  @override
  UserInfo? get currentUser => _state.currentUser.value;

  CoordinatorWebSocket? _ws;
  StreamSubscription<CoordinatorEvent>? _wsSubscription;

  @override
  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEvent>();

  @override
  void Function(CallCreated)? onCallCreated;

  /// Default log handler function for the [StreamVideoImpl] logger.
  static void defaultLogHandler(LogRecord record) {
    print(
      '${record.time} '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '[${record.loggerName}] ${record.message} ',
    );
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  }

  /// Connects the [user] to the Stream Video service.
  @override
  Future<void> connectUser(
    UserInfo user, {
    Token? token,
    TokenProvider? provider,
  }) async {
    if (_ws != null) return;

    _logger.i(() => '[connectUser] user.id : ${user.id}');

    _state.currentUser.value = user;
    await _tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    try {
      _ws = buildCoordinatorWs(
        coordinatorWsUrl,
        apiKey: apiKey,
        userInfo: user,
        tokenManager: _tokenManager,
      );
      _wsSubscription = _ws?.events.listen((event) {
        _logger.v(() => '[onCoordWsEvent] event.type: ${event.runtimeType}');
        if (event is CoordinatorCallCreatedEvent) {
          final currentUserId = _state.currentUser.value?.id;
          if (currentUserId == null) {
            _logger.v(() => '[onCoordWsEvent] rejected(no currentUserId)');
            return;
          }
          final callCreated = CallCreated(
            callCid: StreamCallCid(cid: event.callCid),
            ringing: event.ringing,
            metadata: CallMetadata(
              details: event.details,
              info: event.info,
              users: event.users,
            ),
          );
          _logger.v(() => '[onCoordWsEvent] onCallCreated: $onCallCreated');
          onCallCreated?.call(callCreated);
        }
        _events.emit(event);
      });

      await _ws!.connect();
      return _pushNotificationManager.onUserLoggedIn();
    } catch (e) {
      _logger.e(() => '[connectUser] failed(${user.id}): $e');
      rethrow;
    }
  }

  /// Disconnects the [user] from the Stream Video service.
  @override
  Future<void> disconnectUser() async {
    _logger.i(() => '[disconnectUser] currentUser.id: ${currentUser?.id}');

    if (_ws == null) return;
    await _ws?.disconnect();
    _ws = null;
    await _wsSubscription?.cancel();
    _wsSubscription = null;
    _tokenManager.reset();

    // Resetting the state.
    await _state.close();
    _state = _StreamVideoState();
  }

  @override
  Future<Result<CallCreated>> createCall({
    required StreamCallCid cid,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    _logger.d(
      () => '[createCall] cid: $cid, ringing: $ringing, '
          'participantIds: $participantIds',
    );

    final currentUserId = _state.currentUser.value?.id;
    if (currentUserId == null) {
      _logger.e(() => '[createCall] failed (no userId)');
      return Result.error('[createCall] failed; no user_id found');
    }

    final response = await _client.createCall(
      input.CreateCallInput(
        callCid: cid,
        ringing: ringing,
        members: participantIds.map((id) {
          return input.MemberInput(
            userId: id,
            role: 'admin',
          );
        }),
      ),
    );

    return response.fold(
      success: (it) {
        _logger.v(() => '[createCall] completed: ${it.data}');
        return it;
      },
      failure: (it) {
        _logger.e(() => '[createCall] failed: ${it.error}');
        return it;
      },
    );
  }

  @override
  Future<Result<CallReceivedOrCreated>> getOrCreateCall({
    required StreamCallCid cid,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    _logger.d(
      () => '[getOrCreateCall] cid: $cid, ringing: $ringing, '
          'participantIds: $participantIds',
    );

    final currentUserId = _state.currentUser.value?.id;
    if (currentUserId == null) {
      _logger.e(() => '[getOrCreateCall] failed (no userId)');
      return Result.error('[createCall] failed; no user_id found');
    }

    final response = await _client.getOrCreateCall(
      input.GetOrCreateCallInput(
        callCid: cid,
        ringing: ringing,
        members: participantIds.map((id) {
          return input.MemberInput(
            userId: id,
            role: 'admin',
          );
        }),
      ),
    );

    return response.fold(
      success: (it) {
        _logger.v(() => '[getOrCreateCall] completed: ${it.data}');
        return it;
      },
      failure: (it) {
        _logger.e(() => '[getOrCreateCall] failed: ${it.error}');
        return it;
      },
    );
  }

  @override
  Future<Result<CallJoined>> joinCall({
    required StreamCallCid cid,
    void Function(CallReceivedOrCreated)? onReceivedOrCreated,
  }) async {
    _logger.d(() => '[joinCall] cid: $cid');
    final joinResult = await _client.joinCall(
      input.JoinCallInput(callCid: cid),
    );
    if (joinResult is! Success<CoordinatorJoined>) {
      _logger.e(() => '[joinCall] join failed: $joinResult');
      return joinResult as Failure;
    }
    onReceivedOrCreated?.call(
      CallReceivedOrCreated(
        wasCreated: joinResult.data.wasCreated,
        data: CallCreated(
          callCid: cid,
          ringing: false,
          metadata: joinResult.data.metadata,
        ),
      ),
    );
    _logger.v(() => '[joinCall] joinedMetadata: ${joinResult.data.metadata}');
    final edgeResult = await _client.findBestCallEdgeServer(
      callCid: cid,
      edges: joinResult.data.edges,
    );
    if (edgeResult is! Success<SfuServerSelected>) {
      _logger.e(() => '[joinCall] edge finding failed: $joinResult');
      return joinResult as Failure;
    }
    final call = CallJoined(
      callCid: cid,
      wasCreated: joinResult.data.wasCreated,
      metadata: edgeResult.data.metadata,
      credentials: edgeResult.data.credentials,
    );
    _logger.v(() => '[joinCall] completed: $call');
    return Result.success(call);
  }

  @override
  Future<Result<None>> acceptCall({
    required StreamCallCid cid,
  }) async {
    return _sendEvent(
      cid: cid,
      eventType: input.EventTypeInput.accepted,
    );
  }

  @override
  Future<Result<None>> rejectCall({
    required StreamCallCid cid,
  }) async {
    return _sendEvent(
      cid: cid,
      eventType: input.EventTypeInput.rejected,
    );
  }

  @override
  Future<Result<None>> cancelCall({
    required StreamCallCid cid,
  }) async {
    return _sendEvent(
      cid: cid,
      eventType: input.EventTypeInput.cancelled,
    );
  }

  Future<Result<None>> _sendEvent({
    required StreamCallCid cid,
    required input.EventTypeInput eventType,
  }) async {
    final result = await _client.sendUserEvent(
      input.EventInput(
        callCid: cid,
        eventType: eventType,
      ),
    );

    return result.fold(
      success: (_) => Result.success(None()),
      failure: (it) => it,
    );
  }

  @override
  Future<Result<None>> sendCustomEvent({
    required StreamCallCid cid,
    required String eventType,
    required Map<String, Object> extraData,
  }) async {
    final result = await _client.sendCustomEvent(
      input.CustomEventInput(
        callCid: cid,
        eventType: eventType,
        dataJson: extraData,
      ),
    );

    return result.fold(
      success: (_) => Result.success(None()),
      failure: (it) => it,
    );
  }

  @override
  Future<Result<List<CallUser>>> queryUsers({
    required Set<String> userIds,
  }) async {
    _logger.d(() => '[queryUsers] userIds: $userIds');
    final usersResult = await _client.queryUsers(
      input.QueryUsersInput(
        mqJson: {
          'id': {r'$in': userIds.toList()},
        },
      ),
    );
    return usersResult.fold(
      success: (it) {
        _logger.v(() => '[queryUsers] completed: ${it.data}');
        return Result.success(it.data);
      },
      failure: (it) {
        _logger.e(() => '[queryUsers] failed: $it');
        return it;
      },
    );
  }

  @override
  Future<Result<None>> inviteUsers({
    required String callCid,
    required List<UserInfo> users,
  }) async {
    return _client.inviteUsers(
      input.UpsertCallMembersInput(
        callCid: StreamCallCid(cid: callCid),
        members: users.map((user) {
          return input.MemberInput(userId: user.id, role: user.role);
        }).toList(),
      ),
    );
  }

  @override
  Future<Result<CallDevice>> createDevice({
    required String token,
    required String pushProviderId,
  }) async {
    return _client.createDevice(
      CreateDeviceInput(
        pushToken: token,
        pushProviderId: pushProviderId,
      ),
    );
  }

  @override
  Future<bool> handlePushNotification(Map<String, dynamic> payload) {
    return _pushNotificationManager.handlePushNotification(payload);
  }

  @override
  Future<CallCreated?> consumeIncomingCall() {
    return _pushNotificationManager.consumeIncomingCall();
  }

  Future<void> _initPushNotificationManager(
      PushNotificationFactory pushNotificationManagerFactrory) async {
    _pushNotificationManager = await pushNotificationManagerFactrory(this);
  }
}

class _StreamVideoState {
  final MutableStateEmitter<UserInfo?> currentUser = MutableStateEmitterImpl();

  Future<void> close() async {
    await currentUser.close();
  }
}

CoordinatorClient buildCoordinatorClient({
  required String baseUrl,
  required String apiKey,
  required TokenManager tokenManager,
}) {
  if (StreamVideo.useNewCoordinator) {
    return CoordinatorClientOpenApi(
      apiKey: apiKey,
      tokenManager: tokenManager,
      baseUrl: baseUrl,
    );
  }
  return CoordinatorClientProtobuf(
    apiKey: apiKey,
    tokenManager: tokenManager,
    baseUrl: baseUrl,
  );
}

CoordinatorWebSocket buildCoordinatorWs(
  String url, {
  Iterable<String>? protocols,
  required String apiKey,
  required UserInfo userInfo,
  required TokenManager tokenManager,
}) {
  if (StreamVideo.useNewCoordinator) {
    return CoordinatorWebSocketOpenApi(
      url,
      protocols: protocols,
      apiKey: apiKey,
      userInfo: userInfo,
      tokenManager: tokenManager,
    );
  }
  return CoordinatorWebSocketProtobuf(
    url,
    protocols: protocols,
    apiKey: apiKey,
    userInfo: userInfo,
    tokenManager: tokenManager,
  );
}
