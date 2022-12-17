import '../../protobuf/video/coordinator/edge_v1/edge.pb.dart';
import '../types/other.dart';

RTCConfiguration? rtcConfigurationFromICEServers(
  Iterable<ICEServer>? config,
) {
  if (config == null || config.isEmpty) return null;
  return RTCConfiguration(
    iceServers: [
      ...config.map(
        (it) => RTCIceServer(
          urls: it.urls,
          username: it.username,
          credential: it.password,
        ),
      ),
    ],
  );
}

RTCConfiguration defaultRtcConfiguration(String sfuUrl) {
  final hostName = Uri.parse(sfuUrl).host;

  return RTCConfiguration(
    iceServers: [
      const RTCIceServer(
        urls: ['stun:stun.l.google.com:19302'],
      ),
      RTCIceServer(
        urls: ['turn:$hostName:3478'],
        username: 'video',
        credential: 'video',
      ),
    ],
  );
}
