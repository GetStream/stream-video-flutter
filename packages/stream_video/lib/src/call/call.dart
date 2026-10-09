// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:math';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_core/stream_core.dart';
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
import '../errors/stream_video_exception.dart';
import '../errors/stream_video_exception_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../logger/stream_log.dart';
import '../models/models.dart';
import '../retry/retry_policy.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_audio_bitrate.dart';
import '../sfu/data/models/sfu_client_capability.dart';
import '../sfu/data/models/sfu_error.dart';
import '../sfu/data/models/sfu_goaway_reason.dart';
import '../sfu/data/models/sfu_participant.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../stream_video.dart';
import '../telemetry/client_event_types.dart';
import '../utils/adaptive_throttle.dart';
import '../utils/cancelable_operation.dart';
import '../utils/cancelables.dart';
import '../utils/future.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../utils/subscriptions.dart';
import '../webrtc/e2ee/call_e2ee.dart';
import '../webrtc/e2ee/e2ee_claims.dart';
import '../webrtc/media/media_constraints.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import '../webrtc/peer_connection.dart';
import '../webrtc/peer_connection_factory.dart';
import '../webrtc/peer_type.dart';
import '../webrtc/rtc_audio_api/rtc_audio_api.dart' as rtc_audio;
import '../webrtc/rtc_manager.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';
import '../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../webrtc/rtc_track/rtc_track.dart';
import '../webrtc/sdp/editor/sdp_editor_impl.dart';
import '../webrtc/sdp/policy/sdp_policy.dart';
import 'call_connect_options.dart';
import 'call_events.dart';
import 'call_reject_reason.dart';
import 'call_ringing_state.dart';
import 'call_type.dart';
import 'connection/connection_executor.dart';
import 'connection/connection_phase.dart';
import 'connection/join_outcome.dart';
import 'connection/reconnect_trigger.dart';
import 'events/call_closed_captions.dart';
import 'events/call_coordinator_event_router.dart';
import 'events/call_reactions.dart';
import 'events/call_video_moderation.dart';
import 'media/local_media_controller.dart';
import 'permissions/permissions_manager.dart';
import 'ring_state_poller.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';
import 'session/dynascale_manager.dart';
import 'state/call_state_notifier.dart';
import 'state/call_state_selection.dart';
import 'stats/sfu_stats_reporter.dart';
import 'stats/stats_reporter.dart';
import 'stats/trace_tag.dart';
import 'viewport_visibility_registry.dart';

part 'call_actions.dart';
part 'call_debug.dart';
part 'connection/call_connection_coordinator.dart';

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
typedef VideoDimension = RtcVideoDimension;

const _idState = 1;
const _idUserId = 2;
const _idCoordEvents = 3;
const _idSessionEvents = 4;
const _idSessionStats = 5;
const _idConnect = 6;
const _idReconnect = 9;
const _idNativeWebRtc = 10;
const _idAudioPlayback = 11;

const _tag = 'SV:Call';
int _callSeq = 1;

/// Represents a [Call] in which you can connect to.
///
/// A call is joined once. Call [dispose] when it is no longer used, whether it
/// was joined or not.
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
             retryPolicy: retryPolicy,
             sdpEditor: sdpPolicy.spdEditingEnabled
                 ? SdpEditorImpl(sdpPolicy)
                 : NoOpSdpEditor(),
           ),
       _stateManager = stateManager,
       _permissionsManager = permissionManager,
       _coordinatorClient = coordinatorClient,
       _streamVideo = streamVideo,
       _retryPolicy = retryPolicy,
       _rtcMediaDeviceNotifier = rtcMediaDeviceNotifier,
       dynascaleManager = DynascaleManager(stateManager: stateManager) {
    _connection._credentials = credentials;
    streamLog.i(_tag, () => '<init> state: ${stateManager.callState}');

    if (stateManager.callState.isRingingFlow) {
      _init();
    }
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();
  late final _callInitLock = Lock();

  final CoordinatorClient _coordinatorClient;
  final StreamVideo _streamVideo;
  final RetryPolicy _retryPolicy;
  final CallSessionFactory _sessionFactory;
  final CallStateNotifier _stateManager;
  final PermissionsManager _permissionsManager;
  final DynascaleManager dynascaleManager;

  /// What each viewport drawing a participant measures for it, and the one
  /// answer per track the call acts on.
  late final viewportVisibility = ViewportVisibilityRegistry(
    onAggregate: _applyViewportAggregate,
  );
  final InternetConnection networkMonitor;
  final RtcMediaDeviceNotifier _rtcMediaDeviceNotifier;

  /// Joins, reconnects and leaves this call, and owns its SFU session.
  late final _connection = CallConnectionCoordinator(this);

  /// Owns the connect options and the local camera, microphone and screen
  /// share.
  late final _media = LocalMediaController(
    stateManager: _stateManager,
    session: () => _session,
    sfuStatsReporter: () => _sfuStatsReporter,
    hasPermission: hasPermission,
    rtcMediaDeviceNotifier: _rtcMediaDeviceNotifier,
    audioConfigurationPolicy: () =>
        _stateManager.callState.preferences.audioConfigurationPolicy ??
        _streamVideo.options.audioConfigurationPolicy,
    muteVideoWhenInBackground: () =>
        _streamVideo.options.muteVideoWhenInBackground,
    onMicrophoneMuted: (muted) async => _streamVideo.pushNotificationManager
        ?.setCallMutedByCid(callCid.value, muted),
    logger: _logger,
  );

  /// Attaches, resolves and releases this call's [EncryptionManager].
  late final _e2ee = CallE2ee(
    callCid: callCid,
    state: () => state.value,
    session: () => _session,
    logger: _logger,
  );

  /// Drops every recorded claim. Tests share one cid across cases, and the
  /// registry outlives them.
  @visibleForTesting
  static void resetE2EEClaims() => E2eeClaims.instance.reset();

  CallSession? get callSession => _session;

  // Connection state owned by [_connection].
  CallSession? get _session => _connection._session;
  SfuStatsReporter? get _sfuStatsReporter => _connection._sfuStatsReporter;
  Set<SfuClientCapability> get _sfuClientCapabilities =>
      _connection._sfuClientCapabilities;
  StreamPeerConnectionFactory? get _pcFactory => _connection._pcFactory;
  set _pcFactory(StreamPeerConnectionFactory? value) =>
      _connection._pcFactory = value;

  /// Audio track states captured at suspension time.
  final _suspendedTrackStates = <String, SuspendedTrackState>{};

  StreamPeerConnectionFactory _ensurePcFactory() {
    return _pcFactory ??= StreamPeerConnectionFactory(
      callCid: callCid,
      audioConfigurationPolicy:
          _stateManager.callState.preferences.audioConfigurationPolicy ??
          _streamVideo.options.audioConfigurationPolicy,
    );
  }

  Future<rtc.NativePeerConnectionFactory?> ensureNativeFactory() {
    return _ensurePcFactory().ensureNativeFactory();
  }

  Future<void> suspendAudio() async {
    final factory = _pcFactory;
    if (factory == null) {
      _logger.w(() => '[suspendAudio] no factory yet');
      return;
    }

    if (_stateManager.callState.isAudioSuspended) {
      _logger.d(() => '[suspendAudio] already suspended');
      return;
    }

    _suspendedTrackStates.clear();
    _stateManager.state = _stateManager.callState.copyWith(
      isAudioSuspended: true,
    );

    try {
      await factory.suspendAudio();
    } catch (e, stk) {
      _logger.e(() => '[suspendAudio] native suspend failed: $e\n$stk');
      _suspendedTrackStates.clear();
      _stateManager.state = _stateManager.callState.copyWith(
        isAudioSuspended: false,
      );
      return;
    }

    final tracks = _session?.rtcManager?.tracks;
    if (tracks != null) {
      for (final entry in tracks.entries) {
        final track = entry.value;
        if (track.isAudioTrack) {
          final wasEnabled = track.mediaTrack.enabled;
          _suspendedTrackStates[entry.key] = wasEnabled
              ? SuspendedTrackState.wasEnabled
              : SuspendedTrackState.wasDisabled;

          track.disable();

          _logger.d(
            () =>
                '[suspendAudio] disabled track ${entry.key} '
                '(was enabled: $wasEnabled)',
          );
        }
      }
    }
  }

  Future<void> resumeAudio() async {
    final factory = _pcFactory;
    if (factory == null) {
      _logger.w(() => '[resumeAudio] no factory yet');
      return;
    }
    await factory.resumeAudio();

    await _session?.resumeSuspendedAudioTracks(_suspendedTrackStates);
    _suspendedTrackStates.clear();

    // Resuming restarts recording, which clears the native ADM's microphone
    // mute, and re-enables tracks from a snapshot taken before the suspension.
    // Reconcile once the tracks have settled.
    await _session?.rtcManager?.reconcileAppleAdmMicrophoneMute();

    _stateManager.state = _stateManager.callState.copyWith(
      isAudioSuspended: false,
    );
  }

  bool _initialized = false;
  RingStatePoller? _ringStatePoller;
  StreamSubscription<CallState>? _ringStatePollerStatusSubscription;

  String get id => state.value.callId;
  StreamCallCid get callCid => state.value.callCid;
  StreamCallType get type => state.value.callType;
  bool get isActiveCall => _streamVideo.state.activeCalls.value.any(
    (call) => call.callCid == callCid,
  );

  StateEmitter<CallState> get state => _stateManager.callStateStream;
  Stream<Duration> get callDurationStream => _stateManager.durationStream;
  StatsReporter? get statsReporter => _session?.statsReporter;

  /// Emits the value [selector] returns from the call state: the current value
  /// when listened to, then each value that differs from the one before, as
  /// compared by [isSameCallStateSelection].
  ///
  /// Each listener runs its own [selector] until it cancels.
  Stream<T> partialState<T>(CallStateSelector<T> selector) {
    return _stateManager.partialCallStateStream(selector);
  }

  /// The participants in this call, rate-limited by
  /// [CallPreferences.participantsThrottleIntervalResolver], which by default
  /// returns a longer interval the more participants there are.
  ///
  /// Prefer this over `partialState((state) => state.callParticipants)` for
  /// anything that renders the list: in a large call the raw state emits far
  /// faster than a screen can usefully repaint. [CallState.callParticipants]
  /// stays immediate, so a lookup that has to see a participant the moment
  /// they join keeps working.
  ///
  /// One window is shared by every listener, so two widgets rendering the same
  /// call always show the same list. A new listener starts from the current
  /// [CallState.callParticipants] rather than from the last window, so it never
  /// begins on a list older than the state it was built against.
  ///
  /// The interval comes from
  /// [CallPreferences.participantsThrottleIntervalResolver], read the first
  /// time this is used; set it to null to emit every change.
  late final Stream<List<CallParticipantState>> participantsStream =
      _buildParticipantsStream();

  /// Each listener is given the live participant list first, then the shared
  /// throttled ones.
  ///
  /// The subject replays the list the last window closed on, which can be older
  /// than the state a listener is starting from — forwarding it would walk the
  /// list backwards for up to one interval. That replay is dropped, and so is
  /// any later value the listener has already been given.
  Stream<List<CallParticipantState>> _buildParticipantsStream() {
    return Stream<List<CallParticipantState>>.multi(
      (controller) {
        var latest = _stateManager.callState.callParticipants;
        controller.add(latest);

        // The subject opens with whatever it currently holds, which is a value
        // or — since it caches the latest error too — an error.
        var replayed = false;
        final subscription = _participantsSubject.stream.listen(
          (value) {
            if (!replayed) {
              replayed = true;
              return;
            }
            if (identical(value, latest)) return;
            latest = value;
            controller.add(value);
          },
          onError: (Object error, StackTrace stackTrace) {
            replayed = true;
            controller.addError(error, stackTrace);
          },
          onDone: controller.close,
        );

        controller.onCancel = subscription.cancel;
      },
      isBroadcast: true,
    );
  }

  /// Built the first time it is read. [dispose] closes it.
  BehaviorSubject<List<CallParticipantState>> get _participantsSubject =>
      _participantsSubjectOrNull ??= _buildParticipantsSubject();
  BehaviorSubject<List<CallParticipantState>>? _participantsSubjectOrNull;

  BehaviorSubject<List<CallParticipantState>> _buildParticipantsSubject() {
    final subject = BehaviorSubject<List<CallParticipantState>>.seeded(
      _stateManager.callState.callParticipants,
    );

    final participants = partialState((state) => state.callParticipants);
    final interval = _stateManager
        .callState
        .preferences
        .participantsThrottleIntervalResolver;

    // Ends when [dispose] closes the state it reads from.
    // ignore: cancel_subscriptions
    (interval == null
            ? participants
            : participants.throttleByCollectionSize(interval: interval))
        .listen(
          (value) {
            // The seed and the state's own replay are the same list, so the
            // first window would otherwise repeat it.
            if (subject.isClosed || identical(subject.valueOrNull, value)) {
              return;
            }
            subject.add(value);
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!subject.isClosed) subject.addError(error, stackTrace);
          },
          onDone: subject.close,
        );

    return subject;
  }

  SharedEmitter<
    ({
      PeerConnectionStatsBundle publisherStatsBundle,
      PeerConnectionStatsBundle subscriberStatsBundle,
    })
  >
  get stats => _stats;
  late final _stats =
      MutableSharedEmitter<
        ({
          PeerConnectionStatsBundle publisherStatsBundle,
          PeerConnectionStatsBundle subscriberStatsBundle,
        })
      >();

  SharedEmitter<StreamCallEvent> get callEvents => _callEvents;
  final _callEvents = MutableSharedEmitter<StreamCallEvent>();

  /// The closed captions currently on screen, oldest first. Each emitted
  /// list is unmodifiable.
  Stream<List<StreamClosedCaption>> get closedCaptions =>
      _closedCaptions.closedCaptions;

  /// Holds the closed captions, and removes them once they expire.
  late final _closedCaptions = CallClosedCaptions(
    stateManager: _stateManager,
    logger: _logger,
  );

  /// Sets reactions on participants, and clears them after a while.
  late final _reactions = CallReactions(stateManager: _stateManager);

  /// Applies and clears video moderation.
  late final _moderation = CallVideoModeration(
    stateManager: _stateManager,
    currentUserId: () => _streamVideo.currentUser.id,
    setMicrophoneEnabled: setMicrophoneEnabled,
    setCameraEnabled: setCameraEnabled,
    logger: _logger,
  );

  /// Applies coordinator events for this call to its state.
  late final _eventRouter = CallCoordinatorEventRouter(
    stateManager: _stateManager,
    reactions: _reactions,
    closedCaptions: _closedCaptions,
    moderation: _moderation,
    onPermissionRequest: (event) => onPermissionRequest?.call(event),
    onAccepted: _handleCoordinatorCallAccepted,
    onRejected: _handleCoordinatorCallRejected,
    onRingActivity: () => _ringStatePoller?.restartQuietPeriod(),
  );

  OnCallPermissionRequest? onPermissionRequest;

  @override
  String toString() {
    return 'Call{cid: $callCid}';
  }

  CallConnectOptions get connectOptions => _media.connectOptions;

  /// Changes the options the pending join applies, for example while an
  /// outgoing call rings. Prefer passing them to [join].
  ///
  /// Fails once the join has applied its options, also while the call is
  /// connected or reconnecting. Change the devices through
  /// [setCameraEnabled], [setMicrophoneEnabled] and the other device methods
  /// from then on.
  @useResult
  Result<None> setConnectOptions(CallConnectOptions connectOptions) =>
      _media.setConnectOptions(connectOptions);

  @Deprecated(
    'Use setConnectOptions instead, which reports whether the options were '
    'applied. This setter will be removed in the next major release.',
  )
  set connectOptions(CallConnectOptions connectOptions) =>
      _media.setConnectOptions(connectOptions);

  /// The user this call is being watched or joined by.
  UserInfo get currentUser => _streamVideo.currentUser;

  Future<void> _init() {
    return _callInitLock.synchronized(() async {
      _logger.v(() => '[_init] no args');

      if (_initialized || _isDisposed) return;
      _logger.d(() => '[_init] initializing');

      _observeEvents();
      _connection._observeState();
      _connection._observeReconnectEvents();
      _observeUserId();
      _observeNativeWebRtcEventStream();
      _observeWebAudioPlaybackBlocked();

      _logger.v(() => '[_init] initialized');
      _initialized = true;
    });
  }

  void _observeNativeWebRtcEventStream() {
    _subscriptions.add(
      _idNativeWebRtc,
      _media.observeNativeWebRtcEvents(),
    );
  }

  /// Mirrors the browser's autoplay-policy blocking, reported by the web audio
  /// layer, into [CallState] — so the app can show a "tap to enable sound"
  /// affordance and call
  /// `RtcMediaDeviceNotifier.instance.resumeWebAudioPlayback()` from the
  /// gesture.
  void _observeWebAudioPlaybackBlocked() {
    _subscriptions.add(
      _idAudioPlayback,
      _rtcMediaDeviceNotifier.webAudioPlaybackBlockedChanges.listen((blocked) {
        _stateManager.rtcSetWebAudioPlaybackBlocked(isBlocked: blocked);
      }),
    );
  }

  void _observeEvents() {
    _subscriptions.cancel(_idCoordEvents);
    _subscriptions.add(
      _idCoordEvents,
      _coordinatorClient.events.on<CoordinatorCallEvent>((event) {
        event
            .mapToCallEvent(state.value)
            .emitIfNotNull(_callEvents)
            ?.also(
              (event) => unawaited(
                _onCoordinatorEvent(event).catchError(
                  (Object error, StackTrace stackTrace) {
                    _logger.e(
                      () =>
                          '[onCoordinatorEvent] failed to handle ${event.runtimeType}: '
                          '$error, stackTrace: $stackTrace',
                    );
                  },
                ),
              ),
            );
      }),
    );
  }

  void _observeUserId() {
    _subscriptions.add(
      _idUserId,
      _streamVideo.state.user.map((u) => u.id).distinct().listen((
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

  Future<void> _onCoordinatorEvent(StreamCallEvent event) async {
    // Return if the event is not for this call.
    if (event.callCid != state.value.callCid) return;

    _logger.v(
      () =>
          '[onCoordinatorEvent] event.type: ${event.runtimeType}, calStatus: ${state.value.status}',
    );

    await _eventRouter.route(event);
  }

  Future<void> _handleCoordinatorCallAccepted(
    StreamCallAcceptedEvent event,
  ) async {
    final currentUserId = _stateManager.callState.currentUserId;
    final status = state.value.status;

    if (event.acceptedByUserId == currentUserId &&
        status is CallStatusIncoming &&
        !status.acceptedByMe) {
      _logger.i(
        () =>
            '[onCoordinatorEvent] call accepted on another device, '
            'rejecting locally with userRespondedElsewhere',
      );
      await reject(reason: CallRejectReason.userRespondedElsewhere());
      return;
    }

    _stateManager.coordinatorCallAccepted(event);
  }

  Future<void> _handleCoordinatorCallRejected(
    StreamCallRejectedEvent event,
  ) async {
    final currentUserId = _stateManager.callState.currentUserId;
    final status = state.value.status;

    if (event.rejectedByUserId == currentUserId &&
        status is CallStatusIncoming &&
        !status.acceptedByMe) {
      _logger.i(
        () =>
            '[onCoordinatorEvent] call rejected on another device, '
            'rejecting locally with userRespondedElsewhere',
      );
      await reject(reason: CallRejectReason.userRespondedElsewhere());
      return;
    }

    _stateManager.coordinatorCallRejected(event);
  }

  /// Clears the moderation action, restoring normal operation.
  ///
  /// When [VideoModerationConfig.muteAudio] / [VideoModerationConfig.muteVideo]
  /// were active, re-enabling mic/camera is allowed again but they stay off
  /// until the user manually re-enables them.
  void clearModerationBlur() => _moderation.clear();

  /// Registers handlers for the native blur effect pipeline.
  ///
  /// Called automatically by `StreamVideoEffectsManager` from
  /// `stream_video_filters` when [VideoModerationConfig.applyBlur] is true.
  @internal
  void setModerationBlurEffectHandlers({
    required void Function() onApply,
    required void Function() onClear,
  }) => _moderation.setBlurEffectHandlers(onApply: onApply, onClear: onClear);

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
      return failureWithError('invalid status: $status');
    }

    final outgoingCall = _streamVideo.state.outgoingCall.value;
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

    _session?.trace(TraceTag.callAccept, null);

    // Optimistically mark the call as accepted
    _stateManager.lifecycleCallAccepted();
    _streamVideo.markCallAcceptedOnThisDevice(callCid, this);

    final result = await _coordinatorClient.acceptCall(cid: state.callCid);
    if (result is Failure) {
      // Revert the optimistic acceptance so the user can retry or reject.
      _stateManager.lifecycleCallAccepted(accepted: false);
      _streamVideo.clearCallAcceptedOnThisDevice(callCid, this);
    }

    return result;
  }

  /// Rejects the incoming call.
  Future<Result<None>> reject({CallRejectReason? reason}) async {
    final state = this.state.value;
    _logger.i(() => '[reject] reason: $reason');

    _session?.trace(TraceTag.callReject, reason?.value);
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
  Future<Result<None>> end({String? reason}) {
    return _connection.end(reason: reason);
  }

  /// The end-to-end encryption manager attached via [setE2EEManager].
  /// `null` when the call is unencrypted.
  EncryptionManager? get e2eeManager => _e2ee.manager;

  /// Turns on end-to-end encryption for this call.
  /// Must run **before** [join]. The call's encryption mode must allow it.
  ///
  /// [EncryptionManager] takes raw key bytes — 16 for AES-128, 32 for
  /// AES-256 — and has no opinion on how participants agreed on them. Deriving
  /// them from a passphrase, or distributing them over your own channel, is up
  /// to the app.
  ///
  /// ```dart
  /// final e2ee = EncryptionManager.create(userId: client.currentUser.id);
  /// await e2ee.setSharedKey(0, sharedKeyBytes);
  ///
  /// await call.setE2EEManager(e2ee);
  /// await call.join(create: true);
  /// ```
  ///
  /// The manager is released and disposed when the call is left, so a fresh
  /// one is needed per call.
  Future<void> setE2EEManager(EncryptionManager manager) =>
      _e2ee.attach(manager);

  /// Detaches the E2EE manager and releases it, so later joins are unencrypted
  /// again.
  ///
  /// [leave] does this for you. Call it directly only to undo a
  /// [setE2EEManager] on a call you are not going to join after all, such as
  /// backing out of a lobby screen.
  ///
  /// The manager is always disposed: its keys live in a native store, and a
  /// manager is not reusable across calls, so there is nothing to keep it alive
  /// for. Give the next call its own manager. To skip deriving a key twice,
  /// hold on to the derived bytes rather than to the manager, and import them
  /// again with `setSharedKey`.
  ///
  /// Does nothing when no manager is attached.
  Future<void> clearE2EEManager() => _e2ee.clear();

  /// Joins the call.
  ///
  /// - [connectOptions]: optional initial call configuration
  /// - [membersLimit]: Sets the maximum number of members to return as part of the response.
  /// - [hintHighScaleLivestreamPublisher]: Whether the local user is a high-scale livestream publisher.
  ///
  /// Calling [join] again while a join on this call is still in flight
  /// returns the same result as that join instead of starting another one.
  ///
  /// A call is joined once. After it is left or ended, including after a
  /// failed join or reconnect, [join] fails with [CallLeftException]; use
  /// [StreamVideo.makeCall] to create a new [Call] for the same call.
  Future<Result<None>> join({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
    bool? hintHighScaleLivestreamPublisher,
  }) {
    return _connection.join(
      connectOptions: connectOptions,
      membersLimit: membersLimit,
      maxJoinRetries: maxJoinRetries,
      hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
    );
  }

  /// Leaves the call.
  ///
  /// The call cannot be joined again. Its [state] stays readable, also after
  /// [dispose].
  ///
  /// Leaving an outgoing call this user created while it still rings, with
  /// nobody accepted or joined, cancels the ring for the callees.
  ///
  /// - [reason]: optional reason for leaving the call
  Future<Result<None>> leave({DisconnectReason? reason}) {
    return _connection.leave(reason: reason);
  }

  /// Leaves the call if it joined and has not been left, then closes its
  /// streams:
  /// [state], [partialState], [participantsStream], [callEvents], [stats],
  /// [closedCaptions] and [callDurationStream] complete, and later state
  /// changes are dropped. [state] keeps its last value.
  ///
  /// A call that is still ringing is reported disconnected and its native
  /// call ends. An outgoing ring is cancelled as by [leave]; an incoming ring
  /// is not rejected, use [reject] for that.
  ///
  /// Calling it again does nothing.
  Future<void> dispose() => _disposed ??= _dispose();
  Future<void>? _disposed;
  bool get _isDisposed => _disposed != null;

  Future<void> _dispose() async {
    _logger.i(() => '[dispose]');
    await _connection.dispose();

    // A leave can end without this teardown, when the call was already
    // disconnected.
    _subscriptions.cancelAll();
    _reactions.cancelTimers();
    _moderation.cancelTimer();
    _stopRingStatePolling();
    await _media.cancelSfuStatsTimers();

    // First, so the participants subject gets the last list before it closes.
    _stateManager.dispose();
    await _closedCaptions.dispose();
    await _callEvents.close();
    await _stats.close();
    await _participantsSubjectOrNull?.close();
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
  /// - [individualRecording]: Individual recording settings for the call.
  /// - [rawRecording]: Raw recording settings for the call.
  /// - [encryption]: Whether the call permits end-to-end encryption.
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
    StreamIndividualRecordingSettings? individualRecording,
    StreamRawRecordingSettings? rawRecording,
    StreamIngressSettings? ingress,
    StreamEncryptionSettings? encryption,
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
      individualRecording: individualRecording,
      rawRecording: rawRecording,
      ingress: ingress,
      encryption: encryption,
    );
  }

  /// Whether exactly one participant, a session of the current user, remains
  /// once [leaving] is removed.
  bool _isAloneAfterLeave(SfuParticipant leaving) {
    final currentUserId = _streamVideo.currentUser.id;
    var remaining = 0;

    for (final participant in state.value.callParticipants) {
      if (participant.userId == leaving.userId &&
          participant.sessionId == leaving.sessionId) {
        continue;
      }
      if (participant.userId != currentUserId || ++remaining > 1) {
        return false;
      }
    }

    return remaining == 1;
  }

  /// Handles [sfuEvent], sent by [session].
  Future<void> _onSfuEvent(
    SfuEvent sfuEvent, {
    required CallSession session,
  }) async {
    if (sfuEvent is SfuParticipantLeftEvent) {
      if (sfuEvent.callCid != callCid.value) return;

      if (state.value.isRingingFlow &&
          _stateManager.callState.preferences.dropIfAloneInRingingFlow &&
          _isAloneAfterLeave(sfuEvent.participant)) {
        final endResult = await end(
          reason: 'last participant left the call (ringing flow)',
        );

        if (endResult.isFailure) {
          _logger.w(
            () =>
                '[onSfuEvent] auto-end failed while alone in ringing flow: $endResult',
          );
          await leave(reason: DisconnectReason.lastParticipantLeft());
        }
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

    await _connection._onSfuConnectionEvent(sfuEvent, session: session);
  }

  Future<Result<None>> setLocalTrack(RtcLocalTrack track) =>
      _media.setLocalTrack(track);

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

  Future<Result<None>> _awaitIncomingToBeAccepted(Duration timeLimit) async {
    return state
        .firstWhere(
          (state) {
            final status = state.status;
            return status is CallStatusIncoming && status.acceptedByMe;
          },
        )
        .timeout(timeLimit)
        .then((value) {
          _logger.i(() => '[awaitIncomingToBeAccepted] completed');
          return const Result.success(none);
        })
        .onError((e, stk) {
          _logger.e(() => '[awaitIncomingToBeAccepted] failed: $e');
          return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
        });
  }

  Future<Result<None>> _awaitOutgoingToBeAccepted(Duration timeLimit) async {
    return state
        .firstWhere(
          (state) {
            final status = state.status;
            return status is CallStatusOutgoing && status.acceptedByCallee;
          },
        )
        .timeout(timeLimit)
        .then((value) {
          _logger.i(() => '[awaitOutgoingToBeAccepted] completed');
          return const Result.success(none);
        })
        .onError((e, stk) {
          _logger.e(() => '[awaitOutgoingToBeAccepted] failed: $e');
          return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
        });
  }

  Future<Result<None>> _awaitCallToBeJoined() async {
    return state
        .firstWhere(
          (state) {
            return state.status is CallStatusJoined;
          },
        )
        .timeout(const Duration(seconds: 60))
        .then((value) {
          _logger.d(() => '[awaitCallToBeJoined] completed');
          return const Result.success(none);
        })
        .onError((e, stk) {
          _logger.e(() => '[awaitCallToBeJoined] failed: $e');
          return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
        });
  }

  Future<Result<T>> _performGetOperation<T>({
    required bool watch,
    required Future<Result<T>> Function() coordinatorCall,
    required CallMetadata Function(T data) onSuccess,
  }) async {
    if (watch && !_isDisposed) {
      _observeEvents();
      _streamVideo.state.setWatchedCall(this);
    }

    final response = await coordinatorCall();

    return response.foldResult(
      success: (success) async {
        _logger.v(() => '[performGetOperation] success: $success');

        final callMetadata = onSuccess(success.data);
        unawaited(
          _media.applyCallSettings(callMetadata.settings).catchError(
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
        _startRingStatePollingIfNeeded(data.metadata);

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
  /// - [individualRecording]: Individual recording settings for the call.
  /// - [rawRecording]: Raw recording settings for the call.
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
    StreamIndividualRecordingSettings? individualRecording,
    StreamRawRecordingSettings? rawRecording,
    StreamEncryptionSettings? encryption,
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
      individualRecording: individualRecording?.toOpenDto(),
      rawRecording: rawRecording?.toOpenDto(),
      encryption: encryption?.toOpenDto(),
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

        _startRingStatePollingIfNeeded(data.data.metadata);
        return data.data.metadata;
      },
    );
  }

  /// Starts polling for the outcome of a ring the current user just started,
  /// in case the `call.accepted` or `call.rejected` event never arrives.
  void _startRingStatePollingIfNeeded(CallMetadata metadata) {
    final settings = _streamVideo.options.ringStatePolling;
    if (!settings.enabled) return;
    if (_ringStatePoller?.isStopped == false) return;

    // A zero interval would fire the poll timer on every event-loop turn.
    if (settings.interval <= Duration.zero) {
      _logger.w(
        () =>
            '[startRingStatePolling] rejected (interval is not positive): '
            '${settings.interval}',
      );
      return;
    }

    final status = _stateManager.callState.status;
    if (status is! CallStatusOutgoing || status.acceptedByCallee) return;

    // Captured once: the ring state is read for the session that rang.
    final sessionId = metadata.session.id;
    if (sessionId.isEmpty) {
      _logger.w(() => '[startRingStatePolling] rejected (no session)');
      return;
    }

    final ringTimeout = metadata.settings.ring.autoCancelTimeout;
    if (ringTimeout <= Duration.zero) return;

    final poller = RingStatePoller(
      settings: settings,
      ringTimeout: ringTimeout,
      fetchRingState: () => _coordinatorClient.getCallRingState(
        callCid: callCid,
        sessionId: sessionId,
      ),
      onRingState: _onPolledRingState,
    );
    _ringStatePoller = poller;

    unawaited(_ringStatePollerStatusSubscription?.cancel());
    _ringStatePollerStatusSubscription = _stateManager.callStateStream.listen((
      state,
    ) {
      final status = state.status;
      if (status is! CallStatusOutgoing || status.acceptedByCallee) {
        _stopRingStatePolling();
      }
    });

    poller.start();
  }

  /// Applies a polled ring state, returning whether the ring is settled.
  bool _onPolledRingState(GetCallRingStateResponse ringState) {
    final callState = _stateManager.callState;
    final status = callState.status;
    if (status is! CallStatusOutgoing || status.acceptedByCallee) return true;

    final snapshot = ringState.toRingingSnapshot(
      memberIds: callState.callMembers.map((member) => member.userId),
    );

    final ringingState = snapshot.resolveFor(callState.currentUserId);
    if (!ringingState.isRinging) {
      // A settled ring here means the event that carried it was dropped.
      _logger.i(
        () => '[onPolledRingState] resolved by polling: $ringingState',
      );
    }

    _stateManager.coordinatorOutgoingRingResolved(ringingState, snapshot);
    return !ringingState.isRinging;
  }

  void _stopRingStatePolling() {
    _ringStatePoller?.stop();
    _ringStatePoller = null;
    unawaited(_ringStatePollerStatusSubscription?.cancel());
    _ringStatePollerStatusSubscription = null;
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

  /// Starts audio processing for the call.
  Future<Result<None>> startAudioProcessing({
    bool requireAdvancedAudioProcessingSupport = false,
  }) async {
    if (!_streamVideo.isAudioProcessorConfigured()) {
      _logger.w(() => '[startAudioProcessing] rejected (not configured)');
      return failureWithError(
        'Cannot start audio processing (not configured)',
      );
    }

    if (!_permissionsManager.hasPermission(
      CallPermission.enableNoiseCancellation,
    )) {
      _logger.w(() => '[startAudioProcessing] rejected (no permission)');
      return failureWithError(
        'Cannot start audio processing (no permission)',
      );
    }

    if (requireAdvancedAudioProcessingSupport) {
      final supportResult = await _streamVideo
          .deviceSupportsAdvancedAudioProcessing();

      if (supportResult.isFailure) {
        return failureWithError(
          'Cannot start audio processing (faild to check advanced audio processing support)',
        );
      } else {
        if (!(supportResult.getDataOrNull() ?? false)) {
          return failureWithError(
            'Cannot start audio processing (device does not support required advanced audio processing)',
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
      return failureWithError(
        'Cannot stop audio processing (not configured)',
      );
    }

    final result = await _streamVideo.setAudioProcessingEnabled(false);

    if (result.isSuccess) {
      await _session?.notifyNoiseCancellationStopped();
      _stateManager.setCallAudioProcessing(isAudioProcessing: false);
    }

    return result;
  }

  Future<Result<None>> setCameraPosition(CameraPosition cameraPosition) =>
      _media.setCameraPosition(cameraPosition);

  Future<Result<None>> flipCamera() => _media.flipCamera();

  Future<Result<bool>> setMultitaskingCameraAccessEnabled(bool enabled) =>
      _media.setMultitaskingCameraAccessEnabled(enabled);

  Future<Result<None>> setZoom({required double zoomLevel}) =>
      _media.setZoom(zoomLevel: zoomLevel);

  Future<Result<None>> focus({Point<double>? focusPoint}) =>
      _media.focus(focusPoint: focusPoint);

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) =>
      _media.setVideoInputDevice(device);

  Future<Result<None>> setCameraEnabled({
    required bool enabled,
    CameraConstraints? constraints,
  }) => _media.setCameraEnabled(enabled: enabled, constraints: constraints);

  /// Changes the camera capture target resolution. It applies to the live
  /// camera, and every later session opens the camera at it, over the call
  /// settings.
  Future<Result<None>> setCameraTargetResolution(
    StreamTargetResolution targetResolution,
  ) => _media.setCameraTargetResolution(targetResolution);

  /// Enables or disables the microphone for this call.
  ///
  /// [stopTrackOnMute] controls whether muting disables and stops (default: `true`)
  /// or keeps the audio track alive but silent (`false`). On iOS/macOS, `false` keeps
  /// muted-talker detection active but leaves the mic indicator on. When null, keeps default behavior.
  Future<Result<None>> setMicrophoneEnabled({
    required bool enabled,
    AudioConstraints? constraints,
    bool? stopTrackOnMute,
  }) => _media.setMicrophoneEnabled(
    enabled: enabled,
    constraints: constraints,
    stopTrackOnMute: stopTrackOnMute,
  );

  Future<bool> requestScreenSharePermission() =>
      _media.requestScreenSharePermission();

  Future<Result<None>> setScreenShareEnabled({
    required bool enabled,
    ScreenShareConstraints? constraints,
  }) => _media.setScreenShareEnabled(
    enabled: enabled,
    constraints: constraints,
  );

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) =>
      _media.setAudioInputDevice(device);

  /// Sets the audio output device for the call.
  /// - [device]: The audio output device to set.
  /// Returns a [Result] indicating the success or failure of the operation.
  ///
  /// On web platforms, this method may return an error if the browser does not support
  /// setting audio output devices programmatically.
  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) =>
      _media.setAudioOutputDevice(device);

  Result<None> setAudioBitrateProfile(SfuAudioBitrateProfile profile) {
    if (!state.value.settings.audio.hifiAudioEnabled) {
      return failureWithError(
        'High Fidelity audio is not enabled for this call',
      );
    }

    if (_streamVideo.isAudioProcessorConfigured()) {
      final disableAudioProcessing =
          profile == SfuAudioBitrateProfile.musicHighQuality;

      if (disableAudioProcessing) {
        unawaited(stopAudioProcessing());
      } else {
        unawaited(startAudioProcessing());
      }
    }

    _stateManager.setAudioBitrateProfile(profile);

    final stereo = profile == SfuAudioBitrateProfile.musicHighQuality;

    // On iOS, toggle stereo playout preference when switching HiFi audio modes.
    if (CurrentPlatform.isIos) {
      unawaited(rtc.Helper.setiOSStereoPlayoutPreferred(stereo));
    }

    _session?.rtcManager?.changeDefaultAudioConstraints(
      AudioConstraints(
        noiseSuppression: !stereo,
        echoCancellation: !stereo,
        autoGainControl: !stereo,
        channelCount: stereo ? 2 : 1,
      ),
    );

    return const Result.success(none);
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

  /// Acts on a track's aggregate, and answers whether it landed: the registry
  /// forgets one that did not, so the next measurement drives it again.
  Future<bool> _applyViewportAggregate(ViewportAggregate aggregate) async {
    final track = aggregate.track;

    if (state.value.status.isDisconnected) {
      _logger.d(() => '[applyViewportAggregate] rejected (disconnected)');
      return false;
    }

    // One failing does not stop the other being tried; either means the
    // aggregate did not land.
    var applied = true;

    final visibilityResult = await updateViewportVisibility(
      sessionId: track.sessionId,
      userId: track.userId,
      visibility: aggregate.visibility,
      trackType: track.trackType,
    );

    if (visibilityResult.isFailure) {
      _logger.w(
        () => '[applyViewportAggregate] visibility failed: $visibilityResult',
      );
      applied = false;
    }

    // A viewport can measure a track for somebody the call does not have yet,
    // or has already lost. Not applied, so it is driven again.
    final participant = _participantBySessionId(track.sessionId);
    if (participant == null) {
      _logger.w(() => '[applyViewportAggregate] no participant for $track');
      return false;
    }

    // Only a remote track is subscribed to: a local one is already coming out
    // of the camera, and an unpublished one has nothing to ask for.
    final trackState = participant.publishedTracks[track.trackType];
    if (trackState is! RemoteTrackState) return applied;

    // Dropped on the track being hidden, not on an empty size: a viewport
    // drawing a sliver of one still wants it.
    final Result<None> subscriptionResult;
    if (!aggregate.visibility.isVisible && !aggregate.persistWhenHidden) {
      subscriptionResult = await removeSubscription(
        userId: track.userId,
        sessionId: track.sessionId,
        trackIdPrefix: track.trackIdPrefix,
        trackType: track.trackType,
      );
    } else {
      subscriptionResult = await updateSubscription(
        userId: track.userId,
        sessionId: track.sessionId,
        trackIdPrefix: track.trackIdPrefix,
        trackType: track.trackType,
        videoDimension: aggregate.dimension,
      );
    }

    if (subscriptionResult.isFailure) {
      _logger.w(
        () =>
            '[applyViewportAggregate] subscription failed: $subscriptionResult',
      );
      applied = false;
    }

    return applied;
  }

  CallParticipantState? _participantBySessionId(String sessionId) {
    for (final participant in _stateManager.callState.callParticipants) {
      if (participant.sessionId == sessionId) return participant;
    }

    return null;
  }

  /// Records a track's viewport visibility and tells the session.
  ///
  /// Driven by [viewportVisibility], which every viewport reports to; a
  /// viewport writing here directly is back to overwriting the others.
  @internal
  Future<Result<None>> updateViewportVisibility({
    required String sessionId,
    required String userId,
    required ViewportVisibility visibility,
    required SfuTrackTypeVideo trackType,
  }) async {
    if (state.value.status.isDisconnected) {
      _logger.d(() => '[updateViewportVisibility] rejected (disconnected)');
      return const Result.success(none);
    }

    if (trackType.isScreenShare) {
      _stateManager.participantUpdateScreenShareViewportVisibility(
        sessionId: sessionId,
        userId: userId,
        visibility: visibility,
      );
      return const Result.success(none);
    }

    // Recorded before the session is told, which debounces and ends in the UI
    // reading this same state back, so there is nothing to wait for.
    _stateManager.participantUpdateViewportVisibility(
      sessionId: sessionId,
      userId: userId,
      visibility: visibility,
    );

    final change = VisibilityChange(
      sessionId: sessionId,
      userId: userId,
      visibility: visibility,
    );

    return await _session?.updateViewportVisibility(change) ??
        failureWithError('Session is null');
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

  /// Moves a track's subscription to [videoDimension].
  ///
  /// Driven by [viewportVisibility], which sizes a track for the largest
  /// viewport showing it.
  @internal
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

  /// Drops a track's subscription.
  ///
  /// Driven by [viewportVisibility], which removes a track once no viewport
  /// shows it and none asked to keep it.
  @internal
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
}

CallStateNotifier _makeStateManager(
  StreamCallCid callCid,
  CoordinatorClient coordinatorClient,
  StateEmitter<User?> currentUser,
  CallPreferences callPreferences,
) {
  final currentUserId = currentUser.value?.id ?? '';

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

/// Call factory to create a [Call] instance.
/// Only meant for testing purposes.
@visibleForTesting
// ignore: avoid_classes_with_only_static_members
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

  final StreamVideoException error;
}
