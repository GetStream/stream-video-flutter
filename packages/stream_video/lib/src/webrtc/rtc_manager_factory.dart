import 'package:http/http.dart';

import '../../protobuf/video/sfu/models/models.pb.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../types/other.dart';
import 'peer_connection_factory.dart';
import 'rtc_manager.dart';
import 'sdp/editor/sdp_editor.dart';

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
    ClientDetails? clientDetails,
    String? publisherId,
    int? sessionSequence,
    List<SfuPublishOptions> publishOptions = const [],
  }) async {
    _logger.d(() => '[makeRtcManager] publisherId: $publisherId');

    final publisher = publisherId != null
        ? await pcFactory.makePublisher(
            configuration,
            clientDetails,
            sessionSequence?.toString(),
            mediaConstraints,
          )
        : null;

    final subscriber = await pcFactory.makeSubscriber(
      configuration,
      clientDetails,
      sessionSequence?.toString(),
      mediaConstraints,
    );

    return RtcManager(
      sessionId: sessionId,
      callCid: callCid,
      publisherId: publisherId,
      publisher: publisher,
      subscriber: subscriber,
      publishOptions: publishOptions,
    );
  }
}
