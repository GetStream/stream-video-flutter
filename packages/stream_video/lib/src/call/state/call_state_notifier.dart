import 'dart:async';

import 'package:state_notifier/state_notifier.dart';
import 'package:stream_core/stream_core.dart';

import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import 'call_state_selection.dart';
import 'mixins/state_call_actions_mixin.dart';
import 'mixins/state_coordinator_mixin.dart';
import 'mixins/state_lifecycle_mixin.dart';
import 'mixins/state_participant_mixin.dart';
import 'mixins/state_pending_tracks_mixin.dart';
import 'mixins/state_rtc_mixin.dart';
import 'mixins/state_sfu_mixin.dart';

class CallStateNotifier extends StateNotifier<CallState>
    with
        StateCoordinatorMixin,
        StateLifecycleMixin,
        StateParticipantMixin,
        StatePendingTracksMixin,
        StateRtcMixin,
        StateSfuMixin,
        StateCallActionsMixin {
  CallStateNotifier(CallState initialState) : super(initialState) {
    callStateStream = MutableStateEmitter<CallState>(
      initialState,
      sync: true,
    );
    _durationTimerController = StreamController<Duration>.broadcast();
    _setupDurationTimer();
  }

  final _logger = taggedLogger(tag: 'CallStateNotifier');

  /// The end this side has asked the server for, while that request runs.
  ///
  /// A call that ends meanwhile, by its own `call.ended` arriving before the
  /// response, is that end rather than one from elsewhere.
  DisconnectReasonEnded? pendingEnd;

  @override
  DisconnectReasonEnded get endedReason =>
      pendingEnd ?? const DisconnectReasonEnded();

  late final MutableStateEmitter<CallState> callStateStream;
  CallState get callState => callStateStream.value;

  /// Whether the current [CallState.audioOutputDevice] was chosen explicitly by
  /// the user (via `Call.setAudioOutputDevice`) rather than observed from a
  /// passive OS audio-route change (`AudioRouteChangedEvent`).
  bool audioOutputSelectedByUser = false;

  // Each listener gets its own selector chain on the value stream, which ends
  // when that listener cancels.
  Stream<T> partialCallStateStream<T>(T Function(CallState state) selector) {
    return callStateStream.map(selector).distinct(isSameCallStateSelection);
  }

  Stream<Duration> get durationStream =>
      _durationTimerController.stream.distinct();

  /// How long the call has been live, as described on
  /// `Call.liveDurationStream`.
  Stream<Duration> get liveDurationStream async* {
    final current = _liveDuration(state);
    if (current != null) yield current;
    yield* _liveDurationController.stream;
  }

  late final StreamController<Duration> _durationTimerController;
  final _liveDurationController = StreamController<Duration>.broadcast();
  Timer? _durationTimer;

  /// The `liveEndedAt` the live duration was last frozen at.
  DateTime? _frozenLiveEndedAt;

  /// Stays readable after [dispose]: it is the last state set.
  @override
  CallState get state => callStateStream.value;

  /// After [dispose] a new state is dropped.
  @override
  set state(CallState value) {
    if (!mounted) {
      _logger.w(() => '[setState] dropped (disposed): ${value.status}');
      return;
    }

    if (value.status != super.state.status) {
      _logger.v(() => '[setState] ${value.status} <= ${super.state.status}');
    }

    super.state = value;
    callStateStream.value = value;

    _setupDurationTimer();
  }

  void _setupDurationTimer() {
    _freezeLiveDuration();

    final callTicking = state.startedAt != null && state.liveEndedAt == null;
    if (!callTicking && !_isLive(state)) {
      _durationTimer?.cancel();
      _durationTimer = null;
      return;
    }

    _durationTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final startedAt = state.startedAt;
      if (startedAt != null && state.liveEndedAt == null) {
        _durationTimerController.add(now.difference(startedAt));
      }
      final liveStartedAt = state.liveStartedAt;
      if (liveStartedAt != null && _isLive(state)) {
        _liveDurationController.add(now.difference(liveStartedAt));
      }
    });
  }

  /// Emits the length of a live that has just ended, once.
  void _freezeLiveDuration() {
    final liveEndedAt = state.liveEndedAt;
    if (liveEndedAt == _frozenLiveEndedAt) return;
    _frozenLiveEndedAt = liveEndedAt;

    final duration = _liveDuration(state);
    if (liveEndedAt != null && duration != null) {
      _liveDurationController.add(duration);
    }
  }

  static bool _isLive(CallState state) =>
      state.liveStartedAt != null && state.liveEndedAt == null;

  /// From `liveStartedAt` to `liveEndedAt`, or to now while live.
  static Duration? _liveDuration(CallState state) {
    final liveStartedAt = state.liveStartedAt;
    if (liveStartedAt == null) return null;

    return (state.liveEndedAt ?? DateTime.now()).difference(liveStartedAt);
  }

  void updateCallPreferences(CallPreferences preferences) {
    _logger.v(() => '[updateCallPreferences] $preferences');
    state = state.copyWith(preferences: preferences);
  }

  @override
  void dispose() {
    super.dispose();
    callStateStream.close();
    _durationTimer?.cancel();
    _durationTimer = null;
    _durationTimerController.close();
    _liveDurationController.close();
  }
}
