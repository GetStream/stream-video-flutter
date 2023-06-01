import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../logger/impl/tagged_logger.dart';

abstract class HealthMonitor {
  bool get isStarted;

  void start();

  void onPongReceived();

  void onSocketOpen();

  void onSocketClose();

  void onSocketError(Object error);

  void stop();
}

abstract class HealthListener {
  void onPingRequested();

  void onPongTimeout(Duration timeout);

  void onNetworkConnected();

  void onNetworkDisconnected();
}

typedef SendPing = void Function();
typedef OnPongTimeout = void Function(Duration timeout);

class HealthMonitorImpl implements HealthMonitor {
  HealthMonitorImpl(this.owner, this.listener);

  final String owner;
  final HealthListener listener;

  late final _logger = taggedLogger(tag: 'SV:$owner-HM');
  final _pingPeriod = const Duration(seconds: 7);
  final _pongTimeout = const Duration(seconds: 35);

  bool _started = false;
  Timer? _pingTimer;
  Timer? _pongTimer;
  StreamSubscription<ConnectivityResult>? _networkChangeSubscription;

  @override
  bool get isStarted => _started;

  @override
  void start() {
    if (_started) {
      _logger.w(() => '[start] rejected (already started)');
      return;
    }
    _logger.d(() => '[start] no args');
    _started = true;
    _listenNetworkChanges();
  }

  @override
  void onPongReceived() {
    if (!_started) {
      _logger.w(() => '[onPongReceived] rejected (not started)');
      return;
    }
    _logger.d(() => '[onPongReceived] no args');
    _pongTimer?.cancel();
    _pongTimer = Timer(_pongTimeout, () {
      _stopPinging();
      listener.onPongTimeout(_pongTimeout);
    });
    _startPinging();
  }

  @override
  void onSocketOpen() {
    _logger.d(() => '[onSocketOpen] no args');
  }

  @override
  void onSocketClose() {
    if (!_started) {
      _logger.w(() => '[onSocketClose] rejected (not started)');
      return;
    }
    _logger.i(() => '[onSocketClose] no args');
    _stopPinging();
  }

  @override
  void onSocketError(Object error) {
    if (!_started) {
      _logger.w(() => '[onSocketError] rejected (not started)');
      return;
    }
    _logger.e(() => '[onSocketError] error: $error');
    _stopPinging();
  }

  @override
  void stop() {
    if (!_started) {
      _logger.w(() => '[stop] rejected (not started)');
      return;
    }
    _logger.d(() => '[stop] no args');
    _started = false;
    _stopPinging();
    _stopPongTimer();
    _stopListeningNetworkChanges();
  }

  Future<void> _startPinging() async {
    if (_pingTimer != null) {
      _logger.v(() => '[startPinging] rejected (pinging already started)');
      return;
    }
    _logger.d(() => '[startPinging] no args');
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingPeriod, (_) {
      listener.onPingRequested();
    });
  }

  void _stopPinging() {
    _logger.d(() => '[stopPinging] no args');
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _stopPongTimer() {
    _logger.d(() => '[stopPongTimer] no args');
    _pongTimer?.cancel();
    _pongTimer = null;
  }

  void _listenNetworkChanges() {
    _networkChangeSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      _logger.v(() => '[onConnectivityChanged] result: $result');
      if (result == ConnectivityResult.none) {
        listener.onNetworkDisconnected();
        _stopPinging();
        _stopPongTimer();
      } else {
        listener.onNetworkConnected();
      }
    });
  }

  void _stopListeningNetworkChanges() {
    _logger.d(() => '[stopListeningNetworkChanges] no args');
    _networkChangeSubscription?.cancel();
    _networkChangeSubscription = null;
  }

  Future<bool> _isNetworkConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
