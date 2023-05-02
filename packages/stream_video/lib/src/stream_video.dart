import 'dart:async';

import '../stream_video.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/models/coordinator_inputs.dart' as input;
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'coordinator/retry/coordinator_client_retry.dart';
import 'errors/video_error_composer.dart';
import 'internal/_instance_holder.dart';
import 'logger/impl/external_logger.dart';
import 'models/queried_calls.dart';
import 'retry/retry_policy.dart';
import 'shared_emitter.dart';
import 'state_emitter.dart';
import 'token/token_manager.dart';
import 'utils/none.dart';
import 'utils/standard.dart';
import 'webrtc/sdp/policy/sdp_policy.dart';

const _tag = 'SV:Client';
const _defaultCoordinatorRpcUrl = 'https://video.stream-io-api.com/video';
const _defaultCoordinatorWsUrl = 'wss://video.stream-io-api.com/video/connect';

/// Handler function used for logging.
typedef LogHandlerFunction = void Function(
  Priority priority,
  String tag,
  MessageBuilder message, [
  Object? error,
  StackTrace? stk,
]);

/// The client responsible for handling config and maintaining calls
class StreamVideo {
  /// The singleton instance of the Stream Video client.
  factory StreamVideo() => instance;

  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideo.create(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    RetryPolicy retryPolicy = const RetryPolicy(),
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
  }) {
    return StreamVideo._(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
    );
  }

  StreamVideo._(
    this.apiKey, {
    required this.coordinatorRpcUrl,
    required this.coordinatorWsUrl,
    required this.latencyMeasurementRounds,
    required this.retryPolicy,
    required this.sdpPolicy,
  }) {
    _client = buildCoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      retryPolicy: retryPolicy,
      rpcUrl: coordinatorRpcUrl,
      wsUrl: coordinatorWsUrl,
    );
  }

  static final InstanceHolder _instanceHolder = InstanceHolder();

  static StreamVideo init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    RetryPolicy retryPolicy = const RetryPolicy(),
    Priority logPriority = Priority.none,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
  }) {
    _setupLogger(logPriority, logHandlerFunction);
    return _instanceHolder.init(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
    );
  }

  /// The singleton instance of the Stream Video client.
  static StreamVideo get instance => _instanceHolder.instance;

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnectUser = false}) async {
    if (disconnectUser) {
      await _instanceHolder.instance.disconnectUser();
    }
    return _instanceHolder.reset();
  }

  /// Return if the singleton instance of the Stream Video Client has already
  /// been initialized.
  static bool isInitialized() {
    return _instanceHolder.isInitialized();
  }

  final _logger = taggedLogger(tag: _tag);

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final int latencyMeasurementRounds;

  /// Returns the current [RetryPolicy].
  final RetryPolicy retryPolicy;

  /// Returns the current [SdpPolicy].
  final SdpPolicy sdpPolicy;

  final _tokenManager = TokenManager();
  late final CoordinatorClient _client;
  PushNotificationManager? _pushNotificationManager;

  var _state = _StreamVideoState();

  StreamSubscription<CoordinatorEvent>? _eventSubscription;

  Future<void> initPushNotificationManager(
    PushNotificationManagerFactory factory,
  ) async {
    _pushNotificationManager = await factory(_client);
  }

  /// Returns the current user if exists.
  UserInfo? get currentUser => _state.currentUser.valueOrNull;

  /// Returns the active call if exists.
  Call? get activeCall => _state.activeCall.valueOrNull;

  /// You can subscribe to WebSocket events provided by the API.
  /// Please note that subscribing to WebSocket events is an advanced use-case,
  /// for most use-cases it should be enough to watch for changes
  /// in the reactive [Call.state].
  Stream<CoordinatorEvent> get events => _client.events.asStream();

  /// Invoked when a call was created by another user with ringing set as True.
  void Function(Call)? onIncomingCall;

  /// Connects the [user] to the Stream Video service using a [TokenProvider].
  /// This method is great if your service requires tokens to be refreshed.
  ///
  /// For applications outside of test and development, this method may be more
  /// suitable as token refreshes are handled for you.
  Future<Result<String>> connectUserWithProvider(
    UserInfo user, {
    required TokenProvider tokenProvider,
  }) async {
    _logger.i(() => '[connectUser] user.id : ${user.id}');
    if (currentUser != null) {
      _logger.w(() => '[connectUser] rejected (already set): $currentUser');
      return _tokenManager.getToken();
    }
    final tokenResult = await _tokenManager.setTokenProvider(
      user.id,
      tokenProvider: tokenProvider,
    );
    if (tokenResult.isFailure) {
      return tokenResult;
    }
    _state.currentUser.value = user;

    try {
      _eventSubscription = _client.events.listen((event) {
        _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
        if (event is CoordinatorCallCreatedEvent &&
            event.metadata.details.createdBy.id != user.id &&
            event.data.ringing) {
          _logger.v(() => '[onCoordinatorEvent] onCallCreated: ${event.data}');
          onIncomingCall?.call(_makeCallFromCreated(data: event.data));
        }
      });

      final result = await _client.onUserLogin(user);
      await _pushNotificationManager?.onUserLoggedIn();
      if (result is Failure) {
        return result;
      }
      return tokenResult;
    } catch (e, stk) {
      _logger.e(() => '[connectUser] failed(${user.id}): $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnectUser() async {
    _logger.i(() => '[disconnectUser] currentUser.id: ${currentUser?.id}');
    if (currentUser == null) {
      _logger.w(() => '[disconnectUser] rejected (no user): $currentUser');
      return Result.success(None());
    }
    try {
      await _client.onUserLogout();
      await _eventSubscription?.cancel();
      _eventSubscription = null;
      _tokenManager.reset();

      // Resetting the state.
      await _state.close();
      _state = _StreamVideoState();
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[disconnectUser] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  StreamSubscription<Call?> listenActiveCall(
    void Function(Call? value)? onActiveCall,
  ) {
    return _state.activeCall.listen(onActiveCall);
  }

  Call makeCall({
    required String type,
    required String id,
    CallPreferences? preferences,
  }) {
    return Call(
      callCid: StreamCallCid.from(type: type, id: id),
      coordinatorClient: _client,
      getCurrentUserId: _state.getCurrentUserId,
      setActiveCall: _state.setActiveCall,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    );
  }

  Call _makeCallFromCreated({
    required CallCreatedData data,
    CallPreferences? preferences,
  }) {
    return Call.fromCreated(
      data: data,
      coordinatorClient: _client,
      getCurrentUserId: _state.getCurrentUserId,
      setActiveCall: _state.setActiveCall,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    );
  }

  /// Queries the API for calls.
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    int? limit,
  }) {
    return _client.queryCalls(
      input.QueryCallsInput(
        filterConditions: filterConditions,
        next: next,
        limit: limit,
      ),
    );
  }

  Future<bool> handlePushNotification(Map<String, dynamic> payload) {
    return _pushNotificationManager?.handlePushNotification(payload) ??
        Future.value(false);
  }

  Future<Call?> consumeIncomingCall() {
    return _pushNotificationManager?.consumeIncomingCall().then((data) {
          return data?.let((it) => _makeCallFromCreated(data: it));
        }) ??
        Future.value();
  }
}

class _StreamVideoState {
  final MutableStateEmitter<UserInfo?> currentUser = MutableStateEmitterImpl(
    null,
  );
  final MutableStateEmitter<Call?> activeCall = MutableStateEmitterImpl(null);

  Future<void> close() async {
    await currentUser.close();
    await activeCall.close();
  }

  String? getCurrentUserId() => currentUser.valueOrNull?.id;

  Future<void> setActiveCall(Call? call) async {
    final ongoingCall = activeCall.valueOrNull;
    if (ongoingCall != null && call != null) {
      await ongoingCall.disconnect();
    }
    activeCall.value = call;
  }
}

CoordinatorClient buildCoordinatorClient({
  required String rpcUrl,
  required String wsUrl,
  required String apiKey,
  required TokenManager tokenManager,
  required RetryPolicy retryPolicy,
}) {
  streamLog.i(_tag, () => '[buildCoordinatorClient] rpcUrl: $rpcUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] wsUrl: $wsUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] apiKey: $apiKey');
  return CoordinatorClientRetry(
    retryPolicy: retryPolicy,
    delegate: CoordinatorClientOpenApi(
      apiKey: apiKey,
      tokenManager: tokenManager,
      retryPolicy: retryPolicy,
      rpcUrl: rpcUrl,
      wsUrl: wsUrl,
    ),
  );
}

void _setupLogger(Priority logPriority, LogHandlerFunction logHandlerFunction) {
  if (logPriority != Priority.none) {
    StreamLog().priority = logPriority;
    StreamLog().logger = CompositeStreamLogger([
      const ConsoleStreamLogger(),
      ExternalStreamLogger(logHandlerFunction),
    ]);
  }
}

/// Default log handler function for the [StreamVideo] logger.
void _defaultLogHandler(
  Priority priority,
  String tag,
  MessageBuilder message, [
  Object? error,
  StackTrace? stk,
]) {
  /* no-op */
}

const _defaultSdpPolicy = SdpPolicy();

extension StreamVideoX on StreamVideo {
  /// Connects the [user] to the Stream Video service using a static token.
  Future<Result<String>> connectUser(
    UserInfo user,
    String token,
  ) {
    return connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.static(token),
    );
  }
}
