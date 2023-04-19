import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../internal_action.dart';

@internal
abstract class RtcAction extends StreamInternalAction {
  const RtcAction();
}

class SubscriberTrackReceived extends RtcAction {
  const SubscriberTrackReceived({
    required this.trackIdPrefix,
    required this.trackType,
  });

  final String trackIdPrefix;
  final SfuTrackType trackType;

  @override
  List<Object?> get props => [trackIdPrefix, trackType];
}
