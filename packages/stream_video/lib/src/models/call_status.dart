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

  factory CallStatus.connecting() {
    return CallStatusConnecting();
  }

  factory CallStatus.reconnecting(int attempt) {
    return CallStatusReconnecting(attempt: attempt);
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

  bool get isOutgoing => this is CallStatusOutgoing;

  bool get isIncoming => this is CallStatusIncoming;

  bool get isConnecting => this is CallStatusConnecting;

  bool get isReconnecting => this is CallStatusReconnecting;

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
  String toString() => 'Idle';
}

abstract class CallStatusActive extends CallStatus {
  const CallStatusActive();
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

class CallStatusConnecting extends CallStatusActive {
  factory CallStatusConnecting() {
    return _instance;
  }
  const CallStatusConnecting._internal();
  static const CallStatusConnecting _instance = CallStatusConnecting._internal();
  @override
  String toString() => 'Connecting';
}

class CallStatusReconnecting extends CallStatusConnecting {
  const CallStatusReconnecting({required this.attempt}) : super._internal();

  final int attempt;

  @override
  List<Object?> get props => [attempt];

  @override
  String toString() {
    return 'Reconnecting{attempt: $attempt}';
  }
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
