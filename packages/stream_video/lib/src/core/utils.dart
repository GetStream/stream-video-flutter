import 'package:stream_video/src/types/other.dart';

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
