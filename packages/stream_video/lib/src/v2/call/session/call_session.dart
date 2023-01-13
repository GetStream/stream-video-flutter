import '../../../disposable.dart';
import '../../../logger/stream_logger.dart';
import '../../../sfu-client/sfu_client.dart';
import '../../coordinator/coordinator_client.dart';
import '../../coordinator/ws/coordinator_ws.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../webrtc/rtc_manager.dart';

class CallSession extends Disposable {
  CallSession({
    required this.sessionId,
    required this.callCid,
    required this.coordinatorClient,
    required this.coordinatorWS,
  });

  final _logger = taggedLogger(tag: 'SV:RtcManager');

  final String sessionId;
  final String callCid;
  final CoordinatorClient coordinatorClient;
  final CoordinatorWebSocket coordinatorWS;

  late SfuClient sfuClient;
  late SfuWebSocket sfuWS;
  late RtcManager rtcManager;

  Future<void> start() async {
    return;
  }

  Future<void> dispose() async {
    return await super.dispose();
  }
}
