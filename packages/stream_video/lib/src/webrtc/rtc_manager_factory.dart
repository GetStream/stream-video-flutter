import '../../open_api/video/coordinator/api.dart';
import '../../protobuf/video/sfu/models/models.pb.dart';
import '../call/session/call_session_config.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/sfu_client.dart';
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
    required SfuClient sfuClient,
    ClientDetails? clientDetails,
    String? publisherId,
    int? sessionSequence,
    List<SfuPublishOptions> publishOptions = const [],
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
  }) async {
    _logger.d(() => '[makeRtcManager] publisherId: $publisherId');

    final publisher = publisherId != null
        ? await pcFactory.makePublisher(
            sfuClient,
            configuration,
            clientDetails,
            sessionSequence?.toString(),
            mediaConstraints,
            statsOptions,
            callSessionConfig,
          )
        : null;

    final subscriber = await pcFactory.makeSubscriber(
      sfuClient,
      configuration,
      clientDetails,
      sessionSequence?.toString(),
      mediaConstraints,
      statsOptions,
      callSessionConfig,
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
