import 'package:state_notifier/state_notifier.dart';

import '../../call_state.dart';
import '../../models/call_preferences.dart';
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
  CallStateNotifier(CallState initialState, this.callPreferences)
      : super(initialState) {
    callStateStream =
        MutableStateEmitterImpl<CallState>(initialState, sync: true);
  }

  @override
  final CallPreferences callPreferences;

  late final MutableStateEmitterImpl<CallState> callStateStream;
  CallState get callState => callStateStream.value;

  @override
  set state(CallState value) {
    super.state = value;
    callStateStream.value = value;
  }

  @override
  void dispose() {
    super.dispose();
    callStateStream.close();
  }
}
