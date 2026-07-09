abstract class NetworkMonitor {
  Stream<NetworkStatus> get onStatusChange;

  /// A fresh, one-shot read of the current network status.
  Future<NetworkStatus> get currentStatus;

  /// The interval between connection checks.
  Duration get checkInterval;

  /// Updates the check interval and resets the polling timer to start
  /// counting from now with the new interval.
  void setIntervalAndResetTimer(Duration duration);
}

enum NetworkStatus {
  /// Internet is available because at least one of the HEAD requests succeeded.
  connected,

  /// None of the HEAD requests succeeded. Basically, no internet.
  disconnected,
}
