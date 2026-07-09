import 'ws/health/network_monitor.dart';

class NetworkMonitorSettings {
  const NetworkMonitorSettings({
    this.checkInterval = const Duration(seconds: 5),
    this.offlineCheckInterval = const Duration(seconds: 2),
    this.customEndpoints = const [],
    this.networkMonitor,
  });

  /// The interval between connection checks.
  final Duration checkInterval;

  /// The interval between connection checks when offline.
  final Duration offlineCheckInterval;

  /// A list of custom endpoints for checking internet connectivity.
  final List<NetworkMonitorEndpoint> customEndpoints;

  /// A custom [NetworkMonitor] instance to use for connectivity checks.
  ///
  /// This allows you to provide your own implementation, or an instance you
  /// already manage elsewhere in your app. If not provided, the platform's
  /// default implementation is used (native: connectivity-triggered HTTP
  /// checks via `stream_video_flutter`; web/Jaspr: periodic HTTP checks).
  final NetworkMonitor? networkMonitor;
}

class NetworkMonitorEndpoint {
  const NetworkMonitorEndpoint({
    required this.url,
    this.headers = const {},
    this.timeout = const Duration(seconds: 3),
    this.validCodes = const [200],
  });

  /// The URL to check.
  final String url;

  /// Headers to include in the request.
  final Map<String, String> headers;

  /// The timeout for the request.
  final Duration timeout;

  /// List of HTTP status codes that are considered valid responses.
  final List<int> validCodes;
}
