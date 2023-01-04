import 'package:stream_video/src/v2/state_emitter.dart';

/// TODO - Class that holds any information about the call, including participants
class Call {
  final callParticipants = StateEmitter(List.empty());
}
