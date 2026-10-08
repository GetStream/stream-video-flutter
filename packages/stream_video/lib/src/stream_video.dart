import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' show CompositeSubscription;
import 'package:stream_core/stream_core.dart' hide LifecycleState;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../globals.dart';
import '../open_api/video/coordinator/api.dart' hide User;
import 'audio_processing/audio_processor.dart';
import 'call/call.dart';
import 'call/call_ringing_state.dart';
import 'call/call_host.dart';
import 'call/call_type.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'core/client_state.dart';
import 'core/coordinator_connection.dart';
import 'core/internet_connection_network_state_provider.dart';
import 'errors/stream_video_exception.dart';
import 'internal/_instance_holder.dart';
import 'latency/latency_service.dart';
import 'latency/latency_settings.dart';
import 'lifecycle/app_lifecycle_controller.dart';
import 'lifecycle/lifecycle_state.dart';
import 'lifecycle/lifecycle_utils.dart'
    if (dart.library.io) 'lifecycle/lifecycle_utils_io.dart'
    as lifecycle;
import 'logger/core_log_bridge.dart';
import 'logger/impl/console_logger.dart';
import 'logger/impl/external_logger.dart';
import 'logger/impl/tagged_logger.dart';
import 'logger/logger_api.dart';
import 'logger/stream_log.dart';
import 'models/audio_configuration_policy.dart';
import 'models/call_cid.dart';
import 'models/call_metadata.dart';
import 'models/call_preferences.dart';
import 'models/call_ringing_data.dart';
import 'models/multi_call_audio_policy.dart';
import 'models/push_device.dart';
import 'models/push_provider.dart';
import 'models/queried_calls.dart';
import 'models/user.dart';
import 'models/user_info.dart';
import 'network_monitor_settings.dart';
import 'push_notification/push_notification_manager.dart';
import 'retry/retry_policy.dart';
import 'ring_state_polling_settings.dart';
import 'ringing/ringing_flow_coordinator.dart';
import 'ringing/ringing_flow_coordinator_impl.dart';
import 'telemetry/client_event_reporter.dart';
import 'telemetry/client_event_transport.dart';
import 'token/token.dart';
import 'token/token_provider_factory.dart';
import 'token/token_source.dart';
import 'utils/none.dart';
import 'utils/result.dart';
import 'utils/subscriptions.dart';
import 'webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import 'webrtc/sdp/policy/sdp_policy.dart';

const _tag = 'SV:Client';

const _idEvents = 1;
const _idAppState = 2;

const _defaultCoordinatorRpcUrl = 'https://video.stream-io-api.com';
const _defaultCoordinatorWsUrl = 'wss://video.stream-io-api.com/video/connect';

/// Handler function used for logging.
typedef LogHandlerFunction =
    void Function(
      Priority priority,
      String tag,
      MessageBuilder message, [
      Object? error,
      StackTrace? stk,
    ]);

/// The client responsible for handling config and maintaining calls
class StreamVideo extends Disposable implements CallHost {
  /// Creates a new Stream Video client associated with the
  /// Stream Video singleton instance
  ///
  /// If [failIfSingletonExists] is set to false, the new instance will override and disconnect the existing singleton instance.
  factory StreamVideo(
    String apiKey, {
    StreamVideoOptions? options,
    required User user,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    bool failIfSingletonExists = true,
    PNManagerProvider? pushNotificationManagerProvider,
  }) {
    final instance = StreamVideo._(
      apiKey,
      options: options ?? StreamVideoOptions(),
      user: user,
      userToken: userToken,
      tokenLoader: tokenLoader,
      onTokenUpdated: onTokenUpdated,
      pushNotificationManagerProvider: pushNotificationManagerProvider,
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
    required User user,
    StreamVideoOptions? options,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    PNManagerProvider? pushNotificationManagerProvider,
    @Deprecated(
      'No longer used, SDPs are now generated lazily per call. This parameter is a no-op and will be removed in a future major release.',
    )
    bool precacheGenericSdps = true,
  }) {
    final instance = StreamVideo._(
      apiKey,
      user: user,
      options: options ?? StreamVideoOptions(),
      userToken: userToken,
      tokenLoader: tokenLoader,
      onTokenUpdated: onTokenUpdated,
      pushNotificationManagerProvider: pushNotificationManagerProvider,
    );
    return instance;
  }

  /// Creates a client unassociated with the singleton, like
  /// [StreamVideo.create].
  ///
  /// When given, it talks to [coordinatorClient] instead of building one,
  /// and follows the stream [appState] returns instead of the app's
  /// lifecycle. [appState] is called on each connect; unlike the app's
  /// lifecycle, its stream need not emit the current state on listen.
  @visibleForTesting
  factory StreamVideo.forTesting(
    String apiKey, {
    required User user,
    StreamVideoOptions? options,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    PNManagerProvider? pushNotificationManagerProvider,
    CoordinatorClient? coordinatorClient,
    Stream<LifecycleState> Function()? appState,
  }) {
    return StreamVideo._(
      apiKey,
      user: user,
      options: options ?? StreamVideoOptions(),
      userToken: userToken,
      tokenLoader: tokenLoader,
      onTokenUpdated: onTokenUpdated,
      pushNotificationManagerProvider: pushNotificationManagerProvider,
      coordinatorClient: coordinatorClient,
      appState: appState,
    );
  }

  StreamVideo._(
    this.apiKey, {
    required User user,
    required StreamVideoOptions options,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    PNManagerProvider? pushNotificationManagerProvider,
    CoordinatorClient? coordinatorClient,
    Stream<LifecycleState> Function()? appState,
  }) : _options = options,
       _appStateOverride = appState,
       _state = MutableClientState(user, options) {
    _networkMonitor =
        _options.networkMonitorSettings.internetConnectionInstance ??
        InternetConnection.createInstance(
          checkInterval: _options.networkMonitorSettings.checkInterval,
          triggerStream: Connectivity().onConnectivityChanged,
          useDefaultOptions:
              _options.networkMonitorSettings.customEndpoints.isEmpty,
          customCheckOptions:
              _options.networkMonitorSettings.customEndpoints.isEmpty
              ? null
              : _options.networkMonitorSettings.customEndpoints
                    .map((option) => option.toInternetCheckOption())
                    .toList(),
        );

    _clientEventReporter = _options.clientEventsReportingEnabled
        ? ClientEventReporter(
            transport: ClientEventTransport(
              baseUrl: _options.coordinatorRpcUrl,
              apiKey: apiKey,
              getToken: _clientEventToken,
            ),
            resolveUserId: () => _state.currentUser.id,
          )
        : const ClientEventReporter.noOp();

    if (user.type == UserType.guest) {
      // A guest's identity is assigned by the server, so the manager starts
      // without one and is pointed at the created guest by the first caller
      // that needs a token (see [_establishGuestSession]).
      _tokenManager = TokenManager.unconfigured(onTokenUpdated: onTokenUpdated);
      _tokens = TokenSource(
        _tokenManager,
        establishSession: _establishGuestSession,
      );
    } else {
      _tokenManager = TokenManager(
        userId: user.id,
        tokenProvider: buildTokenProvider(
          user,
          userToken: userToken,
          tokenLoader: tokenLoader,
        ),
        onTokenUpdated: onTokenUpdated,
      );
      _tokens = TokenSource(_tokenManager);
    }

    _client =
        coordinatorClient ??
        buildCoordinatorClient(
          user: user,
          apiKey: apiKey,
          tokenSource: _tokens,
          latencySettings: _options.latencySettings,
          retryPolicy: _options.retryPolicy,
          rpcUrl: _options.coordinatorRpcUrl,
          wsUrl: _options.coordinatorWsUrl,
          networkMonitor: _networkMonitor,
          clientEventReporter: _clientEventReporter,
        );

    // Initialize the push notification manager if the provider is provided.
    pushNotificationManager = pushNotificationManagerProvider?.call(
      _client,
      this,
    );

    _state.user.value = user;

    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) {
      RtcMediaDeviceNotifier.instance
          .reinitializeAudioConfiguration(options.audioConfigurationPolicy)
          .then((_) {
            webrtcInitializationCompleter.complete();
          })
          .onError((_, _) {
            webrtcInitializationCompleter.complete();
          });
    } else {
      webrtcInitializationCompleter.complete();
    }

    // Pre-warm the token cache, mirroring the eager fetch previously
    // triggered by setting the token provider. Failures are logged by
    // getToken and surface later, when the token is actually needed — the
    // caller that needs one then establishes the session itself.
    unawaited(_tokens.getToken());

    _setupLogger(options.logPriority, options.logHandlerFunction);

    unawaited(
      videoEnvironmentManager
          .collectAndUpdate()
          .catchError((Object error, StackTrace stackTrace) {
            _logger.e(
              () =>
                  '[StreamVideo] failed to collect environment: $error '
                  'with stackTrace: $stackTrace',
            );
          })
          .whenComplete(() {
            if (options.autoConnect) {
              connect(
                includeUserDetails: options.includeUserDetailsForAutoConnect,
              ).catchError((dynamic error, StackTrace stackTrace) {
                _logger.e(
                  () =>
                      '[StreamVideo] failed to auto connect: $error '
                      'with stackTrace: $stackTrace',
                );

                return failureWithError<UserToken>(
                  'Failed to auto connect: $error',
                );
              });
            }
          }),
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
  final String apiKey;

  final MutableClientState _state;

  StreamVideoOptions get options => _options;

  @internal
  Completer<void> webrtcInitializationCompleter = Completer();

  late final TokenManager _tokenManager;

  /// Every token this client authenticates with comes from here, so a guest's
  /// identity is established by whichever caller needs a token first rather
  /// than only by [connect].
  late final TokenSource _tokens;

  /// Creates this client's guest and adopts the identity the server assigns.
  ///
  /// Called by [_tokens] alone, which shares one exchange between concurrent
  /// callers and retries after a failure.
  Future<Result<UserToken>> _establishGuestSession() {
    return establishGuestSession(
      tokenManager: _tokenManager,
      user: _state.user.value,
      createGuest: ({required id, name, image, required custom}) =>
          _client.loadGuest(id: id, name: name, image: image, custom: custom),
      onGuestUserUpdated: (updatedUser) => _state.user.value = updatedUser,
    );
  }

  final _subscriptions = Subscriptions();

  late final CoordinatorClient _client;

  /// Replaces the app's lifecycle stream in tests.
  final Stream<LifecycleState> Function()? _appStateOverride;
  late final InternetConnection _networkMonitor;
  late final PushNotificationManager? pushNotificationManager;

  late final ClientEventReporter _clientEventReporter;

  @internal
  ClientEventReporter get clientEventReporter => _clientEventReporter;

  /// Resolves the current user token for the telemetry transport's auth
  /// interceptor, mirroring the coordinator client's authentication.
  Future<UserToken> _clientEventToken() async {
    final tokenResult = await _tokens.getToken();
    if (tokenResult is! Success<UserToken>) {
      throw (tokenResult as Failure).videoError;
    }
    return tokenResult.data;
  }

  /// Records the app's lifecycle, and closes the connection in the
  /// background while no call is active.
  late final _lifecycle = AppLifecycleController(
    state: _state,
    keepConnectionAliveInBackground: () =>
        _options.keepConnectionsAliveWhenInBackground,
    isConnected: () => _client.isConnected,
    closeConnection: () async {
      _subscriptions.cancel(_idEvents);
      await _client.closeConnection();
    },
    openConnection: () async {
      await _client.openConnection();
      _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
    },
  );

  @override
  @internal
  Future<void>? prepareToAccept(Call call) => _ringing.prepareToAccept(call);

  /// Handles ringing calls: the incoming ring, the native call screen's
  /// actions, the ringing pushes, and the auto-reject of an unanswered call.
  RingingFlowCoordinator get ringing => _ringing;

  late final _ringing = RingingFlowCoordinatorImpl(
    state: _state,
    client: _client,
    pushNotificationManager: () => pushNotificationManager,
    options: _options,
    makeRingingCall: _makeCallFromRinging,
    ensureConnected: connect,
  );

  /// Returns the current user.
  UserInfo get currentUser => _state.currentUser.toUserInfo();

  /// Returns the current user type.
  UserType get currentUserType => _state.currentUser.type;

  /// Returns the [StreamVideo] state.
  ClientState get state => _state;

  /// Returns the active call if exists.
  List<Call> get activeCalls => _state.activeCalls.value;

  Call? get activeCall {
    if (_options.allowMultipleActiveCalls) {
      throw Exception(
        'Multiple active calls are enabled, use activeCalls instead',
      );
    }

    return _state.activeCalls.value.singleOrNull;
  }

  /// You can subscribe to WebSocket events provided by the API.
  /// Please note that subscribing to WebSocket events is an advanced use-case,
  /// for most use-cases it should be enough to watch for changes
  /// in the reactive [Call.state].
  Stream<CoordinatorEvent> get events => _client.events;

  /// Connects the user, and disconnects them again.
  late final _connection = CoordinatorConnection(
    client: _client,
    state: _state,
    tokens: _tokens,
    pushNotificationManager: () => pushNotificationManager,
    onConnected: () {
      _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
      _subscriptions.add(
        _idAppState,
        (_appStateOverride?.call() ?? lifecycle.appState).listen(
          _lifecycle.onAppState,
        ),
      );
    },
    onDisconnected: () async {
      _subscriptions.cancelAll();
      _ringing.clear();
      await _state.clear();
    },
  );

  /// Connects the user to the Stream Video service.
  ///
  /// Connects and disconnects run one at a time, in the order they are
  /// called. A connect while the user is connected opens no second connection
  /// and returns the current token, so [includeUserDetails] only applies to
  /// the connect that opens it; one queued behind a connect that failed tries
  /// again itself. [registerPushDevice] registers the push device once per
  /// connection, also from a later connect when the first one skipped it.
  Future<Result<UserToken>> connect({
    bool includeUserDetails = true,
    bool registerPushDevice = true,
  }) {
    return _connection.connect(
      includeUserDetails: includeUserDetails,
      registerPushDevice: registerPushDevice,
    );
  }

  /// Disconnects the user from the Stream Video service, and unregisters the
  /// push device. The user ends up disconnected even when a step fails; the
  /// result reports a failure to close the connection.
  Future<Result<None>> disconnect() => _connection.disconnect();

  @override
  Future<void> dispose() async {
    _logger.i(() => '[dispose]');
    // First, while the push manager still ends the native call of each call
    // that leaves.
    await _disposeCalls(_trackedCalls());

    // Keeps the push device registered: a client disposed after handling a
    // push in the background must not stop the next one.
    await _connection.dispose();

    _ringing.dispose();

    _subscriptions.cancelAll();
    await pushNotificationManager?.dispose();
    _clientEventReporter.dispose();
    await _state.clear();

    return super.dispose();
  }

  /// Every call this client tracks, each once.
  Set<Call> _trackedCalls() {
    final calls = LinkedHashSet<Call>.identity()
      ..addAll(_state.activeCalls.value)
      ..addAll(_ringing.ringingCalls)
      ..addAll(_state.watchedCalls.value);
    if (_state.incomingCall.value case final call?) calls.add(call);
    if (_state.outgoingCall.value case final call?) calls.add(call);
    return calls;
  }

  /// Disposes [calls], which leaves the ones still joined.
  Future<void> _disposeCalls(Set<Call> calls) async {
    for (final call in calls) {
      try {
        await call.dispose();
      } catch (e, stk) {
        _logger.e(() => '[dispose] call ${call.callCid} failed: $e\n$stk');
      }
    }
  }

  /// Routes [event] through the coordinator event handling. Tests only.
  @visibleForTesting
  void debugHandleCoordinatorEvent(CoordinatorEvent event) => _onEvent(event);

  void _onEvent(CoordinatorEvent event) {
    _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
    if (_ringing.handleCoordinatorEvent(event)) {
      return;
    } else {
      _connection.handleEvent(event);
      if (event is CoordinatorConnectedEvent) _rewatchCalls();
    }
  }

  void _rewatchCalls() {
    final watched = state.watchedCalls.value;
    if (watched.isEmpty) return;

    _logger.d(() => '[rewatchCalls] count: ${watched.length}');
    unawaited(
      queryCalls(
        watch: true,
        filterConditions: {
          'cid': {r'$in': watched.map((call) => call.callCid.value).toList()},
        },
      ).then((result) {
        if (result case Failure(:final error)) {
          _logger.e(
            () =>
                '[rewatchCalls] re-watching ${watched.length} call(s) '
                'failed: $error',
          );
        }
      }),
    );
  }

  StreamSubscription<Call?> listenActiveCall(
    void Function(Call? value)? onActiveCall,
  ) {
    if (_options.allowMultipleActiveCalls) {
      throw Exception(
        'Multiple active calls are enabled, use listenActiveCalls instead',
      );
    }

    return _state.activeCall.listen(onActiveCall);
  }

  StreamSubscription<List<Call>> listenActiveCalls(
    void Function(List<Call> value)? onActiveCalls,
  ) {
    return _state.activeCalls.listen(onActiveCalls);
  }

  Call makeCall({
    required StreamCallType callType,
    required String id,
    CallPreferences? preferences,
  }) {
    return Call(
      callCid: StreamCallCid.from(type: callType, id: id),
      coordinatorClient: _client,
      streamVideo: this,
      networkMonitor: _networkMonitor,
      retryPolicy: _options.retryPolicy,
      sdpPolicy: _options.sdpPolicy,
      preferences: preferences ?? _options.defaultCallPreferences,
    );
  }

  Call _makeCallFromRinging(
    CallRingingData data, {
    CallPreferences? preferences,
  }) {
    return Call.fromRinging(
      data: data,
      coordinatorClient: _client,
      streamVideo: this,
      networkMonitor: _networkMonitor,
      retryPolicy: _options.retryPolicy,
      sdpPolicy: _options.sdpPolicy,
      preferences: preferences ?? _options.defaultCallPreferences,
    );
  }

  /// Queries the API for calls.
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    int? limit,
    List<SortParamRequest>? sorts,
    bool? watch,
  }) {
    return _client.queryCalls(
      filterConditions: filterConditions,
      next: next,
      limit: limit,
      prev: prev,
      sorts: sorts ?? [],
      watch: watch,
    );
  }

  /// Adds a device that will be used to receive push notifications.
  Future<Result<None>> addDevice({
    required String pushToken,
    required PushProvider pushProvider,
    String? pushProviderName,
    bool? voipToken,
  }) {
    _logger.d(
      () =>
          '[addDevice] pushProvider: $pushProvider'
          ', pushToken: $pushToken, pushProviderName: $pushProviderName'
          ', voipToken: $voipToken',
    );
    return _client.createDevice(
      id: pushToken,
      pushProvider: pushProvider,
      pushProviderName: pushProviderName,
      voipToken: voipToken,
    );
  }

  /// Gets a list of devices used to receive push notifications.
  Future<Result<List<PushDevice>>> getDevices() {
    return _client.listDevices();
  }

  /// Removes a device used to receive push notifications.
  Future<Result<None>> removeDevice({required String pushToken}) {
    _logger.d(() => '[removeDevice] pushToken: $pushToken');
    return _client.deleteDevice(id: pushToken, userId: currentUser.id);
  }

  Future<Result<List<CallRecording>>> listRecordings(
    StreamCallCid callCid,
  ) async {
    _logger.d(() => '[listRecordings] Call $callCid');
    final result = await _client.listRecordings(callCid);
    _logger.v(() => '[listRecordings] result: $result');
    return result;
  }

  /// Forwards to [RingingFlowCoordinator.onRingingEvent].
  @Deprecated('Use ringing.onRingingEvent instead.')
  StreamSubscription<T>? onRingingEvent<T extends RingingEvent>(
    void Function(T event)? onEvent,
  ) => ringing.onRingingEvent<T>(onEvent);

  /// Forwards to [RingingFlowCoordinator.consumeAndAcceptActiveCall].
  @Deprecated('Use ringing.consumeAndAcceptActiveCall instead.')
  Future<bool> consumeAndAcceptActiveCall({
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) => ringing.consumeAndAcceptActiveCall(
    onCallAccepted: onCallAccepted,
    callPreferences: callPreferences,
  );

  /// Forwards to [RingingFlowCoordinator.observeCoreRingingEvents].
  @Deprecated('Use ringing.observeCoreRingingEvents instead.')
  CompositeSubscription observeCoreRingingEvents({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) => ringing.observeCoreRingingEvents(
    onCallAccepted: onCallAccepted,
    acceptCallPreferences: acceptCallPreferences,
  );

  /// Forwards to
  /// [RingingFlowCoordinator.observeCoreRingingEventsForBackground].
  @Deprecated('Use ringing.observeCoreRingingEventsForBackground instead.')
  CompositeSubscription observeCoreRingingEventsForBackground() =>
      ringing.observeCoreRingingEventsForBackground();

  /// Forwards to [RingingFlowCoordinator.observeCallAcceptRingingEvent].
  @Deprecated('Use ringing.observeCallAcceptRingingEvent instead.')
  StreamSubscription<ActionCallAccept>? observeCallAcceptRingingEvent({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) => ringing.observeCallAcceptRingingEvent(
    onCallAccepted: onCallAccepted,
    acceptCallPreferences: acceptCallPreferences,
  );

  /// Forwards to [RingingFlowCoordinator.observeCallIncomingRingingEvent].
  @Deprecated('Use ringing.observeCallIncomingRingingEvent instead.')
  StreamSubscription<ActionCallIncoming>? observeCallIncomingRingingEvent() =>
      ringing.observeCallIncomingRingingEvent();

  /// Forwards to [RingingFlowCoordinator.observeCallDeclinedRingingEvent].
  @Deprecated('Use ringing.observeCallDeclinedRingingEvent instead.')
  StreamSubscription<ActionCallDecline>? observeCallDeclinedRingingEvent() =>
      ringing.observeCallDeclinedRingingEvent();

  /// Forwards to [RingingFlowCoordinator.observeCallEndedRingingEvent].
  @Deprecated('Use ringing.observeCallEndedRingingEvent instead.')
  StreamSubscription<ActionCallEnded>? observeCallEndedRingingEvent() =>
      ringing.observeCallEndedRingingEvent();

  /// Forwards to [RingingFlowCoordinator.verifyDisplayedIncomingCalls].
  @Deprecated('Use ringing.verifyDisplayedIncomingCalls instead.')
  Future<void> verifyDisplayedIncomingCalls({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) => ringing.verifyDisplayedIncomingCalls(
    onCallAccepted: onCallAccepted,
    acceptCallPreferences: acceptCallPreferences,
  );

  /// Forwards to [RingingFlowCoordinator.isCallAcceptedOnThisDevice].
  @Deprecated('Use ringing.isCallAcceptedOnThisDevice instead.')
  bool isCallAcceptedOnThisDevice(String cid) =>
      ringing.isCallAcceptedOnThisDevice(cid);

  /// Forwards to [RingingFlowCoordinator.handleRingingFlowNotifications].
  @Deprecated('Use ringing.handleRingingFlowNotifications instead.')
  Future<bool> handleRingingFlowNotifications(
    Map<String, dynamic> payload, {
    bool handleMissedCall = true,
  }) => ringing.handleRingingFlowNotifications(
    payload,
    handleMissedCall: handleMissedCall,
  );

  /// Forwards to [RingingFlowCoordinator.getCallRingingState].
  @Deprecated('Use ringing.getCallRingingState instead.')
  Future<CallRingingState> getCallRingingState({
    required StreamCallType callType,
    required String id,
  }) => ringing.getCallRingingState(callType: callType, id: id);

  /// Forwards to [RingingFlowCoordinator.consumeIncomingCall].
  @Deprecated('Use ringing.consumeIncomingCall instead.')
  Future<Result<Call>> consumeIncomingCall({
    required String uuid,
    required String cid,
    CallPreferences? preferences,
    CallMetadata? metadata,
  }) => ringing.consumeIncomingCall(
    uuid: uuid,
    cid: cid,
    preferences: preferences,
    metadata: metadata,
  );

  /// Disposes this client a second after the ringing flow resolves — once the
  /// user has answered, declined, or let the call time out.
  ///
  /// [disposingCallback] runs first, for whatever the caller set up alongside
  /// the client.
  @Deprecated(
    'Use StreamVideoPushHandler.handleBackgroundMessage instead, which runs the '
    'whole background lifecycle.',
  )
  StreamSubscription<RingingEvent>? disposeAfterResolvingRinging({
    void Function()? disposingCallback,
  }) {
    return ringing.onRingingEvent((event) {
      if (event is ActionCallAccept ||
          event is ActionCallDecline ||
          event is ActionCallTimeout ||
          event is ActionCallEnded) {
        // Delay the callback to ensure the call is fully resolved.
        Future<void>.delayed(const Duration(seconds: 1), () {
          disposingCallback?.call();
          dispose();
        });
      }
    });
  }

  @internal
  bool isAudioProcessorConfigured() {
    return _options.audioProcessor != null;
  }

  @internal
  Future<Result<bool>> isAudioProcessingEnabled() async {
    return await _options.audioProcessor?.isEnabled() ??
        const Result.failure(
          StreamVideoException(message: 'No audio processor found.'),
        );
  }

  @internal
  Future<Result<None>> setAudioProcessingEnabled(bool enabled) async {
    return await _options.audioProcessor?.setEnabled(enabled) ??
        const Result.failure(
          StreamVideoException(message: 'No audio processor found.'),
        );
  }

  /// This method returns true if the iOS device supports Apple's Neural Engine
  /// or if an Android device has the FEATURE_AUDIO_PRO feature enabled.
  /// Devices with this capability are better suited for handling noise cancellation efficiently.
  ///
  /// Returns false on other platforms.
  Future<Result<bool>> deviceSupportsAdvancedAudioProcessing() async {
    return await _options.audioProcessor
            ?.deviceSupportsAdvancedAudioProcessing() ??
        const Result.failure(
          StreamVideoException(message: 'No audio processor found.'),
        );
  }
}

CoordinatorClient buildCoordinatorClient({
  required User user,
  required String rpcUrl,
  required String wsUrl,
  required String apiKey,
  required TokenSource tokenSource,
  required RetryPolicy retryPolicy,
  required LatencySettings latencySettings,
  required InternetConnection networkMonitor,
  ClientEventReporter clientEventReporter = const ClientEventReporter.noOp(),
}) {
  streamLog.i(_tag, () => '[buildCoordinatorClient] rpcUrl: $rpcUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] wsUrl: $wsUrl');
  streamLog.i(_tag, () => '[buildCoordinatorClient] apiKey: $apiKey');

  // Retries live in the HTTP client's interceptor chain, so there is no
  // wrapper around these methods any more.
  return CoordinatorClientOpenApi(
    apiKey: apiKey,
    tokenSource: tokenSource,
    latencyService: LatencyService(settings: latencySettings),
    retryPolicy: retryPolicy,
    rpcUrl: rpcUrl,
    wsUrl: wsUrl,
    isAnonymous: user.type == UserType.anonymous,
    networkStateProvider: InternetConnectionNetworkStateProvider(
      networkMonitor,
    ),
    clientEventReporter: clientEventReporter,
  );
}

void _setupLogger(Priority logPriority, LogHandlerFunction logHandlerFunction) {
  if (logPriority != Priority.none) {
    StreamLog().priority = logPriority;
    StreamLog().logger = CompositeStreamLogger([
      const ConsoleStreamLogger(),
      ExternalStreamLogger(logHandlerFunction),
    ]);

    installCoreLogBridge(logPriority);
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
  StreamVideoOptions({
    this.coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    this.coordinatorWsUrl = _defaultCoordinatorWsUrl,
    this.latencySettings = const LatencySettings(),
    this.retryPolicy = const RetryPolicy(),
    this.defaultCallPreferences,
    this.sdpPolicy = const SdpPolicy(),
    this.audioProcessor,
    this.logPriority = Priority.none,
    this.logHandlerFunction = _defaultLogHandler,
    this.muteVideoWhenInBackground = false,
    this.muteAudioWhenInBackground = false,
    this.autoConnect = true,
    this.includeUserDetailsForAutoConnect = true,
    this.keepConnectionsAliveWhenInBackground = false,
    this.networkMonitorSettings = const NetworkMonitorSettings(),
    this.allowMultipleActiveCalls = false,
    this.multiCallAudioPolicy = MultiCallAudioPolicy.suspendExisting,
    this.clientEventsReportingEnabled = true,
    this.ringStatePolling = const RingStatePollingSettings(),
    @Deprecated(
      'Use audioConfigurationPolicy instead. This parameter will be removed in the next major release.',
    )
    this.androidAudioConfiguration,
    AudioConfigurationPolicy? audioConfigurationPolicy,
  }) : audioConfigurationPolicy = androidAudioConfiguration == null
           ? audioConfigurationPolicy ?? const BroadcasterAudioPolicy()
           : CustomAudioPolicy(androidConfiguration: androidAudioConfiguration);

  final String coordinatorRpcUrl;
  final String coordinatorWsUrl;
  final LatencySettings latencySettings;

  /// Returns the current [RetryPolicy].
  final RetryPolicy retryPolicy;
  final CallPreferences? defaultCallPreferences;

  /// Returns the current [SdpPolicy].
  final SdpPolicy sdpPolicy;

  final Priority logPriority;
  final LogHandlerFunction logHandlerFunction;

  final AudioProcessor? audioProcessor;

  /// Mutes the camera track while the app is in the background.
  ///
  /// On iOS devices without multitasking camera access the camera track is
  /// muted in the background regardless of this option.
  final bool muteVideoWhenInBackground;
  final bool muteAudioWhenInBackground;
  final bool autoConnect;
  final bool includeUserDetailsForAutoConnect;
  final bool keepConnectionsAliveWhenInBackground;
  final bool allowMultipleActiveCalls;

  /// Controls automatic audio suspension between calls when
  /// [allowMultipleActiveCalls] is `true`. Defaults to [MultiCallAudioPolicy.suspendExisting].
  ///
  /// Ignored when [allowMultipleActiveCalls] is `false`.
  final MultiCallAudioPolicy multiCallAudioPolicy;

  /// Whether to report join-lifecycle telemetry
  final bool clientEventsReportingEnabled;

  /// Caller-side polling for the ring outcome, used when `call.accepted` or
  /// `call.rejected` never arrives over the WebSocket. Enabled by default; pass
  /// [RingStatePollingSettings.disabled] to turn it off.
  final RingStatePollingSettings ringStatePolling;

  /// Returns the current [NetworkMonitorSettings].
  final NetworkMonitorSettings networkMonitorSettings;

  @Deprecated(
    'Use audioConfigurationPolicy instead. This parameter will be removed in the next major release.',
  )
  final rtc.AndroidAudioConfiguration? androidAudioConfiguration;

  /// The audio configuration policy for the SDK.
  ///
  /// **Broadcaster Policy** (default) - For active participation:
  /// - Use for: meeting participants, livestream hosts, active speakers
  /// - Enables echo cancellation and noise suppression
  /// - Volume buttons control call volume (Android)
  /// - Optimized for voice clarity
  ///
  /// **Viewer Policy** - For passive consumption:
  /// - Use for: livestream viewers, watch-only audience
  /// - Disables audio processing for higher fidelity
  /// - Volume buttons control media volume (Android)
  /// - Optimized for audio quality
  /// - Enables stereo playout
  ///
  /// Use predefined policies:
  /// - [AudioConfigurationPolicy.broadcaster] - Voice/video calls (default)
  /// - [AudioConfigurationPolicy.viewer] - Livestream playback
  /// - [AudioConfigurationPolicy.custom] - Full control over platform settings
  ///
  /// Defaults to [BroadcasterAudioPolicy].
  /// Once set it will be applied for all calls.
  /// To change the audio configuration policy after initial setup, use [RtcMediaDeviceNotifier.reinitializeAudioConfiguration].
  final AudioConfigurationPolicy audioConfigurationPolicy;
}
