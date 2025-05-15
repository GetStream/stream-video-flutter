import 'dart:async';

import 'package:state_notifier/state_notifier.dart';

import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../state_emitter.dart';
import 'mixins/state_call_actions_mixin.dart';
import 'mixins/state_coordinator_mixin.dart';
import 'mixins/state_lifecycle_mixin.dart';
import 'mixins/state_participant_mixin.dart';
import 'mixins/state_rtc_mixin.dart';
import 'mixins/state_sfu_mixin.dart';

class CallStateNotifier extends StateNotifier<CallState>
    with
        StateCoordinatorMixin,
        StateLifecycleMixin,
        StateParticipantMixin,
        StateRtcMixin,
        StateSfuMixin,
        StateCallActionsMixin {
  CallStateNotifier(CallState initialState) : super(initialState) {
    callStateStream =
        MutableStateEmitterImpl<CallState>(initialState, sync: true);
    _durationTimerController = StreamController<Duration>.broadcast();
    _ensureStartDurationTimer();
  }

  final _logger = taggedLogger(tag: 'CallStateNotifier');

  late final MutableStateEmitterImpl<CallState> callStateStream;
  CallState get callState => callStateStream.value;

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

    _ensureStartDurationTimer();
  }

  void _ensureStartDurationTimer() {
    if (state.startedAt == null || _durationTimer != null) return;

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.startedAt == null || state.endedAt != null) return;

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
