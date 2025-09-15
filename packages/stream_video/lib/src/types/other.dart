/// The iceTransportPolicy used for [RTCConfiguration].
/// See https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/RTCPeerConnection
enum RTCIceTransportPolicy { all, relay }

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
      'bundlePolicy':
          'max-bundle', // https://linear.app/stream/issue/FLU-91/peerconnection-rtp-bundle
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
  }) => RTCConfiguration(
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
