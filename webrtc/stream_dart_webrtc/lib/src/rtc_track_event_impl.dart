import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

class RTCTrackEventWeb extends RTCTrackEvent {
  RTCTrackEventWeb({
    super.receiver,
    required super.streams,
    required super.track,
    super.transceiver,
  });
}
