import 'dart:async';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../../stream_video.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../http/stream_auth_interceptor.dart';
import '../../http/stream_client_info_interceptor.dart';
import '../../http/stream_connection_id_interceptor.dart';
import '../../http/stream_retry_interceptor.dart';
import '../../latency/latency_service.dart';
import '../../location/location_service.dart';
import '../../telemetry/client_event_reporter.dart';
import '../../token/token_source.dart';
import '../models/coordinator_connection_state.dart';
import '../models/coordinator_models.dart';
import 'coordinator_ws.dart';
import 'open_api_extensions.dart';

/// How long `connectUser` waits for the socket to come up.
const _connectUserTimeout = Duration(seconds: 5);

/// How long a request waits for a connection id that is on its way.
const _waitForConnectionId = Duration(seconds: 5);

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClientOpenApi extends CoordinatorClient {
  CoordinatorClientOpenApi({
    required String rpcUrl,
    required String wsUrl,
    required String apiKey,
    required TokenSource tokenSource,
    required LatencyService latencyService,
    required RetryPolicy retryPolicy,
    this.isAnonymous = false,
    NetworkStateProvider? networkStateProvider,
    ClientEventReporter clientEventReporter = const ClientEventReporter.noOp(),
  }) : _rpcUrl = rpcUrl,
       _wsUrl = wsUrl,
       _apiKey = apiKey,
       _tokenSource = tokenSource,
       _latencyService = latencyService,
       _retryPolicy = retryPolicy,
       _networkStateProvider = networkStateProvider,
       _clientEventReporter = clientEventReporter;

  final _logger = taggedLogger(tag: 'SV:CoordClient');
  final String _rpcUrl;
  final String _apiKey;
  final String _wsUrl;
  final TokenSource _tokenSource;
  // ignore: unused_field
  final LatencyService _latencyService;
  final RetryPolicy _retryPolicy;
  final NetworkStateProvider? _networkStateProvider;
  final ClientEventReporter _clientEventReporter;

  final bool isAnonymous;

  late final StreamCoreHttpClient _httpClient = _buildHttpClient();

  Future<UserToken> _getToken() async {
    final tokenResult = await _tokenSource.getToken();
    if (tokenResult is! Success<UserToken>) {
      throw (tokenResult as Failure).videoError;
    }
    return tokenResult.data;
  }

  /// The client every coordinator call goes through.
  StreamCoreHttpClient _buildHttpClient() {
    final client = StreamCoreHttpClient(
      options: BaseOptions(baseUrl: _rpcUrl),
    );

    client.interceptors.addAll(
      _buildInterceptors(
        apiKey: _apiKey,
        connectionIdInterceptor: StreamConnectionIdInterceptor(
          _resolveConnectionId,
        ),
        authInterceptor: StreamAuthInterceptor.refreshing(
          _getToken,
          dio: client,
          tokenSource: _tokenSource,
        ),
        retryInterceptor: StreamRetryInterceptor(
          dio: client,
          policy: _retryPolicy,
        ),
      ),
    );

    return client;
  }

  late final _defaultApi = open.DefaultApi(_httpClient);
  late final _locationService = LocationService();

  @override
  SharedEmitter<CoordinatorEvent> get events => _events;

  @override
  bool get isConnected => _ws?.isConnected ?? false;

  final _events = MutableSharedEmitter<CoordinatorEvent>();

  final _connectionState = MutableStateEmitter<CoordinatorConnectionState>(
    const CoordinatorDisconnected(),
  );

  UserInfo? _user;
  CoordinatorWebSocket? _ws;
  StreamSubscription<CoordinatorEvent>? _wsSubscription;

  @override
  Future<Result<None>> connectUser(
    UserInfo user, {
    bool includeUserDetails = false,
  }) async {
    _logger.d(() => '[connectUser] user.id: ${user.id}');
    final state = _connectionState.value;
    if (state.isConnected) {
      _logger.w(() => '[connectUser] rejected (already connected): $_user');
      return const Result.success(none);
    }
    if (state.isConnecting) {
      _logger.w(() => '[connectUser] wait (already connecting): $_user');
      return _awaitConnected();
    }
    _connectionState.value = CoordinatorConnectionState.connecting(
      userId: user.id,
    );
    _user = user;
    _ws =
        _createWebSocket(
          user,
          includeUserDetails: includeUserDetails,
        ).also((ws) {
          _wsSubscription = ws.events.listen((event) {
            if (event is CoordinatorConnectedEvent) {
              _logger.i(() => '[connectUser] WS connected');
              _connectionState.value = CoordinatorConnectionState.connected(
                userId: event.userId,
                connectionId: event.connectionId,
              );
            } else if (event is CoordinatorDisconnectedEvent) {
              _logger.i(() => '[connectUser] WS disconnected');
              _connectionState.value = CoordinatorConnectionState.disconnected(
                userId: event.userId,
                connectionId: event.connectionId,
                closeCode: event.closeCode,
                closeReason: event.closeReason,
                apiError: event.apiError,
              );
            }
            _events.emit(event);
          });
        });
    final openResult = await openConnection();
    if (openResult is Failure) {
      _logger.e(() => '[connectUser] open failed: $openResult');
      return openResult;
    }
    return _awaitConnected().whenComplete(() {
      _logger.v(() => '[connectUser] completed');
    });
  }

  /// Completes once the socket is connected, or fails if it does not get there
  /// in time.
  ///
  /// Unlike [_resolveConnectionId] this is a real precondition: `connectUser`
  /// is not done until the socket is up, so a caller awaiting it needs the
  /// failure. No other call uses it — a request that merely wants a connection
  /// id goes out without one rather than failing.
  Future<Result<None>> _awaitConnected() {
    return _connectionState
        .firstWhere((it) => it.isConnected)
        .timeout(_connectUserTimeout)
        .then((_) {
          _logger.v(() => '[awaitConnected] connected');
          return const Result<None>.success(none);
        })
        .onError((error, stackTrace) {
          _logger.e(() => '[awaitConnected] failed: $error');
          return Result<None>.failure(
            StreamVideoExceptions.compose(error, stackTrace),
            stackTrace,
          );
        });
  }

  /// The connection id to attach to a request, or `null` when there is none
  /// and none is on its way.
  ///
  /// Never fails the request. A call made without an id succeeds, and the
  /// watches it registered are re-registered when the socket connects — see
  /// `StreamVideo._rewatchCalls`.
  Future<String?> _resolveConnectionId() async {
    // An anonymous session never opens a socket, so there is never an id.
    if (isAnonymous) return null;

    final connectionId = _ws?.connectionId;
    if (connectionId != null && connectionId.isNotEmpty) return connectionId;

    final state = _connectionState.value;
    if (!state.isConnecting) {
      _logger.d(
        () => '[resolveConnectionId] not waiting (state: $state)',
      );
      return null;
    }

    _logger.d(() => '[resolveConnectionId] waiting for the socket');
    try {
      await _connectionState
          .firstWhere((it) => it.isConnected)
          .timeout(_waitForConnectionId);
      return _ws?.connectionId;
    } on TimeoutException catch (_) {
      _logger.w(
        () =>
            '[resolveConnectionId] gave up after '
            '${_waitForConnectionId.inSeconds}s',
      );
      return null;
    }
  }

  @override
  Future<Result<None>> openConnection() async {
    try {
      final ws = _ws;
      if (ws == null) {
        _logger.w(() => '[openConnection] rejected (no WS)');
        return failureWithError(
          'WS is not initialized, call "connectUser" first',
        );
      }
      if (!ws.isDisconnected) {
        _logger.w(() => '[openConnection] rejected (not closed)');
        return failureWithError('WS is not closed');
      }

      _logger.i(() => '[openConnection] no args');
      await ws.connect();

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[openConnection] failed: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> closeConnection() async {
    try {
      final ws = _ws;
      if (ws == null) {
        _logger.w(() => '[closeConnection] rejected (no WS)');
        return failureWithError('WS is not initialized');
      }
      if (ws.isDisconnected) {
        _logger.w(() => '[closeConnection] rejected (already closed)');
        return failureWithError('WS is already closed');
      }
      _logger.i(() => '[closeConnection] no args');

      await ws.disconnect();

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[closeConnection] failed: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> disconnectUser() async {
    _logger.d(() => '[disconnectUser] userId: ${_user?.id}');
    if (_user == null) {
      _logger.w(() => '[disconnectUser] rejected (user is null)');
      return const Result.success(none);
    }
    _user = null;

    final closedResult = await closeConnection();

    // Always dispose regardless of closeConnection result
    await _ws?.dispose();
    _ws = null;
    await _wsSubscription?.cancel();
    _wsSubscription = null;

    return closedResult.when(
      success: (_) => const Result.success(none),
      failure: Result.failure,
    );
  }

  CoordinatorWebSocket _createWebSocket(
    UserInfo user, {
    bool includeUserDetails = false,
  }) {
    return CoordinatorWebSocket(
      _wsUrl,
      apiKey: _apiKey,
      userInfo: user,
      tokenSource: _tokenSource,
      includeUserDetails: includeUserDetails,
      networkStateProvider: _networkStateProvider,
      clientEventReporter: _clientEventReporter,
    );
  }

  // Submit user feedback for the call
  @override
  Future<Result<None>> collectUserFeedback({
    required String callType,
    required String callId,
    required String sessionId,
    required int rating,
    required String sdk,
    required String sdkVersion,
    required String userSessionId,
    String? reason,
    Map<String, Object>? custom,
  }) async {
    try {
      final input = open.CollectUserFeedbackRequest(
        custom: custom ?? {},
        rating: rating,
        reason: reason,
        sdk: sdk,
        sdkVersion: sdkVersion,
        userSessionId: userSessionId,
      );

      _logger.d(() => '[collectUserFeedback] input: $input');
      final result = await _defaultApi.collectUserFeedback(
        type: callType,
        id: callId,
        collectUserFeedbackRequest: input,
      );

      _logger.v(() => '[collectUserFeedback] completed: $result');

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[collectUserFeedback] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Create a new Device used to receive Push Notifications.
  @override
  Future<Result<None>> createDevice({
    required String id,
    required PushProvider pushProvider,
    String? pushProviderName,
    bool? voipToken,
  }) async {
    try {
      final input = open.CreateDeviceRequest(
        id: id,
        pushProvider: pushProvider.toOpenDTO(),
        pushProviderName: pushProviderName,
        voipToken: voipToken,
      );

      _logger.d(() => '[createDevice] input: $input');
      final result = await _defaultApi.createDevice(
        createDeviceRequest: input,
      );

      _logger.v(() => '[createDevice] completed: $result');
      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[createDevice] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// List devices used to receive Push Notifications.
  @override
  Future<Result<List<PushDevice>>> listDevices() async {
    try {
      _logger.d(() => '[listDevices]');

      final result = await _defaultApi.listDevices();
      _logger.v(() => '[listDevices] completed: $result');
      return result.fold(
        onSuccess: (data) => Result.success(data.devices.toPushDevices()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[listDevices] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Deletes a Device used to receive Push Notifications.
  @override
  Future<Result<None>> deleteDevice({
    required String id,
    String? userId,
  }) async {
    try {
      _logger.d(() => '[deleteDevice] id: $id, userId: $userId');

      final result = await _defaultApi.deleteDevice(
        id: id,
      );

      _logger.v(() => '[deleteDevice] completed: $result');
      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[deleteDevice] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Gets the call if already exists.
  @override
  Future<Result<CallReceivedData>> getCall({
    required StreamCallCid callCid,
    int? membersLimit,
    bool? ringing,
    bool? notify,
    bool? video,
  }) async {
    try {
      _logger.d(
        () =>
            '[getCall] cid: $callCid, ringing: $ringing'
            ', membersLimit: $membersLimit, ringing: $ringing, notify: $notify'
            ', video: $video',
      );

      final result = await _defaultApi.getCall(
        type: callCid.type.value,
        id: callCid.id,
        membersLimit: membersLimit,
        ring: ringing,
        notify: notify,
        video: video,
      );

      _logger.v(() => '[getCall] completed: $result');

      return result.fold(
        onSuccess: (data) => Result.success(
          CallReceivedData(
            callCid: callCid,
            metadata: data.call.toCallMetadata(
              membership: data.membership,
              members: data.members,
              ownCapabilities: data.ownCapabilities,
            ),
          ),
        ),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[getCall] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Gets the call if already exists or attempts to create a new call.
  @override
  Future<Result<CallReceivedOrCreatedData>> getOrCreateCall({
    required StreamCallCid callCid,
    bool? ringing,
    List<open.MemberRequest>? members,
    String? team,
    bool? notify,
    bool? video,
    DateTime? startsAt,
    int? membersLimit,
    CallSettingsRequest? settingsOverride,
    Map<String, Object> custom = const {},
  }) async {
    try {
      _logger.d(
        () =>
            '[getOrCreateCall] cid: $callCid'
            ', ringing: $ringing, members: $members'
            ', team: $team, notify: $notify, video: $video'
            ', startsAt: $startsAt, settingsOverride: $settingsOverride',
      );

      final result = await _defaultApi.getOrCreateCall(
        type: callCid.type.value,
        id: callCid.id,
        getOrCreateCallRequest: open.GetOrCreateCallRequest(
          data: open.CallRequest(
            members: members ?? [],
            team: team,
            startsAt: startsAt,
            video: video,
            settingsOverride: settingsOverride,
            custom: custom,
          ),
          membersLimit: membersLimit,
          ring: ringing,
          notify: notify,
          video: video,
        ),
      );

      _logger.v(() => '[getOrCreateCall] completed: $result');

      return result.fold(
        onSuccess: (data) => Result.success(
          CallReceivedOrCreatedData(
            wasCreated: data.created,
            data: CallCreatedData(
              callCid: callCid,
              metadata: data.call.toCallMetadata(
                membership: data.membership,
                members: data.members,
                ownCapabilities: data.ownCapabilities,
              ),
            ),
          ),
        ),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[getOrCreateCall] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Attempts to join a Call. If successful, gives us more information
  /// about the user and the call itself.
  @override
  Future<Result<CoordinatorJoined>> joinCall({
    required StreamCallCid callCid,
    bool? ringing,
    bool? create,
    String? migratingFrom,
    List<String> migratingFromList = const [],
    bool? video,
    int? membersLimit,
    bool? hintHighScaleLivestreamPublisher,
    bool? e2ee,
  }) async {
    try {
      _logger.d(
        () =>
            '[joinCall] cid: $callCid'
            ', ringing: $ringing, create: $create , migratingFrom: $migratingFrom'
            ', video: $video',
      );
      final location = await _locationService.getLocation();
      _logger.v(() => '[joinCall] location: $location');

      final result = await _defaultApi.joinCall(
        type: callCid.type.value,
        id: callCid.id,
        joinCallRequest: open.JoinCallRequest(
          create: create,
          ring: ringing,
          location: location,
          membersLimit: membersLimit,
          migratingFrom: migratingFrom,
          migratingFromList: migratingFromList,
          video: video,
          hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
          e2ee: e2ee,
        ),
      );

      _logger.v(() => '[joinCall] completed: $result');

      return result.fold(
        onSuccess: (data) => Result.success(
          CoordinatorJoined(
            wasCreated: data.created,
            metadata: data.call.toCallMetadata(
              membership: data.membership,
              members: data.members,
              ownCapabilities: data.ownCapabilities,
            ),
            credentials: data.credentials.toCallCredentials(),
            members: data.members.toCallMembers(),
            users: data.members.toCallUsers(),
            duration: data.duration,
            statsOptions: data.statsOptions,
            ownCapabilities: data.ownCapabilities
                .map(CallPermission.fromAlias)
                .toList(),
          ),
        ),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[joinCall] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<List<String>>> ringCall({
    required StreamCallCid callCid,
    required List<String> membersIds,
    bool? video,
  }) async {
    try {
      _logger.d(
        () =>
            '[ringCall] cid: $callCid, membersIds: $membersIds, video: $video',
      );

      final result = await _defaultApi.ringCall(
        type: callCid.type.value,
        id: callCid.id,
        ringCallRequest: open.RingCallRequest(
          membersIds: membersIds,
          video: video,
        ),
      );

      _logger.v(() => '[ringCall] completed: $result');

      return result.fold(
        onSuccess: (data) => Result.success(data.membersIds),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[ringCall] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Sends a custom event with encoded JSON data.
  @override
  Future<Result<None>> sendCustomEvent({
    required StreamCallCid callCid,
    required String eventType,
    Map<String, Object> custom = const {},
  }) async {
    try {
      _logger.d(
        () =>
            '[sendCustomEvent] cid: $callCid'
            ', eventType: $eventType, custom: $custom',
      );
      final result = await _defaultApi.sendCallEvent(
        type: callCid.type.value,
        id: callCid.id,
        sendCallEventRequest: open.SendCallEventRequest(
          custom: custom,
        ),
      );

      _logger.v(() => '[sendCustomEvent] completed: $result');
      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[sendCustomEvent] failed: $e; $stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Sends invite to people for an existing call.
  @override
  Future<Result<None>> addMembers({
    required StreamCallCid callCid,
    required Iterable<open.MemberRequest> members,
  }) async {
    _logger.d(
      () => '[addMembers] cid: $callCid, members: $members',
    );

    return updateCallMembers(callCid: callCid, updateMembers: members);
  }

  @override
  Future<Result<None>> removeMembers({
    required StreamCallCid callCid,
    required Iterable<String> removeIds,
  }) async {
    _logger.d(
      () => '[removeMembers] cid: $callCid, removeIds: $removeIds',
    );

    return updateCallMembers(callCid: callCid, removeIds: removeIds);
  }

  @override
  Future<Result<None>> updateCallMembers({
    required StreamCallCid callCid,
    Iterable<open.MemberRequest> updateMembers = const [],
    Iterable<String> removeIds = const [],
  }) async {
    try {
      _logger.d(
        () =>
            '[updateCallMembers] cid: $callCid, updateMembers: $updateMembers, removeIds: $removeIds',
      );

      final result = await _defaultApi.updateCallMembers(
        type: callCid.type.value,
        id: callCid.id,
        updateCallMembersRequest: open.UpdateCallMembersRequest(
          updateMembers: updateMembers.toList(),
          removeMembers: removeIds.toList(),
        ),
      );

      _logger.v(() => '[updateCallMembers] completed: $result');
      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> requestPermissions({
    required StreamCallCid callCid,
    required List<CallPermission> permissions,
  }) async {
    try {
      final result = await _defaultApi.requestPermission(
        type: callCid.type.value,
        id: callCid.id,
        requestPermissionRequest: open.RequestPermissionRequest(
          permissions: permissions
              .map((e) => e.toRequestPermissionDomain())
              .whereType<open.RequestPermissionRequestPermissions>()
              .toList(),
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> videoPin({
    required StreamCallCid callCid,
    required String sessionId,
    required String userId,
  }) async {
    try {
      final result = await _defaultApi.videoPin(
        type: callCid.type.value,
        id: callCid.id,
        pinRequest: open.PinRequest(
          sessionId: sessionId,
          userId: userId,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> videoUnpin({
    required StreamCallCid callCid,
    required String sessionId,
    required String userId,
  }) async {
    try {
      final result = await _defaultApi.videoUnpin(
        type: callCid.type.value,
        id: callCid.id,
        unpinRequest: open.UnpinRequest(
          sessionId: sessionId,
          userId: userId,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> updateUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    required List<CallPermission> grantPermissions,
    required List<CallPermission> revokePermissions,
  }) async {
    try {
      final result = await _defaultApi.updateUserPermissions(
        type: callCid.type.value,
        id: callCid.id,
        updateUserPermissionsRequest: open.UpdateUserPermissionsRequest(
          userId: userId,
          grantPermissions: grantPermissions
              .map((e) => e.toGrantPermissionDomain())
              .whereType<open.UpdateUserPermissionsRequestGrantPermissions>()
              .toList(),
          revokePermissions: revokePermissions
              .map((e) => e.toRevokePermissionDomain())
              .whereType<open.UpdateUserPermissionsRequestRevokePermissions>()
              .toList(),
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> startRecording(
    StreamCallCid callCid, {
    RecordingType recordingType = RecordingType.composite,
    String? recordingExternalStorage,
  }) async {
    try {
      final result = await _defaultApi.startRecording(
        type: callCid.type.value,
        id: callCid.id,
        recordingType: recordingType.toOpenDto(),
        startRecordingRequest: open.StartRecordingRequest(
          recordingExternalStorage: recordingExternalStorage,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<List<open.CallRecording>>> listRecordings(
    StreamCallCid callCid,
  ) async {
    try {
      final result = await _defaultApi.listRecordings(
        type: callCid.type.value,
        id: callCid.id,
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.recordings),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> stopRecording(
    StreamCallCid callCid, {
    RecordingType recordingType = RecordingType.composite,
  }) async {
    try {
      final result = await _defaultApi.stopRecording(
        type: callCid.type.value,
        id: callCid.id,
        recordingType: recordingType.toOpenDto(),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> startTranscription(
    StreamCallCid callCid, {
    bool? enableClosedCaptions,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    try {
      final result = await _defaultApi.startTranscription(
        type: callCid.type.value,
        id: callCid.id,
        startTranscriptionRequest: open.StartTranscriptionRequest(
          transcriptionExternalStorage: transcriptionExternalStorage,
          enableClosedCaptions: enableClosedCaptions,
          language: language?.toStartTranscriptionDto(),
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<List<open.CallTranscription>>> listTranscriptions(
    StreamCallCid callCid,
  ) async {
    try {
      final result = await _defaultApi.listTranscriptions(
        type: callCid.type.value,
        id: callCid.id,
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.transcriptions),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> stopTranscription(
    StreamCallCid callCid, {
    bool? stopClosedCaptions,
  }) async {
    try {
      final result = await _defaultApi.stopTranscription(
        type: callCid.type.value,
        id: callCid.id,
        stopTranscriptionRequest: open.StopTranscriptionRequest(
          stopClosedCaptions: stopClosedCaptions,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> startClosedCaptions(
    StreamCallCid callCid, {
    bool? enableTranscription,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    try {
      final result = await _defaultApi.startClosedCaptions(
        type: callCid.type.value,
        id: callCid.id,
        startClosedCaptionsRequest: open.StartClosedCaptionsRequest(
          enableTranscription: enableTranscription,
          externalStorage: transcriptionExternalStorage,
          language: language?.toStartClosedCaptionsDto(),
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> stopClosedCaptions(
    StreamCallCid callCid, {
    bool? stopTranscription,
  }) async {
    try {
      final result = await _defaultApi.stopClosedCaptions(
        type: callCid.type.value,
        id: callCid.id,
        stopClosedCaptionsRequest: open.StopClosedCaptionsRequest(
          stopTranscription: stopTranscription,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<String?>> startBroadcasting(StreamCallCid callCid) async {
    try {
      final result = await _defaultApi.startHLSBroadcasting(
        type: callCid.type.value,
        id: callCid.id,
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.playlistUrl),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> stopBroadcasting(StreamCallCid callCid) async {
    try {
      final result = await _defaultApi.stopHLSBroadcasting(
        type: callCid.type.value,
        id: callCid.id,
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> startRtmpBroadcasts(
    StreamCallCid callCid, {
    required List<StreamRtmpBroadcastRequest> broadcasts,
  }) async {
    try {
      final result = await _defaultApi.startRTMPBroadcasts(
        type: callCid.type.value,
        id: callCid.id,
        startRTMPBroadcastsRequest: open.StartRTMPBroadcastsRequest(
          broadcasts: broadcasts.map((it) => it.toRequestDomain()).toList(),
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> stopRtmpBroadcast(
    StreamCallCid callCid, {
    required String name,
  }) async {
    try {
      final result = await _defaultApi.stopRTMPBroadcast(
        type: callCid.type.value,
        id: callCid.id,
        name: name,
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> stopAllRtmpBroadcasts(StreamCallCid callCid) async {
    try {
      final result = await _defaultApi.stopAllRTMPBroadcasts(
        type: callCid.type.value,
        id: callCid.id,
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<CallReaction>> sendReaction({
    required StreamCallCid callCid,
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) async {
    try {
      final result = await _defaultApi.sendVideoReaction(
        type: callCid.type.value,
        id: callCid.id,
        sendVideoReactionRequest: open.SendVideoReactionRequest(
          type: reactionType,
          emojiCode: emojiCode,
          custom: custom,
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.reaction.toCallReaction()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Queries users based on the given input.
  @override
  Future<Result<QueriedMembers>> queryMembers({
    required StreamCallCid callCid,
    Map<String, Object> filterConditions = const {},
    String? next,
    String? prev,
    List<open.SortParamRequest> sorts = const [],
    int? limit,
  }) async {
    try {
      final result = await _defaultApi.queryCallMembers(
        queryCallMembersRequest: open.QueryCallMembersRequest(
          type: callCid.type.value,
          id: callCid.id,
          filterConditions: filterConditions,
          next: next,
          prev: prev,
          sort: sorts,
          limit: limit,
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.toQueriedMembers(callCid)),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Queries calls based on the given input.
  @override
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<open.SortParamRequest> sorts = const [],
    int? limit,
    bool? watch,
  }) async {
    try {
      final result = await _defaultApi.queryCalls(
        queryCallsRequest: open.QueryCallsRequest(
          filterConditions: filterConditions,
          next: next,
          prev: prev,
          sort: sorts,
          limit: limit,
          watch: watch,
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.toQueriedCalls()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> blockUser({
    required StreamCallCid callCid,
    required String userId,
  }) async {
    try {
      final result = await _defaultApi.blockUser(
        type: callCid.type.value,
        id: callCid.id,
        blockUserRequest: open.BlockUserRequest(userId: userId),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> unblockUser({
    required StreamCallCid callCid,
    required String userId,
  }) async {
    try {
      final result = await _defaultApi.unblockUser(
        type: callCid.type.value,
        id: callCid.id,
        unblockUserRequest: open.UnblockUserRequest(userId: userId),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> kickUser({
    required StreamCallCid callCid,
    required String userId,
    bool block = false,
  }) async {
    try {
      final result = await _defaultApi.kickUser(
        type: callCid.type.value,
        id: callCid.id,
        kickUserRequest: open.KickUserRequest(userId: userId, block: block),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> endCall(StreamCallCid callCid) async {
    try {
      final result = await _defaultApi.endCall(
        type: callCid.type.value,
        id: callCid.id,
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<CallMetadata>> goLive({
    required StreamCallCid callCid,
    bool? startHls,
    bool? startRecording,
    bool? startCompositeRecording,
    bool? startIndividualRecording,
    bool? startRawRecording,
    bool? startTranscription,
    bool? startClosedCaption,
    String? recordingStorageName,
    String? transcriptionStorageName,
  }) async {
    try {
      final result = await _defaultApi.goLive(
        type: callCid.type.value,
        id: callCid.id,
        goLiveRequest: open.GoLiveRequest(
          startHls: startHls,
          startRecording: startRecording,
          startCompositeRecording: startCompositeRecording,
          startIndividualRecording: startIndividualRecording,
          startRawRecording: startRawRecording,
          startTranscription: startTranscription,
          startClosedCaption: startClosedCaption,
          recordingStorageName: recordingStorageName,
          transcriptionStorageName: transcriptionStorageName,
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.call.toCallMetadata()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<CallMetadata>> stopLive(
    StreamCallCid callCid, {
    bool? continueClosedCaption,
    bool? continueCompositeRecording,
    bool? continueHls,
    bool? continueIndividualRecording,
    bool? continueRawRecording,
    bool? continueRecording,
    bool? continueRtmpBroadcasts,
    bool? continueTranscription,
  }) async {
    try {
      final result = await _defaultApi.stopLive(
        type: callCid.type.value,
        id: callCid.id,
        stopLiveRequest: open.StopLiveRequest(
          continueClosedCaption: continueClosedCaption,
          continueCompositeRecording: continueCompositeRecording,
          continueHls: continueHls,
          continueIndividualRecording: continueIndividualRecording,
          continueRawRecording: continueRawRecording,
          continueRecording: continueRecording,
          continueRtmpBroadcasts: continueRtmpBroadcasts,
          continueTranscription: continueTranscription,
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.call.toCallMetadata()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<None>> muteUsers({
    required StreamCallCid callCid,
    required List<String> userIds,
    bool? muteAllUsers,
    bool? audio,
    bool? video,
    bool? screenshare,
  }) async {
    try {
      final result = await _defaultApi.muteUsers(
        type: callCid.type.value,
        id: callCid.id,
        muteUsersRequest: open.MuteUsersRequest(
          userIds: userIds,
          muteAllUsers: muteAllUsers,
          audio: audio,
          video: video,
          screenshare: screenshare,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<CallMetadata>> updateCall({
    required StreamCallCid callCid,
    Map<String, Object> custom = const {},
    DateTime? startsAt,
    StreamRingSettings? ring,
    StreamAudioSettings? audio,
    StreamVideoSettings? video,
    StreamScreenShareSettings? screenShare,
    StreamRecordingSettings? recording,
    StreamTranscriptionSettings? transcription,
    StreamBackstageSettings? backstage,
    StreamGeofencingSettings? geofencing,
    StreamLimitsSettings? limits,
    StreamBroadcastingSettings? broadcasting,
    StreamSessionSettings? session,
    StreamFrameRecordingSettings? frameRecording,
    StreamIndividualRecordingSettings? individualRecording,
    StreamRawRecordingSettings? rawRecording,
    StreamIngressSettings? ingress,

    /// Whether the call permits end-to-end encryption.
    StreamEncryptionSettings? encryption,
  }) async {
    try {
      final result = await _defaultApi.updateCall(
        type: callCid.type.value,
        id: callCid.id,
        updateCallRequest: open.UpdateCallRequest(
          startsAt: startsAt,
          custom: custom,
          settingsOverride: open.CallSettingsRequest(
            ring: ring?.toOpenDto(),
            audio: audio?.toOpenDto(),
            video: video?.toOpenDto(),
            screensharing: screenShare?.toOpenDto(),
            recording: recording?.toOpenDto(),
            transcription: transcription?.toOpenDto(),
            backstage: backstage?.toOpenDto(),
            geofencing: geofencing?.toOpenDto(),
            limits: limits?.toOpenDto(),
            broadcasting: broadcasting?.toOpenDto(),
            session: session?.toOpenDto(),
            frameRecording: frameRecording?.toOpenDto(),
            encryption: encryption?.toOpenDto(),
            individualRecording: individualRecording?.toOpenDto(),
            rawRecording: rawRecording?.toOpenDto(),
            ingress: ingress?.toOpenDto(),
          ),
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.call.toCallMetadata()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Signals other users that I have accepted the incoming call.
  /// Causes the [CoordinatorCallAcceptedEvent] event to be emitted
  /// to all the call members.
  @override
  Future<Result<None>> acceptCall({
    required StreamCallCid cid,
  }) async {
    try {
      final result = await _defaultApi.acceptCall(
        type: cid.type.value,
        id: cid.id,
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Signals other users that I have rejected the incoming call.
  /// Causes the [CoordinatorCallRejectedEvent] event to be emitted
  /// to all the call members.
  @override
  Future<Result<None>> rejectCall({
    required StreamCallCid cid,
    String? reason,
  }) async {
    try {
      final result = await _defaultApi.rejectCall(
        type: cid.type.value,
        id: cid.id,
        rejectCallRequest: open.RejectCallRequest(
          reason: reason,
        ),
      );

      return result.fold(
        onSuccess: (_) => const Result.success(none),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  @override
  Future<Result<GuestCreatedData>> loadGuest({
    required String id,
    String? name,
    String? image,
    Map<String, Object> custom = const {},
  }) async {
    try {
      _logger.d(() => '[loadGuest] id: $id');
      final dio = StreamCoreHttpClient(
        options: BaseOptions(baseUrl: _rpcUrl),
      );
      dio.interceptors.addAll(
        _buildInterceptors(
          apiKey: _apiKey,
          // No connection id: this call is unauthenticated and watches
          // nothing, so an id could only add latency. It would also couple the
          // call to the socket that is often waiting on it — establishing the
          // session is what a socket authenticating a guest is blocked on, and
          // resolving an id waits for that same socket to connect.
          //
          // Signs only, too: this call is what establishes the session, so
          // there is no token yet for a refusal to replace.
          authInterceptor: const StreamAuthInterceptor(UserToken.anonymous),
          retryInterceptor: StreamRetryInterceptor(
            dio: dio,
            policy: _retryPolicy,
          ),
        ),
      );
      final defaultApi = open.DefaultApi(dio);

      final result = await defaultApi.createGuest(
        createGuestRequest: open.CreateGuestRequest(
          user: open.UserRequest(
            id: id,
            custom: custom,
            image: image,
            name: name,
          ),
        ),
      );

      return result.fold(
        onSuccess: (data) => Result.success(data.toGuestCreatedData()),
        onFailure: (error, stackTrace) => Result.failure(
          StreamVideoExceptions.compose(error, stackTrace),
          stackTrace,
        ),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }
}

final _httpLogger = taggedLogger(tag: 'SV:CoordHttp');

/// The interceptor stack every coordinator call goes through.
///
/// [connectionIdInterceptor] is omitted for a request that cannot use a
/// connection id — see `loadGuest`.
List<Interceptor> _buildInterceptors({
  required String apiKey,
  required StreamAuthInterceptor authInterceptor,
  required StreamRetryInterceptor retryInterceptor,
  StreamConnectionIdInterceptor? connectionIdInterceptor,
}) {
  return [
    _ApiKeyInterceptor(apiKey),
    ?connectionIdInterceptor,
    authInterceptor,
    const StreamClientInfoInterceptor(),
    // Before the retry, so a retryable failure is already carrying the Stream
    // exception the retry reads its decision from.
    const ApiErrorInterceptor(),
    retryInterceptor,
    LoggingInterceptor(
      requestHeader: true,
      logPrint: (_, object) => _httpLogger.v(() => object.toString()),
    ),
  ];
}

/// Adds the Stream `api_key` as a query parameter to every request.
class _ApiKeyInterceptor extends Interceptor {
  const _ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.queryParameters['api_key'] = apiKey;
    handler.next(options);
  }
}

extension on PushProvider {
  open.CreateDeviceRequestPushProvider toOpenDTO() {
    switch (this) {
      case PushProvider.firebase:
        return open.CreateDeviceRequestPushProvider.firebase;
      case PushProvider.xiaomi:
        return open.CreateDeviceRequestPushProvider.xiaomi;
      case PushProvider.huawei:
        return open.CreateDeviceRequestPushProvider.huawei;
      case PushProvider.apn:
        return open.CreateDeviceRequestPushProvider.apn;
    }
  }
}
