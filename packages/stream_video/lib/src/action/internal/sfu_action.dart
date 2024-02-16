import 'package:meta/meta.dart';
import 'package:stream_video/src/action/internal_action.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';

@internal
abstract class SfuAction extends StreamInternalAction {
  const SfuAction();
}

class SfuEventAction extends SfuAction {
  const SfuEventAction(this.event);

  final SfuEvent event;

  @override
  List<Object?> get props => [event];
}
