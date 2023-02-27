import '../action/action.dart';
import '../action/call_control_action.dart';
import '../action/call_coordinator_action.dart';
import '../action/lifecycle_action.dart';
import '../action/rtc_action.dart';
import '../action/sfu_action.dart';
import '../call_state.dart';
import '_call_control_reducer.dart';
import '_call_coordinator_reducer.dart';
import '_lifecycle_reducer.dart';
import '_rtc_reducer.dart';
import '_sfu_reducer.dart';

class CallStateReducer {
  CallStateReducer();

  late final lifecycleReducer = const LifecycleReducer();
  late final callCoordinatorReducer = const CallCoordinatorReducer();
  late final sfuReducer = const SfuReducer();
  late final rtcReducer = const RtcReducer();
  late final callControlReducer = const CallControlReducer();

  CallState reduce(CallState state, StreamAction action) {
    if (action is LifecycleAction) {
      return lifecycleReducer.reduce(state, action);
    } else if (action is CallCoordinatorAction) {
      return callCoordinatorReducer.reduce(state, action);
    } else if (action is SfuAction) {
      return sfuReducer.reduce(state, action);
    } else if (action is CallControlAction) {
      return callControlReducer.reduce(state, action);
    } else if (action is RtcAction) {
      return rtcReducer.reduce(state, action);
    }
    return state;
  }
}
