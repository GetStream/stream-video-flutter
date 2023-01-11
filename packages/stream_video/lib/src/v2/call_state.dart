import 'package:stream_video/src/v2/call_participant_state.dart';
import 'package:stream_video/src/v2/state_emitter.dart';

/// TODO - Class that holds any information about the call, including participants
class CallStateV2 {
  /// TODO
  CallStateV2({
    this.callParticipants = const [],
  });

  final List<CallParticipantState> callParticipants;
}
