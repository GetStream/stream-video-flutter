import 'package:meta/meta.dart';

import '../../stream_video.dart';
import 'action.dart';

@internal
abstract class RtcAction extends StreamAction {}

class SubscriberTrackReceivedAction extends RtcAction {
  SubscriberTrackReceivedAction({
    required this.trackIdPrefix,
    required this.trackType,
  });

  final String trackIdPrefix;
  final SfuTrackType trackType;

  @override
  List<Object?> get props => [trackIdPrefix, trackType];
}
