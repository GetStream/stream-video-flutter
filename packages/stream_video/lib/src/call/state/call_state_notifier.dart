import 'dart:async';

import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../state_emitter.dart';
import 'mixins/state_call_actions_mixin.dart';
import 'mixins/state_coordinator_mixin.dart';
import 'mixins/state_lifecycle_mixin.dart';
import 'mixins/state_participant_mixin.dart';
import 'mixins/state_pending_tracks_mixin.dart';
import 'mixins/state_rtc_mixin.dart';
import 'mixins/state_sfu_mixin.dart';

// Whether two values returned by a partial state selector are the same: equal
// by `==`, or collections with equal contents. Collections are compared deeply,
// so a map of lists counts as unchanged when only its instances are new. A
// record compares its fields with `==`, so a list inside a record is compared
// by identity.
bool _isSameSelection(Object? previous, Object? current) {
  if (identical(previous, current) || previous == current) return true;
  if ((previous is Iterable && current is Iterable) ||
      (previous is Map && current is Map)) {
    return const DeepCollectionEquality().equals(previous, current);
  }
  return false;
}

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
    callStateStream = MutableStateEmitterImpl<CallState>(
      initialState,
      sync: true,
    );
    _durationTimerController = StreamController<Duration>.broadcast();
    _setupDurationTimer();
  }

  final _logger = taggedLogger(tag: 'CallStateNotifier');

  late final MutableStateEmitterImpl<CallState> callStateStream;
  CallState get callState => callStateStream.value;

  /// Whether the current [CallState.audioOutputDevice] was chosen explicitly by
  /// the user (via `Call.setAudioOutputDevice`) rather than observed from a
  /// passive OS audio-route change (`AudioRouteChangedEvent`).
  bool audioOutputSelectedByUser = false;

  // Each listener gets its own selector chain on the value stream, which ends
  // when that listener cancels.
  Stream<T> partialCallStateStream<T>(T Function(CallState state) selector) {
    return callStateStream.valueStream.map(selector).distinct(_isSameSelection);
  }

  Stream<Duration> get durationStream =>
      _durationTimerController.stream.distinct();

  late final StreamController<Duration> _durationTimerController;
  Timer? _durationTimer;

  @override
  set state(CallState value) {
    if (value.status != super.state.status) {
      _logger.v(() => '[setState] ${value.status} <= ${super.state.status}');
    }

    super.state = value;
    callStateStream.value = value;

    _setupDurationTimer();
  }

  void _setupDurationTimer() {
    if (state.liveEndedAt != null) {
      _durationTimer?.cancel();
      _durationTimer = null;
      return;
    }

    if (state.startedAt == null || _durationTimer != null) return;

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.startedAt == null) return;

      final duration = DateTime.now().difference(state.startedAt!);
      _durationTimerController.add(duration);
    });
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
  }
}
