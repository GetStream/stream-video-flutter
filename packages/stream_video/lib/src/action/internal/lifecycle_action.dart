import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/src/action/internal_action.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/models/call_created_data.dart';
import 'package:stream_video/src/models/call_joined_data.dart';
import 'package:stream_video/src/models/call_received_data.dart';
import 'package:stream_video/src/models/call_ringing_data.dart';

@internal
abstract class LifecycleAction extends StreamInternalAction {
  const LifecycleAction();
}

class SetUserId extends LifecycleAction {
  const SetUserId(this.userId);

  final String userId;
}

class SetLifecycleStage extends LifecycleAction {
  const SetLifecycleStage(this.stage);

  factory SetLifecycleStage.accepted() {
    return const SetLifecycleStage(CallAccepted());
  }

  factory SetLifecycleStage.rejected() {
    return const SetLifecycleStage(CallRejected());
  }

  factory SetLifecycleStage.ended() {
    return const SetLifecycleStage(CallEnded());
  }

  factory SetLifecycleStage.disconnected() {
    return const SetLifecycleStage(CallDisconnected());
  }

  factory SetLifecycleStage.created(CallCreatedData data) {
    return SetLifecycleStage(CallCreated(data));
  }

  factory SetLifecycleStage.joining() {
    return const SetLifecycleStage(CallJoining());
  }

  factory SetLifecycleStage.joined(CallJoinedData data) {
    return SetLifecycleStage(CallJoined(data));
  }

  factory SetLifecycleStage.sessionStart(String sessionId) {
    return SetLifecycleStage(CallSessionStart(sessionId));
  }

  factory SetLifecycleStage.connecting(int attempt) {
    return SetLifecycleStage(CallConnecting(attempt));
  }

  factory SetLifecycleStage.connected() {
    return const SetLifecycleStage(CallConnected());
  }

  factory SetLifecycleStage.timeout() {
    return const SetLifecycleStage(CallTimeout());
  }

  factory SetLifecycleStage.connectFailed(VideoError error) {
    return SetLifecycleStage(ConnectFailed(error));
  }

  final LifecycleStage stage;
}

abstract class LifecycleStage with EquatableMixin {
  const LifecycleStage();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class CallAccepted extends LifecycleStage {
  const CallAccepted();
}

class CallRejected extends LifecycleStage {
  const CallRejected();
}

class CallEnded extends LifecycleStage {
  const CallEnded();
}

class CallDisconnected extends LifecycleStage {
  const CallDisconnected();
}

class CallCreated extends LifecycleStage {
  const CallCreated(this.data);

  final CallCreatedData data;
}

class CallReceived extends LifecycleStage {
  const CallReceived(this.data);

  final CallReceivedData data;
}

class CallRinging extends LifecycleStage {
  const CallRinging(this.data);

  final CallRingingData data;
}

class CallJoining extends LifecycleStage {
  const CallJoining();
}

class CallJoined extends LifecycleStage {
  const CallJoined(this.data);

  final CallJoinedData data;

  @override
  List<Object?> get props => [data];
}

class CallSessionStart extends LifecycleStage {
  const CallSessionStart(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

class CallConnecting extends LifecycleStage {
  const CallConnecting(this.attempt, {this.isFastReconnectAttempt = false});

  factory CallConnecting.fastReconnect() =>
      const CallConnecting(1, isFastReconnectAttempt: true);

  final int attempt;
  final bool isFastReconnectAttempt;

  @override
  List<Object?> get props => [attempt, isFastReconnectAttempt];
}

class CallConnected extends LifecycleStage {
  const CallConnected();
}

class CallTimeout extends LifecycleStage {
  const CallTimeout();
}

class ConnectFailed extends LifecycleStage {
  const ConnectFailed(this.error);

  final VideoError error;

  @override
  List<Object?> get props => [error];
}
