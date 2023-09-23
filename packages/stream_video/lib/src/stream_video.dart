import 'dart:async';

import 'package:async/async.dart' as async;
import 'package:stream_video/src/logger/stream_logger.dart';

import '../open_api/video/coordinator/api.dart' as open;
import 'call/call.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'coordinator/retry/coordinator_client_retry.dart';
import 'core/client_state.dart';
import 'core/connection_state.dart';
import 'errors/video_error_composer.dart';
import 'internal/_instance_holder.dart';
import 'latency/latency_service.dart';
import 'latency/latency_settings.dart';
import 'lifecycle/lifecycle_state.dart';
import 'lifecycle/lifecycle_utils.dart'
    if (dart.library.io) 'lifecycle/lifecycle_utils_io.dart' as lifecycle;
import 'logger/impl/console_logger.dart';
import 'logger/impl/external_logger.dart';
import 'logger/impl/tagged_logger.dart';
import 'logger/stream_log.dart';
import 'models/call_cid.dart';
import 'models/call_created_data.dart';
import 'models/call_preferences.dart';
import 'models/call_ringing_data.dart';
import 'models/guest_created_data.dart';
import 'models/queried_calls.dart';
import 'models/user.dart';
import 'models/user_info.dart';
import 'push_notification/push_notification_manager.dart';
import 'retry/retry_policy.dart';
import 'token/token.dart';
import 'token/token_manager.dart';
import 'utils/cancelable_operation.dart';
import 'utils/future.dart';
import 'utils/none.dart';
import 'utils/result.dart';
import 'utils/standard.dart';
import 'utils/subscriptions.dart';
import 'webrtc/sdp/policy/sdp_policy.dart';

const _tag = 'SV:Client';

const _idEvents = 1;
const _idAppState = 2;
const _idConnect = 3;

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
  /// Creates a new Stream Video client associated with the
  /// Stream Video singleton instance
  ///
  /// If [failIfSingletonExists] is set to false, the new instance will override and disconnect the existing singleton instance.
  factory StreamVideo(
    String apiKey, {
    StreamVideoOptions options = const StreamVideoOptions(),
    required User user,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    bool failIfSingletonExists = true,
  }) {
    final instance = StreamVideo._(
      apiKey,
      options: options,
      user: user,
      userToken: userToken,
      tokenLoader: tokenLoader,
      onTokenUpdated: onTokenUpdated,
    );
    _instanceHolder.install(
      instance,
      failIfSingletonExists: failIfSingletonExists,
    );
    return instance;
  }

  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideo.create(
    String apiKey, {
    StreamVideoOptions options = const StreamVideoOptions(),
    required User user,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
  }) {
    final instance = StreamVideo._(
      apiKey,
      options: options,
      user: user,
      userToken: userToken,
      tokenLoader: tokenLoader,
      onTokenUpdated: onTokenUpdated,
    );
    return instance;
  }

  StreamVideo._(
    String apiKey, {
    required StreamVideoOptions options,
    required User user,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
  })  : _options = options,
        _state = MutableClientState(user) {
    _client = buildCoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      latencySettings: _options.latencySettings,
      retryPolicy: _options.retryPolicy,
      rpcUrl: _options.coordinatorRpcUrl,
      wsUrl: _options.coordinatorWsUrl,
    );

    _state.user.value = user;
    final tokenProvider = switch (user.type) {
      UserType.authenticated => TokenProvider.from(
          userToken?.let(UserToken.jwt),
          tokenLoader,
          onTokenUpdated,
        ),
      UserType.anonymous => TokenProvider.static(
          UserToken.anonymous(),
          onTokenUpdated: onTokenUpdated,
        ),
      UserType.guest => TokenProvider.dynamic(
          (userId) async {
            final result = await _client.loadGuest(id: userId);
            if (result is! Success<GuestCreatedData>) {
              throw (result as Failure).error;
            }
            final updatedUser = result.data.user;
            _state.user.value = User(
              type: user.type,
              info: updatedUser.toUserInfo(),
            );
            return result.data.accessToken;
          },
          onTokenUpdated: onTokenUpdated,
        ),
    };

    _tokenManager.setTokenProvider(
      user.id,
      tokenProvider: tokenProvider,
    );

    _setupLogger(options.logPriority, options.logHandlerFunction);

    if (options.autoConnect) {
      unawaited(connect());
    }
  }

  static final InstanceHolder _instanceHolder = InstanceHolder();

  /// The singleton instance of the Stream Video client.
  static StreamVideo get instance => _instanceHolder.instance;

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnect = false}) async {
    if (disconnect && _instanceHolder.isInitialized()) {
      await _instanceHolder.instance.disconnect();
    }
    return _instanceHolder.reset();
  }

  /// Return if the singleton instance of the Stream Video Client has already
  /// been initialized.
  static bool isInitialized() {
    return _instanceHolder.isInitialized();
  }

  final _logger = taggedLogger(tag: _tag);

  final StreamVideoOptions _options;
  final MutableClientState _state;

  final _tokenManager = TokenManager();
  final _subscriptions = Subscriptions();
  late final CoordinatorClient _client;
  PushNotificationManager? pushNotificationManager;

  bool _mutedCameraByStateChange = false;
  bool _mutedAudioByStateChange = false;

  Future<void> initPushNotificationManager(
    PushNotificationManagerFactory factory,
  ) async {
    pushNotificationManager = await factory(_client);
  }

  /// Returns the current user if exists.
  UserInfo get currentUser => _state.currentUser.info;

  /// Returns the [StreamVideo] state.
  ClientState get state => _state;

  /// Returns the active call if exists.
  Call? get activeCall => _state.activeCall.valueOrNull;

  /// You can subscribe to WebSocket events provided by the API.
  /// Please note that subscribing to WebSocket events is an advanced use-case,
  /// for most use-cases it should be enough to watch for changes
  /// in the reactive [Call.state].
  Stream<CoordinatorEvent> get events => _client.events.asStream();

  async.CancelableOperation<Result<UserToken>>? _connectOperation;
  async.CancelableOperation<Result<None>>? _disconnectOperation;

  set _connectionState(ConnectionState newState) {
    final curState = _connectionState;
    if (curState != newState) {
      _logger.i(() => '[setConnectionState] #client; $newState <= $curState');
      _state.connection.value = newState;
    }
  }

  ConnectionState get _connectionState => _state.connection.value;

  /// Connects the user to the Stream Video service.
  Future<Result<UserToken>> connect() async {
    _connectOperation ??= _connect().asCancelable();
    return _connectOperation!
        .valueOrDefault(
      Result.error('connect was cancelled'),
    )
        .whenComplete(() {
      _logger.i(() => '[connect] clear shared operation');
      _connectOperation = null;
    });
  }

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnect() async {
    _disconnectOperation ??= _disconnect().asCancelable();
    return _disconnectOperation!
        .valueOrDefault(
      Result.error('disconnect was cancelled'),
    )
        .whenComplete(() {
      _logger.i(() => '[disconnect] clear shared operation');
      _disconnectOperation = null;
    });
  }

  Future<Result<UserToken>> _connect() async {
    _logger.i(() => '[connect] currentUser.id: ${_state.currentUser.id}');
    if (_connectionState.isConnected) {
      _logger.w(() => '[connect] rejected (already connected)');
      final token = _tokenManager.getCachedToken();
      if (token == null) {
        return Result.error('[connect] userToken is null in Connected state');
      }
      return Result.success(token);
    }
    _connectionState = ConnectionState.connecting(
      _state.currentUser.id,
    );
    // guest user will be updated when token gets fetched
    final tokenResult = await _tokenManager.getToken();
    if (tokenResult is! Success<UserToken>) {
      _logger.e(() => '[connect] token fetching failed: $tokenResult');
      _connectionState = ConnectionState.failed(
        _state.currentUser.id,
        error: (tokenResult as Failure).error,
      );
      return tokenResult;
    }
    final user = _state.user.value;
    _logger.v(() => '[connect] currentUser.id : ${user.id}');
    try {
      final result = await _client.connectUser(user.info);
      _logger.v(() => '[connect] completed: $result');
      if (result is Failure) {
        _connectionState = ConnectionState.failed(
          _state.currentUser.id,
          error: result.error,
        );
        return result;
      }
      _connectionState = ConnectionState.connected(
        _state.currentUser.id,
      );
      _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
      _subscriptions.add(_idAppState, lifecycle.appState.listen(_onAppState));
      try {
        await pushNotificationManager?.onUserLoggedIn();
      } catch (e, stk) {
        _logger.w(() => '[connect] #pnManager; failed: $e, $stk');
      }
      return Result.success(tokenResult.data);
    } catch (e, stk) {
      _logger.e(() => '[connect] failed(${user.id}): $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<None>> _disconnect() async {
    _logger.i(() => '[disconnect] currentUser.id: ${_state.currentUser.id}');
    if (_connectionState.isDisconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return const Result.success(none);
    }
    try {
      await _connectOperation?.cancel();
      _connectOperation = null;
      await _client.disconnectUser();
      _subscriptions.cancelAll();

      // Resetting the state.
      await _state.clear();
      _connectionState = ConnectionState.disconnected(
        _state.currentUser.id,
      );
      _logger.v(() => '[disconnect] completed');
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[disconnect] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  void _onEvent(CoordinatorEvent event) {
    final currentUserId = _state.currentUser.id;
    _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
    if (event is CoordinatorCallRingingEvent &&
        event.metadata.details.createdBy.id != currentUserId &&
        event.data.ringing) {
      _logger.v(() => '[onCoordinatorEvent] onCallRinging: ${event.data}');
      final call = _makeCallFromRinging(data: event.data);
      _state.incomingCall.emit(call);
    } else if (event is CoordinatorConnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] connected ${event.userId}');
      _connectionState = ConnectionState.connected(
        _state.currentUser.id,
      );
    } else if (event is CoordinatorDisconnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] disconnected ${event.userId}');
      _connectionState = ConnectionState.disconnected(
        _state.currentUser.id,
      );
    }
  }

  Future<void> _onAppState(LifecycleState state) async {
    _logger.d(() => '[onAppState] state: $state');
    try {
      final loggedIn = currentUser != null;
      final activeCallCid = _state.activeCall.valueOrNull?.callCid;
      if (loggedIn && state.isPaused && activeCallCid == null) {
        _logger.i(() => '[onAppState] close connection');
        _subscriptions.cancel(_idEvents);
        await _client.closeConnection();
      } else if (loggedIn && state.isPaused && activeCallCid != null) {
        final callState = activeCall?.state.value;
        final isVideoEnabled =
            callState?.localParticipant?.isVideoEnabled ?? false;
        final isAudioEnabled =
            callState?.localParticipant?.isAudioEnabled ?? false;

        if (_options.muteVideoWhenInBackground && isVideoEnabled) {
          await activeCall?.setCameraEnabled(enabled: false);
          _mutedCameraByStateChange = true;
          _logger.v(() => 'Muted camera track since app was paused.');
        }
        if (_options.muteAudioWhenInBackground && isAudioEnabled) {
          await activeCall?.setMicrophoneEnabled(enabled: false);
          _mutedAudioByStateChange = true;
          _logger.v(() => 'Muted audio track since app was paused.');
        }
      } else if (loggedIn && state.isResumed) {
        _logger.i(() => '[onAppState] open connection');
        await _client.openConnection();
        _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
        if (_mutedCameraByStateChange) {
          await activeCall?.setCameraEnabled(enabled: true);
          _mutedCameraByStateChange = false;
          _logger.v(() => 'Unmuted camera track since app was unpaused.');
        }
        if (_mutedAudioByStateChange) {
          await activeCall?.setMicrophoneEnabled(enabled: true);
          _mutedAudioByStateChange = false;
          _logger.v(() => 'Unmuted audio track since app was unpaused.');
        }
      }
    } catch (e) {
      _logger.e(() => '[onAppState] failed: $e');
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
      currentUser: _state.user,
      setActiveCall: _state.setActiveCall,
      retryPolicy: _options.retryPolicy,
      sdpPolicy: _options.sdpPolicy,
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
      currentUser: _state.user,
      setActiveCall: _state.setActiveCall,
      retryPolicy: _options.retryPolicy,
      sdpPolicy: _options.sdpPolicy,
      preferences: preferences,
    );
  }

  Call _makeCallFromRinging({
    required CallRingingData data,
    CallPreferences? preferences,
  }) {
    return Call.fromRinging(
      data: data,
      coordinatorClient: _client,
      currentUser: _state.user,
      setActiveCall: _state.setActiveCall,
      retryPolicy: _options.retryPolicy,
      sdpPolicy: _options.sdpPolicy,
      preferences: preferences,
    );
  }

  /// Queries the API for calls.
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    int? limit,
    List<open.SortParamRequest>? sorts,
  }) {
    return _client.queryCalls(
      filterConditions: filterConditions,
      next: next,
      limit: limit,
      prev: prev,
      sorts: sorts ?? [],
    );
  }

  Future<bool> handlePushNotification(Map<String, dynamic> payload) async {
    final manager = pushNotificationManager;
    if (manager == null) return false;

    return manager.handlePushNotification(payload);
  }

  Future<Call?> consumeIncomingCall() async {
    return pushNotificationManager?.consumeIncomingCall().then((data) {
      return data?.let((it) => _makeCallFromCreated(data: it));
    });
  }
}

CoordinatorClient buildCoordinatorClient({
  required String rpcUrl,
  required String wsUrl,
  required String apiKey,
  required TokenManager tokenManager,
  required RetryPolicy retryPolicy,
  required LatencySettings latencySettings,
}) {
  streamLog.i(_tag, () => '[buildCoordinatorClient] rpcUrl: $rpcUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] wsUrl: $wsUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] apiKey: $apiKey');
  return CoordinatorClientRetry(
    retryPolicy: retryPolicy,
    delegate: CoordinatorClientOpenApi(
      apiKey: apiKey,
      tokenManager: tokenManager,
      latencyService: LatencyService(settings: latencySettings),
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

class StreamVideoOptions {
  const StreamVideoOptions({
    this.coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    this.coordinatorWsUrl = _defaultCoordinatorWsUrl,
    this.latencySettings = const LatencySettings(),
    this.retryPolicy = const RetryPolicy(),
    this.sdpPolicy = const SdpPolicy(),
    this.logPriority = Priority.none,
    this.logHandlerFunction = _defaultLogHandler,
    this.muteVideoWhenInBackground = false,
    this.muteAudioWhenInBackground = false,
    this.autoConnect = true,
  });

  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final LatencySettings latencySettings;

  /// Returns the current [RetryPolicy].
  final RetryPolicy retryPolicy;

  /// Returns the current [SdpPolicy].
  final SdpPolicy sdpPolicy;

  final Priority logPriority;
  final LogHandlerFunction logHandlerFunction;

  final bool muteVideoWhenInBackground;
  final bool muteAudioWhenInBackground;
  final bool autoConnect;
}
