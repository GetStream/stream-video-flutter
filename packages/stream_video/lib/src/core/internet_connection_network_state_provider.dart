import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:stream_core/stream_core.dart'
    show MutableStateEmitter, NetworkState, NetworkStateProvider;

/// Bridges [InternetConnection] into stream_core's [NetworkStateProvider]
class InternetConnectionNetworkStateProvider implements NetworkStateProvider {
  InternetConnectionNetworkStateProvider(InternetConnection connection)
    : state = MutableStateEmitter(NetworkState.unknown) {
    connection.internetStatus.then(_updateState);
    _subscription = connection.onStatusChange.listen(_updateState);
  }

  @override
  final MutableStateEmitter<NetworkState> state;

  late final StreamSubscription<InternetStatus> _subscription;

  void _updateState(InternetStatus status) {
    state.emit(
      status == InternetStatus.connected
          ? NetworkState.connected
          : NetworkState.disconnected,
    );
  }

  void dispose() => _subscription.cancel();
}
