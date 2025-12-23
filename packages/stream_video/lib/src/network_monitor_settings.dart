import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkMonitorSettings {
  const NetworkMonitorSettings({
    this.checkInterval = const Duration(seconds: 5),
    this.offlineCheckInterval = const Duration(seconds: 2),
    this.customEndpoints = const [],
    this.internetConnectionInstance,
  });

  /// The interval between connection checks.
  final Duration checkInterval;

  /// The interval between connection checks when offline.
  final Duration offlineCheckInterval;

  /// A list of custom options for checking internet connectivity.
  ///
  /// This allows you to specify custom URLs, headers, and timeout settings
  /// for determining internet availability. The InternetConnection checker
  /// will use these options when performing connectivity checks.
  final List<NetworkMonitorEndpoint> customEndpoints;

  /// An instance of the InternetConnection class to use for connectivity checks.
  ///
  /// This allows you to provide a custom implementation of the InternetConnection
  /// class if you already have an existing instance in your app. If not provided,
  /// a default implementation will be used.
  final InternetConnection? internetConnectionInstance;
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

  InternetCheckOption toInternetCheckOption() {
    return InternetCheckOption(
      uri: Uri.parse(url),
      headers: headers,
      timeout: timeout,
      responseStatusFn: (response) => validCodes.contains(response.statusCode),
    );
  }
}
