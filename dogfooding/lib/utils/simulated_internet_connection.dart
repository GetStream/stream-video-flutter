import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// A network monitor that reports the device's real status, except while
/// [goOffline] holds it offline.
///
/// The real status comes from a monitor built from `settings`, the way
/// `StreamVideo` builds its own when the app passes none. Pass the settings
/// given to `StreamVideo`, so both check alike.
class SimulatedInternetConnection implements InternetConnection {
  SimulatedInternetConnection({required NetworkMonitorSettings settings})
    : _real = InternetConnection.createInstance(
        checkInterval: settings.checkInterval,
        triggerStream: Connectivity().onConnectivityChanged,
        useDefaultOptions: settings.customEndpoints.isEmpty,
        customCheckOptions: settings.customEndpoints.isEmpty
            ? null
            : [
                for (final endpoint in settings.customEndpoints)
                  endpoint.toInternetCheckOption(),
              ],
      );

  final InternetConnection _real;
  final _simulated = StreamController<InternetStatus>.broadcast();
  Timer? _offlineTimer;

  /// Whether [goOffline] is holding the status offline.
  bool get isOffline => _offlineTimer?.isActive ?? false;

  /// Reports offline for [duration], then the real status again. A second
  /// call replaces the first one's duration.
  void goOffline(Duration duration) {
    _offlineTimer?.cancel();
    _offlineTimer = Timer(duration, () async {
      final status = await _real.internetStatus;
      if (!_simulated.isClosed) _simulated.add(status);
    });
    _simulated.add(InternetStatus.disconnected);
  }

  @override
  Stream<InternetStatus> get onStatusChange =>
      Rx.merge([_real.onStatusChange, _simulated.stream])
          .map((status) => isOffline ? InternetStatus.disconnected : status)
          .distinct();

  @override
  Future<InternetStatus> get internetStatus async =>
      isOffline ? InternetStatus.disconnected : _real.internetStatus;

  @override
  Future<bool> get hasInternetAccess async =>
      !isOffline && await _real.hasInternetAccess;

  @override
  InternetStatus? get lastTryResults =>
      isOffline ? InternetStatus.disconnected : _real.lastTryResults;

  @override
  Duration get checkInterval => _real.checkInterval;

  @override
  void setIntervalAndResetTimer(Duration duration) =>
      _real.setIntervalAndResetTimer(duration);

  @override
  bool get enableStrictCheck => _real.enableStrictCheck;

  @override
  ConnectivityCheckCallback? get customConnectivityCheck =>
      _real.customConnectivityCheck;

  @override
  Stream<dynamic>? get triggerStream => _real.triggerStream;

  @override
  Future<void> dispose() async {
    _offlineTimer?.cancel();
    await _simulated.close();
    await _real.dispose();
  }
}
