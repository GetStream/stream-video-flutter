enum SfuCallEndedReason {
  unspecified,
  ended,
  liveEnded,
  kicked,
  sessionEnded;

  @override
  String toString() {
    return name;
  }
}
