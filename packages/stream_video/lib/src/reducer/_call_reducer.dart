import '../action/call_action.dart';
import '../call_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../store/store.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-Call');

class CallReducer extends Reducer<CallState, CallAction> {
  const CallReducer();

  @override
  CallState reduce(
    CallState state,
    CallAction action,
  ) {
    return state;
  }
}
