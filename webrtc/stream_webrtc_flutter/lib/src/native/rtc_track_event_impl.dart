import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_impl.dart';
import 'media_stream_track_impl.dart';
import 'rtc_rtp_receiver_impl.dart';
import 'rtc_rtp_transceiver_impl.dart';

class RTCTrackEventNative extends RTCTrackEvent {
  RTCTrackEventNative(
    RTCRtpReceiver receiver,
    List<MediaStream> streams,
    MediaStreamTrack track,
    RTCRtpTransceiver transceiver,
  ) : super(
        receiver: receiver,
        streams: streams,
        track: track,
        transceiver: transceiver,
      );

  factory RTCTrackEventNative.fromMap(
    Map<String, dynamic> map,
    String peerConnectionId,
  ) {
    final streamsParams = map['streams'] as List<Map<String, dynamic>>;
    final streams = streamsParams.map(MediaStreamNative.fromMap).toList();
    return RTCTrackEventNative(
      RTCRtpReceiverNative.fromMap(
        map['receiver'],
        peerConnectionId: peerConnectionId,
      ),
      streams,
      MediaStreamTrackNative.fromMap(map['track'], peerConnectionId),
      RTCRtpTransceiverNative.fromMap(
        map['transceiver'],
        peerConnectionId: peerConnectionId,
      ),
    );
  }
}
