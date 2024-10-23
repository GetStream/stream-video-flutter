enum SfuGoAwayReason {
  rebalance,
  shuttingDown,
  migrate,
  unspecified;

  @override
  String toString() {
    return name;
  }
}
