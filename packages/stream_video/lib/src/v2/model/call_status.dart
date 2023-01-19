abstract class CallStatus {
  const CallStatus();

  factory CallStatus.idle() {
    return CallStatusIdle();
  }

  factory CallStatus.initialized() {
    return CallStatusIdle();
  }

  factory CallStatus.outgoing({
    bool acceptedByOther = false,
  }) {
    return CallStatusOutgoing(acceptedByOther: acceptedByOther);
  }

  factory CallStatus.incoming({
    bool acceptedByMe = false,
  }) {
    return CallStatusIncoming(acceptedByMe: acceptedByMe);
  }

  factory CallStatus.connecting() {
    return const CallStatusConnecting();
  }

  factory CallStatus.connected() {
    return const CallStatusConnected();
  }

  factory CallStatus.drop() {
    return const CallStatusDrop();
  }

  bool get isJoinable => this is CallStatusJoinable;
}

abstract class CallStatusJoinable implements CallStatus {}

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

class CallStatusInitialized extends CallStatus implements CallStatusJoinable {
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

class CallStatusOutgoing extends CallStatus implements CallStatusJoinable {
  const CallStatusOutgoing({required this.acceptedByOther});

  final bool acceptedByOther;

  @override
  String toString() {
    return 'Outgoing{acceptedByOther: $acceptedByOther}';
  }
}

class CallStatusIncoming extends CallStatus with CallStatusJoinable {
  const CallStatusIncoming({required this.acceptedByMe});

  final bool acceptedByMe;

  @override
  String toString() {
    return 'Outgoing{acceptedByMe: $acceptedByMe}';
  }
}

class CallStatusConnecting extends CallStatus {
  const CallStatusConnecting();
  @override
  String toString() {
    return 'Connecting';
  }
}

class CallStatusConnected extends CallStatus {
  const CallStatusConnected();
  @override
  String toString() {
    return 'Connected';
  }
}

class CallStatusDrop extends CallStatus {
  const CallStatusDrop();
  @override
  String toString() {
    return 'Drop';
  }
}
