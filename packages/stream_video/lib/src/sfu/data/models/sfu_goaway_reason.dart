enum SfuGoAwayReason {
  rebalance,
  shuttingDown,
  unspecified;

  @override
  String toString() {
    return name;
  }
}
