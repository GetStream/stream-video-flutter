import '../action/action.dart';
import '../action/coordinator_action.dart';
import '../action/sfu_action.dart';
import '../action/update_call_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../coordinator/ws/coordinator_events.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '_coordinator_reducer.dart';
import '_sfu_reducer.dart';
import '_user_reducer.dart';

class CallStateReducer {
  CallStateReducer(this.currentUserId);

  final String currentUserId;
  late final coordinatorReducer = CoordinatorReducer(currentUserId);
  late final sfuReducer = SfuReducer(currentUserId);
  late final userReducer = UserReducer(currentUserId);

  CallStateV2 reduce(CallStateV2 state, StreamAction action) {
    if (action is CoordinatorAction) {
      return coordinatorReducer.reduce(state, action);
    } else if (action is SfuAction) {
      return sfuReducer.reduce(state, action);
    } else if (action is UpdateCallAction) {
      return userReducer.reduce(state, action);
    }
    return state;
  }
}
