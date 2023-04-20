import '../action/action.dart';
import '../action/call_action.dart';
import '../action/internal/coordinator_action.dart';
import '../action/internal/lifecycle_action.dart';
import '../action/internal/rtc_action.dart';
import '../action/internal/sfu_action.dart';
import '../action/participant_action.dart';
import '../call_state.dart';
import '_call_reducer.dart';
import '_coordinator_reducer.dart';
import '_lifecycle_reducer.dart';
import '_participant_reducer.dart';
import '_rtc_reducer.dart';
import '_sfu_reducer.dart';

class RootReducer {
  RootReducer();

  late final _lifecycleReducer = const LifecycleReducer();
  late final _coordinatorReducer = const CoordinatorReducer();
  late final _sfuReducer = const SfuReducer();
  late final _rtcReducer = const RtcReducer();
  late final _participantReducer = const ParticipantReducer();
  late final _callReducer = const CallReducer();

  CallState reduce(CallState state, StreamAction action) {
    if (action is LifecycleAction) {
      return _lifecycleReducer.reduce(state, action);
    } else if (action is CoordinatorEventAction) {
      return _coordinatorReducer.reduce(state, action);
    } else if (action is SfuAction) {
      return _sfuReducer.reduce(state, action);
    } else if (action is ParticipantAction) {
      return _participantReducer.reduce(state, action);
    } else if (action is RtcAction) {
      return _rtcReducer.reduce(state, action);
    } else if (action is CallAction) {
      return _callReducer.reduce(state, action);
    }
    return state;
  }
}
