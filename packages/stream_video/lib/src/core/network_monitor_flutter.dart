import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../ws/ws.dart';

class NetworkMonitorFlutter implements NetworkMonitor {
  NetworkMonitorFlutter.fromInternetConnection(
    InternetConnection? internetConnection,
  ) : _internetConnection =
            internetConnection ?? InternetConnection.createInstance();

  final InternetConnection _internetConnection;

  @override
  Stream<NetworkStatus> get onStatusChange =>
      _internetConnection.onStatusChange.map(
        (event) => switch (event) {
          InternetStatus.connected => NetworkStatus.connected,
          InternetStatus.disconnected => NetworkStatus.disconnected,
        },
      );
}
