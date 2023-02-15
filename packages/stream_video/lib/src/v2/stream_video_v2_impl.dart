import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/push_v1/push.pb.dart';

import '../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../logger/impl/tagged_logger.dart';
import '../logger/logger.dart';
import '../models/user_info.dart';
import '../push_notification/no_op_push_notification.dart';
import '../push_notification/push_notification_manager.dart';
import '../token/token.dart';
import '../token/token_manager.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/coordinator_ws.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/models/coordinator_input.dart' as input;
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/protobuf/coordinator_client_protobuf.dart';
import 'coordinator/protobuf/coordinator_ws_protobuf.dart';
import 'coordinator/protobuf/mapper_extensions.dart';
import 'model/call_cid.dart';
import 'model/call_created.dart';
import 'model/call_joined.dart';
import 'model/call_received_created.dart';
import 'shared_emitter.dart';
import 'state_emitter.dart';
import 'stream_video_v2.dart';
import 'utils/none.dart';
import 'utils/result.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

typedef PushNotificationFactory = Future<PushNotificationManager> Function(
    StreamVideoV2);

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
class StreamVideoV2Impl implements StreamVideoV2 {
  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideoV2Impl(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = StreamVideoV2Impl.defaultLogHandler,
    PushNotificationFactory pushNotificationFactrory =
        defaultPushNotificationManager,
  }) {
    return StreamVideoV2Impl._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
      pushNotificationFactrory: pushNotificationFactrory,
    );
  }

  StreamVideoV2Impl._(
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

    _client = CoordinatorClientProtobuf(
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
  late final CoordinatorClientV2 _client;
  late final PushNotificationManager _pushNotificationManager;

  var _state = _StreamVideoStateV2();

  @override
  UserInfo? get currentUser => _state.currentUser.value;

  CoordinatorWebSocketV2? _ws;
  StreamSubscription<CoordinatorEventV2>? _wsSubscription;

  @override
  SharedEmitter<CoordinatorEventV2> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEventV2>();

  @override
  void Function(CallCreated)? onCallCreated;

  /// Default log handler function for the [StreamVideoV2Impl] logger.
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

    logger.info('setting user : ${user.id}');

    _state.currentUser.value = user;
    await _tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    try {
      _ws = CoordinatorWebSocketProtobuf(
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
    } catch (e, stk) {
      logger.severe('error connecting user : ${user.id}', e, stk);
      rethrow;
    }
  }

  /// Disconnects the [user] from the Stream Video service.
  @override
  Future<void> disconnectUser() async {
    logger.info('disconnecting user : ${currentUser?.id}');

    if (_ws == null) return;
    await _ws?.disconnect();
    _ws = null;
    await _wsSubscription?.cancel();
    _wsSubscription = null;
    _tokenManager.reset();

    // Resetting the state.
    await _state.close();
    _state = _StreamVideoStateV2();
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
      rpc.CreateCallRequest(
        type: cid.type,
        id: cid.id,
        input: rpc.CreateCallInput(
          members: participantIds.map((id) {
            return rpc.MemberInput(
              userId: id,
              role: 'admin',
            );
          }),
          ring: ringing,
        ),
      ),
    );

    return response.fold(
      success: (it) {
        final finalResult = CallCreated(
          callCid: cid,
          ringing: ringing,
          metadata: it.data.call.toCallMetadata(),
        );

        _logger.v(() => '[createCall] completed: $finalResult');
        return Result.success(finalResult);
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
      rpc.GetOrCreateCallRequest(
        id: cid.id,
        type: cid.type,
        input: rpc.CreateCallInput(
          members: participantIds.map((id) {
            return rpc.MemberInput(
              userId: id,
              role: 'admin',
            );
          }),
          ring: ringing,
        ),
      ),
    );

    return response.fold(
      success: (it) {
        final finalResult = CallReceivedOrCreated(
          wasCreated: it.data.created,
          data: CallCreated(
            callCid: cid,
            ringing: ringing,
            metadata: it.data.call.toCallMetadata(),
          ),
        );

        _logger.v(() => '[getOrCreateCall] completed: $finalResult');
        return Result.success(finalResult);
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
      rpc.JoinCallRequest(type: cid.type, id: cid.id),
    );
    if (joinResult is! Success<rpc.JoinCallResponse>) {
      _logger.e(() => '[joinCall] join failed: $joinResult');
      return joinResult as Failure;
    }
    final metadata = joinResult.data.call.toCallMetadata();
    onReceivedOrCreated?.call(
      CallReceivedOrCreated(
        wasCreated: joinResult.data.created,
        data: CallCreated(
          callCid: cid,
          ringing: false,
          metadata: metadata,
        ),
      ),
    );
    _logger.v(() => '[joinCall] joinedMetadata: $metadata');
    final edgeResult = await _client.findBestCallEdgeServer(
      callCid: cid.value,
      edges: joinResult.data.edges,
    );
    if (edgeResult is! Success<rpc.GetCallEdgeServerResponse>) {
      _logger.e(() => '[joinCall] edge finding failed: $joinResult');
      return joinResult as Failure;
    }
    final call = CallJoined(
      callCid: cid,
      wasCreated: joinResult.data.created,
      metadata: edgeResult.data.call.toCallMetadata(),
      credentials: edgeResult.data.credentials.toCallCredentials(),
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
    required Map<String, dynamic> dataJson,
  }) async {
    final result = await _client.sendCustomEvent(
      input.CustomEventInput(
        callCid: cid,
        eventType: eventType,
        dataJson: dataJson,
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
    final mqJson = {
      'id': {
        r'$in': userIds.toList(),
      },
    };
    _logger.d(() => '[queryUsers] mqJson: $mqJson');
    final request = rpc.QueryUsersRequest(
      mqJson: utf8.encode(
        json.encode(mqJson),
      ),
    );
    _logger.v(() => '[queryUsers] request: $request');
    final usersResult = await _client.queryUsers(request);

    return usersResult.fold(
      success: (it) {
        final users = it.data.users.toCallUsers();
        _logger.v(() => '[queryUsers] completed: $users');
        return Result.success(users);
      },
      failure: (it) => it,
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
  Future<void> createDevice({
    required String token,
    required String pushProviderId,
  }) async {
    await _client.createDevice(CreateDeviceRequest(
      input: DeviceInput(
        id: token,
        pushProviderId: pushProviderId,
      ),
    ));
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

class _StreamVideoStateV2 {
  final MutableStateEmitter<UserInfo?> currentUser = MutableStateEmitterImpl();

  Future<void> close() async {
    await currentUser.close();
  }
}
