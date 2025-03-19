class HealthCheckEndpoint {
  HealthCheckEndpoint({
    required this.uri,
    this.timeout = const Duration(seconds: 3),
    this.headers = const {},
    this.validStatusCodes = const [200],
  });

  final Uri uri;
  final Duration timeout;
  final Map<String, String> headers;
  final List<int> validStatusCodes;
}
