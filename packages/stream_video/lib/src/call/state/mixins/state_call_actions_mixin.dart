import 'package:state_notifier/state_notifier.dart';
import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateCallActionsMixin on StateNotifier<CallState> {
  void setCallLive({required bool isLive}) {
    _logger.e(() => '[setCallLive] isLive:$isLive');
    state = state.copyWith(
      isBackstage: !isLive,
    );
  }

  void setCallRecording({required bool isRecording}) {
    _logger.e(() => '[setCallRecording] isRecording:$isRecording');
    state = state.copyWith(
      isRecording: isRecording,
    );
  }

  void setCallBroadcasting({required bool isBroadcasting}) {
    _logger.e(() => '[setCallBroadcasting] isBroadcasting:$isBroadcasting');
    state = state.copyWith(
      isBroadcasting: isBroadcasting,
    );
  }
}
