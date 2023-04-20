import 'package:meta/meta.dart';

import '../../errors/video_error.dart';
import '../../models/call_created_data.dart';
import '../../models/call_joined_data.dart';
import '../internal_action.dart';

@internal
abstract class LifecycleAction extends StreamInternalAction {
  const LifecycleAction();
}

class SetUserId extends LifecycleAction {
  const SetUserId({
    required this.userId,
  });

  final String userId;
}

class CallAccepted extends LifecycleAction {
  const CallAccepted();
}

class CallRejected extends LifecycleAction {
  const CallRejected();
}

class CallDisconnected extends LifecycleAction {
  const CallDisconnected();
}

class CallCreated extends LifecycleAction {
  const CallCreated({
    required this.data,
  });

  final CallCreatedData data;
}

class CallJoining extends LifecycleAction {
  const CallJoining();
}

class CallJoined extends LifecycleAction {
  const CallJoined(this.data);

  final CallJoinedData data;

  @override
  List<Object?> get props => [data];
}

class CallSessionStart extends LifecycleAction {
  const CallSessionStart({required this.sessionId});

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

class CallConnecting extends LifecycleAction {
  const CallConnecting(this.attempt);

  final int attempt;

  @override
  List<Object?> get props => [attempt];
}

class CallConnected extends LifecycleAction {
  const CallConnected();
}

class CallTimeout extends LifecycleAction {
  const CallTimeout(this.timeLimit);

  final Duration timeLimit;

  @override
  List<Object?> get props => [timeLimit];
}

class ConnectFailed extends LifecycleAction {
  const ConnectFailed(this.error);

  final VideoError error;

  @override
  List<Object?> get props => [error];
}
