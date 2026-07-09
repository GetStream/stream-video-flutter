import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as plugin;
import 'package:stream_video/stream_video.dart';

/// [NetworkMonitorFactory] backed by `internet_connection_checker_plus`,
/// triggered by `connectivity_plus` connectivity changes — matching the
/// native SDK's existing behavior.
class FlutterNetworkMonitorFactory implements NetworkMonitorFactory {
  const FlutterNetworkMonitorFactory();

  @override
  NetworkMonitor create(NetworkMonitorSettings settings) {
    if (settings.networkMonitor != null) return settings.networkMonitor!;

    final internetConnection = plugin.InternetConnection.createInstance(
      checkInterval: settings.checkInterval,
      triggerStream: Connectivity().onConnectivityChanged,
      useDefaultOptions: settings.customEndpoints.isEmpty,
      customCheckOptions: settings.customEndpoints.isEmpty
          ? null
          : settings.customEndpoints
                .map(
                  (endpoint) => plugin.InternetCheckOption(
                    uri: Uri.parse(endpoint.url),
                    headers: endpoint.headers,
                    timeout: endpoint.timeout,
                    responseStatusFn: (response) =>
                        endpoint.validCodes.contains(response.statusCode),
                  ),
                )
                .toList(),
    );
    return FlutterNetworkMonitor(internetConnection);
  }
}

class FlutterNetworkMonitor implements NetworkMonitor {
  FlutterNetworkMonitor(this._internetConnection);

  final plugin.InternetConnection _internetConnection;

  @override
  Stream<NetworkStatus> get onStatusChange =>
      _internetConnection.onStatusChange.map(_toDomain);

  @override
  Future<NetworkStatus> get currentStatus async =>
      _toDomain(await _internetConnection.internetStatus);

  @override
  Duration get checkInterval => _internetConnection.checkInterval;

  @override
  void setIntervalAndResetTimer(Duration duration) {
    _internetConnection.setIntervalAndResetTimer(duration);
  }

  static NetworkStatus _toDomain(plugin.InternetStatus status) {
    return switch (status) {
      plugin.InternetStatus.connected => NetworkStatus.connected,
      plugin.InternetStatus.disconnected => NetworkStatus.disconnected,
    };
  }
}
