import '../action/call_action.dart';
import '../call_state.dart';
import '../logger/impl/tagged_logger.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-Call');

class CallReducer {
  const CallReducer();

  CallState reduce(
    CallState state,
    CallAction action,
  ) {
    return state;
  }
}
