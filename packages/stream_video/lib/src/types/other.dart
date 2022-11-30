import 'package:meta/meta.dart';
import 'package:stream_video/src/core/logger/logger.dart';

/// Connection state type used throughout the SDK.
enum ConnectionState {
  disconnected,
  connecting,
  reconnecting,
  connected,
}

enum TrackSource {
  unknown,
  camera,
  microphone,
  screenShareVideo,
  screenShareAudio,
}

enum TrackType {
  audio,
  video;

  String toRtcTrackKind() {
    switch (this) {
      case TrackType.audio:
        return 'audio';
      case TrackType.video:
        return 'video';
    }
  }

  static TrackType? fromRtcTrackKind(String? kind) {
    if (kind == null) return null;
    return {
      'audio': TrackType.audio,
      'video': TrackType.video,
    }[kind];
  }
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

typedef OnConnectionStateUpdated = void Function(ConnectionStateUpdated);

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

    logger.fine(
      'SignalClient ConnectionState '
      '${oldState.name} -> ${newState.name}',
    );

    _connectionState = newState;

    final didConnected = oldState != ConnectionState.connected &&
        newState == ConnectionState.connected;

    final updatedState = ConnectionStateUpdated(
      oldState: oldState,
      newState: newState,
      didConnected: didConnected,
    );

    return onConnectionStateUpdated?.call(updatedState);
  }
}

/// Model class for connection state updates.
class ConnectionStateUpdated {
  /// Creates a new instance of [ConnectionStateUpdated].
  const ConnectionStateUpdated({
    required this.newState,
    required this.oldState,
    required this.didConnected,
  });

  /// The new connection state.
  final ConnectionState newState;

  /// The old connection state.
  final ConnectionState oldState;

  /// Whether the connection state changed to [ConnectionState.connected].
  final bool didConnected;
}
