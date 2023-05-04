enum LifecycleState {
  paused,
  resumed,
  inactive,
  detached;

  @override
  String toString() => name;
}

extension LifecycleStateX on LifecycleState {
  bool get isResumed => this == LifecycleState.resumed;

  bool get isPaused => this == LifecycleState.paused;

  bool get isDetached => this == LifecycleState.detached;

  bool get isInactive => this == LifecycleState.inactive;
}
