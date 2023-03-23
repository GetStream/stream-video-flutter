import '../../../stream_video.dart';
import '../../disposable.dart';
import '../../models/call_stats.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';

abstract class CallSession extends Disposable {
  String get sessionId;

  SharedEmitter<SfuEvent> get events;

  SharedEmitter<CallStats> get stats;

  Future<Result<None>> start();

  Future<Result<None>> apply(SessionControlAction action);

  Future<Result<None>> setLocalTrack(RtcLocalTrack track);

  List<RtcTrack> getTracks(String trackIdPrefix);

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType);
}
