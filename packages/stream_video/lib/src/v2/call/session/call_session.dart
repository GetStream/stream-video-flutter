import '../../../disposable.dart';
import '../../action/call_control_action.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/rtc_track.dart';

abstract class CallSession extends Disposable {
  String get sessionId;

  SharedEmitter<SfuEventV2> get events;

  Future<Result<None>> start();

  Future<Result<None>> apply(CallControlAction action);

  List<RtcTrack> getTracks(String trackId);

  RtcTrack? getTrack(String trackSid);
}
