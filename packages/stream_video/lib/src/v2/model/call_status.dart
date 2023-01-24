import 'package:flutter/cupertino.dart';

import 'drop_reason.dart';

@immutable
abstract class CallStatus {
  const CallStatus();

  factory CallStatus.idle() {
    return CallStatusIdle();
  }

  factory CallStatus.initialized() {
    return CallStatusInitialized();
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

  factory CallStatus.connected() {
    return CallStatusConnected();
  }

  factory CallStatus.drop(DropReason reason) {
    return CallStatusDrop(reason: reason);
  }

  bool get isIdle => this is CallStatusIdle;

  bool get isActive => this is CallStatusActive;

  bool get isJoinable => this is CallStatusJoinable;

  bool get isConnecting => this is CallStatusConnecting;

  bool get isConnected => this is CallStatusConnected;
}

class CallStatusIdle extends CallStatus {
  factory CallStatusIdle() {
    return _instance;
  }
  const CallStatusIdle._internal();
  static const CallStatusIdle _instance = CallStatusIdle._internal();
  @override
  String toString() {
    return 'Idle';
  }
}

abstract class CallStatusActive extends CallStatus {
  const CallStatusActive();
}

abstract class CallStatusJoinable extends CallStatusActive {
  const CallStatusJoinable();
}

class CallStatusInitialized extends CallStatusJoinable {
  factory CallStatusInitialized() {
    return _instance;
  }
  const CallStatusInitialized._internal();
  static const CallStatusInitialized _instance =
      CallStatusInitialized._internal();
  @override
  String toString() {
    return 'Initialized';
  }
}

class CallStatusOutgoing extends CallStatusJoinable {
  const CallStatusOutgoing({required this.acceptedByCallee});

  final bool acceptedByCallee;

  @override
  String toString() {
    return 'Outgoing{acceptedByCallee: $acceptedByCallee}';
  }
}

class CallStatusIncoming extends CallStatusJoinable {
  const CallStatusIncoming({required this.acceptedByMe});

  final bool acceptedByMe;

  @override
  String toString() {
    return 'Outgoing{acceptedByMe: $acceptedByMe}';
  }
}

class CallStatusConnecting extends CallStatusActive {
  factory CallStatusConnecting() {
    return _instance;
  }
  const CallStatusConnecting._internal();
  static const CallStatusConnecting _instance =
      CallStatusConnecting._internal();

  @override
  String toString() {
    return 'Connecting';
  }
}

class CallStatusConnected extends CallStatusActive {
  factory CallStatusConnected() {
    return _instance;
  }
  const CallStatusConnected._internal();
  static const CallStatusConnected _instance = CallStatusConnected._internal();
  @override
  String toString() {
    return 'Connected';
  }
}

class CallStatusDrop extends CallStatus {
  const CallStatusDrop({required this.reason});

  final DropReason reason;
  @override
  String toString() {
    return 'Drop';
  }
}
