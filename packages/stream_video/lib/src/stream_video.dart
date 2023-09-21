import 'dart:async';

import '../stream_video.dart';
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'coordinator/retry/coordinator_client_retry.dart';
import 'errors/video_error_composer.dart';
import 'internal/_instance_holder.dart';
import 'latency/latency_service.dart';
import 'latency/latency_settings.dart';
import 'lifecycle/lifecycle_state.dart';
import 'lifecycle/lifecycle_utils.dart'
    if (dart.library.io) 'lifecycle/lifecycle_utils_io.dart' as lifecycle;
import 'logger/impl/external_logger.dart';
import 'retry/retry_policy.dart';
import 'state_emitter.dart';
import 'token/token_manager.dart';
import 'utils/standard.dart';
import 'webrtc/sdp/policy/sdp_policy.dart';

const _tag = 'SV:Client';

const _idEvents = 1;
const _idAppState = 2;

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
  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideo(
    String apiKey, {
    StreamVideoOptions options = const StreamVideoOptions(),
    required User user,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
  }) {
    final instance = StreamVideo._(
      apiKey,
      coordinatorRpcUrl: options.coordinatorRpcUrl,
      coordinatorWsUrl: options.coordinatorWsUrl,
      latencySettings: options.latencySettings,
      retryPolicy: options.retryPolicy,
      sdpPolicy: options.sdpPolicy,
      muteVideoWhenInBackground: options.muteVideoWhenInBackground,
      muteAudioWhenInBackground: options.muteAudioWhenInBackground,
    );

    instance._state.currentUser.value = user;
    if (user.type == UserType.anonymous) {
      instance._tokenManager.setTokenProvider(
        user.id,
        tokenProvider: TokenProvider.static(
          UserToken.anonymous(),
          onTokenUpdated: instance._wrapOnTokenUpdated(onTokenUpdated),
        ),
      );
    } else if (user.type == UserType.guest) {
      instance._tokenManager.setTokenProvider(
        user.id,
        tokenProvider: TokenProvider.dynamic(
          (userId) async {
            final result = await instance._client.loadGuest(id: userId);
            if (result is! Success<GuestCreatedData>) {
              throw (result as Failure).error;
            }
            final updatedUser = result.data.user;
            instance._state.currentUser.value = User(
              type: user.type,
              info: updatedUser.toUserInfo(),
            );
            return result.data.accessToken;
          },
          onTokenUpdated: instance._wrapOnTokenUpdated(onTokenUpdated),
        ),
      );
    } else {
      instance._tokenManager.setTokenProvider(
        user.id,
        tokenProvider: TokenProvider.from(
          userToken?.let(UserToken.jwt),
          tokenLoader,
          instance._wrapOnTokenUpdated(onTokenUpdated),
        ),
      );
    }

    _setupLogger(options.logPriority, options.logHandlerFunction);

    if (options.installAsSingleton) {
      _instanceHolder.install(instance);
    }
    if (options.autoConnect) {
      unawaited(instance.connect());
    }
    return instance;
  }

  StreamVideo._(
    this.apiKey, {
    required this.coordinatorRpcUrl,
    required this.coordinatorWsUrl,
    required this.latencySettings,
    required this.retryPolicy,
    required this.sdpPolicy,
    this.muteVideoWhenInBackground = false,
    this.muteAudioWhenInBackground = false,
  }) {
    _client = buildCoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      latencySettings: latencySettings,
      retryPolicy: retryPolicy,
      rpcUrl: coordinatorRpcUrl,
      wsUrl: coordinatorWsUrl,
    );
  }

  static final InstanceHolder _instanceHolder = InstanceHolder();

  /// The singleton instance of the Stream Video client.
  static StreamVideo get instance => _instanceHolder.instance;

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnect = false}) async {
    if (disconnect) {
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

  final String apiKey;
  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final LatencySettings latencySettings;

  /// Returns the current [RetryPolicy].
  final RetryPolicy retryPolicy;

  /// Returns the current [SdpPolicy].
  final SdpPolicy sdpPolicy;

  final _tokenManager = TokenManager();
  final _subscriptions = Subscriptions();
  late final CoordinatorClient _client;
  PushNotificationManager? pushNotificationManager;

  late bool muteVideoWhenInBackground;
  late bool muteAudioWhenInBackground;
  bool _mutedCameraByStateChange = false;
  bool _mutedAudioByStateChange = false;

  var _state = _StreamVideoState();

  Future<void> initPushNotificationManager(
    PushNotificationManagerFactory factory,
  ) async {
    pushNotificationManager = await factory(_client);
  }

  /// Returns the current user if exists.
  UserInfo? get currentUser => _state.currentUser.valueOrNull?.info;

  /// Returns the active call if exists.
  Call? get activeCall => _state.activeCall.valueOrNull;

  /// You can subscribe to WebSocket events provided by the API.
  /// Please note that subscribing to WebSocket events is an advanced use-case,
  /// for most use-cases it should be enough to watch for changes
  /// in the reactive [Call.state].
  Stream<CoordinatorEvent> get events => _client.events.asStream();

  /// Invoked when a call was created by another user with ringing set as True.
  void Function(Call)? onIncomingCall;

  /// Connects the user to the Stream Video service.
  Future<Result<None>> connect() async {
    final user = _state.currentUser.valueOrNull;
    if (user == null) {
      _logger.w(() => '[connect] rejected (currentUser is null)');
      return Result.error('User is not set');
    }
    _logger.i(() => '[connect] currentUser.id : ${user.id}');

    try {
      final result = await _client.connectUser(user.info);
      _logger.v(() => '[connect] completed: $result');
      if (result is Failure) {
        return result;
      }
      _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
      _subscriptions.add(_idAppState, lifecycle.appState.listen(_onAppState));
      try {
        await pushNotificationManager?.onUserLoggedIn();
      } catch (e, stk) {
        _logger.w(() => '[connect] #pnManager; failed: $e, $stk');
      }
      try {
        _logger.v(() => '[connect] checking token');
        await _tokenManager.getToken();
      } catch (e, stk) {
        _logger.w(() => '[connect] #tokenManager; failed: $e, $stk');
      }
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[connect] failed(${user.id}): $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnect() async {
    final user = _state.currentUser.valueOrNull;
    if (user == null) {
      _logger.w(() => '[disconnect] rejected (currentUser is null)');
      return const Result.success(none);
    }
    _logger.i(() => '[disconnect] currentUser.id: ${user.id}');
    try {
      await _client.disconnectUser();
      _subscriptions.cancelAll();
      //_tokenManager.reset();

      // Resetting the state.
      await _state.clear();
      _logger.v(() => '[disconnect] completed');
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[disconnect] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  OnTokenUpdated _wrapOnTokenUpdated(OnTokenUpdated? onTokenUpdated) {
    return (UserToken token) async {
      _logger.v(() => '[onTokenUpdated] token: $token');
      _state.currentToken.value = token;
      return onTokenUpdated?.call(token);
    };
  }

  void _onEvent(CoordinatorEvent event) {
    final currentUserId = _state.getCurrentUserId();
    _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
    if (event is CoordinatorCallRingingEvent &&
        event.metadata.details.createdBy.id != currentUserId &&
        event.data.ringing) {
      _logger.v(() => '[onCoordinatorEvent] onCallRinging: ${event.data}');
      onIncomingCall?.call(_makeCallFromRinging(data: event.data));
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

        if (muteVideoWhenInBackground && isVideoEnabled) {
          await activeCall?.setCameraEnabled(enabled: false);
          _mutedCameraByStateChange = true;
          _logger.v(() => 'Muted camera track since app was paused.');
        }
        if (muteAudioWhenInBackground && isAudioEnabled) {
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

  Call _makeCallFromRinging({
    required CallRingingData data,
    CallPreferences? preferences,
  }) {
    return Call.fromRinging(
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
    String? prev,
    int? limit,
    List<SortParamRequest>? sorts,
  }) {
    return _client.queryCalls(
      filterConditions: filterConditions,
      next: next,
      limit: limit,
      prev: prev,
      sorts: sorts ?? [],
    );
  }

  Future<Result<GuestCreatedData>> createGuest({
    required String id,
    String? name,
    String? role,
    String? image,
    List<String>? teams,
    Map<String, Object>? custom,
  }) async {
    await _tokenManager.setTokenProvider(
      id,
      tokenProvider: AnonymousTokenProvider(),
    );
    final result = await _client.createGuest(
      id: id,
      name: name,
      role: role,
      image: image,
      teams: teams,
      custom: custom ?? {},
    );
    _tokenManager.reset();
    return result;
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

class _StreamVideoState {
  final MutableStateEmitter<User?> currentUser = MutableStateEmitterImpl(
    null,
  );
  final MutableStateEmitter<UserToken?> currentToken = MutableStateEmitterImpl(
    null,
  );
  final MutableStateEmitter<Call?> activeCall = MutableStateEmitterImpl(null);

  Future<void> close() async {
    await currentToken.close();
    await currentUser.close();
    await activeCall.close();
  }

  Future<void> clear() async {
    activeCall.value = null;
  }

  String? getCurrentUserId() => currentUser.valueOrNull?.id;

  Future<void> setActiveCall(Call? call) async {
    final ongoingCall = activeCall.valueOrNull;
    if (ongoingCall != null && call != null) {
      await ongoingCall.leave();
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

const _defaultSdpPolicy = SdpPolicy();

class StreamVideoOptions {
  const StreamVideoOptions({
    this.coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    this.coordinatorWsUrl = _defaultCoordinatorWsUrl,
    this.latencySettings = const LatencySettings(),
    this.retryPolicy = const RetryPolicy(),
    this.sdpPolicy = _defaultSdpPolicy,
    this.logPriority = Priority.none,
    this.logHandlerFunction = _defaultLogHandler,
    this.muteVideoWhenInBackground = false,
    this.muteAudioWhenInBackground = false,
    this.autoConnect = true,
    this.installAsSingleton = true,
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
  final bool installAsSingleton;
}
