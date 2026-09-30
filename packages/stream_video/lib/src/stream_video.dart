import 'dart:async';

import 'package:async/async.dart' as async;
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_core/stream_core.dart' hide LifecycleState;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:uuid/uuid.dart';

import '../globals.dart';
import '../open_api/video/coordinator/api.dart' hide User;
import 'audio_processing/audio_processor.dart';
import 'call/call.dart';
import 'call/call_reject_reason.dart';
import 'call/call_ringing_state.dart';
import 'call/call_type.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/models/coordinator_events.dart';
import 'coordinator/open_api/coordinator_client_open_api.dart';
import 'core/client_state.dart';
import 'core/connection_state.dart';
import 'core/internet_connection_network_state_provider.dart';
import 'errors/stream_video_exception.dart';
import 'errors/stream_video_exception_composer.dart';
import 'internal/_background_mute_policy.dart';
import 'internal/_instance_holder.dart';
import 'latency/latency_service.dart';
import 'latency/latency_settings.dart';
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
import 'models/call_received_data.dart';
import 'models/call_ringing_data.dart';
import 'models/call_status.dart';
import 'models/disconnect_reason.dart';
import 'models/multi_call_audio_policy.dart';
import 'models/push_device.dart';
import 'models/push_provider.dart';
import 'models/queried_calls.dart';
import 'models/user.dart';
import 'models/user_info.dart';
import 'network_monitor_settings.dart';
import 'push_notification/push_notification_manager.dart';
import 'retry/retry_policy.dart';
import 'telemetry/client_event_reporter.dart';
import 'telemetry/client_event_transport.dart';
import 'token/token.dart';
import 'token/token_provider_factory.dart';
import 'token/token_source.dart';
import 'utils/cancelable_operation.dart';
import 'utils/future.dart';
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
class StreamVideo extends Disposable {
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

  StreamVideo._(
    this.apiKey, {
    required User user,
    required StreamVideoOptions options,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    PNManagerProvider? pushNotificationManagerProvider,
  }) : _options = options,
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

    _client = buildCoordinatorClient(
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

  final Map<String, bool> _mutedCameraByStateChange = {};
  final Map<String, bool> _mutedAudioByStateChange = {};
  final Map<String, Timer> _incomingAutoRejectTimers = {};
  final Set<String> _handledIncomingCallCids = {};
  final Set<String> _acceptingCallCids = {};

  /// Calls built for a ringing flow, by cid.
  ///
  /// Deliberately not [ClientState.incomingCall]: that one is the app-facing
  /// signal for showing an incoming call. This only exists so that every path
  /// consuming the same ringing flow ends up with the same [Call].
  final Map<String, Call> _ringingCalls = {};

  /// Cids this device has accepted, from the moment the accept is sent to the
  /// coordinator until the call is cleaned up.
  final Map<String, Call> _locallyAcceptedCalls = {};

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
  Future<Result<UserToken>> connect({
    bool includeUserDetails = true,
    bool registerPushDevice = true,
  }) async {
    if (currentUserType == UserType.anonymous) {
      _logger.w(() => '[connect] rejected (anonymous user)');
      return failureWithError(
        'Cannot connect anonymous user to the WS due to Missing Permissions',
      );
    }

    _connectOperation ??= _connect(
      includeUserDetails: includeUserDetails,
      registerPushDevice: registerPushDevice,
    ).asCancelable();

    return _connectOperation!
        .valueOrDefault(failureWithError('connect was cancelled'))
        .whenComplete(() {
          _logger.i(() => '[connect] clear shared operation');
          _connectOperation = null;
        });
  }

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnect() async {
    _disconnectOperation ??= _disconnect().asCancelable();
    return _disconnectOperation!
        .valueOrDefault(failureWithError('disconnect was cancelled'))
        .whenComplete(() {
          _logger.i(() => '[disconnect] clear shared operation');
          _disconnectOperation = null;
        });
  }

  Future<Result<UserToken>> _connect({
    bool includeUserDetails = false,
    bool registerPushDevice = true,
  }) async {
    _logger.i(() => '[connect] currentUser.id: ${_state.currentUser.id}');

    if (_connectionState.isConnected) {
      _logger.w(() => '[connect] rejected (already connected)');
      // The cache can be briefly empty while a token refresh is in flight;
      // getToken serves the cached token when present and otherwise waits
      // for the refresh instead of failing.
      return _tokens.getToken();
    }

    _connectionState = ConnectionState.connecting(_state.currentUser.id);

    // Establishes a guest's server-assigned identity, unless a request that
    // needed a token got there first.
    final tokenResult = await _tokens.getToken();
    if (tokenResult is! Success<UserToken>) {
      _logger.e(() => '[connect] token fetching failed: $tokenResult');
      _connectionState = ConnectionState.failed(
        _state.currentUser.id,
        error: (tokenResult as Failure).videoError,
      );
      return tokenResult;
    }

    final user = _state.user.value;
    _logger.v(() => '[connect] currentUser.id : ${user.id}');
    try {
      await _disconnectOperation?.cancel();
      final result = await _client.connectUser(
        user.toUserInfo(),
        includeUserDetails: includeUserDetails,
      );
      _logger.v(() => '[connect] completed: $result');
      if (result is Failure) {
        _connectionState = ConnectionState.failed(
          _state.currentUser.id,
          error: result.videoError,
        );
        return result;
      }
      _connectionState = ConnectionState.connected(_state.currentUser.id);
      _subscriptions.add(_idEvents, _client.events.listen(_onEvent));
      _subscriptions.add(_idAppState, lifecycle.appState.listen(_onAppState));

      // Register device with push notification manager.
      if (registerPushDevice) {
        pushNotificationManager?.registerDevice();
      }

      return Result.success(tokenResult.data);
    } catch (e, stk) {
      _logger.e(() => '[connect] failed(${user.id}): $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Drops the per-connection ringing bookkeeping.
  void _clearRingingState() {
    _ringingCalls.clear();
    _locallyAcceptedCalls.clear();
    _acceptingCallCids.clear();
    _handledIncomingCallCids.clear();
  }

  Future<Result<None>> _disconnect() async {
    _logger.i(() => '[disconnect] currentUser.id: ${_state.currentUser.id}');
    if (_connectionState.isDisconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      // Reachable with state still held: a dropped websocket marks the client
      // disconnected without coming through here.
      _clearRingingState();
      return const Result.success(none);
    }
    try {
      await _connectOperation?.cancel();

      // Unregister device from push notification manager.
      await pushNotificationManager?.unregisterDevice();

      await _client.disconnectUser();
      _subscriptions.cancelAll();

      _clearRingingState();
      await _state.clear();
      _connectionState = ConnectionState.disconnected(_state.currentUser.id);
      _logger.v(() => '[disconnect] completed');
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[disconnect] failed: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<void> dispose() async {
    _logger.i(() => '[dispose]');

    if (!_connectionState.isDisconnected) {
      await _client.disconnectUser();
    }

    for (final timer in _incomingAutoRejectTimers.values) {
      timer.cancel();
    }
    _incomingAutoRejectTimers.clear();
    _clearRingingState();

    _subscriptions.cancelAll();
    await pushNotificationManager?.dispose();
    _clientEventReporter.dispose();
    await _state.clear();

    return super.dispose();
  }

  /// Routes [event] through the coordinator event handling. Tests only.
  @visibleForTesting
  void debugHandleCoordinatorEvent(CoordinatorEvent event) => _onEvent(event);

  void _onEvent(CoordinatorEvent event) {
    final currentUserId = _state.currentUser.id;
    _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
    if (event is CoordinatorCallRingingEvent &&
        event.metadata.details.createdBy.id != currentUserId &&
        event.data.ringing) {
      _logger.v(() => '[onCoordinatorEvent] onCallRinging: ${event.data}');

      // In a edge case where call with the same CID as the incoming call is also an outgoing call
      // we want to use the same Call instance.
      if (state.outgoingCall.value?.callCid.value == event.data.callCid.value) {
        _state.incomingCall.value = state.outgoingCall.value;
        return;
      }

      if (isCallAcceptedOnThisDevice(event.data.callCid.value)) {
        _logger.v(
          () => '[onCoordinatorEvent] already accepted here: ${event.data}',
        );
        return;
      }

      final consumedCall = _ringingCalls[event.data.callCid.value];
      if (consumedCall != null) {
        _logger.v(
          () => '[onCoordinatorEvent] reusing consumed call: ${event.data}',
        );
        _state.incomingCall.value = consumedCall;
        return;
      }

      final call = _makeCallFromRinging(data: event.data);
      _ringingCalls[event.data.callCid.value] = call;
      _state.incomingCall.value = call;
    } else if (event is CoordinatorCallRejectedEvent) {
      unawaited(_onRingingCancelled(event));
    } else if (event is CoordinatorConnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] connected ${event.userId}');
      _connectionState = ConnectionState.connected(_state.currentUser.id);
      _rewatchCalls();
    } else if (event is CoordinatorDisconnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] disconnected ${event.userId}');
      _connectionState = ConnectionState.disconnected(_state.currentUser.id);
    } else if (event is CoordinatorReconnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] reconnected ${event.userId}');
    }
  }

  /// Ends a ringing call cancelled by the caller.
  ///
  /// Applies only when the caller rejects; other rejections are handled elsewhere.
  Future<void> _onRingingCancelled(CoordinatorCallRejectedEvent event) async {
    final cid = event.callCid.value;
    if (event.rejectedBy.id != event.metadata.details.createdBy.id) return;

    final call = _ringingCalls[cid] ?? _state.incomingCall.value;
    if (call == null || call.callCid.value != cid) return;

    final status = call.state.value.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) return;

    _logger.i(
      () => '[onCoordinatorEvent] ringing cancelled by the caller, cid: $cid',
    );

    _cancelIncomingAutoRejectTimerByCid(cid);

    // Leaving, not rejecting: the caller has already withdrawn the call, so
    // there is nothing to tell the coordinator. `leave` clears the ringing
    // cache and `incomingCall` on its way out.
    await call.leave(
      reason: DisconnectReason.cancelled(byUserId: event.rejectedBy.id),
    );
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

  /// Whether the capture session in use supports camera access while
  /// multitasking, or `null` when it could not be read.
  Future<bool?> _multitaskingCameraAccessSupported() async {
    if (!CurrentPlatform.isIos) return null;

    try {
      return await rtc.Helper.isIOSMultitaskingCameraAccessSupported();
    } catch (e) {
      _logger.w(() => '[multitaskingCameraAccessSupported] failed: $e');
      return null;
    }
  }

  Future<void> _onAppState(LifecycleState state) async {
    _logger.d(() => '[onAppState] state: $state');
    try {
      final activeCalls = _state.activeCalls.value;
      _state.appLifecycleState.value = state;

      if (state.isPaused) {
        for (final activeCall in activeCalls) {
          activeCall.traceSessionLog('device.stateChange', 'paused');
        }

        // Handle app paused state
        if (activeCalls.isEmpty &&
            !_options.keepConnectionsAliveWhenInBackground) {
          _logger.i(() => '[onAppState] close connection');
          _subscriptions.cancel(_idEvents);
          await _client.closeConnection();
        } else if (activeCalls.isNotEmpty) {
          final multitaskingCameraAccessSupported =
              await _multitaskingCameraAccessSupported();

          for (final activeCall in activeCalls) {
            final callState = activeCall.state.value;
            final isVideoEnabled =
                callState.localParticipant?.isVideoEnabled ?? false;
            final isAudioEnabled =
                callState.localParticipant?.isAudioEnabled ?? false;

            if (shouldMuteCameraInBackground(
              isVideoEnabled: isVideoEnabled,
              muteVideoWhenInBackground: _options.muteVideoWhenInBackground,
              multitaskingCameraAccessSupported:
                  multitaskingCameraAccessSupported,
              platform: CurrentPlatform.type,
            )) {
              await activeCall.setCameraEnabled(enabled: false);
              _mutedCameraByStateChange[activeCall.callCid.value] = true;
              _logger.v(() => 'Muted camera track since app was paused.');
            }
            if (_options.muteAudioWhenInBackground && isAudioEnabled) {
              await activeCall.setMicrophoneEnabled(enabled: false);
              _mutedAudioByStateChange[activeCall.callCid.value] = true;
              _logger.v(() => 'Muted audio track since app was paused.');
            }
          }
        }
      } else if (state.isResumed) {
        // Handle app resumed state
        _logger.i(() => '[onAppState] open connection');
        await _client.openConnection();
        _subscriptions.add(_idEvents, _client.events.listen(_onEvent));

        for (final activeCall in activeCalls) {
          activeCall.traceSessionLog('device.stateChange', 'resumed');

          final wasCameraMuted =
              _mutedCameraByStateChange[activeCall.callCid.value] ?? false;
          if (wasCameraMuted) {
            await activeCall.setCameraEnabled(enabled: true);
            _mutedCameraByStateChange[activeCall.callCid.value] = false;
            _logger.v(() => 'Unmuted camera track since app was unpaused.');
          }

          final wasAudioMuted =
              _mutedAudioByStateChange[activeCall.callCid.value] ?? false;
          if (wasAudioMuted) {
            await activeCall.setMicrophoneEnabled(enabled: true);
            _mutedAudioByStateChange[activeCall.callCid.value] = false;
            _logger.v(() => 'Unmuted audio track since app was unpaused.');
          }
        }
      }
    } catch (e) {
      _logger.e(() => '[onAppState] failed: $e');
    }
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

  Call _makeCallFromRinging({
    required CallRingingData data,
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

  StreamSubscription<T>? onRingingEvent<T extends RingingEvent>(
    void Function(T event)? onEvent,
  ) {
    final manager = pushNotificationManager;
    if (manager == null) {
      _logger.e(() => '[onRingingEvent] rejected (no manager)');
      return null;
    }

    return manager.on<T>(onEvent);
  }

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
    return onRingingEvent((event) {
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

  Future<bool> consumeAndAcceptActiveCall({
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    final allCalls = await pushNotificationManager?.activeCalls();

    // Only consume calls that the user explicitly accepted via the native notification UI.
    final calls = allCalls?.where((c) => c.isAccepted).toList();
    if (calls == null || calls.isEmpty) return false;

    final uuid = calls.first.uuid;
    final cid = calls.first.callCid;
    if (uuid == null || cid == null) return false;

    // Before connecting: on a cold start that is the slow part, and the timer
    // would otherwise reject the call the user just answered.
    _cancelIncomingAutoRejectTimerByCid(cid);

    if (!_acceptingCallCids.add(cid)) {
      _logger.v(() => '[consumeAndAcceptActiveCall] already accepting: $cid');
      return false;
    }

    try {
      final accepted = _acceptedElsewhereOnThisClient(cid);
      if (accepted != null) {
        _logger.v(() => '[consumeAndAcceptActiveCall] already accepted: $cid');
        onCallAccepted?.call(accepted);
        return true;
      }

      // Ensure the coordinator WS is connected before proceeding.
      // During cold start, autoConnect may still be in progress so we need to wait for it to complete.
      final connectResult = await connect();
      if (connectResult.isFailure) {
        _logger.e(
          () =>
              '[consumeAndAcceptActiveCall] failed to connect: '
              '${connectResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      final callResult = await consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        preferences: callPreferences,
      );

      if (callResult.isFailure) {
        _logger.d(
          () =>
              '[consumeAndAcceptActiveCall] error consuming incoming call: '
              '${callResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      final call = callResult.getDataOrNull();
      if (call == null) {
        _logger.e(() => '[consumeAndAcceptActiveCall] no call consumed: $cid');
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      final acceptResult = await call.accept();
      if (acceptResult.isFailure) {
        _logger.w(
          () =>
              '[consumeAndAcceptActiveCall] error accepting call: '
              '${acceptResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return false;
      }

      onCallAccepted?.call(call);

      return true;
    } finally {
      _acceptingCallCids.remove(cid);
    }
  }

  @Deprecated('Use observeCoreRingingEvents instead.')
  CompositeSubscription observeCoreCallKitEvents({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) {
    return observeCoreRingingEvents(
      onCallAccepted: onCallAccepted,
      acceptCallPreferences: acceptCallPreferences,
    );
  }

  /// Helper method to observe core ringing events.
  /// Should be used as soon as the app is launched when handling incoming calls.
  CompositeSubscription observeCoreRingingEvents({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) {
    final ringingEventSubscriptions = CompositeSubscription();

    observeCallIncomingRingingEvent()?.addTo(ringingEventSubscriptions);

    observeCallAcceptRingingEvent(
      onCallAccepted: onCallAccepted,
      acceptCallPreferences: acceptCallPreferences,
    )?.addTo(ringingEventSubscriptions);

    observeCallDeclinedRingingEvent()?.addTo(ringingEventSubscriptions);
    observeCallEndedRingingEvent()?.addTo(ringingEventSubscriptions);

    // The incoming and accept events can be emitted before this call (terminated
    // state), in which case they aren't delivered to the subscriptions above at
    // all, so calls that are already displayed - ringing or answered - are
    // picked up here.
    unawaited(
      verifyDisplayedIncomingCalls(
        onCallAccepted: onCallAccepted,
        acceptCallPreferences: acceptCallPreferences,
      ),
    );

    return ringingEventSubscriptions;
  }

  /// Helper method to observe core ringing events for background.
  /// Should be used in the background handler when handling incoming calls.
  CompositeSubscription observeCoreRingingEventsForBackground() {
    final ringingEventSubscriptions = CompositeSubscription();

    observeCallIncomingRingingEvent()?.addTo(ringingEventSubscriptions);
    observeCallDeclinedRingingEvent()?.addTo(ringingEventSubscriptions);

    return ringingEventSubscriptions;
  }

  @Deprecated('Use observeCallAcceptRingingEvent instead.')
  StreamSubscription<ActionCallAccept>? observeCallAcceptCallKitEvent({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) {
    return observeCallAcceptRingingEvent(
      onCallAccepted: onCallAccepted,
      acceptCallPreferences: acceptCallPreferences,
    );
  }

  StreamSubscription<ActionCallAccept>? observeCallAcceptRingingEvent({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) {
    return onRingingEvent<ActionCallAccept>((event) {
      // Ignore call accept event when app is in detached state on Android.
      // The call flow should be handled by consuming the call like in the terminated state.
      if (!CurrentPlatform.isAndroid ||
          _state.appLifecycleState.value != LifecycleState.detached) {
        _onCallAccept(
          event,
          onCallAccepted: onCallAccepted,
          callPreferences: acceptCallPreferences,
        );
      }
    });
  }

  StreamSubscription<ActionCallIncoming>? observeCallIncomingRingingEvent() {
    return onRingingEvent<ActionCallIncoming>(_onCallIncoming);
  }

  @Deprecated('Use observeCallDeclinedRingingEvent instead.')
  StreamSubscription<ActionCallDecline>? observeCallDeclinedCallKitEvent() {
    return observeCallDeclinedRingingEvent();
  }

  StreamSubscription<ActionCallDecline>? observeCallDeclinedRingingEvent() {
    return onRingingEvent<ActionCallDecline>(_onCallDecline);
  }

  @Deprecated('Use observeCallEndedRingingEvent instead.')
  StreamSubscription<ActionCallEnded>? observeCallEndedCallKitEvent() {
    return observeCallEndedRingingEvent();
  }

  StreamSubscription<ActionCallEnded>? observeCallEndedRingingEvent() {
    return onRingingEvent<ActionCallEnded>(_onCallEnded);
  }

  Future<void> _onCallAccept(
    ActionCallAccept event, {
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    _logger.d(() => '[onCallAccept] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    await _acceptIncomingCall(
      uuid: uuid,
      cid: cid,
      onCallAccepted: onCallAccepted,
      callPreferences: callPreferences,
    );
  }

  /// Ends the native call for [cid] after the user answered it but the call
  /// could not be set up, so they are not left on an answered call screen with
  /// nothing behind it.
  Future<void> _endUnjoinableNativeCall(String cid) async {
    await pushNotificationManager?.endCallByCid(cid);
  }

  /// Consumes, accepts and joins the call the user answered on the native call
  /// screen.
  Future<void> _acceptIncomingCall({
    required String uuid,
    required String cid,
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    // Before the dedupe guard: the user has answered, so the call must not be
    // auto-rejected no matter which path ends up handling it.
    _cancelIncomingAutoRejectTimerByCid(cid);

    if (!_acceptingCallCids.add(cid)) {
      _logger.v(() => '[acceptIncomingCall] already accepting: $cid');
      return;
    }

    try {
      final accepted = _acceptedElsewhereOnThisClient(cid);
      if (accepted != null) {
        _logger.v(() => '[acceptIncomingCall] already accepted: $cid');
        onCallAccepted?.call(accepted);
        return;
      }

      final consumeResult = await consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        preferences: callPreferences,
      );

      if (consumeResult.isFailure) {
        _logger.w(
          () =>
              '[acceptIncomingCall] error consuming incoming call: ${consumeResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return;
      }

      final callToJoin = consumeResult.getDataOrNull();
      if (callToJoin == null) {
        _logger.e(() => '[acceptIncomingCall] no call consumed: $cid');
        await _endUnjoinableNativeCall(cid);
        return;
      }

      final acceptResult = await callToJoin.accept();

      if (acceptResult.isFailure) {
        _logger.w(
          () =>
              '[acceptIncomingCall] error accepting call ($callToJoin): '
              '${acceptResult.getErrorOrNull()}',
        );
        await _endUnjoinableNativeCall(cid);
        return;
      }

      unawaited(callToJoin.join());
      onCallAccepted?.call(callToJoin);
    } finally {
      _acceptingCallCids.remove(cid);
    }
  }

  Future<void> _onCallIncoming(ActionCallIncoming event) async {
    _logger.d(() => '[onCallIncoming] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    return _handleIncomingCall(uuid: uuid, cid: cid);
  }

  /// Checks incoming calls currently shown by the OS.
  ///
  /// On iOS, CallKit may show the incoming call UI before Dart code runs,
  /// so ringing events can be missed. This inspects all displayed calls:
  /// - Still-ringing calls are verified so dismissed flows are ended.
  /// - Calls already answered but not picked up by the app are accepted and
  ///   joined. **iOS only** - on Android a call answered from the app's own
  ///   notification is picked up by [consumeAndAcceptActiveCall] instead.
  ///
  /// Called automatically by [observeCoreRingingEvents], which passes its own
  /// [onCallAccepted] and [acceptCallPreferences] on.
  Future<void> verifyDisplayedIncomingCalls({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  }) async {
    final manager = pushNotificationManager;
    if (manager == null) return;

    final displayedCalls = await manager.activeCalls();
    _logger.d(
      () => '[verifyDisplayedIncomingCalls] calls: $displayedCalls',
    );

    for (final displayedCall in displayedCalls) {
      final uuid = displayedCall.uuid;
      final cid = displayedCall.callCid;
      if (uuid == null || cid == null) continue;

      if (displayedCall.isAccepted) {
        await _acceptDisplayedIncomingCall(
          uuid: uuid,
          cid: cid,
          onCallAccepted: onCallAccepted,
          callPreferences: acceptCallPreferences,
        );
        continue;
      }

      await _handleIncomingCall(uuid: uuid, cid: cid);
    }
  }

  /// Picks up a call the user answered on the native call screen before the app
  /// was able to observe the [ActionCallAccept] for it.
  Future<void> _acceptDisplayedIncomingCall({
    required String uuid,
    required String cid,
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    // iOS only: handles accepting calls answered via CallKit before Dart runs.
    if (!CurrentPlatform.isIos) {
      _logger.v(() => '[acceptDisplayedCall] skipped (not iOS): $cid');
      return;
    }

    if (activeCalls.any((call) => call.callCid.value == cid)) {
      _logger.v(() => '[acceptDisplayedCall] already joined: $cid');
      return;
    }

    if (isCallAcceptedOnThisDevice(cid)) {
      _logger.v(() => '[acceptDisplayedCall] already accepted: $cid');
      return;
    }

    _logger.d(() => '[acceptDisplayedCall] answered before subscribing: $cid');

    await _acceptIncomingCall(
      uuid: uuid,
      cid: cid,
      onCallAccepted: onCallAccepted,
      callPreferences: callPreferences,
    );
  }

  Future<void> _handleIncomingCall({
    required String uuid,
    required String cid,
  }) async {
    // The same call can be reported by the incoming call event and by the
    // displayed calls verification at the same time.
    if (!_handledIncomingCallCids.add(cid)) {
      _logger.v(() => '[handleIncomingCall] already handling: $cid');
      return;
    }

    try {
      await _verifyAndConsumeIncomingCall(uuid: uuid, cid: cid);
    } finally {
      _handledIncomingCallCids.remove(cid);
    }
  }

  Future<void> _verifyAndConsumeIncomingCall({
    required String uuid,
    required String cid,
  }) async {
    // The incoming call UI is already on screen at this point on iOS where the OS
    // requires the CallKit call to be reported as soon as the VoIP push is
    // received. Verify the call is still ringing and dismiss it if it isn't.
    final callCid = StreamCallCid(cid: cid);
    final metadata = await _getCallForRingingEvent(callCid);

    if (metadata == null) {
      // The state couldn't be verified. Keep ringing instead of dismissing a
      // call that might still be valid, consumeIncomingCall retries the fetch.
      _logger.w(
        () => '[verifyIncomingCall] could not verify ringing state: $cid',
      );
    } else {
      final ringingState = metadata.ringingStateFor(_state.currentUser.id);

      if (!ringingState.isRinging) {
        // Never end the native call when it's already being answered on this
        // device (in the app or on the native call screen while the state was
        // still being verified), as that would tear down the ongoing call.
        if (await _isAnsweredOnThisDevice(cid)) {
          _logger.d(
            () =>
                '[verifyIncomingCall] call is no longer ringing ($ringingState) '
                'but is answered on this device, keeping it: $cid',
          );
          return;
        }

        _logger.d(
          () =>
              '[verifyIncomingCall] call is no longer ringing ($ringingState), '
              'dismissing incoming call UI: $cid',
        );

        // Silently, as the ringing flow is already resolved and the native end
        // must not be reported back as a decline/ended action.
        await pushNotificationManager?.endCallByCid(cid, silent: true);

        _cancelIncomingAutoRejectTimerByCid(cid);
        await _resolveStaleIncomingCall(cid, ringingState);
        return;
      }
    }

    final consumeResult = await consumeIncomingCall(
      uuid: uuid,
      cid: cid,
      metadata: metadata,
    );

    final incomingCall = consumeResult.getDataOrNull();
    if (incomingCall == null) return;

    final timeout = incomingCall.state.value.settings.ring.autoRejectTimeout;
    _startIncomingAutoRejectTimer(incomingCall, timeout);
  }

  /// Fetches the call state used to decide whether the incoming call UI should
  /// stay on screen. Returns `null` when the state can't be established.
  ///
  /// The push is often delivered while the client is still starting up (cold
  /// start after the app was terminated), and `getCall` only waits for the
  /// coordinator connection, it doesn't establish it. Connecting first is what
  /// makes the check work in that case instead of timing out and leaving a
  /// resolved call ringing.
  Future<CallMetadata?> _getCallForRingingEvent(StreamCallCid callCid) async {
    final connectResult = await connect(
      includeUserDetails: _options.includeUserDetailsForAutoConnect,
      // The device is registered already, otherwise the push wouldn't have been
      // delivered. Registering it is not this flow's concern.
      registerPushDevice: false,
    );

    if (connectResult.isFailure) {
      _logger.e(
        () =>
            '[getCallForRingingEvent] failed to connect: '
            '${connectResult.getErrorOrNull()}',
      );
      return null;
    }

    final callResult = await _client.getCall(callCid: callCid);
    if (callResult is! Success<CallReceivedData>) {
      _logger.e(
        () =>
            '[getCallForRingingEvent] failed to get call: '
            '${callResult.getErrorOrNull()}',
      );
      return null;
    }

    return callResult.data.metadata;
  }

  /// Marks [callCid] as accepted on this device, by [call].
  @internal
  void markCallAcceptedOnThisDevice(StreamCallCid callCid, Call call) {
    _logger.v(() => '[markCallAccepted] cid: $callCid');
    _locallyAcceptedCalls[callCid.value] = call;
  }

  /// Drops the [Call] cached for [callCid]'s ringing flow, if it is still
  /// [call]. A newer instance for the same cid is left alone.
  @internal
  void releaseRingingCall(StreamCallCid callCid, Call call) {
    if (identical(_ringingCalls[callCid.value], call)) {
      _ringingCalls.remove(callCid.value);
    }
  }

  /// Clears the acceptance marker for [callCid], if it is still [call]'s.
  @internal
  void clearCallAcceptedOnThisDevice(StreamCallCid callCid, Call call) {
    if (!identical(_locallyAcceptedCalls[callCid.value], call)) return;
    _locallyAcceptedCalls.remove(callCid.value);
    _logger.v(() => '[clearCallAccepted] cid: $callCid');
  }

  /// The [Call] for [cid] when another entry point on this client already
  /// accepted it.
  Call? _acceptedElsewhereOnThisClient(String cid) =>
      _locallyAcceptedCalls[cid];

  /// Whether the call with [cid] was accepted on this device.
  bool isCallAcceptedOnThisDevice(String cid) =>
      _locallyAcceptedCalls.containsKey(cid);

  /// Whether the call is already being answered on this device, either in the
  /// app or on the native call screen.
  Future<bool> _isAnsweredOnThisDevice(String cid) async {
    // Covers the window between accepting and [Call.join] marking the call
    // active, which is where the integrator's own navigation happens when the
    // call is answered from a terminated state.
    if (isCallAcceptedOnThisDevice(cid)) return true;

    if (activeCalls.any((call) => call.callCid.value == cid)) return true;

    // The native call is marked as accepted from the moment it's answered on the
    // native call screen, before the call is joined in the app.
    final nativeCalls = await pushNotificationManager?.activeCalls();
    return nativeCalls?.any(
          (call) => call.callCid == cid && call.isAccepted,
        ) ??
        false;
  }

  /// Brings the in-app incoming call in sync with a ringing flow that turned
  /// out to be already resolved.
  Future<void> _resolveStaleIncomingCall(
    String cid,
    CallRingingState ringingState,
  ) async {
    final incomingCall = _state.incomingCall.value;
    if (incomingCall == null || incomingCall.callCid.value != cid) return;

    _logger.d(
      () => '[resolveStaleIncomingCall] cid: $cid, state: $ringingState',
    );

    await incomingCall.leave(
      reason: DisconnectReason.rejected(
        byUserId: _state.currentUser.id,
        reason: ringingState.toReason(),
      ),
    );

    if (identical(_state.incomingCall.value, incomingCall)) {
      _state.incomingCall.value = null;
    }
  }

  Future<void> _onCallDecline(ActionCallDecline event) async {
    _logger.d(() => '[onCallDecline] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    _cancelIncomingAutoRejectTimerByCid(cid);

    final call = await consumeIncomingCall(uuid: uuid, cid: cid);
    final callToReject = call.getDataOrNull();
    if (callToReject == null) return;

    final result = await callToReject.reject(
      reason: CallRejectReason.decline(),
    );

    if (result is Failure) {
      _logger.d(() => '[onCallDecline] error rejecting call: ${result.error}');
    }
  }

  /// ActionCallEnded event is sent by native side of stream_video_push_notification package when the call is ended.
  /// On iOS this is connected to CallKit and should end active call or reject incoming call.
  /// On Android this is connected to push notification being dismissed.
  /// When app is terminated it can be send even when accepting the call. That's why we only handle
  /// it on iOS, unless the event carries [CallData.endedBySystem]: a hang-up reported by the
  /// Android Telecom stack (paired watch, headset, car head unit) is unambiguous and has to be
  /// applied, otherwise the call keeps running after the system has already ended it.
  Future<void> _onCallEnded(ActionCallEnded event) async {
    if (CurrentPlatform.isAndroid && !event.data.endedBySystem) return;

    _logger.d(() => '[onCallEnded] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    _cancelIncomingAutoRejectTimerByCid(cid);

    final activeCall = activeCalls.firstWhereOrNull(
      (call) => call.callCid.value == cid,
    );
    final incomingCall = _state.incomingCall.value;

    if (activeCall?.callCid.value == cid) {
      final result = await activeCall?.leave(
        reason: DisconnectReason.callEnded(),
      );

      if (result is Failure) {
        _logger.d(() => '[onCallEnded] error leaving call: ${result.error}');
      }
    } else if (incomingCall?.callCid.value == cid) {
      final status = incomingCall?.state.value.status;
      if (status is CallStatusIncoming && !status.acceptedByMe) {
        final result = await incomingCall?.reject(
          reason: CallRejectReason.callEnded(),
        );
        if (result is Failure) {
          _logger.d(
            () =>
                '[onCallEnded] error rejecting incoming call: ${result.error}',
          );
        }
      } else {
        _logger.v(() => '[onCallEnded] skip reject (status: $status)');
      }
    }
  }

  void _startIncomingAutoRejectTimer(Call call, Duration timeout) {
    if (timeout <= Duration.zero) return;
    final cid = call.callCid.value;

    _incomingAutoRejectTimers[cid]?.cancel();
    _incomingAutoRejectTimers[cid] = Timer(timeout, () async {
      try {
        // Also guards against a stale timer: an accepted call is never
        // rejected here, whoever forgot to cancel.
        final status = call.state.value.status;
        if (status is CallStatusIncoming && !status.acceptedByMe) {
          await call.reject(reason: CallRejectReason.timeout());
        }
      } catch (e) {
        _logger.e(() => '[incomingTimeout] failed cid: $cid: $e');
      } finally {
        _incomingAutoRejectTimers.remove(cid);
      }
    });
  }

  void _cancelIncomingAutoRejectTimerByCid(String cid) {
    final timer = _incomingAutoRejectTimers.remove(cid);
    timer?.cancel();
  }

  @Deprecated('Use handleRingingFlowNotifications instead.')
  Future<bool> handleVoipPushNotification(
    Map<String, dynamic> payload, {
    bool handleMissedCall = true,
  }) {
    return handleRingingFlowNotifications(
      payload,
      handleMissedCall: handleMissedCall,
    );
  }

  /// This method is used to handle incoming call notifications.
  /// It will show an incoming call notification if the call is ringing.
  /// It will show a missed call notification if the call is missed.
  ///
  /// Returns `true` if the notification was handled, `false` otherwise.
  Future<bool> handleRingingFlowNotifications(
    Map<String, dynamic> payload, {
    bool handleMissedCall = true,
  }) async {
    _logger.d(() => '[handleRingingFlowNotifications] payload: $payload');
    final manager = pushNotificationManager;
    if (manager == null) {
      _logger.e(() => '[handleRingingFlowNotifications] rejected (no manager)');
      return false;
    }

    // Only handle messages from stream.video
    if (!StreamPushPayload.isStreamPush(payload)) return false;

    final callCid = StreamPushPayload.callCidOf(payload);
    if (callCid == null) return false;

    final callUUID = const Uuid().v4();
    var callId = const Uuid().v4();
    var callType = StreamCallType.defaultType();

    final splitCid = callCid.split(':');
    if (splitCid.length == 2) {
      callType = StreamCallType.fromString(splitCid.first);
      callId = splitCid.last;
    }

    final createdById = payload[StreamPushPayload.createdByIdKey] as String?;
    final createdByName =
        payload[StreamPushPayload.createdByDisplayNameKey] as String?;
    final callDisplayName =
        payload[StreamPushPayload.callDisplayNameKey] as String?;

    final hasVideo = payload[StreamPushPayload.videoKey] as String?;

    if (handleMissedCall && StreamPushPayload.isMissedCallPush(payload)) {
      unawaited(
        manager.showMissedCall(
          uuid: callUUID,
          handle: createdById,
          callerName: (callDisplayName?.isNotEmpty ?? false)
              ? callDisplayName
              : createdByName,
          callCid: callCid,
        ),
      );

      return true;
    } else if (!StreamPushPayload.isRingingPush(payload)) {
      return false;
    }

    final callRingingState = await getCallRingingState(
      callType: callType,
      id: callId,
    );

    switch (callRingingState) {
      case CallRingingState.ringing:
        unawaited(
          manager.showIncomingCall(
            uuid: callUUID,
            handle: createdById,
            callerName: (callDisplayName?.isNotEmpty ?? false)
                ? callDisplayName
                : createdByName,
            callCid: callCid,
            hasVideo: hasVideo != 'false',
          ),
        );
        return true;
      case CallRingingState.accepted:
        return false;
      case CallRingingState.rejected:
        return false;
      case CallRingingState.ended:
        return false;
    }
  }

  Future<CallRingingState> getCallRingingState({
    required StreamCallType callType,
    required String id,
  }) async {
    final call = makeCall(callType: callType, id: id);
    final callResult = await call.get(watch: false);

    return callResult.foldResult(
      failure: (failure) {
        _logger.e(() => '[getCallRingingState] failed: $failure');
        return CallRingingState.ended;
      },
      success: (success) {
        final state = success.data.metadata.ringingStateFor(
          _state.currentUser.id,
        );
        _logger.d(() => '[getCallRingingState] state: $state');
        return state;
      },
    );
  }

  /// Consumes incoming voIP call and returns the [Call] object.
  ///
  /// Pass [metadata] when the caller already fetched the call state to avoid
  /// requesting it a second time.
  Future<Result<Call>> consumeIncomingCall({
    required String uuid,
    required String cid,
    CallPreferences? preferences,
    CallMetadata? metadata,
  }) async {
    _logger.d(() => '[consumeIncomingCall] uuid: $uuid, cid: $cid');
    final manager = pushNotificationManager;
    if (manager == null) {
      return const Result.failure(
        StreamVideoException(
          message: 'Push notification manager not initialized.',
        ),
      );
    }

    // If call was already created by consuming ringing event, use the same instance.
    final existingCall = _ringingCalls[cid] ?? _state.incomingCall.value;
    if (existingCall?.callCid.value == cid) {
      final call = existingCall!;
      if (preferences != null) {
        call.updateCallPreferences(preferences);
      }
      return Result.success(call);
    }

    final callCid = StreamCallCid(cid: cid);

    var callMetadata = metadata;
    if (callMetadata == null) {
      final callResult = await _client.getCall(callCid: callCid);
      if (callResult is! Success<CallReceivedData>) {
        return callResult as Failure;
      }

      callMetadata = callResult.data.metadata;

      // Re-check: a concurrent consume for the same cid may have populated the
      // cache while the fetch above was in flight.
      final cached = _ringingCalls[cid] ?? _state.incomingCall.value;
      if (cached?.callCid.value == cid) {
        if (preferences != null) {
          cached!.updateCallPreferences(preferences);
        }
        return Result.success(cached!);
      }
    }

    final call = _makeCallFromRinging(
      data: CallRingingData(
        callCid: callCid,
        ringing: true,
        metadata: callMetadata,
      ),
      preferences: preferences ?? _options.defaultCallPreferences,
    );

    _ringingCalls[cid] = call;

    return Result.success(call);
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
