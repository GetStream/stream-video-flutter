import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart';
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/coordinator_client.dart';
import 'package:stream_video/src/coordinator_ws.dart';
import 'package:stream_video/src/core/error/video_error.dart';
import 'package:stream_video/src/core/http/token.dart';
import 'package:stream_video/src/core/http/token_manager.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/core/utils/event_emitter.dart';
import 'package:stream_video/src/core/utils/rx_controller.dart';
import 'package:stream_video/src/latency_service/latency.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/options.dart';
import 'package:synchronized/synchronized.dart';

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

class StreamVideo {
  StreamVideo.init(
    this.apiKey, {
    this.coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    this.coordinatorWsUrl = _defaultCoordinatorWsUrl,
    this.latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = StreamVideo.defaultLogHandler,
  }) {
    _instance = StreamVideo._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );

    // TODO(Deven): Reinitialise values if init is called again
  }

  factory StreamVideo.new(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = StreamVideo.defaultLogHandler,
  }) {
    return StreamVideo._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }

  StreamVideo._(
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

    _client = CoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      baseUrl: coordinatorRpcUrl,
    );
  }

  static late final StreamVideo _instance;
  static StreamVideo get instance {
    try {
      return _instance;
    } catch (e) {
      throw Exception(
        'Please initialise the client using StreamVideo.init() before using the instance.',
      );
    }
  }

  static Future<void> connectUser(
    UserInfo user, {
    Token? token,
    TokenProvider? provider,
  }) async {
    var client = StreamVideo.instance;

    if (client._ws != null) return;

    logger.info('setting user : ${user.id}');

    client._state.currentUser.value = user;
    client._tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    try {
      client._ws = CoordinatorWebSocket(
        client.coordinatorWsUrl,
        apiKey: client.apiKey,
        userInfo: user,
        tokenManager: client._tokenManager,
      );
      return client._ws!.connect();
    } catch (e, stk) {
      logger.severe('error connecting user : ${user.id}', e, stk);
      rethrow;
    }
  }

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final int latencyMeasurementRounds;

  final _tokenManager = TokenManager();
  late final CoordinatorClient _client;

  var _state = _StreamVideoState();

  UserInfo? get currentUser => _state.currentUser.valueOrNull;

  Stream<UserInfo?> get currentUserStream => _state.currentUser.stream;

  Call? get activeCall => _state.activeCall.valueOrNull;

  Stream<Call?> get activeCallStream => _state.activeCall.stream;

  CoordinatorWebSocket? _ws;

  /// Default log handler function for the [StreamChatClient] logger.
  static void defaultLogHandler(LogRecord record) {
    print(
      '${record.time} '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '[${record.loggerName}] ${record.message} ',
    );
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  }

  Future<void> connect(
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
      _ws = CoordinatorWebSocket(
        coordinatorWsUrl,
        apiKey: apiKey,
        userInfo: user,
        tokenManager: _tokenManager,
      );
      return _ws!.connect();
    } catch (e, stk) {
      logger.severe('error connecting user : ${user.id}', e, stk);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    logger.info('disconnecting user : ${currentUser?.id}');

    if (_ws == null) return;
    await _ws?.disconnect();
    _ws = null;
    _tokenManager.reset();

    // Resetting the state.
    await _state.dispose();
    _state = _StreamVideoState();
  }

  /// Binds the [listener] to the passed [event] to be invoked at most [limit].
  void addListener(
    WebsocketEvent_Event event,
    Listener<WebsocketEvent> listener, {
    int? limit,
  }) {
    return _ws?.addListener(
      event.name,
      listener,
      limit: limit,
    );
  }

  /// Unbinds the [listener] from the passed [event].
  void removeListener(
    WebsocketEvent_Event event,
    Listener<WebsocketEvent> listener,
  ) {
    return _ws?.removeListener(
      event.name,
      listener,
    );
  }

  Future<CallEnvelope> createCall({
    required String type,
    required String id,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final response = await _client.createCall(
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

    return response.call;
  }

  Future<CallEnvelope> getOrCreateCall({
    required String type,
    required String id,
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final response = await _client.getOrCreateCall(
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
    return response.call;
  }

  Future<Call> joinCall({
    required String type,
    required String id,
    CallOptions callOptions = const CallOptions(),
  }) async {
    final response = await _client.joinCall(
      JoinCallRequest(
        id: id,
        type: type,
        datacenterId: '',
      ),
    );

    final edges = response.edges;
    final callId = response.call.call.id;
    final callType = response.call.call.type;
    final callCid = response.call.call.callCid;

    if (edges.isEmpty) {
      throw StreamVideoError('No edges found for call $callCid');
    }

    final edgeServer = await _getCallEdgeServer(
      callCid: callCid,
      edges: edges,
    );

    if (!edgeServer.hasCredentials() || !edgeServer.credentials.hasServer()) {
      throw StreamVideoError('No credentials found for call $callCid');
    }

    final credentials = edgeServer.credentials;

    final call = Call.fromDetails(
      cid: callCid,
      credentials: credentials,
      callOptions: callOptions,
      onCallConnected: (it) {
        updateCallStateConnected(it, callId, callType);
      },
      onCallLeft: updateStateDisconnected,
      client: this,
    );

    _state.pendingCalls.add(call);

    return call;
  }

  void updateCallStateConnected(Call it, String callId, String callType) {
    _state.activeCall.value = it;

    // Updating ws about the current call.
    final callInfo = CallInfo(callId: callId, callType: callType);
    _ws?.callInfo = callInfo;
  }

  void updateStateDisconnected(Call c) {
    _state.activeCall.value = null;

    // Updating ws about the current call.
    _ws?.callInfo = null;
  }

  Future<ReportCallStatsResponse> reportCallStats({
    required String callCid,
    required List<int> stats,
  }) async {
    final response = await _client.reportCallStats(
      ReportCallStatsRequest(
        callCid: callCid,
        statsJson: stats,
      ),
    );

    return response;
  }

  Future<GetCallEdgeServerResponse> _getCallEdgeServer({
    required String callCid,
    required List<Edge> edges,
  }) async {
    final latencyByEdge = await _measureLatencies(edges: edges);
    final response = await _client.getCallEdgeServer(
      GetCallEdgeServerRequest(
        callCid: callCid,
        measurements: LatencyMeasurements(
          measurements: latencyByEdge,
        ),
      ),
    );

    return response;
  }

  Future<SendEventResponse> sendEvent({
    required String callCid,
    required UserEventType eventType,
  }) async {
    final response = _client.sendEvent(
      SendEventRequest(
        callCid: callCid,
        eventType: eventType,
      ),
    );

    return response;
  }

  Future<Future<SendCustomEventResponse>> sendCustomEvent({
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

  Future<Call> acceptCall({
    required String type,
    required String id,
  }) async {
    final call = await joinCall(type: type, id: id);

    await sendEvent(
      callCid: call.cid,
      eventType: UserEventType.USER_EVENT_TYPE_ACCEPTED_CALL,
    );

    return call;
  }

  Future<SendEventResponse> rejectCall({
    required String callCid,
  }) async {
    final response = await sendEvent(
      callCid: callCid,
      eventType: UserEventType.USER_EVENT_TYPE_REJECTED_CALL,
    );

    return response;
  }

  Future<SendEventResponse> cancelCall({
    required String callCid,
  }) async {
    final response = await sendEvent(
      callCid: callCid,
      eventType: UserEventType.USER_EVENT_TYPE_CANCELLED_CALL,
    );

    return response;
  }

  Future<Map<String, Latency>> _measureLatencies({
    required List<Edge> edges,
    int rounds = 3,
  }) async {
    return {
      for (final edge in edges)
        edge.name: await measureEdgeLatency(
          edge: edge,
          rounds: rounds,
        ),
    };
  }
}

class _StreamVideoState {
  final _lock = Lock();

  final currentUser = UserInfoController();
  final activeCall = ActiveCallController();
  final pendingCalls = PendingCallsController();

  Future<void> dispose() async {
    await currentUser.dispose();
    await activeCall.dispose();
    await pendingCalls.dispose();
  }
}

typedef UserInfoController = RxController<UserInfo>;

typedef ActiveCallController = RxController<Call?>;

class PendingCallsController extends RxController<List<Call>> {
  PendingCallsController() : super(seedValue: const []);

  void add(Call call) {
    final calls = [...value];
    value = [...calls, call];
  }

  void remove(Call call) {
    final calls = [...value];
    value = calls.where((it) => it.cid != call.cid).toList();
  }
}
