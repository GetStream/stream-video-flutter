import 'package:state_notifier/state_notifier.dart';

import '../../call_state.dart';
import '../../models/call_preferences.dart';
import '../../models/call_status.dart';
import '../../models/disconnect_reason.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../state_emitter.dart';
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
        StateSfuMixin {
  CallStateNotifier(CallState initialState, this.callPreferences)
      : super(initialState) {
    callStateStream = MutableStateEmitterImpl<CallState>(initialState, sync: true);
  }

  final CallPreferences callPreferences;

  late final MutableStateEmitterImpl<CallState> callStateStream;
  CallState get callState => callStateStream.value;

  // TODO: This method is here to access preferences which can't be done in mixins -
  // TODO: find a better way to do this.
  void sfuParticipantLeft(
    SfuParticipantLeftEvent event,
  ) {
    final callParticipants = [...state.callParticipants]..removeWhere(
        (participant) =>
            participant.userId == event.participant.userId &&
            participant.sessionId == event.participant.sessionId,
      );

    if (callParticipants.length == 1 &&
        callParticipants.first.userId == state.currentUserId &&
        state.isRingingFlow &&
        callPreferences.dropIfAloneInRingingFlow) {
      state = state.copyWith(
        status: CallStatus.disconnected(
          DisconnectReason.lastParticipantLeft(),
        ),
        callParticipants: callParticipants,
      );
    }
    state = state.copyWith(
      callParticipants: callParticipants,
    );
  }

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
