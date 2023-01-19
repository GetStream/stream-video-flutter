import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart';
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/coordinator_client.dart';
import 'package:stream_video/src/coordinator_ws.dart';
import 'package:stream_video/src/core/rx_controller.dart';
import 'package:stream_video/src/core/video_error.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/latency_service/latency.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/token/token.dart';
import 'package:stream_video/src/token/token_manager.dart';
import 'package:stream_video/src/v2/coordinator/ws/coordinator_ws.dart';
import 'package:stream_video/src/v2/shared_emitter.dart';
import 'package:synchronized/synchronized.dart';
import 'package:stream_video/src/v2/coordinator/ws/mapper_extensions.dart';

import '../../protobuf/video/coordinator/event_v1/event.pb.dart';
import 'call/call.dart';
import 'call/call_impl.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/ws/coordinator_events.dart';
import 'coordinator/ws/coordinator_socket_listener.dart';
import 'errors/video_error.dart';
import 'state_emitter.dart';
import 'stream_video_v2.dart';
import 'utils/result.dart';
import 'utils/result_converters.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.

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
  }) {
    return StreamVideoV2Impl._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }

  StreamVideoV2Impl._(
    this.apiKey, {
    required this.coordinatorRpcUrl,
    required this.coordinatorWsUrl,
    required this.latencyMeasurementRounds,
    required Level logLevel,
    required LogHandlerFunction logHandlerFunction,
  }) {
    // Preparing logger
    setLogLevel(logLevel);
    setLogHandler(logHandlerFunction);

    _client = CoordinatorClientV2(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      baseUrl: coordinatorRpcUrl,
    );
  }

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final int latencyMeasurementRounds;

  final _tokenManager = TokenManager();
  late final CoordinatorClientV2 _client;

  var _state = _StreamVideoStateV2();

  @override
  UserInfo? get currentUser => _state.currentUser.value;

  @override
  CallV2? get activeCall => _state.activeCall;

  CoordinatorWebSocketV2? _ws;
  StreamSubscription<CoordinatorEventV2>? _wsSubscription;

  @override
  SharedEmitter<CoordinatorEventV2> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEventV2>();

  Function(CallV2)? onCallCreated;

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
    _tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    try {
      _ws = CoordinatorWebSocketV2(
        coordinatorWsUrl,
        apiKey: apiKey,
        userInfo: user,
        tokenManager: _tokenManager,
      );
      _wsSubscription = _ws?.events.listen((event) {
        if (event is CoordinatorCallCreatedEvent) {
          final currentUserId = _state.currentUser.value?.id;
          if (currentUserId == null) {
            return;
          }
          final metadata = CallMetadata(
            createdByMe: event.info.createdByUserId == currentUserId,
            ringing: event.ringing,
            details: event.details,
            info: event.info,
          );
          final call = CallV2Impl(
            currentUserId: currentUserId,
            callCid: event.callCid,
            coordinatorClient: _client,
            coordinatorWS: _ws!,
            metadata: metadata,
          );
          onCallCreated?.call(call);
          if (event.ringing) {
            _state.activeCall = call;
          }
          _events.emit(event);
        } else if (event is CoordinatorCallAcceptedEvent) {
          // TODO implement
          final call = _state.activeCall;
        } else if (event is CoordinatorCallRejectedEvent) {
          // TODO implement
          final call = _state.activeCall;
        } else if (event is CoordinatorCallCancelledEvent) {
          // TODO implement
          final call = _state.activeCall;
        }
      });

      return _ws!.connect();
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
  Future<Result<CallV2>> createCall({
    required String type,
    required String id,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final currentUserId = _state.currentUser.value?.id;
    if (currentUserId == null) {
      return Failure(
        const VideoError(message: '[createCall] failed; no user_id found'),
      );
    }
    final result = await _client.createCall(
      CreateCallRequest(
        id: id,
        type: type,
        input: CreateCallInput(
          members: participantIds.map((id) {
            return MemberInput(
              userId: id,
              role: 'admin',
            );
          }),
          ring: ringing,
        ),
      ),
    );
    if (result is! Success<CreateCallResponse>) {
      return result as Failure;
    }
    final coordCall = result.data.call;
    final metadata = coordCall.toCallMetadata(ringing: ringing, created: true);

    final call = CallV2Impl(
      currentUserId: currentUserId,
      callCid: coordCall.call.callCid,
      coordinatorClient: _client,
      coordinatorWS: _ws!,
      metadata: metadata,
    );
    if (ringing) {
      _state.activeCall = call;
    }
    return call.toSuccess();
  }

  @override
  Future<Result<CallV2>> getOrCreateCall({
    required String type,
    required String id,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final currentUserId = _state.currentUser.value?.id;
    if (currentUserId == null) {
      return Failure(
        const VideoError(message: '[createCall] failed; no user_id found'),
      );
    }
    final result = await _client.getOrCreateCall(
      GetOrCreateCallRequest(
        id: id,
        type: type,
        input: CreateCallInput(
          members: participantIds.map((id) {
            return MemberInput(
              userId: id,
              role: 'admin',
            );
          }),
          ring: ringing,
        ),
      ),
    );
    if (result is! Success<GetOrCreateCallResponse>) {
      return result as Failure;
    }
    final coordCall = result.data.call;
    final created = result.data.created;
    final metadata = coordCall.toCallMetadata(
      ringing: ringing,
      created: created,
    );

    final call = CallV2Impl(
      currentUserId: currentUserId,
      callCid: coordCall.call.callCid,
      coordinatorClient: _client,
      coordinatorWS: _ws!,
      metadata: metadata,
    );
    if (ringing) {
      _state.activeCall = call;
    }

    return call.toSuccess();
  }

  /*void updateCallStateConnected(Call call) {
    _state.activeCall.value = call;

    // Updating ws about the current call.
    final callInfo = CallInfo(callId: call.callId, callType: call.callType);
    _ws?.callInfo = callInfo;
  }*/

  /*void updateCallStateDisconnected(Call call) {
    _state.activeCall.value = null;

    // Updating ws about the current call.
    _ws?.callInfo = null;
  }*/

  Future<Result<SendEventResponse>> sendEvent({
    required String callCid,
    required UserEventType eventType,
  }) async {
    final result = _client.sendUserEvent(
      SendEventRequest(
        callCid: callCid,
        eventType: eventType,
      ),
    );

    return result;
  }

  Future<Result<SendCustomEventResponse>> sendCustomEvent({
    required String callCid,
    required List<int> dataJson,
    String? eventType,
  }) async {
    final response = _client.sendCustomEvent(
      SendCustomEventRequest(
        callCid: callCid,
        dataJson: dataJson,
        type: eventType,
      ),
    );

    return response;
  }
}

class _StreamVideoStateV2 {
  final MutableStateEmitter<UserInfo?> currentUser = MutableStateEmitterImpl(
    null,
  );

  final MutableStateEmitter<CallV2?> _activeCall = MutableStateEmitterImpl(
    null,
  );

  CallV2? get activeCall {
    return _activeCall.value;
  }

  set activeCall(CallV2? value) {
    if (value != null) {
      value.state.listen((value) {
        activeCall = null;
      });
    }
    _activeCall.value = value;
  }

  Future<void> close() async {
    await currentUser.close();
    await _activeCall.close();
  }
}
