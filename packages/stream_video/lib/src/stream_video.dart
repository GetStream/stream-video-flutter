import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../open_api/video/coordinator/api.dart' as open;
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
import 'utils/none.dart';
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
  /// The singleton instance of the Stream Video client.
  factory StreamVideo() => instance;

  /// Creates a new Stream Video client unassociated with the
  /// Stream Video singleton instance
  factory StreamVideo.create(
    String apiKey, {
    LatencySettings latencySettings = const LatencySettings(),
    RetryPolicy retryPolicy = const RetryPolicy(),
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
    bool muteVideoWhenInBackground = false,
    bool muteAudioWhenInBackground = false,
    PNManagerProvider? pushNotificationManagerProvider,
  }) {
    return StreamVideo._(
      apiKey,
      coordinatorRpcUrl: _defaultCoordinatorRpcUrl,
      coordinatorWsUrl: _defaultCoordinatorWsUrl,
      latencySettings: latencySettings,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      muteVideoWhenInBackground: muteVideoWhenInBackground,
      muteAudioWhenInBackground: muteAudioWhenInBackground,
      pushNotificationManagerProvider: pushNotificationManagerProvider,
    );
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
    PNManagerProvider? pushNotificationManagerProvider,
  }) {
    _client = buildCoordinatorClient(
      apiKey: apiKey,
      tokenManager: _tokenManager,
      latencySettings: latencySettings,
      retryPolicy: retryPolicy,
      rpcUrl: coordinatorRpcUrl,
      wsUrl: coordinatorWsUrl,
    );

    // Initialize the push notification manager if the provider is provided.
    if (pushNotificationManagerProvider != null) {
      _pushNotificationManager = pushNotificationManagerProvider(_client);
    }
  }

  static final InstanceHolder _instanceHolder = InstanceHolder();

  static StreamVideo init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    LatencySettings latencySettings = const LatencySettings(),
    RetryPolicy retryPolicy = const RetryPolicy(),
    SdpPolicy sdpPolicy = _defaultSdpPolicy,
    Priority logPriority = Priority.none,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
    bool muteVideoWhenInBackground = false,
    bool muteAudioWhenInBackground = false,
    PNManagerProvider? pushNotificationManagerProvider,
  }) {
    _setupLogger(logPriority, logHandlerFunction);
    return _instanceHolder.init(
      apiKey,
      latencySettings: latencySettings,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      muteVideoWhenInBackground: muteVideoWhenInBackground,
      muteAudioWhenInBackground: muteAudioWhenInBackground,
      pushNotificationManagerProvider: pushNotificationManagerProvider,
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
  final LatencySettings latencySettings;

  /// Returns the current [RetryPolicy].
  final RetryPolicy retryPolicy;

  /// Returns the current [SdpPolicy].
  final SdpPolicy sdpPolicy;

  final _tokenManager = TokenManager();
  final _subscriptions = Subscriptions();
  late final CoordinatorClient _client;
  late final PushNotificationManager? _pushNotificationManager;

  final bool muteVideoWhenInBackground;
  final bool muteAudioWhenInBackground;
  bool _mutedCameraByStateChange = false;
  bool _mutedAudioByStateChange = false;

  var _state = _StreamVideoState();

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
      final res = await _tokenManager.getToken();
      return res.map((data) => data.rawValue);
    }
    final tokenResult = await _tokenManager.setTokenProvider(
      user.id,
      tokenProvider: tokenProvider,
    );
    if (tokenResult.isFailure) {
      return tokenResult.map((data) => data.rawValue);
    }
    _state.currentUser.value = user;

    try {
      final result = await _client.connectUser(user);
      _logger.v(() => '[connectUser] completed: $result');
      if (result is Failure) {
        return result;
      }
      _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
      _subscriptions.add(_idAppState, lifecycle.appState.listen(_onAppState));

      // Register device for push notification.
      _pushNotificationManager?.registerDevice();

      return tokenResult.map((data) => data.rawValue);
    } catch (e, stk) {
      _logger.e(() => '[connectUser] failed(${user.id}): $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
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

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnectUser() async {
    _logger.i(() => '[disconnectUser] currentUser.id: ${currentUser?.id}');
    if (currentUser == null) {
      _logger.w(() => '[disconnectUser] rejected (no user): $currentUser');
      return const Result.success(none);
    }
    try {
      await _client.disconnectUser();
      _subscriptions.cancelAll();
      _tokenManager.reset();

      // Unregister device for push notification.
      _pushNotificationManager?.unregisterDevice();

      // Resetting the state.
      await _state.close();
      _state = _StreamVideoState();
      return const Result.success(none);
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

  Future<Result<None>> createDevice({
    required String id,
    required open.CreateDeviceRequestPushProviderEnum pushProvider,
    String? pushProviderName,
    String? userId,
    bool? voipToken,
  }) {
    return _client.createDevice(
      id: id,
      pushProvider: pushProvider,
      pushProviderName: pushProviderName,
      userId: userId,
      voipToken: voipToken,
    );
  }

  Future<Result<None>> deleteDevice({
    required String id,
    String? userId,
  }) {
    return _client.deleteDevice(
      id: id,
      userId: userId,
    );
  }

  Future<Result<List<open.Device>>> listDevices({required String userId}) {
    return _client.listDevices(userId: userId);
  }

  StreamSubscription<T>? onCallKitEvent<T extends CallKitEvent>(
    void Function(T event)? onEvent,
  ) {
    final manager = _pushNotificationManager;
    if (manager == null) {
      _logger.e(() => '[on] rejected (no manager)');
      return null;
    }

    return manager.on<T>(onEvent);
  }

  static const _uuid = Uuid();

  /// Handle incoming VoIP push notifications.
  ///
  /// Returns `true` if the notification was handled, `false` otherwise.
  Future<bool> handleVoipPushNotification(Map<String, dynamic> payload) async {
    final manager = _pushNotificationManager;
    if (manager == null) {
      _logger.e(() => '[handleVoipPushNotification] rejected (no manager)');
      return false;
    }

    // Only handle messages from stream.video
    final sender = payload['sender'] as String?;
    if (sender != 'stream.video') return false;

    // Only handle ringing calls.
    final type = payload['type'] as String?;
    if (type != 'call.ring') return false;

    // Return if the payload does not contain a call cid.
    final cid = payload['call_cid'] as String?;
    if (cid == null) return false;

    final caller = payload['created_by_display_name'] as String?;
    unawaited(
      manager.showIncomingCall(
        uuid: _uuid.v4(),
        callCid: StreamCallCid(cid: cid),
        nameCaller: caller,
      ),
    );

    return true;
  }

  Future<Call?> consumeIncomingCall() async {
    final manager = _pushNotificationManager;
    if (manager == null) {
      _logger.e(() => '[consumeIncomingCall] rejected (no manager)');
      return null;
    }

    final calls = await manager.activeCalls();

    return null;

    // return if calls and data is not available.
    // if (calls is! List) return null;
    // final call = calls.lastOrNull;
    // if (call is! Map) return null;
    //
    // final incomingCid = call['extra']?['incomingCallCid'];
    //
    // if (incomingCid == null) return null;
    //
    // return _from(StreamCallCid(cid: incomingCid));
    // manager.activeCalls();
    //
    // return manager.consumeIncomingCall().then((data) {
    //   return data?.let((it) => _makeCallFromCreated(data: it));
    // });
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

extension StreamVideoX on StreamVideo {
  /// Connects the [user] to the Stream Video service using a static token.
  Future<Result<String>> connectUser(
    UserInfo user,
    String token,
  ) {
    return connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.static(UserToken.fromRawValue(token)),
    );
  }
}
