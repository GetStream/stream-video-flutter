import 'dart:async';

import 'package:http/http.dart' as http;

import '../../network_monitor_settings.dart';
import 'network_monitor.dart';

/// Builds a [NetworkMonitor] from [NetworkMonitorSettings].
///
/// The default implementation ([HttpNetworkMonitorFactory]) polls a set of
/// HTTP endpoints periodically — correct for web/Jaspr, which has no native
/// connectivity-change signal. `stream_video_flutter` registers a
/// connectivity-triggered implementation via
/// `StreamVideoFlutter.ensureInitialized()`.
abstract class NetworkMonitorFactory {
  static NetworkMonitorFactory instance = const HttpNetworkMonitorFactory();

  NetworkMonitor create(NetworkMonitorSettings settings);
}

class HttpNetworkMonitorFactory implements NetworkMonitorFactory {
  const HttpNetworkMonitorFactory();

  @override
  NetworkMonitor create(NetworkMonitorSettings settings) {
    if (settings.networkMonitor != null) return settings.networkMonitor!;
    return HttpNetworkMonitor(settings: settings);
  }
}

const _defaultEndpoints = [
  NetworkMonitorEndpoint(url: 'https://one.one.one.one'),
  NetworkMonitorEndpoint(url: 'https://icanhazip.com'),
];

/// Pure-Dart [NetworkMonitor] that periodically issues HTTP HEAD requests
/// against [NetworkMonitorSettings.customEndpoints] (or a small built-in
/// default list) to determine connectivity.
class HttpNetworkMonitor implements NetworkMonitor {
  HttpNetworkMonitor({required this.settings})
    : _checkInterval = settings.checkInterval {
    _statusController.onListen = () {
      _startPolling();
      unawaited(_checkNow());
    };
    _statusController.onCancel = () {
      _timer?.cancel();
      _timer = null;
    };
  }

  final NetworkMonitorSettings settings;

  List<NetworkMonitorEndpoint> get _endpoints =>
      settings.customEndpoints.isNotEmpty
      ? settings.customEndpoints
      : _defaultEndpoints;

  Duration _checkInterval;
  Timer? _timer;
  NetworkStatus? _lastStatus;

  final _statusController = StreamController<NetworkStatus>.broadcast();

  @override
  Stream<NetworkStatus> get onStatusChange => _statusController.stream;

  @override
  Future<NetworkStatus> get currentStatus => _check();

  @override
  Duration get checkInterval => _checkInterval;

  @override
  void setIntervalAndResetTimer(Duration duration) {
    _checkInterval = duration;
    if (_timer != null) _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) => unawaited(_checkNow()));
  }

  Future<void> _checkNow() async {
    final status = await _check();
    if (status != _lastStatus) {
      _lastStatus = status;
      _statusController.add(status);
    }
  }

  Future<NetworkStatus> _check() async {
    for (final endpoint in _endpoints) {
      try {
        final response = await http
            .head(Uri.parse(endpoint.url), headers: endpoint.headers)
            .timeout(endpoint.timeout);
        if (endpoint.validCodes.contains(response.statusCode)) {
          return NetworkStatus.connected;
        }
      } catch (_) {
        // Try the next endpoint.
      }
    }
    return NetworkStatus.disconnected;
  }
}
