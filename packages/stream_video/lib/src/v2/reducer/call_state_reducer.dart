import '../action/action.dart';
import '../action/call_control_action.dart';
import '../action/coordinator_action.dart';
import '../action/lifecycle_action.dart';
import '../action/sfu_action.dart';
import '../call_state.dart';
import '_call_control_reducer.dart';
import '_coordinator_reducer.dart';
import '_lifecycle_reducer.dart';
import '_sfu_reducer.dart';

class CallStateReducer {
  CallStateReducer(this.currentUserId);

  final String currentUserId;
  late final lifecycleReducer = LifecycleReducer(currentUserId);
  late final coordinatorReducer = CoordinatorReducer(currentUserId);
  late final sfuReducer = SfuReducer(currentUserId);
  late final callControlReducer = CallControlReducer(currentUserId);

  CallStateV2 reduce(CallStateV2 state, StreamAction action) {
    if (action is LifecycleAction) {
      return lifecycleReducer.reduce(state, action);
    } else if (action is CoordinatorAction) {
      return coordinatorReducer.reduce(state, action);
    } else if (action is SfuAction) {
      return sfuReducer.reduce(state, action);
    } else if (action is CallControlAction) {
      return callControlReducer.reduce(state, action);
    }
    return state;
  }
}
