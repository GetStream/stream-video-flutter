import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:synchronized/synchronized.dart';

import '../protobuf/video/coordinator/push_v1/push.pb.dart';
import 'push_notification/push_notification_manager.dart';

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
    'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect';

/// The client responsible for handling config and maintaining calls
class StreamVideo with EventEmittable<CoordinatorEvent> {
  /// Initialises the Stream Video SDK and creates the singleton instance of the client.
  StreamVideo.init(
    this.apiKey, {
    this.coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    this.coordinatorWsUrl = _defaultCoordinatorWsUrl,
    this.latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = StreamVideo.defaultLogHandler,
  }) {
    if (_instance != null) {
      throw Exception('''
        StreamVideo has already been initialised, use StreamVideo.instance to access the singleton instance.
        If you want to re-initialise the SDK, call StreamVideo.reset() first.
        If you want to use multiple instances of the SDK, use StreamVideo.new() instead.
        ''');
    }
    _instance = StreamVideo._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }

  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
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
    _pushNotificationManager = PushNotificationManager(client: this);
  }

  static StreamVideo? _instance;

  /// The singleton instance of the Stream Video client.
  static StreamVideo get instance {
    final instance = _instance;
    if (instance == null) {
      throw Exception(
        'Please initialise Stream Video by calling StreamVideo.init()',
      );
    }

    return instance;
  }

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static void reset({bool disconnectUser = false}) async {
    if (disconnectUser) {
      _instance?.activeCall?.disconnect();
      _instance?.disconnectUser();
    }
    _instance = null;
  }

  /// Return if the singleton instance of the Stream Video Client has already
  /// been initialized.
  static bool isInitialized() {
    return _instance != null;
  }

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final int latencyMeasurementRounds;

  final _tokenManager = TokenManager();
  late final CoordinatorClient _client;
  late final PushNotificationManager _pushNotificationManager;

  var _state = _StreamVideoState();

  UserInfo? get currentUser => _state.currentUser.valueOrNull;

  Stream<UserInfo?> get currentUserStream => _state.currentUser.stream;

  Call? get activeCall => _state.activeCall.valueOrNull;

  Stream<Call?> get activeCallStream => _state.activeCall.stream;

  CoordinatorWebSocket? _ws;

  /// Default log handler function for the [StreamVideo] logger.
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
      _ws = CoordinatorWebSocket(
        coordinatorWsUrl,
        apiKey: apiKey,
        userInfo: user,
        tokenManager: _tokenManager,
      )..events.listen(events.emit);

      await _ws!.connect();
      return _pushNotificationManager.onUserLoggedIn();
    } catch (e, stk) {
      logger.severe('error connecting user : ${user.id}', e, stk);
      rethrow;
    }
  }

  /// Disconnects the [user] from the Stream Video service.
  Future<void> disconnectUser() async {
    logger.info('disconnecting user : ${currentUser?.id}');

    if (_ws == null) return;
    await _ws?.disconnect();
    _ws = null;
    _tokenManager.reset();

    // Resetting the state.
    await _state.dispose();
    _state = _StreamVideoState();
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

  Future<Device> createDevice({required String token}) async {
    final response = await _client.createDevice(
      CreateDeviceRequest(
        input: DeviceInput(
          id: token,
          pushProviderId: 'firebase',
        ),
      ),
    );

    return response.device;
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
      JoinCallRequest(id: id, type: type),
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
      callId: callId,
      callType: callType,
      credentials: credentials,
      callOptions: callOptions,
      client: this,
    );

    _state.pendingCalls.add(call);

    return call;
  }

  void updateCallStateConnected(Call call) {
    _state.activeCall.value = call;

    // Updating ws about the current call.
    final callInfo = CallInfo(callId: call.callId, callType: call.callType);
    _ws?.callInfo = callInfo;
  }

  void updateCallStateDisconnected(Call call) {
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

  Future<bool> handlePushNotification(RemoteMessage remoteMessage) {
    return _pushNotificationManager.handlePushNotification(remoteMessage);
  }

  Future<Call> acceptCall({
    required String type,
    required String id,
  }) async {
    final call = await joinCall(type: type, id: id);

    await sendEvent(
      callCid: call.callCid,
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

  Future<void> inviteUsers({
    required String callCid,
    required List<UserInfo> users,
  }) async {
    final res = await _client.upsertCallMembers(
      UpsertCallMembersRequest(
        callCid: callCid,
        members: users.map((user) {
          return MemberInput(userId: user.id, role: user.role);
        }),
      ),
    );
    print('[inviteUsers] res: $res');
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
    value = calls.where((it) => it.callCid != call.callCid).toList();
  }
}
