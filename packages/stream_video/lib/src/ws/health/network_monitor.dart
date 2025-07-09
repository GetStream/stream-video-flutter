abstract class NetworkMonitor {
  Stream<NetworkStatus> get onStatusChange;
}

enum NetworkStatus {
  /// Internet is available because at least one of the HEAD requests succeeded.
  connected,

  /// None of the HEAD requests succeeded. Basically, no internet.
  disconnected,
}
