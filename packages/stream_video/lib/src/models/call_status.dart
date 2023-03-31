import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'call_credentials.dart';
import 'drop_reason.dart';

@immutable
abstract class CallStatus extends Equatable {
  const CallStatus();

  factory CallStatus.idle() {
    return CallStatusIdle();
  }

  factory CallStatus.created() {
    return CallStatusCreated();
  }

  factory CallStatus.outgoing({
    bool acceptedByCallee = false,
  }) {
    return CallStatusOutgoing(acceptedByCallee: acceptedByCallee);
  }

  factory CallStatus.incoming({
    bool acceptedByMe = false,
  }) {
    return CallStatusIncoming(acceptedByMe: acceptedByMe);
  }

  factory CallStatus.joining() {
    return CallStatusJoining();
  }

  factory CallStatus.joined(CallCredentials credentials) {
    return CallStatusJoined(credentials: credentials);
  }

  factory CallStatus.connecting() {
    return CallStatusConnecting();
  }

  factory CallStatus.connected() {
    return CallStatusConnected();
  }

  factory CallStatus.drop(DropReason reason) {
    return CallStatusDrop(reason: reason);
  }

  @override
  List<Object?> get props => [];

  bool get isIdle => this is CallStatusIdle;

  bool get isActive => this is CallStatusActive;

  bool get isJoinable => this is CallStatusJoinable;

  bool get isCreated => this is CallStatusCreated;

  bool get isOutgoing => this is CallStatusOutgoing;

  bool get isIncoming => this is CallStatusIncoming;

  bool get isJoining => this is CallStatusJoining;

  bool get isJoined => this is CallStatusJoined;

  bool get isConnecting => this is CallStatusConnecting;

  bool get isConnected => this is CallStatusConnected;

  bool get isDrop => this is CallStatusDrop;
}

mixin CallStatusJoinable implements CallStatus {}

class CallStatusIdle extends CallStatus with CallStatusJoinable {
  factory CallStatusIdle() {
    return _instance;
  }
  const CallStatusIdle._internal();
  static const CallStatusIdle _instance = CallStatusIdle._internal();
  @override
  String toString() => 'Created';
}

abstract class CallStatusActive extends CallStatus {
  const CallStatusActive();
}

class CallStatusCreated extends CallStatusActive with CallStatusJoinable {
  factory CallStatusCreated() {
    return _instance;
  }
  const CallStatusCreated._internal();
  static const CallStatusCreated _instance = CallStatusCreated._internal();
  @override
  String toString() => 'Idl';
}

class CallStatusOutgoing extends CallStatusActive with CallStatusJoinable {
  const CallStatusOutgoing({required this.acceptedByCallee});

  final bool acceptedByCallee;

  @override
  List<Object?> get props => [acceptedByCallee];

  @override
  String toString() => 'Outgoing{acceptedByCallee: $acceptedByCallee}';
}

class CallStatusIncoming extends CallStatusActive with CallStatusJoinable {
  const CallStatusIncoming({required this.acceptedByMe});

  final bool acceptedByMe;

  @override
  List<Object?> get props => [acceptedByMe];

  @override
  String toString() => 'Incoming{acceptedByMe: $acceptedByMe}';
}

class CallStatusJoining extends CallStatusActive {
  factory CallStatusJoining() {
    return _instance;
  }
  const CallStatusJoining._internal();
  static const CallStatusJoining _instance = CallStatusJoining._internal();
  @override
  String toString() => 'Joining';
}

class CallStatusJoined extends CallStatusActive {
  const CallStatusJoined({required this.credentials});

  final CallCredentials credentials;

  @override
  List<Object?> get props => [credentials];

  @override
  String toString() => 'Joined{credentials: $credentials}';
}

class CallStatusConnecting extends CallStatusActive {
  factory CallStatusConnecting() {
    return _instance;
  }
  const CallStatusConnecting._internal();
  static const CallStatusConnecting _instance = CallStatusConnecting._internal();
  @override
  String toString() => 'Connecting';
}

class CallStatusConnected extends CallStatusActive {
  factory CallStatusConnected() {
    return _instance;
  }
  const CallStatusConnected._internal();
  static const CallStatusConnected _instance = CallStatusConnected._internal();
  @override
  String toString() => 'Connected';
}

class CallStatusDrop extends CallStatus {
  const CallStatusDrop({required this.reason});

  final DropReason reason;

  @override
  List<Object?> get props => [reason];

  @override
  String toString() {
    return 'Drop{reason: $reason}';
  }
}
