import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

/// A network monitor that reports the device's real status, except while
/// [goOffline] holds it offline.
///
/// Built like the monitor `StreamVideo` makes when the app passes none.
class SimulatedInternetConnection implements InternetConnection {
  SimulatedInternetConnection()
    : _real = InternetConnection.createInstance(
        checkInterval: const Duration(seconds: 5),
        triggerStream: Connectivity().onConnectivityChanged,
      );

  final InternetConnection _real;
  final _simulated = StreamController<InternetStatus>.broadcast();
  Timer? _offlineTimer;

  /// When the simulated outage ends, or null while there is none.
  final offlineUntil = ValueNotifier<DateTime?>(null);

  bool get isOffline => offlineUntil.value != null;

  /// Reports offline for [duration], then the real status again. A second
  /// call replaces the first one's duration.
  void goOffline(Duration duration) {
    _offlineTimer?.cancel();
    offlineUntil.value = DateTime.now().add(duration);
    _simulated.add(InternetStatus.disconnected);
    _offlineTimer = Timer(duration, () async {
      offlineUntil.value = null;
      _simulated.add(await _real.internetStatus);
    });
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
    offlineUntil.dispose();
    await _simulated.close();
    await _real.dispose();
  }
}
