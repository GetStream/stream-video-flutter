// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:async/async.dart' show CancelableOperation;
import 'package:collection/collection.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';
import 'package:synchronized/synchronized.dart';

import '../../globals.dart';
import '../../open_api/video/coordinator/api.dart' hide User;
import '../../protobuf/video/sfu/event/events.pb.dart' show ReconnectDetails;
import '../call_state.dart';
import '../coordinator/coordinator_client.dart';
import '../coordinator/models/coordinator_events.dart';
import '../coordinator/models/coordinator_models.dart';
import '../coordinator/open_api/error/open_api_error.dart';
import '../errors/video_error.dart';
import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../logger/stream_log.dart';
import '../models/call_received_data.dart';
import '../models/models.dart';
import '../platform_detector/platform_detector.dart';
import '../retry/retry_policy.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_client_capability.dart';
import '../sfu/data/models/sfu_error.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../stream_video.dart';
import '../utils/cancelable_operation.dart';
import '../utils/cancelables.dart';
import '../utils/extensions.dart';
import '../utils/future.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../utils/standard.dart';
import '../utils/subscriptions.dart';
import '../webrtc/media/media_constraints.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import '../webrtc/model/rtc_video_parameters.dart';
import '../webrtc/rtc_audio_api/rtc_audio_api.dart' as rtc_audio;
import '../webrtc/rtc_manager.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';
import '../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../webrtc/rtc_track/rtc_track.dart';
import '../webrtc/sdp/editor/sdp_editor_impl.dart';
import '../webrtc/sdp/policy/sdp_policy.dart';
import '../ws/ws.dart';
import 'call_connect_options.dart';
import 'call_events.dart';
import 'call_reject_reason.dart';
import 'call_type.dart';
import 'permissions/permissions_manager.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';
import 'session/dynascale_manager.dart';
import 'state/call_state_notifier.dart';
import 'stats/sfu_stats_reporter.dart';
import 'stats/stats_reporter.dart';

typedef OnCallPermissionRequest =
    void Function(
      StreamCallPermissionRequestEvent,
    );

typedef GetCurrentUserId = String? Function();

typedef SetActiveCall = Future<void> Function(Call?);
typedef SetOutgoingCall = Future<void> Function(Call?);
typedef GetActiveCall = Call? Function();
typedef GetOutgoingCall = Call? Function();
typedef CallStateSelector<T> = T Function(CallState state);

const _idState = 1;
const _idUserId = 2;
const _idCoordEvents = 3;
const _idSessionEvents = 4;
const _idSessionStats = 5;
const _idConnect = 6;
const _idAwait = 7;
const _idFastReconnectTimeout = 8;
const _idReconnect = 9;
const _idNativeWebRtc = 10;

const _tag = 'SV:Call';
int _callSeq = 1;

/// Represents a [Call] in which you can connect to.
class Call {
  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call({
    required StreamCallCid callCid,
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    required InternetConnection networkMonitor,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
    RtcMediaDeviceNotifier? rtcMediaDeviceNotifier,
  }) {
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    return Call._internal(
      callCid: callCid,
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      networkMonitor: networkMonitor,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
      rtcMediaDeviceNotifier: rtcMediaDeviceNotifier,
    );
  }

  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call.fromCreated({
    required CallCreatedData data,
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    required InternetConnection networkMonitor,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
    RtcMediaDeviceNotifier? rtcMediaDeviceNotifier,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      networkMonitor: networkMonitor,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
      rtcMediaDeviceNotifier: rtcMediaDeviceNotifier,
    ).also(
      (it) => it._stateManager.updateFromCallCreatedData(
        data,
        callConnectOptions: it.connectOptions,
      ),
    );
  }

  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call.fromRinging({
    required CallRingingData data,
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    required InternetConnection networkMonitor,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
    RtcMediaDeviceNotifier? rtcMediaDeviceNotifier,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      networkMonitor: networkMonitor,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
      rtcMediaDeviceNotifier: rtcMediaDeviceNotifier,
    ).also((it) => it._stateManager.lifecycleCallRinging(data));
  }

  factory Call._internal({
    required StreamCallCid callCid,
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    required InternetConnection networkMonitor,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
    CallCredentials? credentials,
    RtcMediaDeviceNotifier? rtcMediaDeviceNotifier,
  }) {
    final finalCallPreferences = preferences ?? DefaultCallPreferences();
    final finalRetryPolicy = retryPolicy ?? const RetryPolicy();
    final finalSdpPolicy =
        sdpPolicy ?? const SdpPolicy(spdEditingEnabled: false);

    final stateManager = _makeStateManager(
      callCid,
      coordinatorClient,
      streamVideo.state.user,
      finalCallPreferences,
    );

    final permissionManager = _makePermissionAwareManager(
      callCid,
      coordinatorClient,
      stateManager,
    );

    return Call._(
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      networkMonitor: networkMonitor,
      stateManager: stateManager,
      credentials: credentials,
      retryPolicy: finalRetryPolicy,
      sdpPolicy: finalSdpPolicy,
      permissionManager: permissionManager,
      rtcMediaDeviceNotifier:
          rtcMediaDeviceNotifier ?? RtcMediaDeviceNotifier.instance,
    );
  }

  Call._({
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    required CallStateNotifier stateManager,
    required PermissionsManager permissionManager,
    required this.networkMonitor,
    required RetryPolicy retryPolicy,
    required SdpPolicy sdpPolicy,
    required RtcMediaDeviceNotifier rtcMediaDeviceNotifier,
    CallCredentials? credentials,
    CallSessionFactory? sessionFactory,
  }) : _sessionFactory =
           sessionFactory ??
           CallSessionFactory(
             callCid: stateManager.callState.callCid,
             sdpEditor: sdpPolicy.spdEditingEnabled
                 ? SdpEditorImpl(sdpPolicy)
                 : NoOpSdpEditor(),
           ),
       _stateManager = stateManager,
       _permissionsManager = permissionManager,
       _coordinatorClient = coordinatorClient,
       _streamVideo = streamVideo,
       _retryPolicy = retryPolicy,
       _credentials = credentials,
       _rtcMediaDeviceNotifier = rtcMediaDeviceNotifier,
       dynascaleManager = DynascaleManager(stateManager: stateManager) {
    streamLog.i(_tag, () => '<init> state: ${stateManager.callState}');

    if (stateManager.callState.isRingingFlow) {
      _init();
    }
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();
  late final _cancelables = Cancelables();
  late final _callInitLock = Lock();
  late final _callJoinLock = Lock();
  late final _callReconnectLock = Lock();
  late final _callClosedCaptionsLock = Lock();
  late final _multitaskingCameraLock = Lock();

  final CoordinatorClient _coordinatorClient;
  final StreamVideo _streamVideo;
  final RetryPolicy _retryPolicy;
  final CallSessionFactory _sessionFactory;
  final CallStateNotifier _stateManager;
  final PermissionsManager _permissionsManager;
  final DynascaleManager dynascaleManager;
  final InternetConnection networkMonitor;
  final RtcMediaDeviceNotifier _rtcMediaDeviceNotifier;

  CallCredentials? _credentials;
  CallSession? _session;
  CallSession? _previousSession;

  StatsOptions? _sfuStatsOptions;
  SfuStatsReporter? _sfuStatsReporter;
  String? _unifiedSessionId;

  int _reconnectAttempts = 0;
  Duration _fastReconnectDeadline = Duration.zero;
  SfuReconnectionStrategy _reconnectStrategy =
      SfuReconnectionStrategy.unspecified;
  Future<InternetStatus>? _awaitNetworkAvailableFuture;
  Future<Result<None>>? _awaitMigrationCompleteFuture;
  bool _initialized = false;
  bool _leaveCallTriggered = false;

  // Completer that will be completed when call lifecycle ends (call leave is called)
  final Completer<void> _callLifecycleCompleter = Completer<void>();

  final Map<String, Timer> _reactionTimers = {};
  final Map<String, Timer> _captionsTimers = {};
  final List<CancelableOperation<void>> _sfuStatsTimers = [];
  final Set<SfuClientCapability> _sfuClientCapabilities = {
    SfuClientCapability.subscriberVideoPause, // on by default
  };

  String get id => state.value.callId;
  StreamCallCid get callCid => state.value.callCid;
  StreamCallType get type => state.value.callType;
  bool get isActiveCall => _streamVideo.state.activeCalls.value.any(
    (call) => call.callCid == callCid,
  );

  StateEmitter<CallState> get state => _stateManager.callStateStream;
  Stream<Duration> get callDurationStream => _stateManager.durationStream;
  StatsReporter? get statsReporter => _session?.statsReporter;

  Stream<T> partialState<T>(CallStateSelector<T> selector) {
    return _stateManager.partialCallStateStream(selector);
  }

  SharedEmitter<
    ({
      PeerConnectionStatsBundle publisherStatsBundle,
      PeerConnectionStatsBundle subscriberStatsBundle,
    })
  >
  get stats => _stats;
  late final _stats =
      MutableSharedEmitterImpl<
        ({
          PeerConnectionStatsBundle publisherStatsBundle,
          PeerConnectionStatsBundle subscriberStatsBundle,
        })
      >();

  SharedEmitter<StreamCallEvent> get callEvents => _callEvents;
  final _callEvents = MutableSharedEmitterImpl<StreamCallEvent>();

  Stream<List<StreamClosedCaption>> get closedCaptions =>
      _closedCaptions.asStream();
  final _closedCaptions = MutableStateEmitterImpl<List<StreamClosedCaption>>(
    [],
  );

  OnCallPermissionRequest? onPermissionRequest;

  CallConnectOptions _connectOptions = const CallConnectOptions();
  CallConnectOptions? _connectOptionsOverride;

  @override
  String toString() {
    return 'Call{cid: $callCid}';
  }

  CallConnectOptions get connectOptions {
    return _connectOptionsOverride ?? _connectOptions;
  }

  /// It is better to pass the [connectOptions] to [join] method,
  /// setting it directly has to be done carefully. Depending on the moment in the call lifecycle,
  /// it might be overwritten by default configuration or it might be too late to apply the changes.
  set connectOptions(CallConnectOptions connectOptions) {
    if (state.value.status is CallStatusConnected) {
      _logger.w(
        () =>
            '[setConnectOptions] rejected (connectOptions must be'
            ' set before invoking `connect`)',
      );

      return;
    }

    _logger.d(() => '[setConnectOptions] connectOptions: $connectOptions)');
    _connectOptionsOverride = connectOptions;
  }

  Future<void> _init() {
    return _callInitLock.synchronized(() async {
      _logger.v(() => '[_init] no args');

      if (_initialized) return;
      _logger.d(() => '[_init] initializing');

      _observeEvents();
      _observeState();
      _observeReconnectEvents();
      _observeUserId();
      _observeNativeWebRtcEventStream();

      _logger.v(() => '[_init] initialized');
      _initialized = true;
    });
  }

  void _observeNativeWebRtcEventStream() {
    _subscriptions.add(
      _idNativeWebRtc,
      _onNativeWebRtcEvent(),
    );
  }

  void _observeState() {
    _subscriptions.add(
      _idState,
      _stateManager.callStateStream.listen(
        (state) async => _onStateChanged(state),
      ),
    );
  }

  void _observeEvents() {
    _subscriptions.cancel(_idCoordEvents);
    _subscriptions.add(
      _idCoordEvents,
      _coordinatorClient.events.on<CoordinatorCallEvent>((event) async {
        event
            .mapToCallEvent(state.value)
            .emitIfNotNull(_callEvents)
            ?.also(_onCoordinatorEvent);
      }),
    );
  }

  void _observeReconnectEvents() {
    _subscriptions.add(
      _idReconnect,
      networkMonitor.onStatusChange.listen(
        (status) {
          if (status == InternetStatus.disconnected) {
            _logger.d(() => '[observeReconnectEvents] network disconnected');
            _reconnect(
              SfuReconnectionStrategy.fast,
              reconnectReason: 'network disconnected',
            );
          }
        },
      ),
    );
  }

  void _observeUserId() {
    _subscriptions.add(
      _idUserId,
      _streamVideo.state.user.asStream().map((u) => u.id).distinct().listen((
        userId,
      ) {
        final stateUserId = _stateManager.callState.currentUserId;
        if (userId == stateUserId) {
          _logger.v(() => '[observeUserId] rejected (same userId): $userId');
          return;
        }

        _logger.d(() => '[observeUserId] userId: $userId');
        _stateManager.lifecycleUpdateUserId(userId);
      }),
    );
  }

  Future<void> _onStateChanged(CallState state) async {
    final status = state.status;

    if (status is CallStatusReconnectionFailed) {
      await leave(reason: DisconnectReason.reconnectionFailed());
    }

    if (status is CallStatusDisconnected) {
      await _clear('status-disconnected');
    }

    _sessionFactory.sdpEditor.opusDtxEnabled =
        state.settings.audio.opusDtxEnabled;
    _sessionFactory.sdpEditor.opusRedEnabled =
        state.settings.audio.redundantCodingEnabled;
  }

  StreamSubscription<NativeWebRtcEvent> _onNativeWebRtcEvent() {
    return RtcMediaDeviceNotifier.instance.nativeWebRtcEventsStream().listen((
      event,
    ) {
      _logger.d(
        () => '[_onNativeWebRtcEvent] screenSharingStopped: $event',
      );

      switch (event) {
        case ScreenSharingStoppedEvent _:
          if (CurrentPlatform.isIos) {
            // On iOS only one broadcast extension can be active at a time
            setScreenShareEnabled(enabled: false);
          } else {
            final trackId = event.data?['trackId'] as String?;
            if (trackId != null && state.value.localParticipant != null) {
              final track = getTrack(
                state.value.localParticipant!.trackIdPrefix,
                SfuTrackType.screenShare,
              );

              if (track?.mediaTrack.id == trackId) {
                setScreenShareEnabled(enabled: false);
              }
            }
          }
          break;
        case ScreenSharingStartedEvent _:
          _stateManager.participantSetScreenShareEnabled(
            enabled: true,
          );

          _connectOptions = _connectOptions.copyWith(
            screenShare: TrackOption.enabled(
              constraints: const ScreenShareConstraints(
                useiOSBroadcastExtension: true,
              ),
            ),
          );
          break;
        default:
          return;
      }
    });
  }

  Future<void> _onCoordinatorEvent(StreamCallEvent event) async {
    // Return if the event is not for this call.
    if (event.callCid != state.value.callCid) return;

    _logger.v(
      () =>
          '[onCoordinatorEvent] event.type: ${event.runtimeType}, calStatus: ${state.value.status}',
    );

    switch (event) {
      case StreamCallPermissionRequestEvent _:
        // Notify the client about the permission request.
        return onPermissionRequest?.call(event);
      case StreamCallRejectedEvent _:
        return _stateManager.coordinatorCallRejected(event);
      case StreamCallAcceptedEvent _:
        return _stateManager.coordinatorCallAccepted(event);
      case StreamCallEndedEvent _:
        return _stateManager.coordinatorCallEnded(event);
      case StreamCallPermissionsUpdatedEvent _:
        return _stateManager.coordinatorCallPermissionsUpdated(event);
      case StreamCallRecordingStartedEvent _:
        return _stateManager.coordinatorCallRecordingStarted(event);
      case StreamCallRecordingStoppedEvent _:
        return _stateManager.coordinatorCallRecordingStopped(event);
      case StreamCallRecordingFailedEvent _:
        return _stateManager.coordinatorCallRecordingFailed(event);
      case StreamCallTranscriptionStartedEvent _:
        return _stateManager.coordinatorCallTranscriptionStarted(event);
      case StreamCallTranscriptionStoppedEvent _:
        return _stateManager.coordinatorCallTranscriptionStopped(event);
      case StreamCallTranscriptionFailedEvent _:
        return _stateManager.coordinatorCallTranscriptionFailed(event);
      case StreamCallClosedCaptionsStartedEvent _:
        return _stateManager.coordinatorCallClosedCaptionsStarted(event);
      case StreamCallClosedCaptionsStoppedEvent _:
        return _stateManager.coordinatorCallClosedCaptionsStopped(event);
      case StreamCallClosedCaptionsFailedEvent _:
        return _stateManager.coordinatorCallClosedCaptionsFailed(event);
      case StreamCallBroadcastingStartedEvent _:
        return _stateManager.coordinatorCallBroadcastingStarted(event);
      case StreamCallBroadcastingStoppedEvent _:
        return _stateManager.coordinatorCallBroadcastingStopped(event);
      case StreamCallBroadcastingFailedEvent _:
        return _stateManager.coordinatorCallBroadcastingFailed(event);
      case StreamCallClosedCaptionsEvent _:
        return _handleClosedCaptionEvent(event);
      case StreamCallReactionEvent _:
        _reactionTimers[event.user.id]?.cancel();

        _reactionTimers[event.user.id] = Timer(
          _stateManager.callState.preferences.reactionAutoDismissTime,
          () {
            _stateManager.resetCallReaction(event.user.id);
            _reactionTimers.remove(event.user.id);
          },
        );
        return _stateManager.coordinatorCallReaction(event);
      case StreamCallSessionParticipantCountUpdatedEvent _:
        if (state.value.status.isConnected || state.value.status.isJoined) {
          return;
        }

        return _stateManager.setParticipantsCount(
          totalCount: event.participantsCountByRole.values.fold(
            0,
            (a, b) => a + b,
          ),
          anonymousCount: event.anonymousParticipantCount,
        );
      case StreamCallMemberAddedEvent _:
        return _stateManager.coordinatorCallMemberAdded(event);
      case StreamCallMemberRemovedEvent _:
        return _stateManager.coordinatorCallMemberRemoved(event);
      case StreamCallMemberUpdatedEvent _:
        return _stateManager.coordinatorCallMemberUpdated(event.members);
      case StreamCallMemberUpdatedPermissionEvent _:
        return _stateManager.coordinatorCallMemberUpdated(
          event.updatedMembers,
          capabilitiesByRole: event.capabilitiesByRole,
        );
      case StreamCallUserBlockedEvent _:
        return _stateManager.coordinatorCallUserBlocked(event);
      case StreamCallUserUnblockedEvent _:
        return _stateManager.coordinatorCallUserUnblocked(event);
      case StreamCallUpdatedEvent _:
        return _stateManager.callMetadataChanged(
          event.metadata,
          capabilitiesByRole: event.capabilitiesByRole,
        );
      case StreamCallLiveStartedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case StreamCallRingingEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case StreamCallMissedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case StreamCallSessionEndedEvent _:
        return _stateManager.callMetadataChanged(
          event.metadata,
          updateMembers: false,
        );
      case StreamCallSessionStartedEvent _:
        return _stateManager.callMetadataChanged(
          event.metadata,
          updateMembers: false,
        );
      default:
        break;
    }
  }

  @internal
  void traceSessionLog(String tag, dynamic data) {
    _session?.trace(tag, data);
  }

  void updateCallPreferences(CallPreferences preferences) {
    _logger.i(() => '[updateCallPreferences] $preferences');
    _stateManager.updateCallPreferences(preferences);
  }

  /// Enables the given SFU client capabilities for this call.
  ///
  /// Should be configured before `call.join()` is called. Changes made after
  /// joining will not affect the current session until the next join/reconnect.
  void enableClientCapabilities(
    List<SfuClientCapability> capabilities,
  ) {
    _logger.i(() => '[enableClientCapabilities] $capabilities');
    capabilities.forEach(_sfuClientCapabilities.add);
  }

  /// Disables the given SFU client capabilities for this call.
  ///
  /// Should be configured before `call.join()` is called. Changes made after
  /// joining will not affect the current session until the next join/reconnect.
  void disableClientCapabilities(
    List<SfuClientCapability> capabilities,
  ) {
    _logger.i(() => '[disableClientCapabilities] $capabilities');
    capabilities.forEach(_sfuClientCapabilities.remove);
  }

  /// Accepts the incoming call.
  Future<Result<None>> accept() async {
    final state = this.state.value;
    _logger.i(() => '[accept] state: $state');

    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[accept] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }

    final outgoingCall = _streamVideo.state.outgoingCall.valueOrNull;
    if (outgoingCall != null && outgoingCall.callCid != callCid) {
      _logger.i(() => '[accept] canceling outgoing call: $outgoingCall');
      await outgoingCall.reject(reason: CallRejectReason.cancel());
      await _streamVideo.state.setOutgoingCall(null);
    }

    if (!_streamVideo.options.allowMultipleActiveCalls) {
      final activeCall = _streamVideo.activeCall;
      if (activeCall != null && activeCall.callCid != callCid) {
        _logger.i(() => '[accept] canceling another active call: $activeCall');
        await activeCall.leave(reason: DisconnectReason.replaced());
        await _streamVideo.state.removeActiveCall(activeCall);
      }
    }

    final result = await _coordinatorClient.acceptCall(cid: state.callCid);
    if (result is Success<None>) {
      _stateManager.lifecycleCallAccepted();
    }

    return result;
  }

  /// Rejects the incoming call.
  Future<Result<None>> reject({CallRejectReason? reason}) async {
    final state = this.state.value;
    _logger.i(() => '[reject] state: $state');

    final result = await _coordinatorClient.rejectCall(
      cid: state.callCid,
      reason: reason?.value,
    );

    // Always leave the call after rejecting it.
    await leave(
      reason: result is Success<None>
          ? DisconnectReason.rejected(
              byUserId: state.currentUserId,
              reason: reason,
            )
          : null,
    );

    return result;
  }

  /// Ends the call for all participants.
  Future<Result<None>> end() async {
    final state = this.state.value;
    _logger.d(() => '[end] status: ${state.status}');

    if (state.status is! CallStatusActive) {
      _logger.w(() => '[end] rejected (invalid status): ${state.status}');
      return Result.error('invalid status: ${state.status}');
    }

    _session?.leave(reason: 'user is ending the call');
    await _clear('end');

    final result = await _permissionsManager.endCall();
    _stateManager.lifecycleCallEnded();

    _logger.v(() => '[end] completed: $result');
    return result;
  }

  /// Joins the call.
  ///
  /// - [connectOptions]: optional initial call configuration
  /// - [membersLimit]: Sets the maximum number of members to return as part of the response.
  Future<Result<None>> join({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
  }) async {
    await _init();

    if (state.value.status is CallStatusConnected) {
      _logger.w(() => '[join] rejected (connected)');
      return const Result.success(none);
    }

    if (_streamVideo.state.activeCalls.value.any(
      (call) => call.callCid == callCid,
    )) {
      _logger.w(
        () => '[join] rejected (a call with the same cid is in progress)',
      );

      return Result.error('a call with the same cid is in progress');
    }

    if (state.value.status is CallStatusConnecting) {
      _logger.v(() => '[join] await "connecting" change');

      final status = await state.firstWhere(
        (it) => it.status is CallStatusConnected,
        timeLimit: _stateManager.callState.preferences.connectTimeout,
      );

      if (status is! CallStatusConnected) {
        return const Result.success(none);
      } else {
        _logger.e(() => '[join] original "connect" failed');
        return Result.error('original "connect" failed');
      }
    }

    await _streamVideo.state.setActiveCall(this);
    final result =
        await _join(
              connectOptions: connectOptions,
              membersLimit: membersLimit,
              maxJoinRetries: maxJoinRetries,
            )
            .asCancelable()
            .storeIn(_idConnect, _cancelables)
            .valueOrDefault(Result.error('connect cancelled'));

    if (result.isSuccess) {
      _logger.v(() => '[join] finished: $result');
    } else {
      _logger.e(() => '[join] failed: $result');
      final videoError = result.getErrorOrNull();
      await leave(
        reason: videoError != null
            ? DisconnectReason.failure(videoError)
            : null,
      );
    }

    return result;
  }

  Future<Result<None>> _join({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
    String? reconnectReason,
  }) async {
    if (_callJoinLock.locked) {
      _logger.w(() => '[join] rejected (already joining)');
      return Result.error('already joining');
    }

    return _callJoinLock.synchronized(() async {
      final sfuJoinFailures = <String, int>{};
      String? sfuToForceExclude;

      for (var attempt = 0; attempt < max(maxJoinRetries, 1); attempt++) {
        final result = await runCatchingResult(
          () => _doJoin(
            connectOptions: connectOptions,
            membersLimit: membersLimit,
            sfuToForceExclude: sfuToForceExclude,
            reconnectReason: reconnectReason,
          ),
        );

        if (result.isSuccess) {
          _logger.v(() => '[join] attempt $attempt, cid: $callCid, success');
          sfuToForceExclude = null;
          return result;
        } else {
          _logger.e(
            () => '[join] attempt $attempt, cid: $callCid, failed: $result',
          );

          final error = result.getErrorOrNull();
          if (error is VideoErrorWithCause &&
              error.cause is SessionConnectionFailure) {
            final sfuName = _credentials?.sfuServer.name ?? '';

            sfuJoinFailures.update(
              sfuName,
              (value) => value + 1,
              ifAbsent: () => 1,
            );

            if (sfuJoinFailures[sfuName]! >= 2) {
              _logger.e(
                () =>
                    '[join] too many failures for SFU: $sfuName, migrating...',
              );

              _session?.trace('call_join_migrate', {
                'migrateFrom': sfuName,
              });

              sfuToForceExclude = sfuName;
            }
          }
        }

        await Future<void>.delayed(
          _retryPolicy.backoff(attempt),
        );
      }

      await leave(
        reason: DisconnectReason.failure(
          VideoError(
            message: 'failed to join after $maxJoinRetries attempts',
          ),
        ),
      );

      return Result.error(
        'failed to join after $maxJoinRetries attempts',
      );
    });
  }

  Future<Result<None>> _doJoin({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    String? sfuToForceExclude,
    String? reconnectReason,
  }) async {
    _logger.d(() => '[join] options: $_connectOptions');
    final connectionTimeStopwatch = Stopwatch()..start();

    final validation = await _stateManager.validateUserId(
      _streamVideo.currentUser.id,
    );

    if (validation.isFailure) {
      _logger.w(() => '[join] rejected (validation): $validation');
      return validation;
    }

    _logger.v(() => '[join] validated');

    final performingMigration =
        _reconnectStrategy == SfuReconnectionStrategy.migrate;
    final performingRejoin =
        _reconnectStrategy == SfuReconnectionStrategy.rejoin;
    final performingFastReconnect =
        _reconnectStrategy == SfuReconnectionStrategy.fast;

    final result = await _awaitIfNeeded();
    if (result.isFailure) {
      _logger.e(() => '[join] waiting failed: $result');

      await reject(reason: CallRejectReason.timeout());

      return result;
    }

    if (_callLifecycleCompleter.isCompleted) {
      _logger.w(() => '[join] rejected (call was left)');
      return Result.error('call was left');
    }

    _stateManager.lifecycleCallConnecting(
      attempt: _reconnectAttempts,
      strategy: _reconnectStrategy,
    );

    final joinedResult = await _joinIfNeeded(
      connectOptions: connectOptions,
      membersLimit: membersLimit,
      forceMigratingFrom: sfuToForceExclude,
    );

    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[join] coordinator joining failed: $joinedResult');

      final error = (joinedResult as Failure).error;
      await leave(reason: DisconnectReason.failure(error));
      return joinedResult;
    }

    _credentials = joinedResult.data;
    _previousSession = _session;

    if (_callLifecycleCompleter.isCompleted) {
      _logger.w(() => '[join] rejected (call was left during joining)');
      return Result.error('call was left');
    }

    final reconnectDetails =
        _reconnectStrategy == SfuReconnectionStrategy.unspecified
        ? null
        : await _previousSession?.getReconnectDetails(
            _reconnectStrategy,
            reconnectAttempts: _reconnectAttempts,
            reason: reconnectReason,
          );

    if (!performingFastReconnect) {
      _logger.v(
        () =>
            '[join] creating new sfu session (rejoin: $performingRejoin, migration: $performingMigration)',
      );

      _session = await _sessionFactory.makeCallSession(
        // a new session_id is necessary for the REJOIN strategy.
        // we use the previous session_id if available
        sessionId: performingRejoin ? null : _previousSession?.sessionId,
        sessionSeq: _reconnectAttempts,
        credentials: _credentials!,
        stateManager: _stateManager,
        dynascaleManager: dynascaleManager,
        networkMonitor: networkMonitor,
        streamVideo: _streamVideo,
        statsOptions: _sfuStatsOptions!,
        leftoverTraceRecords:
            _previousSession
                ?.getTrace()
                .expand((slice) => slice.snapshot)
                .toList() ??
            const [],
        onReconnectionNeeded: (pc, strategy) {
          _session?.trace('pc_reconnection_needed', {
            'peerConnectionId': pc.type.name,
            'reconnectionStrategy': strategy.name,
          });

          _reconnect(
            strategy,
            reconnectReason: '${pc.type.name} pc disconnected',
          );
        },
        clientPublishOptions:
            _stateManager.callState.preferences.clientPublishOptions,
      );

      if (performingMigration) {
        _awaitMigrationCompleteFuture = _session!.waitForMigrationComplete();
      }

      dynascaleManager.init(
        sfuClient: _session!.sfuClient,
        sessionId: _session!.sessionId,
      );

      if (_callLifecycleCompleter.isCompleted) {
        _logger.w(
          () => '[join] rejected (call was left during session creation)',
        );
        return Result.error('call was left');
      }

      _logger.d(() => '[join] starting sfu session');

      final sessionResult = await _startSession(
        _session!,
        reconnectDetails: reconnectDetails,
      );

      if (sessionResult is! Success<None>) {
        _logger.e(() => '[join] sfu session start failed: $sessionResult');

        final error = (sessionResult as Failure).error;
        return Result.errorWithCause(
          error.message,
          SessionConnectionFailure(error: error),
        );
      }
    } else {
      _logger.v(
        () =>
            '[join] reusing previous sfu session (rejoin: $performingRejoin, migration: $performingMigration)',
      );

      _session = _previousSession;

      _logger.d(() => '[join] fast reconnecting');
      final result = await _session!.fastReconnect(
        reconnectDetails: reconnectDetails!,
        capabilities: _sfuClientCapabilities,
        unifiedSessionId: _unifiedSessionId,
      );

      if (result.isFailure) {
        _logger.e(() => '[join] fast reconnecting failed: $result');
        _reconnectStrategy = SfuReconnectionStrategy.rejoin;
        return Result.error('fast reconnecting failed');
      }

      _logger.v(() => '[join] fast reconnecting success');
      _fastReconnectDeadline =
          result.getDataOrNull()?.fastReconnectDeadline ??
          _fastReconnectDeadline;
    }

    // make sure we only track connection timing if we are not calling this method as part of a migration flow
    connectionTimeStopwatch.stop();
    if (!performingMigration) {
      unawaited(
        _sfuStatsReporter?.sendSfuStats(
          reconnectionStrategy: _reconnectStrategy,
          connectionTimeMs: connectionTimeStopwatch.elapsedMilliseconds,
        ),
      );
    }

    if (performingRejoin) {
      _logger.v(() => '[join] leaving previous session');
      _previousSession?.leave(
        reason:
            'Closing previous WS after reconnect with strategy: ${_reconnectStrategy.name}',
      );
      await _previousSession?.dispose();
    }

    // For migration we have to wait for confirmation before we can complete the flow
    if (_reconnectStrategy != SfuReconnectionStrategy.migrate) {
      _logger.v(() => '[join] connected');
      _previousSession = null;
      _stateManager.lifecycleCallConnected();
    }

    _logger.v(() => '[join] completed');
    return const Result.success(none);
  }

  Future<Result<CallCredentials>> _joinIfNeeded({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    String? forceMigratingFrom,
  }) async {
    _logger.d(
      () =>
          '[joinIfNeeded] options: $connectOptions, '
          'reconnectionStrategy: $_reconnectStrategy',
    );

    final credentials = _credentials;
    final prevState = _stateManager.callState;

    if (credentials == null ||
        _sfuStatsOptions == null ||
        forceMigratingFrom != null ||
        _reconnectStrategy == SfuReconnectionStrategy.rejoin ||
        _reconnectStrategy == SfuReconnectionStrategy.migrate) {
      _logger.d(() => '[joinIfNeeded] joining');

      final joinedResult = await _performJoinCallRequest(
        create: true,
        connectOptions: connectOptions,
        migratingFrom:
            forceMigratingFrom ??
            (_reconnectStrategy == SfuReconnectionStrategy.migrate
                ? _session?.config.sfuName
                : null),
        membersLimit: membersLimit,
      );

      return joinedResult.fold(
        success: (success) {
          _credentials = success.data.credentials;
          _sfuStatsOptions = success.data.statsOptions;

          _session?.rtcManager?.subscriber.tracer.setEnabled(
            _sfuStatsOptions!.enableRtcStats,
          );
          _session?.rtcManager?.publisher?.tracer.setEnabled(
            _sfuStatsOptions!.enableRtcStats,
          );
          _session?.setTraceEnabled(_sfuStatsOptions!.enableRtcStats);

          return Result.success(success.data.credentials);
        },
        failure: (failure) {
          _logger.e(() => '[joinIfNeeded] failed: $failure');
          _stateManager.state = prevState;
          return failure;
        },
      );
    }

    _logger.w(() => '[joinIfNeeded] rejected (already joined): $_credentials');
    return Result.success(credentials);
  }

  Future<Result<CallJoinedData>> _performJoinCallRequest({
    bool create = false,
    bool video = false,
    String? migratingFrom,
    int? membersLimit,
    CallConnectOptions? connectOptions,
  }) async {
    _logger.d(() => '[joinCall] cid: $callCid, migratingFrom: $migratingFrom');

    if (_callLifecycleCompleter.isCompleted) {
      _logger.w(() => '[joinCall] rejected (call was left)');
      return Result.error('call was left');
    }

    final joinResult = await _coordinatorClient.joinCall(
      callCid: callCid,
      create: create,
      migratingFrom: migratingFrom,
      video: video,
      membersLimit: membersLimit,
    );

    if (joinResult is! Success<CoordinatorJoined>) {
      _logger.e(() => '[joinCall] join failed: $joinResult');
      return joinResult as Failure;
    }

    final receivedOrCreated = CallReceivedOrCreatedData(
      wasCreated: joinResult.data.wasCreated,
      data: CallCreatedData(
        callCid: callCid,
        metadata: joinResult.data.metadata,
      ),
    );

    // Apply call settings to connect options only when not reconnecting.
    if (_reconnectStrategy == SfuReconnectionStrategy.unspecified) {
      await _applyCallSettingsToConnectOptions(
        receivedOrCreated.data.metadata.settings,
      );

      if (connectOptions != null) {
        _connectOptions = _connectOptions.merge(connectOptions);
      }

      if (_connectOptionsOverride != null) {
        _connectOptions = _connectOptions.merge(_connectOptionsOverride!);
        _connectOptionsOverride = null;
      }
    }

    _logger.v(() => '[joinCall] joinedMetadata: ${joinResult.data.metadata}');

    final joined = CallJoinedData(
      callCid: callCid,
      wasCreated: joinResult.data.wasCreated,
      metadata: joinResult.data.metadata,
      credentials: joinResult.data.credentials,
      statsOptions: joinResult.data.statsOptions,
    );

    _stateManager.lifecycleCallJoined(
      joined,
      callConnectOptions: connectOptions,
    );

    if (_streamVideo.isAudioProcessorConfigured() &&
        joinResult.data.metadata.settings.audio.noiseCancellation?.mode ==
            NoiceCancellationSettingsMode.autoOn) {
      // AutoOn will enable noise cancellation if the device has sufficient processing power
      unawaited(
        startAudioProcessing(
          requireAdvancedAudioProcessingSupport: true,
        ),
      );
    }

    _logger.v(() => '[joinCall] completed: $joined');
    return Result.success(joined);
  }

  /// Updates the configuration of the call.
  ///
  /// - [startsAt]: The date and time when the call is scheduled to start.
  /// - [custom]: Custom metadata to be added to the call.
  /// - [ring]: Ring settings for the call.
  /// - [audio]: Audio settings for the call.
  /// - [video]: Video settings for the call.
  /// - [screenShare]: Screen share settings for the call.
  /// - [recording]: Recording settings for the call.
  /// - [transcription]: Transcription settings for the call.
  /// - [backstage]: Backstage settings for the call.
  /// - [geofencing]: Geofencing settings for the call.
  /// - [limits]: Limits settings for the call.
  /// - [broadcasting]: Broadcasting settings for the call.
  /// - [session]: Session settings for the call.
  /// - [frameRecording]: Frame recording settings for the call.
  Future<Result<CallMetadata>> update({
    Map<String, Object>? custom,
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
    StreamIngressSettings? ingress,
  }) {
    return _coordinatorClient.updateCall(
      callCid: callCid,
      custom: custom ?? {},
      startsAt: startsAt,
      ring: ring,
      audio: audio,
      video: video,
      screenShare: screenShare,
      recording: recording,
      transcription: transcription,
      backstage: backstage,
      geofencing: geofencing,
      limits: limits,
      broadcasting: broadcasting,
      session: session,
      frameRecording: frameRecording,
      ingress: ingress,
    );
  }

  Future<Result<None>> _startSession(
    CallSession session, {
    ReconnectDetails? reconnectDetails,
  }) async {
    _logger.d(
      () => '[startSession] sessionId: $session',
    );

    _session = session;
    _unifiedSessionId ??= _session?.sessionId;

    _sfuStatsReporter?.stop();
    _subscriptions.cancel(_idSessionStats);
    _subscriptions.cancel(_idSessionEvents);

    _subscriptions.add(
      _idSessionEvents,
      session.events.listen((event) {
        event.mapToCallEvent(state.value).emitIfNotNull(_callEvents);
        _onSfuEvent(event);
      }),
    );

    _stateManager.lifecycleCallSessionStart(
      sessionId: session.sessionId,
    );

    if (_callLifecycleCompleter.isCompleted) {
      _logger.w(() => '[startSession] rejected (call was left)');
      return Result.error('call was left');
    }

    final result = await session.start(
      reconnectDetails: reconnectDetails,
      capabilities: _sfuClientCapabilities,
      onRtcManagerCreatedCallback: (_) async {
        _logger.v(() => '[startSession] applying connect options');
        unawaited(
          _applyConnectOptions().catchError((
            dynamic error,
            StackTrace stackTrace,
          ) {
            _logger.e(
              () =>
                  '[startSession] failed to apply connect options: $error, stackTrace: $stackTrace',
            );
          }),
        );
      },
      isAnonymousUser:
          _streamVideo.state.currentUser.type == UserType.anonymous,
      unifiedSessionId: _unifiedSessionId,
    );

    if (session.statsReporter != null) {
      _subscriptions.add(
        _idSessionStats,
        session.statsReporter!
            .run(
              interval: _stateManager
                  .callState
                  .preferences
                  .callStatsReportingInterval,
            )
            .listen(
              (stats) {
                _stats.emit(stats);
              },
            ),
      );
    }

    if (_sfuStatsOptions != null) {
      unawaited(_sfuStatsReporter?.sendSfuStats());
      _sfuStatsReporter =
          SfuStatsReporter(
            callSession: session,
            stateManager: _stateManager,
            statsOptions: _sfuStatsOptions!,
            unifiedSessionId: _unifiedSessionId,
          )..run(
            interval: Duration(
              milliseconds: _sfuStatsOptions!.reportingIntervalMs,
            ),
          );
    }

    return result.fold(
      success: (success) {
        _logger.v(() => '[startSession] success: $success');
        _fastReconnectDeadline = success.data.fastReconnectDeadline;
        return const Result.success(none);
      },
      failure: (failure) {
        _logger.e(() => '[startSession] failed: $failure');
        return failure;
      },
    );
  }

  Future<void> _onSfuEvent(SfuEvent sfuEvent) async {
    if (sfuEvent is SfuParticipantLeftEvent) {
      if (sfuEvent.callCid != callCid.value) return;

      final callParticipants = [...state.value.callParticipants]
        ..removeWhere(
          (participant) =>
              participant.userId == sfuEvent.participant.userId &&
              participant.sessionId == sfuEvent.participant.sessionId,
        );

      if (callParticipants.length == 1 &&
          callParticipants.first.userId == _streamVideo.currentUser.id &&
          state.value.isRingingFlow &&
          _stateManager.callState.preferences.dropIfAloneInRingingFlow) {
        await leave(reason: DisconnectReason.lastParticipantLeft());
      }
    } else if (sfuEvent is SfuHealthCheckResponseEvent) {
      _stateManager.setParticipantsCount(
        totalCount: sfuEvent.participantCount.total,
        anonymousCount: sfuEvent.participantCount.anonymous,
      );
    } else if (sfuEvent is SfuCallEndedEvent) {
      unawaited(_sfuStatsReporter?.sendSfuStats());
      _stateManager.sfuCallEnded(sfuEvent);
    }

    if (sfuEvent is SfuSocketDisconnected) {
      await _sfuStatsReporter?.sendSfuStats();
      // Don't attempt reconnection if leaving the call was triggered
      if (!_leaveCallTriggered &&
          !StreamWebSocketCloseCode.isIntentionalClosure(
            sfuEvent.reason.closeCode,
          )) {
        _logger.w(() => '[onSfuEvent] socket disconnected');

        _session?.trace('sfu_socket_disconnected', {
          'closeCode': sfuEvent.reason.closeCode,
          'closeReason': sfuEvent.reason.closeReason,
        });
        await _reconnect(
          SfuReconnectionStrategy.fast,
          reconnectReason:
              'sfu socket disconnected, closeCode: ${sfuEvent.reason.closeCode}, closeReason: ${sfuEvent.reason.closeReason}',
        );
      } else if (_leaveCallTriggered) {
        _logger.d(
          () =>
              '[onSfuEvent] socket disconnected, leaving call was triggered - no reconnection',
        );
      }
    } else if (sfuEvent is SfuSocketFailed) {
      _logger.w(() => '[onSfuEvent] socket failed');
      _session?.trace('sfu_socket_failed', {
        'error': sfuEvent.error.message,
      });
      await _reconnect(
        SfuReconnectionStrategy.fast,
        reconnectReason: 'sfu socket failed: ${sfuEvent.error.message}',
      );
    } else if (sfuEvent is SfuGoAwayEvent) {
      _logger.w(() => '[onSfuEvent] go away, migrating sfu');
      _session?.trace('sfu_go_away', {
        'reason': sfuEvent.goAwayReason.name,
      });
      await _reconnect(
        SfuReconnectionStrategy.migrate,
        reconnectReason: 'go away',
      );
    }
    // error event
    else if (sfuEvent is SfuErrorEvent) {
      switch (sfuEvent.error.reconnectStrategy) {
        case SfuReconnectionStrategy.rejoin:
        case SfuReconnectionStrategy.fast:
        case SfuReconnectionStrategy.migrate:
          _logger.w(
            () =>
                '[onSfuEvent] SFU error: ${sfuEvent.error}, reconnect strategy: ${sfuEvent.error.reconnectStrategy}',
          );
          _session?.trace('sfu_error', {
            'error': sfuEvent.error.message,
          });
          await _reconnect(
            sfuEvent.error.reconnectStrategy,
            reconnectReason: 'sfu error: ${sfuEvent.error.message}',
          );
          break;
        case SfuReconnectionStrategy.disconnect:
          _logger.w(
            () => '[onSfuEvent] SFU error: ${sfuEvent.error}, leaving call',
          );
          await leave(reason: DisconnectReason.sfuError(sfuEvent.error));
          break;
        case SfuReconnectionStrategy.unspecified:
          _logger.w(() => '[onSfuEvent] SFU error: ${sfuEvent.error}');
          break;
      }
    }
  }

  Future<void> _reconnect(
    SfuReconnectionStrategy strategy, {
    String? reconnectReason,
  }) async {
    if (_callJoinLock.inLock) {
      _logger.w(() => '[_reconnect] skipping reconnect (join in progress)');
      return;
    }

    if (state.value.status is CallStatusDisconnected) {
      _logger.w(() => '[reconnect] rejected (call is already disconnected)');
      return;
    }

    if (_callReconnectLock.locked) {
      _logger.w(
        () =>
            '[reconnect] rejected $strategy (reconnect in progress: $_reconnectStrategy)',
      );
      return;
    }

    await _callReconnectLock.synchronized(() async {
      _reconnectAttempts = 0;
      _reconnectStrategy = strategy;

      final reconnectStartTime = DateTime.now();
      var fastReconnectAttemptsCount = 0;
      do {
        _awaitNetworkAvailableFuture = _awaitNetworkAvailable();

        if (state.value.preferences.reconnectTimeout > Duration.zero) {
          final elapsed = DateTime.now().difference(reconnectStartTime);
          if (elapsed > state.value.preferences.reconnectTimeout) {
            _logger.w(() => '[reconnect] reconnection timeout');
            _stateManager.lifecycleCallReconnectingFailed();
            return;
          }
        }

        if (_callLifecycleCompleter.isCompleted) {
          _logger.w(() => '[reconnect] rejected (call was left)');
          return;
        }

        _session?.trace('callReconnect', {
          'strategy': strategy.name,
          'reason': reconnectReason,
        });

        _stateManager.lifecycleCallConnecting(
          attempt: _reconnectAttempts,
          strategy: _reconnectStrategy,
        );

        _logger.d(
          () =>
              '[reconnect] strategy: $_reconnectStrategy, attempt: $_reconnectAttempts',
        );

        try {
          final networkStatus = await _awaitNetworkAvailableFuture;
          _logger.v(() => '[reconnect] network: $networkStatus');

          if (networkStatus == InternetStatus.disconnected) {
            _logger.w(() => '[reconnect] reconnection timeout');
            _session?.trace('callReconnectFailed', {
              'strategy': strategy.name,
              'error': 'reconnection timeout',
            });
            _stateManager.lifecycleCallReconnectingFailed();
            return;
          }

          if (_callLifecycleCompleter.isCompleted) {
            _logger.w(
              () => '[reconnect] rejected (call was left during network wait)',
            );
            _session?.trace('callReconnectFailed', {
              'strategy': strategy.name,
              'error': 'call was left',
            });
            return;
          }

          unawaited(_sfuStatsReporter?.sendSfuStats());

          switch (_reconnectStrategy) {
            case SfuReconnectionStrategy.unspecified:
            case SfuReconnectionStrategy.disconnect:
              _logger.v(
                () => '[reconnect]  No-op strategy $_reconnectStrategy',
              );
            case SfuReconnectionStrategy.fast:
              _logger.v(() => '[reconnect] fast reconnect');
              await _reconnectFast(reason: reconnectReason);
            case SfuReconnectionStrategy.rejoin:
              _logger.v(() => '[reconnect] rejoin');
              await _reconnectRejoin(reason: reconnectReason);
            case SfuReconnectionStrategy.migrate:
              _logger.v(() => '[reconnect] migrate');
              await _reconnectMigrate(reason: reconnectReason);
          }

          _session?.trace('callReconnectSuccess', {
            'strategy': strategy.name,
          });
        } catch (error) {
          switch (error) {
            case OpenApiError() when error.apiError.unrecoverable ?? false:
            case APIError() when error.unrecoverable ?? false:
              _logger.w(() => '[reconnect] unrecoverable error');
              _stateManager.lifecycleCallReconnectingFailed();

              _session?.trace('callReconnectFailed', {
                'strategy': strategy.name,
                'error': error.toString(),
              });

              return;
            default:
              _logger.w(
                () =>
                    '[reconnect] reconnect failed, error: $error, strategy: $_reconnectStrategy, attempt: $_reconnectAttempts. Attempting with Rejoin strategy',
              );

              if (_reconnectStrategy == SfuReconnectionStrategy.fast) {
                await Future<void>.delayed(
                  _retryPolicy.backoff(fastReconnectAttemptsCount),
                );
              } else {
                await Future<void>.delayed(
                  _retryPolicy.backoff(_reconnectAttempts),
                );
              }

              final wasMigrating =
                  _reconnectStrategy == SfuReconnectionStrategy.migrate;

              final mustPerformRejoin =
                  DateTime.now().difference(reconnectStartTime) >
                  _fastReconnectDeadline;

              // don't immediately switch to the REJOIN strategy, but instead attempt
              // to reconnect with the FAST strategy for a few times before switching.
              // in some cases, we immediately switch to the REJOIN strategy.
              final shouldRejoin =
                  mustPerformRejoin ||
                  wasMigrating || // if we were migrating, but the migration failed
                  fastReconnectAttemptsCount >= 2 || // after 3 failed attempts
                  !(_session?.rtcManager?.publisher?.isHealthy() ??
                      true) || // if the publisher is not healthy
                  !(_session?.rtcManager?.subscriber.isHealthy() ??
                      true); // if the subscriber is not healthy

              if (!shouldRejoin) {
                fastReconnectAttemptsCount++;
              }

              final nextStrategy = shouldRejoin
                  ? SfuReconnectionStrategy.rejoin
                  : SfuReconnectionStrategy.fast;

              _reconnectStrategy = nextStrategy;
          }
        }
      } while (state.value.status is! CallStatusConnected &&
          state.value.status is! CallStatusDisconnected &&
          state.value.status is! CallStatusReconnectionFailed);

      // reset the reconnect strategy to unspecified after a successful reconnection
      _reconnectStrategy = SfuReconnectionStrategy.unspecified;
    });
  }

  Future<void> _reconnectFast({String? reason}) async {
    _reconnectStrategy = SfuReconnectionStrategy.fast;
    await _join(reconnectReason: reason);
  }

  Future<void> _reconnectRejoin({String? reason}) async {
    _reconnectAttempts++;
    _reconnectStrategy = SfuReconnectionStrategy.rejoin;
    await _join(reconnectReason: reason);
  }

  Future<void> _reconnectMigrate({String? reason}) async {
    final migrateTimeStopwatch = Stopwatch()..start();

    _reconnectAttempts++;
    _reconnectStrategy = SfuReconnectionStrategy.migrate;
    final joinResult = await _join(reconnectReason: reason);

    if (joinResult.isFailure) {
      _logger.e(() => '[reconnectMigrate] join failed: $joinResult');
      _reconnectStrategy = SfuReconnectionStrategy.rejoin;
      return;
    }

    await _previousSession?.close(StreamWebSocketCloseCode.disposeOldSocket);

    final migrationResult = await _awaitMigrationCompleteFuture;
    if (migrationResult == null) {
      _logger.e(() => '[reconnectMigrate] migration failed');
      _reconnectStrategy = SfuReconnectionStrategy.rejoin;
      return;
    }

    migrationResult.fold(
      success: (_) {
        _stateManager.lifecycleCallConnected();
      },
      failure: (_) {
        _logger.e(
          () => '[reconnectMigrate] migration did not complete correctly',
        );
        _reconnectStrategy = SfuReconnectionStrategy.rejoin;
      },
    );

    if (migrationResult.isSuccess) {
      migrateTimeStopwatch.stop();
      unawaited(
        _sfuStatsReporter?.sendSfuStats(
          connectionTimeMs: migrateTimeStopwatch.elapsedMilliseconds,
          reconnectionStrategy: _reconnectStrategy,
        ),
      );
    }
  }

  Future<InternetStatus> _awaitNetworkAvailable() async {
    final previousCheckInterval = networkMonitor.checkInterval;
    try {
      networkMonitor.setIntervalAndResetTimer(
        _streamVideo.options.networkMonitorSettings.offlineCheckInterval,
      );

      final networkFuture = networkMonitor.onStatusChange
          .startWithFuture(networkMonitor.internetStatus)
          .firstWhere((status) => status == InternetStatus.connected)
          .timeout(
            state.value.preferences.networkAvailabilityTimeout,
            onTimeout: () {
              _logger.w(() => '[_awaitNetworkAvailable] timeout');
              return InternetStatus.disconnected;
            },
          );

      final lifecycleFuture = _callLifecycleCompleter.future.then((_) {
        _logger.w(() => '[_awaitNetworkAvailable] call was left');
        return InternetStatus.disconnected;
      });

      // Race the network future against the call lifecycle cancellable
      // to ensure we don't wait for the network if the call was left
      final connectionStatus =
          await Future.any([
                networkFuture,
                lifecycleFuture,
              ])
              .asCancelable()
              .storeIn(_idFastReconnectTimeout, _cancelables)
              .valueOrDefault(InternetStatus.disconnected);
      return connectionStatus;
    } finally {
      networkMonitor.setIntervalAndResetTimer(previousCheckInterval);
    }
  }

  Future<Result<None>> _awaitIfNeeded() async {
    final state = this.state.value;
    final status = state.status;
    final settings = state.settings;

    Future<Result<None>>? futureResult;
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      final timeout = settings.ring.autoCancelTimeout;
      _logger.d(() => '[awaitIfNeeded] outgoing timeout: $timeout');
      futureResult = _awaitOutgoingToBeAccepted(timeout);
    } else if (status is CallStatusIncoming && !status.acceptedByMe) {
      final timeout = settings.ring.autoRejectTimeout;
      _logger.d(() => '[awaitIfNeeded] incoming timeout: $timeout');
      futureResult = _awaitIncomingToBeAccepted(timeout);
    } else if (status is CallStatusJoining) {
      // TODO we don't need this case, since we no longer join from LobbyView
      _logger.d(() => '[awaitIfNeeded] joining to become joined');
      futureResult = _awaitCallToBeJoined();
    }

    if (futureResult != null) {
      _logger.v(() => '[awaitIfNeeded] return cancelable');

      final lifecycleFuture = _callLifecycleCompleter.future.then<Result<None>>(
        (_) {
          _logger.w(() => '[awaitIfNeeded] call was left');
          return Result.error('call was left');
        },
      );

      // Race the await future against the call lifecycle cancellable
      // to ensure we don't wait for the call status change if it was left
      return Future.any([
        futureResult,
        lifecycleFuture,
      ]).asCancelable().storeIn(_idAwait, _cancelables).value;
    }

    return const Result.success(none);
  }

  /// Leaves the call.
  ///
  /// - [reason]: optional reason for leaving the call
  Future<Result<None>> leave({DisconnectReason? reason}) async {
    try {
      if (_leaveCallTriggered) {
        _logger.i(() => '[leave] rejected (already leaving call)');
        return const Result.success(none);
      }

      _leaveCallTriggered = true;

      // Complete the leave completer to cancel ongoing operations
      if (!_callLifecycleCompleter.isCompleted) {
        _callLifecycleCompleter.complete();
      }

      final state = this.state.value;
      _logger.i(() => '[leave] state: $state');

      if (state.status.isDisconnected) {
        _logger.d(() => '[leave] rejected (state.status is disconnected)');
        return const Result.success(none);
      }

      try {
        _session?.leave(reason: 'user is leaving the call');
      } finally {
        await _clear('leave');
      }

      _stateManager.lifecycleCallDisconnected(reason: reason);

      _logger.v(() => '[leave] finished');

      return const Result.success(none);
    } finally {
      _leaveCallTriggered = false;
    }
  }

  Future<void> _clear(String src) async {
    _logger.d(() => '[clear] src: $src');

    if (state.value.settings.audio.noiseCancellation?.mode ==
        NoiceCancellationSettingsMode.autoOn) {
      try {
        await stopAudioProcessing();
      } catch (e) {
        _logger.w(() => '[clear] stopAudioProcessing failed: $e');
      }
    }

    for (final timer in [
      ..._reactionTimers.values,
      ..._captionsTimers.values,
    ]) {
      timer.cancel();
    }

    for (final operation in _sfuStatsTimers) {
      await operation.cancel();
    }

    _sfuStatsReporter?.stop();
    _subscriptions.cancelAll();
    _cancelables.cancelAll();

    try {
      await _session?.dispose();
    } catch (e) {
      _logger.w(() => '[clear] stop dispose failed: $e');
    }

    await dynascaleManager.dispose();

    await _streamVideo.state.removeActiveCall(this);
    if (_streamVideo.state.outgoingCall.valueOrNull?.callCid == callCid) {
      await _streamVideo.state.setOutgoingCall(null);
    }

    _logger.v(() => '[clear] completed');
  }

  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    return _setLocalTrack(track);
  }

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    return _session?.getTrack(trackIdPrefix, trackType);
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?_session?.getTracks(trackIdPrefix)];
  }

  /// Takes a picture of a VideoTrack at highest possible resolution
  ///
  /// - [participant]: the participant whose track to take a screenshot of
  /// - [trackType]: optional type of track to take a screenshot of, defaults to [SfuTrackType.video]
  Future<ByteBuffer?> takeScreenshot(
    CallParticipantState participant, {
    SfuTrackType? trackType,
  }) async {
    final track = getTrack(
      participant.trackIdPrefix,
      trackType ?? SfuTrackType.video,
    );

    return track?.captureScreenshot();
  }

  Future<void> _applyCallSettingsToConnectOptions(CallSettings settings) async {
    final mediaDevicesResult = await _rtcMediaDeviceNotifier.enumerateDevices();

    final mediaDevices = mediaDevicesResult.fold(
      success: (success) => success.data,
      failure: (failure) => <RtcMediaDevice>[],
    );

    final audioOutputs = mediaDevices
        .where((d) => d.kind == RtcMediaDeviceKind.audioOutput)
        .toList();
    final audioInputs = mediaDevices
        .where((d) => d.kind == RtcMediaDeviceKind.audioInput)
        .toList();

    /// Determines if the speaker should be enabled based on a priority hierarchy of
    /// settings.
    ///
    /// The priority order is as follows:
    /// 1. If video camera is set to be on by default, speaker is enabled
    /// 2. If audio speaker is set to be on by default, speaker is enabled
    /// 3. If the default audio device is set to speaker, speaker is enabled
    final speakerOnWithSettingsPriority =
        settings.video.cameraDefaultOn ||
        settings.audio.speakerDefaultOn ||
        settings.audio.defaultDevice ==
            AudioSettingsRequestDefaultDeviceEnum.speaker;

    // Determine default audio output with priority:
    // 1. External device (if available)
    var defaultAudioOutput = audioOutputs.firstWhereOrNull(
      (device) => device.isExternal,
    );

    if (defaultAudioOutput == null) {
      // 2. Speaker (if settings indicate it should be used)
      if (speakerOnWithSettingsPriority) {
        defaultAudioOutput = audioOutputs.firstWhereOrNull(
          (device) => device.id.equalsIgnoreCase(
            AudioSettingsRequestDefaultDeviceEnum.speaker.value,
          ),
        );
      } else {
        // 3. First non-speaker device
        defaultAudioOutput = audioOutputs.firstWhereOrNull(
          (device) => !device.id.equalsIgnoreCase(
            AudioSettingsRequestDefaultDeviceEnum.speaker.value,
          ),
        );
      }
    }

    final defaultAudioOutputIsExternal =
        defaultAudioOutput?.isExternal ?? false;

    // iOS doesn't allow implicitly setting the default audio output,
    // if external device is connected we trust the OS to set it as default.
    if (defaultAudioOutputIsExternal && CurrentPlatform.isIos) {
      defaultAudioOutput = null;
    }

    // Match the default audio input with the default audio output if possible
    final defaultAudioInput = audioInputs.firstWhereOrNull(
      (d) => d.label == defaultAudioOutput?.label,
    );

    _connectOptions = connectOptions.copyWith(
      camera: TrackOption.fromSetting(
        enabled: settings.video.cameraDefaultOn,
      ),
      microphone: TrackOption.fromSetting(
        enabled: settings.audio.micDefaultOn,
      ),
      audioInputDevice: defaultAudioInput,
      audioOutputDevice: defaultAudioOutput,
      cameraFacingMode:
          settings.video.cameraFacing ==
              VideoSettingsRequestCameraFacingEnum.front
          ? FacingMode.user
          : FacingMode.environment,
      speakerDefaultOn:
          !defaultAudioOutputIsExternal && speakerOnWithSettingsPriority,
      targetResolution: settings.video.targetResolution,
      screenShareTargetResolution: settings.screenShare.targetResolution,
    );
  }

  Future<void> _applyConnectOptions() async {
    _logger.d(() => '[applyConnectOptions] connectOptions: $_connectOptions');
    await _applyCameraOption(
      _connectOptions.camera,
      _connectOptions.cameraFacingMode,
      _connectOptions.targetResolution,
      _connectOptions.videoInputDevice?.id,
    );

    await _applyMicrophoneOption(_connectOptions.microphone);
    await _applyScreenShareOption(
      _connectOptions.screenShare,
      _connectOptions.screenShareTargetResolution,
    );

    if (_connectOptions.audioInputDevice != null) {
      await setAudioInputDevice(_connectOptions.audioInputDevice!);
    }

    if (_connectOptions.audioOutputDevice != null) {
      await setAudioOutputDevice(_connectOptions.audioOutputDevice!);
    } else {
      if (CurrentPlatform.isIos) {
        await _session?.rtcManager?.setAppleAudioConfiguration(
          speakerOn: _connectOptions.speakerDefaultOn,
        );
      }
    }

    _logger.v(() => '[applyConnectOptions] finished');
  }

  Future<Result<None>> _applyCameraOption(
    TrackOption cameraOption,
    FacingMode facingMode,
    StreamTargetResolution? targetResolution,
    String? deviceId,
  ) async {
    if (cameraOption is TrackProvided) {
      return _setLocalTrack(cameraOption.track);
    } else if (cameraOption is TrackEnabled) {
      final constraints = cameraOption.constraints is CameraConstraints
          ? cameraOption.constraints as CameraConstraints?
          : null;

      return setCameraEnabled(
        enabled: true,
        constraints:
            constraints ??
            CameraConstraints(
              facingMode: facingMode,
              deviceId: deviceId,
              params:
                  targetResolution?.toVideoParams() ??
                  RtcVideoParametersPresets.h720_16x9,
            ),
      );
    }

    return const Result.success(none);
  }

  Future<void> _applyMicrophoneOption(TrackOption microphoneOption) async {
    if (microphoneOption is TrackProvided) {
      await _setLocalTrack(microphoneOption.track);
    } else if (microphoneOption is TrackEnabled) {
      final constraints = microphoneOption.constraints is AudioConstraints
          ? microphoneOption.constraints as AudioConstraints?
          : null;
      await setMicrophoneEnabled(enabled: true, constraints: constraints);
    }
  }

  Future<void> _applyScreenShareOption(
    TrackOption screenShareOption,
    StreamTargetResolution? targetResolution,
  ) async {
    if (screenShareOption is TrackProvided) {
      await _setLocalTrack(screenShareOption.track);
    } else if (screenShareOption is TrackEnabled) {
      final constraints =
          screenShareOption.constraints is ScreenShareConstraints
          ? screenShareOption.constraints as ScreenShareConstraints?
          : null;

      await setScreenShareEnabled(
        enabled: true,
        constraints:
            constraints ??
            ScreenShareConstraints(
              params:
                  targetResolution?.toVideoParams(
                    defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
                  ) ??
                  RtcVideoParametersPresets.h1080_16x9,
            ),
      );
    }
  }

  Future<Result<None>> _setLocalTrack(RtcLocalTrack track) async {
    _logger.d(() => '[setLocalTrack] localTrack: $track');
    final session = _session;
    if (session == null) {
      _logger.w(() => '[setLocalTrack] rejected (session is null);');
      return Result.error('no call session');
    }
    final result = await session.setLocalTrack(track);
    _logger.v(() => '[setLocalTrack] completed: $result');
    if (result.isSuccess) {
      final mediaConstraints = track.mediaConstraints;
      if (mediaConstraints is AudioConstraints) {
        _logger.v(() => '[setLocalTrack]: setMicrophoneEnabled true');
        await setMicrophoneEnabled(
          enabled: true,
          constraints: mediaConstraints,
        );
      } else if (mediaConstraints is CameraConstraints) {
        _logger.v(() => '[setLocalTrack]: setCameraEnabled true');
        await setCameraEnabled(enabled: true, constraints: mediaConstraints);
      } else if (mediaConstraints is ScreenShareConstraints) {
        _logger.v(() => '[setLocalTrack] setScreenShareEnabled true');
        await setScreenShareEnabled(
          enabled: true,
          constraints: mediaConstraints,
        );
      } else {
        streamLog.e(
          _tag,
          () => '[_setLocalTrack] failed: $mediaConstraints',
        );
      }
    }
    return result;
  }

  Future<Result<None>> _awaitIncomingToBeAccepted(Duration timeLimit) async {
    return state
        .firstWhere(
          (state) {
            final status = state.status;
            return status is CallStatusIncoming && status.acceptedByMe;
          },
          timeLimit: timeLimit,
        )
        .then((value) {
          _logger.i(() => '[awaitIncomingToBeAccepted] completed');
          return const Result.success(none);
        })
        .onError((e, stk) {
          _logger.e(() => '[awaitIncomingToBeAccepted] failed: $e');
          return Result.failure(VideoErrors.compose(e, stk));
        });
  }

  Future<Result<None>> _awaitOutgoingToBeAccepted(Duration timeLimit) async {
    return state
        .firstWhere(
          (state) {
            final status = state.status;
            return status is CallStatusOutgoing && status.acceptedByCallee;
          },
          timeLimit: timeLimit,
        )
        .then((value) {
          _logger.i(() => '[awaitOutgoingToBeAccepted] completed');
          return const Result.success(none);
        })
        .onError((e, stk) {
          _logger.e(() => '[awaitOutgoingToBeAccepted] failed: $e');
          return Result.failure(VideoErrors.compose(e, stk));
        });
  }

  Future<Result<None>> _awaitCallToBeJoined() async {
    return state
        .firstWhere(
          (state) {
            return state.status is CallStatusJoined;
          },
          timeLimit: const Duration(seconds: 60),
        )
        .then((value) {
          _logger.d(() => '[awaitCallToBeJoined] completed');
          return const Result.success(none);
        })
        .onError((e, stk) {
          _logger.e(() => '[awaitCallToBeJoined] failed: $e');
          return Result.failure(VideoErrors.compose(e, stk));
        });
  }

  void _handleClosedCaptionEvent(StreamCallClosedCaptionsEvent event) {
    _callClosedCaptionsLock.synchronized(() {
      _logger.v(() => '[handleClosedCaptionEvent] event: $event');

      String keyFor(StreamClosedCaption caption) {
        return '${caption.speakerId}_${caption.startTime}';
      }

      final queue = _closedCaptions.value;
      final currentCaption = StreamClosedCaption.fromEvent(event);
      final currentKey = keyFor(currentCaption);

      // Ignore duplicates from backend
      if (queue.any((caption) => keyFor(caption) == currentKey)) {
        return;
      }

      final newQueue = [...queue, currentCaption];

      final visibilityDurationMs = _stateManager
          .callState
          .preferences
          .closedCaptionsVisibilityDurationMs;
      final visibileCaptions =
          _stateManager.callState.preferences.closedCaptionsVisibleCaptions;

      try {
        // schedule the removal of the closed caption after the retention time
        if (visibilityDurationMs > 0) {
          final timer = Timer(Duration(milliseconds: visibilityDurationMs), () {
            _removeExpiredCaption(keyFor, currentCaption);
            _captionsTimers.remove(currentKey);
          });

          _captionsTimers[currentKey] = timer;

          // cancel the cleanup tasks for the closed captions that are no longer in the queue
          if (newQueue.length > visibileCaptions) {
            for (var i = 0; i < newQueue.length - visibileCaptions; i++) {
              final key = keyFor(newQueue[i]);
              final timer = _captionsTimers[key];

              timer?.cancel();
              _captionsTimers.remove(key);
            }
          }

          _closedCaptions.value = newQueue.length > visibileCaptions
              ? newQueue.sublist(newQueue.length - visibileCaptions)
              : newQueue;
        }
      } catch (error) {
        _logger.e(() => '[handleClosedCaptionEvent] failed: $error');
      }
    });
  }

  Future<void> _removeExpiredCaption(
    String Function(StreamClosedCaption) keyFor,
    StreamClosedCaption caption,
  ) async {
    return _callClosedCaptionsLock.synchronized(() {
      _closedCaptions.value = _closedCaptions.value.where((c) {
        return keyFor(c) != keyFor(caption);
      }).toList();
    });
  }

  /// Adds members to the current call.
  Future<Result<None>> addMembers(List<UserInfo> users) {
    return _coordinatorClient.addMembers(
      callCid: callCid,
      members: users.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
    );
  }

  /// Removes members from the current call.
  Future<Result<None>> removeMembers(List<String> userIds) {
    return _coordinatorClient.removeMembers(
      callCid: callCid,
      removeIds: userIds,
    );
  }

  Future<Result<None>> updateCallMembers({
    List<UserInfo> updateMembers = const [],
    List<String> removeIds = const [],
  }) {
    return _coordinatorClient.updateCallMembers(
      callCid: callCid,
      updateMembers: updateMembers.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
      removeIds: removeIds,
    );
  }

  Future<Result<T>> _performGetOperation<T>({
    required bool watch,
    required Future<Result<T>> Function() coordinatorCall,
    required CallMetadata Function(T data) onSuccess,
  }) async {
    if (watch) {
      _observeEvents();
      _streamVideo.state.setWatchedCall(this);
    }

    final response = await coordinatorCall();

    return response.fold(
      success: (success) async {
        _logger.v(() => '[performGetOperation] success: $success');

        final callMetadata = onSuccess(success.data);
        unawaited(
          _applyCallSettingsToConnectOptions(
            callMetadata.settings,
          ).catchError(
            (dynamic error, StackTrace stackTrace) {
              _logger.e(
                () =>
                    '[performGetOperation] failed to apply call settings: $error, stackTrace: $stackTrace',
              );
            },
          ),
        );

        return success;
      },
      failure: (error) {
        _logger.e(() => '[performGetOperation] failed: $error');
        return error;
      },
    );
  }

  /// Loads the information about the call.
  ///
  /// - [ringing]: If `true`, sends a VoIP notification, triggering the native call screen on iOS and Android.
  /// - [notify]: If `true`, sends a standard push notification.
  /// - [video]: Marks the call as a video call if `true`; otherwise, audio-only.
  /// - [watch]:  If `true`, listens to coordinator events and updates call state accordingly.
  /// - [membersLimit]: Sets the total number of members to return as part of the response.
  Future<Result<CallReceivedData>> get({
    int? membersLimit,
    bool ringing = false,
    bool notify = false,
    bool video = false,
    bool watch = true,
  }) async {
    _logger.d(
      () =>
          '[get] callCid: $callCid, membersLimit: $membersLimit, '
          'ringing: $ringing, notify: $notify, video: $video, watch: $watch',
    );

    return _performGetOperation<CallReceivedData>(
      watch: watch,
      coordinatorCall: () => _coordinatorClient.getCall(
        callCid: callCid,
        membersLimit: membersLimit,
        ringing: ringing,
        notify: notify,
        video: video,
      ),
      onSuccess: (data) {
        _stateManager.updateFromCallReceivedData(
          data,
          ringing: ringing,
          notify: notify,
        );

        return data.metadata;
      },
    );
  }

  /// Loads the information about the call and creates it if it doesn't exist.
  ///
  /// - [ringing]: If `true`, sends a VoIP notification, triggering the native call screen on iOS and Android.
  /// - [notify]: If `true`, sends a standard push notification.
  /// - [video]: Marks the call as a video call if `true`; otherwise, audio-only.
  /// - [watch]:  If `true`, listens to coordinator events and updates call state accordingly.
  /// - [members]:An optional list of `MemberRequest` objects to add to the call.
  /// - [memberIds]: An optional list of member IDs to add to the call.
  /// - [membersLimit]: Sets the total number of members to return as part of the response.
  /// - [ring]: Ring settings for the call.
  /// - [audio]: Audio settings for the call.
  /// - [videoSettings]: Video settings for the call.
  /// - [screenShare]: Screen share settings for the call.
  /// - [recording]: Recording settings for the call.
  /// - [transcription]: Transcription settings for the call.
  /// - [backstage]: Backstage settings for the call.
  /// - [geofencing]: Geofencing settings for the call.
  /// - [limits]: Limits settings for the call.
  /// - [broadcasting]: Broadcasting settings for the call.
  /// - [session]: Session settings for the call.
  /// - [frameRecording]: Frame recording settings for the call.
  Future<Result<CallReceivedOrCreatedData>> getOrCreate({
    List<String> memberIds = const [],
    List<MemberRequest> members = const [],
    bool ringing = false,
    bool video = false,
    bool watch = true,
    bool? notify,
    String? team,
    DateTime? startsAt,
    int? membersLimit,
    StreamRingSettings? ring,
    StreamAudioSettings? audio,
    StreamVideoSettings? videoSettings,
    StreamScreenShareSettings? screenShare,
    StreamBackstageSettings? backstage,
    StreamLimitsSettings? limits,
    StreamRecordingSettings? recording,
    StreamTranscriptionSettings? transcription,
    StreamBroadcastingSettings? broadcasting,
    StreamGeofencingSettings? geofencing,
    StreamSessionSettings? session,
    StreamIngressSettings? ingress,
    StreamFrameRecordingSettings? frameRecording,
    Map<String, Object> custom = const {},
  }) async {
    final settingsOverride = CallSettingsRequest(
      audio: audio?.toOpenDto(),
      video: videoSettings?.toOpenDto(),
      screensharing: screenShare?.toOpenDto(),
      ring: ring?.toOpenDto(),
      backstage: backstage?.toOpenDto(),
      limits: limits?.toOpenDto(),
      transcription: transcription?.toOpenDto(),
      recording: recording?.toOpenDto(),
      broadcasting: broadcasting?.toOpenDto(),
      geofencing: geofencing?.toOpenDto(),
      session: session?.toOpenDto(),
      ingress: ingress?.toOpenDto(),
      frameRecording: frameRecording?.toOpenDto(),
    );

    final aggregatedMembers = [
      ...memberIds.map(
        (id) => MemberRequest(
          userId: id,
        ),
      ),
      ...members,
    ];

    if (ringing) {
      await _streamVideo.state.setOutgoingCall(this);
    }

    return _performGetOperation<CallReceivedOrCreatedData>(
      watch: watch,
      coordinatorCall: () => _coordinatorClient.getOrCreateCall(
        callCid: callCid,
        ringing: ringing,
        members: aggregatedMembers,
        team: team,
        notify: notify,
        video: video,
        startsAt: startsAt,
        membersLimit: membersLimit,
        settingsOverride: settingsOverride,
        custom: custom,
      ),
      onSuccess: (data) {
        _stateManager.updateFromCallCreatedData(
          data.data,
          ringing: ringing,
          callConnectOptions: connectOptions,
        );

        return data.data.metadata;
      },
    );
  }

  /// Sends a ring notification to the provided users who are not already in the call.
  /// All users should be members of the call.
  /// If you want to ring user who are not members yet, use [addMembers] first.
  ///
  /// - [userIds]: List of user IDs to ring. If empty, rings all members who are not in the call.
  /// - [video]: Whether to indicate it's a video call.
  Future<Result<List<String>>> ring({
    List<String> userIds = const [],
    bool video = false,
  }) {
    return _coordinatorClient.ringCall(
      callCid: callCid,
      membersIds: userIds,
      video: video,
    );
  }

  /// Returns true if the current user has the [CallPermission] supplied.
  bool hasPermission(CallPermission permission) {
    return _permissionsManager.hasPermission(permission);
  }

  Future<Result<None>> requestPermissions(List<CallPermission> permissions) {
    return _permissionsManager.request(permissions);
  }

  Future<Result<None>> grantPermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager.grant(userId: userId, permissions: permissions);
  }

  Future<Result<None>> revokePermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager.revoke(userId: userId, permissions: permissions);
  }

  Future<Result<None>> blockUser(String userId) {
    return _permissionsManager.blockUser(userId);
  }

  Future<Result<None>> unblockUser(String userId) {
    return _permissionsManager.unblockUser(userId);
  }

  /// Kicks a user from the call.
  /// Set [block] to true to also block the user from rejoining.
  Future<Result<None>> kickUser(
    String userId, {
    bool block = false,
  }) {
    return _permissionsManager.kickUser(userId, block: block);
  }

  Future<Result<None>> startRecording({
    String? recordingExternalStorage,
  }) async {
    final result = await _permissionsManager.startRecording(
      recordingExternalStorage: recordingExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallRecording(isRecording: true);
    }

    return result;
  }

  Future<Result<List<CallRecording>>> listRecordings() async {
    return _permissionsManager.listRecordings();
  }

  Future<Result<None>> stopRecording() async {
    final result = await _permissionsManager.stopRecording();

    if (result.isSuccess) {
      _stateManager.setCallRecording(isRecording: false);
    }

    return result;
  }

  /// Starts transcription for the call.
  /// If [enableClosedCaptions] Enable closed captions along with transcriptions
  /// [language] The spoken language in the call, if not provided the language defined in the transcription settings will be used
  /// [transcriptionExternalStorage] Store transcriptions in this external storage
  Future<Result<None>> startTranscription({
    bool? enableClosedCaptions,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    final result = await _permissionsManager.startTranscription(
      enableClosedCaptions: enableClosedCaptions,
      language: language,
      transcriptionExternalStorage: transcriptionExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallTranscribing(isTranscribing: true);
    }

    return result;
  }

  Future<Result<List<CallTranscription>>> listTranscriptions() async {
    return _permissionsManager.listTranscriptions();
  }

  Future<Result<None>> stopTranscription() async {
    final result = await _permissionsManager.stopTranscription();

    if (result.isSuccess) {
      _stateManager.setCallTranscribing(isTranscribing: false);
    }

    return result;
  }

  /// Starts close captions for the call.
  /// If [enableTranscription] is set to `true`, it will also enable transcription.
  /// [language] The spoken language in the call, if not provided the language defined in the transcription settings will be used
  /// [transcriptionExternalStorage] Which external storage to use for transcriptions (only applicable if enable_transcription is true)
  Future<Result<None>> startClosedCaptions({
    bool? enableTranscription,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    final result = await _permissionsManager.startClosedCaptions(
      enableTranscription: enableTranscription,
      language: language,
      transcriptionExternalStorage: transcriptionExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallClosedCaptioning(isCaptioning: true);
    }

    return result;
  }

  /// Stops close captions for the call.
  Future<Result<None>> stopClosedCaptions() async {
    final result = await _permissionsManager.stopClosedCaptions();

    if (result.isSuccess) {
      _stateManager.setCallClosedCaptioning(isCaptioning: false);
    }

    return result;
  }

  /// Starts audio processing for the call.
  Future<Result<None>> startAudioProcessing({
    bool requireAdvancedAudioProcessingSupport = false,
  }) async {
    if (!_streamVideo.isAudioProcessorConfigured()) {
      _logger.w(() => '[startAudioProcessing] rejected (not configured)');
      return Result.error('Cannot start audio processing (not configured)');
    }

    if (!_permissionsManager.hasPermission(
      CallPermission.enableNoiseCancellation,
    )) {
      _logger.w(() => '[startAudioProcessing] rejected (no permission)');
      return Result.error('Cannot start audio processing (no permission)');
    }

    if (requireAdvancedAudioProcessingSupport) {
      final supportResult = await _streamVideo
          .deviceSupportsAdvancedAudioProcessing();

      if (supportResult.isFailure) {
        return Result.error(
          'Cannot start audio processing (faild to check advanced audio processing support)',
        );
      } else {
        if (!(supportResult.getDataOrNull() ?? false)) {
          return const Result.failure(
            VideoError(
              message:
                  'Cannot start audio processing (device does not support required advanced audio processing)',
            ),
          );
        }
      }
    }

    final result = await _streamVideo.setAudioProcessingEnabled(true);

    if (result.isSuccess) {
      await _session?.notifyNoiseCancellationStarted();
      _stateManager.setCallAudioProcessing(isAudioProcessing: true);
    }

    return result;
  }

  /// Stops audio processing for the call.
  Future<Result<None>> stopAudioProcessing() async {
    if (!_streamVideo.isAudioProcessorConfigured()) {
      _logger.w(() => '[stopAudioProcessing] rejected (not configured)');
      return Result.error('Cannot stop audio processing (not configured)');
    }

    final result = await _streamVideo.setAudioProcessingEnabled(false);

    if (result.isSuccess) {
      await _session?.notifyNoiseCancellationStopped();
      _stateManager.setCallAudioProcessing(isAudioProcessing: false);
    }

    return result;
  }

  /// Starts the broadcasting of the call.
  Future<Result<String?>> startHLS() async {
    final result = await _permissionsManager.startBroadcasting();

    if (result.isSuccess) {
      _stateManager.setCallBroadcasting(
        isBroadcasting: true,
        hlsPlaylistUrl: result.getDataOrNull(),
      );
    }
    return result;
  }

  /// Stops the broadcasting of the call.
  Future<Result<None>> stopHLS() async {
    final result = await _permissionsManager.stopBroadcasting();

    if (result.isSuccess) {
      _stateManager.setCallBroadcasting(isBroadcasting: false);
    }

    return result;
  }

  /// Allows for the muting of a or group of users as indicated by [userIds].
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteUsers({
    required List<String> userIds,
    TrackType track = TrackType.audio,
  }) {
    return _permissionsManager.muteUsers(userIds: userIds, track: track);
  }

  /// Allows for the muting of the current user.
  ///
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  Future<Result<None>> muteSelf({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteSelf(track: track);
  }

  /// Allows for the muting of all users except current user calling the function.
  ///
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteOthers({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteOthers(track: track);
  }

  /// Allows for the muting of all users on a call including the current user
  /// calling the function.
  ///
  /// By default the function will mute all the tracks (audio and video) of the users but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteAllUsers({TrackType track = TrackType.all}) {
    return _permissionsManager.muteAllUsers(track: track);
  }

  Future<Result<None>> setCameraPosition(CameraPosition cameraPosition) async {
    final result =
        await _session?.setCameraPosition(cameraPosition) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantUpdateCameraPosition(
        cameraPosition: cameraPosition,
      );
    }

    return result;
  }

  Future<Result<None>> flipCamera() async {
    final result =
        await _session?.flipCamera() ?? Result.error('Session is null');

    await result.fold(
      success: (success) async {
        final mediaDevicesResult = await _rtcMediaDeviceNotifier
            .enumerateDevices();

        final mediaDevices = mediaDevicesResult.fold(
          success: (success) => success.data,
          failure: (failure) => <RtcMediaDevice>[],
        );

        final currentInput = mediaDevices
            .where((d) => d.id == success.data.mediaConstraints.deviceId)
            .firstOrNull;

        _connectOptions = connectOptions.copyWith(
          cameraFacingMode: success.data.mediaConstraints.facingMode,
          videoInputDevice: currentInput,
        );

        _stateManager.participantFlipCamera(
          currentInput,
          track: success.data,
        );
      },
      failure: (failure) {},
    );

    return result.map((_) => none);
  }

  Future<Result<bool>> setMultitaskingCameraAccessEnabled(bool enabled) async {
    return _multitaskingCameraLock.synchronized(() async {
      if (CurrentPlatform.isIos) {
        try {
          final result = await rtc.Helper.enableIOSMultitaskingCameraAccess(
            enabled,
          );
          return Result.success(result);
        } catch (error, stackTrace) {
          _logger.e(() => 'Failed to set multitasking camera access: $error');
          return Result.error(
            'Failed to set multitasking camera access',
            stackTrace,
          );
        }
      }

      return const Result.success(false);
    });
  }

  Future<Result<None>> setZoom({
    required double zoomLevel,
  }) async {
    _logger.d(() => '[setZoom] zoomLevel: $zoomLevel');

    final localTrackIdPrefix = state.value.localParticipant?.trackIdPrefix;

    if (localTrackIdPrefix == null) {
      _logger.w(() => '[setZoom] local participant not found');
      return Result.error('Local participant not found');
    }
    final localTrack = _session?.getTrack(
      localTrackIdPrefix,
      SfuTrackType.video,
    );

    if (localTrack == null) {
      _logger.w(() => '[setZoom] local track not found');
      return Result.error('Local track not found');
    }

    try {
      await rtc.Helper.setZoom(localTrack.mediaTrack, zoomLevel);
      return const Result.success(none);
    } catch (error, stackTrace) {
      _logger.e(() => '[setZoom] Failed to set zoom: $error');
      return Result.error('Failed to set zoom', stackTrace);
    }
  }

  Future<Result<None>> focus({Point<double>? focusPoint}) async {
    _logger.d(() => '[focus] focusPoint: $focusPoint');

    final localTrackIdPrefix = state.value.localParticipant?.trackIdPrefix;

    if (localTrackIdPrefix == null) {
      _logger.w(() => '[focus] local participant not found');
      return Result.error('Local participant not found');
    }

    final localTrack = _session?.getTrack(
      localTrackIdPrefix,
      SfuTrackType.video,
    );
    if (localTrack == null) {
      _logger.w(() => '[focus] local track not found');
      return Result.error('Local track not found');
    }

    try {
      await Helper.setFocusPoint(localTrack.mediaTrack, focusPoint);
      await Helper.setExposurePoint(localTrack.mediaTrack, focusPoint);
    } catch (error, stackTrace) {
      _logger.e(() => '[focus] Failed to set focus: $error');
      return Result.error('Failed to set focus', stackTrace);
    }

    return const Result.success(none);
  }

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) async {
    final result =
        await _session?.setVideoInputDevice(device) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      final track = result.getDataOrNull()!;

      _connectOptions = connectOptions.copyWith(
        videoInputDevice: device,
        cameraFacingMode: track.mediaConstraints.facingMode,
      );

      _stateManager.participantSetVideoInputDevice(
        device: device,
        track: track,
      );
    }

    return result.map((_) => none);
  }

  Future<Result<None>> setCameraEnabled({
    required bool enabled,
    CameraConstraints? constraints,
  }) async {
    if (enabled && !hasPermission(CallPermission.sendVideo)) {
      return Result.error('Missing permission to send video');
    }
    final result =
        await _session?.setCameraEnabled(enabled, constraints: constraints) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _sfuStatsTimers.add(
        Future<void>.delayed(const Duration(seconds: 3)).then((_) {
          if (result.getDataOrNull()!.mediaTrack.enabled) {
            _sfuStatsReporter?.sendSfuStats();
          }
        }).asCancelable(),
      );

      var multitaskingEnabled = state.value.iOSMultitaskingCameraAccessEnabled;
      if (enabled && !multitaskingEnabled) {
        // Set multitasking camera access for iOS
        final multitaskingResult = await setMultitaskingCameraAccessEnabled(
          enabled && !_streamVideo.options.muteVideoWhenInBackground,
        );

        multitaskingEnabled = multitaskingResult.getDataOrNull() ?? false;
      }

      _stateManager.participantSetCameraEnabled(
        enabled: enabled,
        iOSMultitaskingCameraAccessEnabled: multitaskingEnabled,
      );

      var facingMode = constraints?.facingMode;
      if (facingMode == null && result.getDataOrNull() is RtcLocalCameraTrack) {
        final track = result.getDataOrNull()! as RtcLocalCameraTrack;
        facingMode = track.mediaConstraints.facingMode;
      }

      _connectOptions = _connectOptions.copyWith(
        camera: enabled
            ? TrackOption.enabled(constraints: constraints)
            : TrackOption.disabled(),
        cameraFacingMode: facingMode ?? _connectOptions.cameraFacingMode,
      );
    }

    return result.map((_) => none);
  }

  /// Changes the camera capture target resolution during an active call.
  Future<Result<None>> setCameraTargetResolution(
    StreamTargetResolution targetResolution,
  ) async {
    connectOptions = _connectOptions.copyWith(
      targetResolution: targetResolution,
    );

    if (_session?.rtcManager == null) {
      return const Result.success(none);
    }

    final params = targetResolution.toVideoParams();
    final result = await _session!.rtcManager!.setCameraVideoParameters(
      params: params,
    );

    if (result.isSuccess) {
      return const Result.success(none);
    } else {
      return result.map((_) => none);
    }
  }

  Future<Result<None>> setMicrophoneEnabled({
    required bool enabled,
    AudioConstraints? constraints,
  }) async {
    if (enabled && !hasPermission(CallPermission.sendAudio)) {
      return Result.error('Missing permission to send audio');
    }

    if (enabled && CurrentPlatform.isAndroid) {
      try {
        if (_streamVideo.options.androidAudioConfiguration != null) {
          await rtc.Helper.setAndroidAudioConfiguration(
            _streamVideo.options.androidAudioConfiguration!,
          );
        }
      } catch (e) {
        _logger.w(
          () =>
              '[setMicrophoneEnabled] Failed to set Android audio configuration: $e',
        );
      }
    }

    final result =
        await _session?.setMicrophoneEnabled(
          enabled,
          constraints: constraints,
        ) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      // Make sure the audio input device is set
      if (enabled && _connectOptions.audioInputDevice != null) {
        await setAudioInputDevice(_connectOptions.audioInputDevice!);
      }

      _sfuStatsTimers.add(
        Future<void>.delayed(const Duration(seconds: 3)).then((_) {
          if (result.getDataOrNull()!.mediaTrack.enabled) {
            _sfuStatsReporter?.sendSfuStats();
          }
        }).asCancelable(),
      );

      await _streamVideo.pushNotificationManager?.setCallMutedByCid(
        callCid.value,
        !enabled,
      );

      _stateManager.participantSetMicrophoneEnabled(
        enabled: enabled,
      );

      _connectOptions = _connectOptions.copyWith(
        microphone: enabled
            ? TrackOption.enabled(constraints: constraints)
            : TrackOption.disabled(),
      );
    }

    return result.map((_) => none);
  }

  Future<bool> requestScreenSharePermission() {
    return Helper.requestCapturePermission();
  }

  Future<Result<None>> setScreenShareEnabled({
    required bool enabled,
    ScreenShareConstraints? constraints,
  }) async {
    // Checks to ensure the user can share their screen.
    final canShare = hasPermission(CallPermission.screenshare);
    if (enabled && !canShare) {
      return Result.error('Missing permission to share screen for the user');
    }

    final updatedConstraints = (constraints ?? const ScreenShareConstraints())
        .copyWith(
          params:
              constraints?.params ??
              _connectOptions.screenShareTargetResolution?.toVideoParams(
                defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
              ),
        );

    final result =
        await _session?.setScreenShareEnabled(
          enabled,
          constraints: updatedConstraints,
        ) ??
        Result.error('Call session is null, cannot start screen share');

    // In case of iOS Broadcast Extension, we don't update the state here
    // We listen to the ScreenShareStarted event instead
    if (CurrentPlatform.isIos &&
        constraints is ScreenShareConstraints &&
        constraints.useiOSBroadcastExtension) {
      return result.map((_) => none);
    }

    if (result.isSuccess) {
      _stateManager.participantSetScreenShareEnabled(
        enabled: enabled,
      );

      _connectOptions = _connectOptions.copyWith(
        screenShare: enabled
            ? TrackOption.enabled(constraints: updatedConstraints)
            : TrackOption.disabled(),
      );

      if (enabled) {
        // [web only] Automatically stop screen share when the track ends
        result.getDataOrNull()?.mediaTrack.onEnded = () {
          setScreenShareEnabled(enabled: false);
        };
      }
    }

    return result.map((_) => none);
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) async {
    final result =
        await _session?.setAudioInputDevice(device) ??
        Result.error('Session is null');

    _connectOptions = _connectOptions.copyWith(audioInputDevice: device);

    if (result.isSuccess) {
      _stateManager.participantSetAudioInputDevice(device: device);
      return const Result.success(none);
    } else {
      if (result.getErrorOrNull() case VideoErrorWithCause(
        cause: TrackMissingException(),
      )) {
        // If the track is null, it most probably means that the user
        // joined the call muted and the audio track was not created.
        // We will set the audio input device when the user unmutes.
        return const Result.success(none);
      } else {
        return result;
      }
    }
  }

  /// Sets the audio output device for the call.
  /// - [device]: The audio output device to set.
  /// Returns a [Result] indicating the success or failure of the operation.
  ///
  /// On web platforms, this method may return an error if the browser does not support
  /// setting audio output devices programmatically.
  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) async {
    final result =
        await _session?.setAudioOutputDevice(device) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _connectOptions = connectOptions.copyWith(audioOutputDevice: device);

      _stateManager.participantSetAudioOutputDevice(
        device: device,
      );
    }

    return result;
  }

  bool checkIfAudioOutputChangeSupported() {
    return rtc_audio.checkIfAudioOutputChangeSupported();
  }

  /// Sets the mirror state for a remote participant's video track.
  ///
  /// - [sessionId]: The session ID of the participant.
  /// - [userId]: The user ID of the participant.
  /// - [mirrorVideo]: Whether to mirror the participant's video.
  Result<None> setMirrorVideo({
    required String sessionId,
    required String userId,
    required bool mirrorVideo,
  }) {
    _stateManager.participantMirrorVideo(
      sessionId: sessionId,
      userId: userId,
      mirrorVideo: mirrorVideo,
    );

    return const Result.success(none);
  }

  /// Pins/unpins the given session to the top of the participants list.
  /// The change is done locally and won't affect other participants.
  void setParticipantPinnedLocally({
    required String sessionId,
    required String userId,
    required bool pinned,
  }) {
    _stateManager.setParticipantPinned(
      sessionId: sessionId,
      userId: userId,
      pinned: pinned,
    );
  }

  /// Pins/unpins the given session to the top of the participants list for everyone in the call.
  /// This method requires current user to have the `pin-for-everyone` capability.
  Future<Result<None>> setParticipantPinnedForEveryone({
    required String sessionId,
    required String userId,
    required bool pinned,
  }) async {
    return pinned
        ? _permissionsManager.pinForEveryone(
            userId: userId,
            sessionId: sessionId,
          )
        : _permissionsManager.unpinForEveryone(
            userId: userId,
            sessionId: sessionId,
          );
  }

  /// Starts the livestreaming of the call.
  Future<Result<CallMetadata>> goLive({
    bool? startHls,
    bool? startRecording,
    bool? startTranscription,
    bool? startClosedCaption,
    String? transcriptionStorageName,
  }) async {
    final result = await _coordinatorClient.goLive(
      callCid: callCid,
      startHls: startHls,
      startRecording: startRecording,
      startTranscription: startTranscription,
      startClosedCaption: startClosedCaption,
      transcriptionStorageName: transcriptionStorageName,
    );

    if (result.isSuccess) {
      _stateManager.setCallLive(isLive: true);
    }

    return result;
  }

  /// Stops the livestreaming of the call.
  Future<Result<CallMetadata>> stopLive() async {
    final result = await _coordinatorClient.stopLive(callCid);

    if (result.isSuccess) {
      _stateManager.setCallLive(isLive: false);
    }

    return result;
  }

  Future<Result<None>> updateViewportVisibility({
    required String sessionId,
    required String userId,
    required ViewportVisibility visibility,
    required SfuTrackTypeVideo trackType,
  }) async {
    final change = VisibilityChange(
      sessionId: sessionId,
      userId: userId,
      visibility: visibility,
    );
    if (trackType.isScreenShare) {
      _stateManager.participantUpdateScreenShareViewportVisibility(
        sessionId: sessionId,
        userId: userId,
        visibility: visibility,
      );
      return const Result.success(none);
    }

    final result =
        await _session?.updateViewportVisibility(change) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantUpdateViewportVisibility(
        sessionId: sessionId,
        userId: userId,
        visibility: visibility,
      );
    }

    return result;
  }

  Future<Result<None>> setSubscriptions(
    List<SubscriptionChange> changes,
  ) async {
    final result = await dynascaleManager.setSubscriptions(changes);
    return result;
  }

  Future<Result<None>> setSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required Map<SfuTrackTypeVideo, RtcVideoDimension> trackTypes,
  }) async {
    final change = SubscriptionChange.set(
      userId: userId,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      trackTypes: trackTypes,
    );

    final result = await dynascaleManager.setSubscriptions([
      change,
    ]);

    return result;
  }

  Future<Result<None>> updateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) async {
    if (state.value.status.isDisconnected) {
      _logger.d(() => '[updateSubscription] rejected (disconnected)');
      return const Result.success(none);
    }

    final result = await dynascaleManager.updateSubscription(
      SubscriptionChange.update(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        videoDimension: videoDimension,
      ),
    );

    if (result.isSuccess) {
      _stateManager.participantUpdateSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        videoDimension: videoDimension,
      );
    }

    return result;
  }

  Future<Result<None>> removeSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) async {
    if (state.value.status.isDisconnected) {
      _logger.d(() => '[removeSubscription] rejected (disconnected)');
      return const Result.success(none);
    }

    final result = await dynascaleManager.updateSubscription(
      SubscriptionChange.update(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      ),
    );

    if (result.isSuccess) {
      _stateManager.participantRemoveSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      );
    }

    return result;
  }

  /// Specifies the preference for incoming video resolution. The preference will
  /// be matched as closely as possible, but the actual resolution will depend
  /// on the video source quality and client network conditions. This will enable
  /// incoming video if it was previously disabled.
  ///
  /// [resolution] is the preferred resolution, or `null` to clear the preference.
  /// [sessionIds] optionally specifies the session IDs of the participants this
  /// preference affects. By default, it affects all participants.
  Future<Result<None>> setPreferredIncomingVideoResolution(
    VideoDimension? resolution, {
    List<String>? sessionIds,
  }) async {
    dynascaleManager.setVideoTrackSubscriptionOverrides(
      override: resolution != null
          ? VideoTrackSubscriptionOverride(
              dimension: RtcVideoDimension(
                width: resolution.width,
                height: resolution.height,
              ),
            )
          : null,
      sessionIds: sessionIds,
    );

    return dynascaleManager.applyTrackSubscriptions();
  }

  /// Enables or disables incoming video from all remote call participants,
  /// and removes any preference for preferred resolution.
  Future<Result<None>> setIncomingVideoEnabled(bool enabled) async {
    dynascaleManager.setVideoTrackSubscriptionOverrides(
      override: VideoTrackSubscriptionOverride(enabled: enabled),
    );

    return dynascaleManager.applyTrackSubscriptions();
  }

  Future<Result<QueriedMembers>> queryMembers({
    Map<String, Object> filterConditions = const {},
    String? next,
    String? prev,
    List<SortParamRequest> sorts = const [],
    int? limit,
  }) {
    return _permissionsManager.queryMembers(
      filterConditions: filterConditions,
      next: next,
      prev: prev,
      sorts: sorts,
      limit: limit,
    );
  }

  Future<Result<CallReaction>> sendReaction({
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) {
    return _permissionsManager.sendReaction(
      reactionType: reactionType,
      emojiCode: emojiCode,
      custom: custom,
    );
  }

  void resetReaction({
    required String userId,
  }) {
    return _stateManager.resetCallReaction(userId);
  }

  List<CallReaction> getCurrentReactions() {
    return _stateManager.callState.callParticipants.fold([], (
      previousValue,
      e,
    ) {
      if (e.reaction != null) {
        return [...previousValue, e.reaction!];
      } else {
        return previousValue;
      }
    });
  }

  Future<Result<None>> sendCustomEvent({
    required String eventType,
    Map<String, Object> custom = const {},
  }) {
    return _coordinatorClient.sendCustomEvent(
      callCid: callCid,
      eventType: eventType,
      custom: custom,
    );
  }

  /// Collects user feedback asynchronously.
  ///
  /// Parameters:
  /// - `[rating]`: Rating between 1 and 5 denoting the experience of the user in the call
  /// - `[reason]`: The reason/description for the rating
  /// - `[custom]`: Custom data
  Future<Result<None>> collectUserFeedback({
    required int rating,
    String? reason,
    Map<String, Object>? custom,
  }) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    if (_session?.sessionId == null) {
      throw ArgumentError(
        'Feedback can be submitted only in the context of a call session',
      );
    }

    return _coordinatorClient.collectUserFeedback(
      callId: id,
      callType: type.value,
      sessionId: _session!.sessionId,
      rating: rating,
      reason: reason,
      custom: custom,
      sdk: streamSdkName,
      sdkVersion: streamVideoVersion,
      userSessionId: _session!.sessionId,
    );
  }
}

CallStateNotifier _makeStateManager(
  StreamCallCid callCid,
  CoordinatorClient coordinatorClient,
  StateEmitter<User?> currentUser,
  CallPreferences callPreferences,
) {
  final currentUserId = currentUser.valueOrNull?.id ?? '';

  return CallStateNotifier(
    CallState(
      preferences: callPreferences,
      currentUserId: currentUserId,
      callCid: callCid,
    ),
  );
}

PermissionsManager _makePermissionAwareManager(
  StreamCallCid callCid,
  CoordinatorClient coordinatorClient,
  CallStateNotifier stateManager,
) {
  return PermissionsManager(
    callCid: callCid,
    coordinatorClient: coordinatorClient,
    stateManager: stateManager,
  );
}

enum TrackType {
  audio,
  video,
  screenshare,
  all;

  @override
  String toString() {
    return name;
  }

  SfuTrackType toSFUTrackType() {
    switch (this) {
      case TrackType.audio:
        return SfuTrackType.audio;
      case TrackType.video:
        return SfuTrackType.video;
      case TrackType.screenshare:
        return SfuTrackType.screenShare;
      //ignore:no_default_cases
      default:
        throw Exception('Unknown mute type: $this');
    }
  }
}

extension FutureStartWithEx<T> on Stream<T> {
  Stream<T> startWithFuture(Future<T> futureValue) async* {
    yield await futureValue;
    yield* this;
  }
}

// ignore: avoid_classes_with_only_static_members
/// Call factory to create a [Call] instance.
/// Only meant for testing purposes.
@visibleForTesting
class BaseCallFactory {
  static Call makeCall({
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    required CallStateNotifier stateManager,
    required PermissionsManager permissionManager,
    required InternetConnection networkMonitor,
    required RetryPolicy retryPolicy,
    required SdpPolicy sdpPolicy,
    required RtcMediaDeviceNotifier rtcMediaDeviceNotifier,
    required CallCredentials? credentials,
    required CallSessionFactory? sessionFactory,
  }) => Call._(
    coordinatorClient: coordinatorClient,
    streamVideo: streamVideo,
    stateManager: stateManager,
    permissionManager: permissionManager,
    networkMonitor: networkMonitor,
    retryPolicy: retryPolicy,
    sdpPolicy: sdpPolicy,
    rtcMediaDeviceNotifier: rtcMediaDeviceNotifier,
    credentials: credentials,
    sessionFactory: sessionFactory,
  );
}

class SessionConnectionFailure {
  SessionConnectionFailure({
    required this.error,
  });

  final VideoError error;
}
