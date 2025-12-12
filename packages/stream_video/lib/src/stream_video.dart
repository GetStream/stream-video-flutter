import 'dart:async';

import 'package:async/async.dart' as async;
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:system_info2/system_info2.dart';
import 'package:uuid/uuid.dart';

import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
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
import 'coordinator/retry/coordinator_client_retry.dart';
import 'core/client_state.dart';
import 'core/connection_state.dart';
import 'disposable.dart';
import 'errors/video_error.dart';
import 'errors/video_error_composer.dart';
import 'internal/_instance_holder.dart';
import 'latency/latency_service.dart';
import 'latency/latency_settings.dart';
import 'lifecycle/lifecycle_state.dart';
import 'lifecycle/lifecycle_utils.dart'
    if (dart.library.io) 'lifecycle/lifecycle_utils_io.dart'
    as lifecycle;
import 'logger/impl/console_logger.dart';
import 'logger/impl/external_logger.dart';
import 'logger/impl/tagged_logger.dart';
import 'logger/stream_log.dart';
import 'logger/stream_logger.dart';
import 'models/call_cid.dart';
import 'models/call_preferences.dart';
import 'models/call_received_data.dart';
import 'models/call_ringing_data.dart';
import 'models/call_status.dart';
import 'models/guest_created_data.dart';
import 'models/push_device.dart';
import 'models/push_provider.dart';
import 'models/queried_calls.dart';
import 'models/user.dart';
import 'models/user_info.dart';
import 'network_monitor_settings.dart';
import 'platform_detector/platform_detector.dart';
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
import 'webrtc/rtc_manager.dart';
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
    StreamVideoOptions options = const StreamVideoOptions(),
    required User user,
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    bool failIfSingletonExists = true,
    PNManagerProvider? pushNotificationManagerProvider,
  }) {
    final instance = StreamVideo._(
      apiKey,
      options: options,
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
    StreamVideoOptions options = const StreamVideoOptions(),
    String? userToken,
    TokenLoader? tokenLoader,
    OnTokenUpdated? onTokenUpdated,
    PNManagerProvider? pushNotificationManagerProvider,
    bool precacheGenericSdps = true,
  }) {
    final instance = StreamVideo._(
      apiKey,
      user: user,
      options: options,
      userToken: userToken,
      tokenLoader: tokenLoader,
      onTokenUpdated: onTokenUpdated,
      pushNotificationManagerProvider: pushNotificationManagerProvider,
      precacheGenericSdps: precacheGenericSdps,
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
    bool precacheGenericSdps = true,
  }) : _options = options,
       _state = MutableClientState(user, options) {
    _networkMonitor =
        _options.networkMonitorSettings.internetConnectionInstance ??
        InternetConnection.createInstance(
          checkInterval: _options.networkMonitorSettings.checkInterval,
          useDefaultOptions:
              _options.networkMonitorSettings.customEndpoints.isEmpty,
          customCheckOptions:
              _options.networkMonitorSettings.customEndpoints.isEmpty
              ? null
              : _options.networkMonitorSettings.customEndpoints
                    .map((option) => option.toInternetCheckOption())
                    .toList(),
        );

    _client = buildCoordinatorClient(
      user: user,
      apiKey: apiKey,
      tokenManager: _tokenManager,
      latencySettings: _options.latencySettings,
      retryPolicy: _options.retryPolicy,
      rpcUrl: _options.coordinatorRpcUrl,
      wsUrl: _options.coordinatorWsUrl,
      networkMonitor: _networkMonitor,
    );

    // Initialize the push notification manager if the provider is provided.
    pushNotificationManager = pushNotificationManagerProvider?.call(
      _client,
      this,
    );

    _state.user.value = user;

    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) {
      unawaited(
        rtc.WebRTC.initialize(
          options: {
            if (CurrentPlatform.isAndroid &&
                options.androidAudioConfiguration != null)
              'androidAudioConfiguration': options.androidAudioConfiguration!
                  .toMap(),
          },
        ),
      );
    }

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

    unawaited(
      _setClientDetails().onError((dynamic error, StackTrace stackTrace) {
        _logger.e(
          () =>
              '[StreamVideo] failed to set client details: $error with stackTrace: $stackTrace',
        );

        return null;
      }),
    );

    if (precacheGenericSdps) {
      unawaited(RtcManager.cacheGenericSdp());
    }

    if (options.autoConnect) {
      unawaited(
        connect(
          includeUserDetails: options.includeUserDetailsForAutoConnect,
        ).onError((dynamic error, StackTrace stackTrace) {
          _logger.e(
            () =>
                '[StreamVideo] failed to auto connect: $error with stackTrace: $stackTrace',
          );

          return Result.error(
            'Failed to auto connect: $error',
          );
        }),
      );
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
  final String apiKey;

  final MutableClientState _state;

  StreamVideoOptions get options => _options;

  final _tokenManager = TokenManager();
  final _subscriptions = Subscriptions();

  late final CoordinatorClient _client;
  late final InternetConnection _networkMonitor;
  late final PushNotificationManager? pushNotificationManager;

  final Map<String, bool> _mutedCameraByStateChange = {};
  final Map<String, bool> _mutedAudioByStateChange = {};
  final Map<String, Timer> _incomingAutoRejectTimers = {};

  /// Returns the current user.
  UserInfo get currentUser => _state.currentUser.info;

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
  Future<Result<UserToken>> connect({
    bool includeUserDetails = true,
    bool registerPushDevice = true,
  }) async {
    if (currentUserType == UserType.anonymous) {
      _logger.w(() => '[connect] rejected (anonymous user)');
      return Result.error(
        'Cannot connect anonymous user to the WS due to Missing Permissions',
      );
    }

    _connectOperation ??= _connect(
      includeUserDetails: includeUserDetails,
      registerPushDevice: registerPushDevice,
    ).asCancelable();

    return _connectOperation!
        .valueOrDefault(Result.error('connect was cancelled'))
        .whenComplete(
          () {
            _logger.i(() => '[connect] clear shared operation');
            _connectOperation = null;
          },
        );
  }

  /// Disconnects the user from the Stream Video service.
  Future<Result<None>> disconnect() async {
    _disconnectOperation ??= _disconnect().asCancelable();
    return _disconnectOperation!
        .valueOrDefault(Result.error('disconnect was cancelled'))
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
      await _disconnectOperation?.cancel();
      final result = await _client.connectUser(
        user.info,
        includeUserDetails: includeUserDetails,
      );
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

      // Register device with push notification manager.
      if (registerPushDevice) {
        pushNotificationManager?.registerDevice();
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

      // Unregister device from push notification manager.
      await pushNotificationManager?.unregisterDevice();

      await _client.disconnectUser();
      _subscriptions.cancelAll();

      // Resetting the state.
      await _state.clear();
      _connectionState = ConnectionState.disconnected(_state.currentUser.id);
      _logger.v(() => '[disconnect] completed');
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[disconnect] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
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

    _subscriptions.cancelAll();
    await pushNotificationManager?.dispose();
    await _state.clear();

    return super.dispose();
  }

  void _onEvent(CoordinatorEvent event) {
    final currentUserId = _state.currentUser.id;
    _logger.v(() => '[onCoordinatorEvent] eventType: ${event.runtimeType}');
    if (event is CoordinatorCallRingingEvent &&
        event.metadata.details.createdBy.id != currentUserId &&
        event.data.ringing) {
      _logger.v(() => '[onCoordinatorEvent] onCallRinging: ${event.data}');

      // In a edge case where call with the same CID as the incoming call is also an outgoing call
      // we want to use the same Call instance.
      if (state.outgoingCall.valueOrNull?.callCid.value ==
          event.data.callCid.value) {
        _state.incomingCall.value = state.outgoingCall.valueOrNull;
        return;
      }

      final call = _makeCallFromRinging(data: event.data);
      _state.incomingCall.value = call;
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
    } else if (event is CoordinatorReconnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] reconnected ${event.userId}');
      if (state.watchedCalls.value.isNotEmpty) {
        // Re-watch the previously watched calls.
        unawaited(
          queryCalls(
            watch: true,
            filterConditions: {
              'cid': {
                r'$in': state.watchedCalls.value
                    .map((call) => call.callCid.value)
                    .toList(),
              },
            },
          ).onError(
            (error, stackTrace) {
              _logger.e(
                () => '[onCoordinatorEvent] re-watching calls failed: $error',
              );
              return Result.failure(VideoErrors.compose(error, stackTrace));
            },
          ),
        );
      }
    }
  }

  Future<void> _onAppState(LifecycleState state) async {
    _logger.d(() => '[onAppState] state: $state');
    try {
      final activeCalls = _state.activeCalls.value;

      if (state.isPaused) {
        // Handle app paused state
        if (activeCalls.isEmpty &&
            !_options.keepConnectionsAliveWhenInBackground) {
          _logger.i(() => '[onAppState] close connection');
          _subscriptions.cancel(_idEvents);
          await _client.closeConnection();
        } else if (activeCalls.isNotEmpty) {
          for (final activeCall in activeCalls) {
            final callState = activeCall.state.value;
            final isVideoEnabled =
                callState.localParticipant?.isVideoEnabled ?? false;
            final isAudioEnabled =
                callState.localParticipant?.isAudioEnabled ?? false;

            if (_options.muteVideoWhenInBackground && isVideoEnabled) {
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
      callCid: StreamCallCid.from(
        type: callType,
        id: id,
      ),
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
  Future<Result<None>> removeDevice({
    required String pushToken,
  }) {
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

  /// This method is used to dispose the StreamVideo instance after the ringing event is resolved.
  /// It is used primarily for Firebase Messaging background handler where separate isolate is used to handle the message.
  ///
  /// [disposingCallback] is a callback that allows to perform any additional disposing operations after the ringing event is resolved.
  StreamSubscription<RingingEvent>? disposeAfterResolvingRinging({
    void Function()? disposingCallback,
  }) {
    return onRingingEvent(
      (event) {
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
      },
    );
  }

  Future<bool> consumeAndAcceptActiveCall({
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  }) async {
    final calls = await pushNotificationManager?.activeCalls();
    if (calls == null || calls.isEmpty) return false;

    final callResult = await consumeIncomingCall(
      uuid: calls.first.uuid!,
      cid: calls.first.callCid!,
      preferences: callPreferences,
    );

    callResult.fold(
      success: (result) async {
        final call = result.data;
        await call.accept();

        onCallAccepted?.call(call);

        return true;
      },
      failure: (error) {
        _logger.d(
          () =>
              '[consumeAndAcceptActiveCall] error consuming incoming call: $error',
        );
        return false;
      },
    );

    return false;
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
    return onRingingEvent<ActionCallAccept>(
      (event) => _onCallAccept(
        event,
        onCallAccepted: onCallAccepted,
        callPreferences: acceptCallPreferences,
      ),
    );
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

    _cancelIncomingAutoRejectTimerByCid(cid);

    final consumeResult = await consumeIncomingCall(
      uuid: uuid,
      cid: cid,
      preferences: callPreferences,
    );

    if (consumeResult.isFailure) {
      _logger.w(
        () => '[onCallAccept] error consuming incoming call}',
      );
      return;
    }

    final callToJoin = consumeResult.getDataOrNull();
    if (callToJoin == null) return;

    final acceptResult = await callToJoin.accept();

    if (acceptResult.isFailure) {
      _logger.d(() => '[onCallAccept] error accepting call: $callToJoin');
      return;
    }

    unawaited(callToJoin.join());
    onCallAccepted?.call(callToJoin);
  }

  Future<void> _onCallIncoming(ActionCallIncoming event) async {
    _logger.d(() => '[onCallIncoming] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final consumeResult = await consumeIncomingCall(
      uuid: uuid,
      cid: cid,
    );

    final incomingCall = consumeResult.getDataOrNull();
    if (incomingCall == null) return;

    final timeout = incomingCall.state.value.settings.ring.autoRejectTimeout;
    _startIncomingAutoRejectTimer(incomingCall, timeout);
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
  /// When app is terminated it can be send even when accepting the call. That's why we only handle it on iOS.
  Future<void> _onCallEnded(ActionCallEnded event) async {
    if (CurrentPlatform.isAndroid) return;

    _logger.d(() => '[onCallEnded] event: $event');

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    _cancelIncomingAutoRejectTimerByCid(cid);

    final activeCall = activeCalls.firstWhereOrNull(
      (call) => call.callCid.value == cid,
    );
    final incomingCall = _state.incomingCall.valueOrNull;

    if (activeCall?.callCid.value == cid) {
      final result = await activeCall?.leave();

      if (result is Failure) {
        _logger.d(() => '[onCallEnded] error leaving call: ${result.error}');
      }
    } else if (incomingCall?.callCid.value == cid) {
      final status = incomingCall?.state.value.status;
      if (status is CallStatusIncoming && !status.acceptedByMe) {
        final result = await incomingCall?.reject(
          reason: CallRejectReason.decline(),
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
    final sender = payload['sender'] as String?;
    if (sender != 'stream.video') return false;

    final callCid = payload['call_cid'] as String?;
    if (callCid == null) return false;

    final callUUID = const Uuid().v4();
    var callId = const Uuid().v4();
    var callType = StreamCallType.defaultType();

    final splitCid = callCid.split(':');
    if (splitCid.length == 2) {
      callType = StreamCallType.fromString(splitCid.first);
      callId = splitCid.last;
    }

    final createdById = payload['created_by_id'] as String?;
    final createdByName = payload['created_by_display_name'] as String?;
    final callDisplayName = payload['call_display_name'] as String?;

    final hasVideo = payload['video'] as String?;

    final type = payload['type'] as String?;
    if (handleMissedCall && type == 'call.missed') {
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
    } else if (type != 'call.ring') {
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
    final call = makeCall(
      callType: callType,
      id: id,
    );
    final callResult = await call.get(watch: false);

    return callResult.fold(
      failure: (failure) {
        _logger.e(() => '[getCallRingingState] failed: $failure');
        return CallRingingState.ended;
      },
      success: (success) {
        final callData = success.data;

        if (callData.metadata.session.acceptedBy.containsKey(
          _state.currentUser.id,
        )) {
          _logger.d(() => '[getCallRingingState] call already accepted');
          return CallRingingState.accepted;
        }

        if (callData.metadata.session.rejectedBy.containsKey(
          _state.currentUser.id,
        )) {
          _logger.d(() => '[getCallRingingState] call already rejected');
          return CallRingingState.rejected;
        }

        final otherMembers = callData.metadata.members.keys.toList()
          ..remove(_state.currentUser.id);
        if (callData.metadata.session.rejectedBy.keys.toSet().containsAll(
          otherMembers,
        )) {
          _logger.d(
            () =>
                '[getCallRingingState] call already rejected by all other members',
          );
          return CallRingingState.rejected;
        }

        return CallRingingState.ringing;
      },
    );
  }

  /// Consumes incoming voIP call and returns the [Call] object.
  Future<Result<Call>> consumeIncomingCall({
    required String uuid,
    required String cid,
    CallPreferences? preferences,
  }) async {
    _logger.d(() => '[consumeIncomingCall] uuid: $uuid, cid: $cid');
    final manager = pushNotificationManager;
    if (manager == null) {
      return const Result.failure(
        VideoError(message: 'Push notification manager not initialized.'),
      );
    }

    // If call was already created by consuming ringing event, use the same instance.
    if (_state.incomingCall.valueOrNull?.callCid.value == cid) {
      final call = _state.incomingCall.value!;
      if (preferences != null) {
        call.updateCallPreferences(preferences);
      }
      return Result.success(call);
    }

    final callCid = StreamCallCid(cid: cid);
    final callResult = await _client.getCall(callCid: callCid);
    if (callResult is! Success<CallReceivedData>) {
      return callResult as Failure;
    }

    final call = _makeCallFromRinging(
      data: CallRingingData(
        callCid: callCid,
        ringing: true,
        metadata: callResult.data.metadata,
      ),
      preferences: preferences ?? _options.defaultCallPreferences,
    );

    return Result.success(call);
  }

  @internal
  bool isAudioProcessorConfigured() {
    return _options.audioProcessor != null;
  }

  @internal
  Future<Result<bool>> isAudioProcessingEnabled() async {
    return await _options.audioProcessor?.isEnabled() ??
        const Result.failure(VideoError(message: 'No audio processor found.'));
  }

  @internal
  Future<Result<None>> setAudioProcessingEnabled(bool enabled) async {
    return await _options.audioProcessor?.setEnabled(enabled) ??
        const Result.failure(VideoError(message: 'No audio processor found.'));
  }

  /// This method returns true if the iOS device supports Apple's Neural Engine
  /// or if an Android device has the FEATURE_AUDIO_PRO feature enabled.
  /// Devices with this capability are better suited for handling noise cancellation efficiently.
  ///
  /// Returns false on other platforms.
  Future<Result<bool>> deviceSupportsAdvancedAudioProcessing() async {
    return await _options.audioProcessor
            ?.deviceSupportsAdvancedAudioProcessing() ??
        const Result.failure(VideoError(message: 'No audio processor found.'));
  }
}

CoordinatorClient buildCoordinatorClient({
  required User user,
  required String rpcUrl,
  required String wsUrl,
  required String apiKey,
  required TokenManager tokenManager,
  required RetryPolicy retryPolicy,
  required LatencySettings latencySettings,
  required InternetConnection networkMonitor,
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
      networkMonitor: networkMonitor,
      retryPolicy: retryPolicy,
      rpcUrl: rpcUrl,
      wsUrl: wsUrl,
      isAnonymous: user.type == UserType.anonymous,
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

Future<String?> _setClientDetails() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();

    final appName = packageInfo.appName;
    final appVersion = packageInfo.version;

    sfu_models.Device? device;
    sfu_models.Browser? browser;

    var os = sfu_models.OS(
      name: CurrentPlatform.name,
    );

    if (CurrentPlatform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      os = sfu_models.OS(
        name: CurrentPlatform.name,
        version: deviceInfo.version.release,
        architecture: SysInfo.rawKernelArchitecture,
      );
      device = sfu_models.Device(
        name: '${deviceInfo.manufacturer} : ${deviceInfo.model}',
      );
    } else if (CurrentPlatform.isIos) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      os = sfu_models.OS(
        name: CurrentPlatform.name,
        version: deviceInfo.systemVersion,
      );
      device = sfu_models.Device(
        name: deviceInfo.utsname.machine,
      );
    } else if (CurrentPlatform.isMacOS) {
      final deviceInfo = await DeviceInfoPlugin().macOsInfo;
      os = sfu_models.OS(
        name: CurrentPlatform.name,
        version:
            '${deviceInfo.majorVersion}.${deviceInfo.minorVersion}.${deviceInfo.patchVersion}',
        architecture: deviceInfo.arch,
      );
      device = sfu_models.Device(
        name: deviceInfo.model,
        version: deviceInfo.osRelease,
      );
    } else if (CurrentPlatform.isWindows) {
      final deviceInfo = await DeviceInfoPlugin().windowsInfo;
      os = sfu_models.OS(
        name: CurrentPlatform.name,
        version:
            '${deviceInfo.majorVersion}.${deviceInfo.minorVersion}.${deviceInfo.buildNumber}',
        architecture: deviceInfo.buildLabEx,
      );
    } else if (CurrentPlatform.isLinux) {
      final deviceInfo = await DeviceInfoPlugin().linuxInfo;
      os = sfu_models.OS(
        name: CurrentPlatform.name,
        version: '${deviceInfo.name} ${deviceInfo.version}',
      );
    } else if (CurrentPlatform.isWeb) {
      final browserInfo = await DeviceInfoPlugin().webBrowserInfo;
      browser = sfu_models.Browser(
        name: browserInfo.browserName.name,
        version: browserInfo.appVersion,
      );
    }

    final versionSplit = streamVideoVersion.split('.');
    clientDetails = sfu_models.ClientDetails(
      sdk: sfu_models.Sdk(
        type: sfu_models.SdkType.SDK_TYPE_FLUTTER,
        major: versionSplit.first,
        minor: versionSplit.skip(1).first,
        patch: versionSplit.last,
      ),
      os: os,
      device: device,
      browser: browser,
    );

    final deviceName = (device?.name != null && device!.name.isNotEmpty)
        ? device.name
        : null;

    return clientVersionDetails ??=
        'app=$appName|app_version=$appVersion|os=${CurrentPlatform.name} ${os.version}${deviceName != null ? '|device_model=$deviceName' : ''}';
  } catch (e) {
    streamLog.e(_tag, () => '[_setClientDetails] failed: $e');
    return null;
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
    this.defaultCallPreferences,
    this.sdpPolicy = const SdpPolicy(spdEditingEnabled: false),
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
    this.androidAudioConfiguration,
  });

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

  final bool muteVideoWhenInBackground;
  final bool muteAudioWhenInBackground;
  final bool autoConnect;
  final bool includeUserDetailsForAutoConnect;
  final bool keepConnectionsAliveWhenInBackground;
  final bool allowMultipleActiveCalls;

  /// Returns the current [NetworkMonitorSettings].
  final NetworkMonitorSettings networkMonitorSettings;

  final rtc.AndroidAudioConfiguration? androidAudioConfiguration;
}
