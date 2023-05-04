/// Latency measurement settings.
class LatencySettings {
  const LatencySettings({
    this.measurementRounds = 3,
    this.measurementTimeout = const Duration(seconds: 3),
  });

  /// Measurement attempt count per each SFU edge.
  final int measurementRounds;

  /// Measurement process timeout.
  final Duration measurementTimeout;
}
