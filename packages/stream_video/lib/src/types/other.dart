import '../events.dart';
import '../logger/stream_log.dart';

/// Connection state type used throughout the SDK.
enum ConnectionState {
  connected,
  disconnected,
  failed,
  closed,
  connecting,
  reconnecting,
}

/// The iceTransportPolicy used for [RTCConfiguration].
/// See https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/RTCPeerConnection
enum RTCIceTransportPolicy {
  all,
  relay;
}

class RTCConfiguration {
  const RTCConfiguration({
    this.iceCandidatePoolSize,
    this.iceServers,
    this.iceTransportPolicy,
  });

  final int? iceCandidatePoolSize;
  final List<RTCIceServer>? iceServers;
  final RTCIceTransportPolicy? iceTransportPolicy;

  Map<String, dynamic> toMap() {
    final iceServersMap = <Map<String, dynamic>>[
      if (iceServers != null)
        for (final e in iceServers!) e.toMap(),
    ];

    return <String, dynamic>{
      // only supports unified plan
      'sdpSemantics': 'unified-plan',
      if (iceServersMap.isNotEmpty) 'iceServers': iceServersMap,
      if (iceCandidatePoolSize != null)
        'iceCandidatePoolSize': iceCandidatePoolSize,
      if (iceTransportPolicy != null)
        'iceTransportPolicy': iceTransportPolicy!.name,
    };
  }

  // Returns new options with updated properties
  RTCConfiguration copyWith({
    int? iceCandidatePoolSize,
    List<RTCIceServer>? iceServers,
    RTCIceTransportPolicy? iceTransportPolicy,
  }) =>
      RTCConfiguration(
        iceCandidatePoolSize: iceCandidatePoolSize ?? this.iceCandidatePoolSize,
        iceServers: iceServers ?? this.iceServers,
        iceTransportPolicy: iceTransportPolicy ?? this.iceTransportPolicy,
      );
}

class RTCIceServer {
  const RTCIceServer({
    this.urls,
    this.username,
    this.credential,
  });

  final List<String>? urls;
  final String? username;
  final String? credential;

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (urls?.isNotEmpty ?? false) 'urls': urls,
        if (username?.isNotEmpty ?? false) 'username': username,
        if (credential?.isNotEmpty ?? false) 'credential': credential,
      };
}

typedef OnConnectionStateUpdated = void Function(ConnectionStateUpdatedEvent);

/// Connection state mixin used throughout the SDK.
mixin ConnectionStateMixin {
  /// Returns True if the connection state is [ConnectionState.connecting].
  bool get isConnecting => connectionState == ConnectionState.connecting;

  /// Returns True if the connection state is [ConnectionState.connected].
  bool get isConnected => connectionState == ConnectionState.connected;

  /// Returns True if the connection state is [ConnectionState.reconnecting].
  bool get isReconnecting => connectionState == ConnectionState.reconnecting;

  /// Returns True if the connection state is [ConnectionState.disconnected].
  bool get isDisconnected => connectionState == ConnectionState.disconnected;

  /// The current connection state of the client.
  ConnectionState get connectionState => _connectionState;
  ConnectionState _connectionState = ConnectionState.disconnected;

  /// Called when the connection state updates.
  OnConnectionStateUpdated? onConnectionStateUpdated;

  set connectionState(ConnectionState newState) {
    final oldState = _connectionState;
    if (oldState == newState) return;

    streamLog.v(
      'SV:ConnectionStateMixin',
      () => '[setConnectionState] ${oldState.name} -> ${newState.name}',
    );

    _connectionState = newState;

    final didConnected = oldState != ConnectionState.connected &&
        newState == ConnectionState.connected;

    final updatedState = ConnectionStateUpdatedEvent(
      oldState: oldState,
      newState: newState,
      didConnected: didConnected,
    );

    return onConnectionStateUpdated?.call(updatedState);
  }
}
