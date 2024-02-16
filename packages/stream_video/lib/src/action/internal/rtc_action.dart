import 'package:meta/meta.dart';
import 'package:stream_video/src/action/internal_action.dart';
import 'package:stream_video/stream_video.dart';

@internal
abstract class RtcAction extends StreamInternalAction {
  const RtcAction();
}

class UpdateSubscriberTrack extends RtcAction {
  const UpdateSubscriberTrack({
    required this.trackIdPrefix,
    required this.trackType,
  });

  final String trackIdPrefix;
  final SfuTrackType trackType;

  @override
  List<Object?> get props => [trackIdPrefix, trackType];
}
