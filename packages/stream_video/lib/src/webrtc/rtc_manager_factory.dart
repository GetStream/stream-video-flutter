import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/sdp/editor/sdp_editor.dart';

class RtcManagerFactory {
  RtcManagerFactory({
    required this.sessionId,
    required this.callCid,
    required this.configuration,
    required SdpEditor sdpEditor,
    this.mediaConstraints = const {},
  }) : pcFactory = StreamPeerConnectionFactory(
          sessionId: sessionId,
          callCid: callCid,
          sdpEditor: sdpEditor,
        );

  final _logger = taggedLogger(tag: 'SV:RtcManagerFactory');

  final String sessionId;
  final StreamCallCid callCid;
  final RTCConfiguration configuration;
  final StreamPeerConnectionFactory pcFactory;
  final Map<String, dynamic> mediaConstraints;

  Future<RtcManager> makeRtcManager({
    required String publisherId,
  }) async {
    _logger.d(() => '[makeRtcManager] publisherId: $publisherId');
    final publisher = await pcFactory.makePublisher(
      configuration,
      mediaConstraints,
    );
    final subscriber = await pcFactory.makeSubscriber(
      configuration,
      mediaConstraints,
    );
    return RtcManager(
      sessionId: sessionId,
      callCid: callCid,
      publisherId: publisherId,
      publisher: publisher,
      subscriber: subscriber,
    );
  }
}
