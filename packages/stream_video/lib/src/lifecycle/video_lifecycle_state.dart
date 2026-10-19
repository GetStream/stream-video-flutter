enum VideoLifecycleState {
  paused,
  resumed,
  inactive,
  detached,
  hidden;

  @override
  String toString() => name;

  bool get isResumed => this == VideoLifecycleState.resumed;

  bool get isPaused => this == VideoLifecycleState.paused;

  bool get isDetached => this == VideoLifecycleState.detached;

  bool get isInactive => this == VideoLifecycleState.inactive;

  bool get isHidden => this == VideoLifecycleState.hidden;
}
