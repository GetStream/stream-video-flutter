import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../types/other.dart';
import 'peer_connection_factory.dart';
import 'rtc_manager.dart';

class RtcManagerFactory {
  RtcManagerFactory({
    required this.sessionId,
    required this.callCid,
    required this.configuration,
    this.mediaConstraints = const {},
  }) : pcFactory = StreamPeerConnectionFactory(
          sessionId: sessionId,
          callCid: callCid,
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
