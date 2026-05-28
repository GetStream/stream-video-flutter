import '../../protobuf/video/sfu/models/models.pb.dart';
import '../../stream_video.dart';
import '../call/session/call_session_config.dart';
import '../call/state/call_state_notifier.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/sfu_client.dart';
import 'peer_connection_factory.dart';
import 'rtc_manager.dart';
import 'sdp/editor/sdp_editor.dart';

class RtcManagerFactory {
  RtcManagerFactory({
    required this.sessionId,
    required this.callCid,
    required this.configuration,
    required this.sdpEditor,
    required this.pcFactory,
    this.mediaConstraints = const {},
  });

  final _logger = taggedLogger(tag: 'SV:RtcManagerFactory');

  final String sessionId;
  final StreamCallCid callCid;
  final RTCConfiguration configuration;
  final SdpEditor sdpEditor;

  final StreamPeerConnectionFactory pcFactory;

  final Map<String, dynamic> mediaConstraints;

  Future<RtcManager> makeRtcManager({
    required SfuClient sfuClient,
    required CallStateNotifier stateManager,
    required StreamVideo streamVideo,
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
            sessionId: sessionId,
            sdpEditor: sdpEditor,
            sfuClient: sfuClient,
            configuration: configuration,
            clientDetails: clientDetails,
            tracerIdPrefix: sessionSequence?.toString(),
            mediaConstraints: mediaConstraints,
            statsOptions: statsOptions,
            callSessionConfig: callSessionConfig,
          )
        : null;

    final subscriber = await pcFactory.makeSubscriber(
      sessionId: sessionId,
      sdpEditor: sdpEditor,
      sfuClient: sfuClient,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: sessionSequence?.toString(),
      mediaConstraints: mediaConstraints,
      statsOptions: statsOptions,
      callSessionConfig: callSessionConfig,
    );

    return RtcManager(
      sessionId: sessionId,
      callCid: callCid,
      publisherId: publisherId,
      publisher: publisher,
      subscriber: subscriber,
      publishOptions: publishOptions,
      stateManager: stateManager,
      streamVideo: streamVideo,
      pcFactory: pcFactory,
    );
  }
}
