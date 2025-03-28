import 'package:state_notifier/state_notifier.dart';
import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateCallActionsMixin on StateNotifier<CallState> {
  void setCallLive({required bool isLive}) {
    _logger.v(() => '[setCallLive] isLive:$isLive');
    state = state.copyWith(
      isBackstage: !isLive,
    );
  }

  void setCallRecording({required bool isRecording}) {
    _logger.v(() => '[setCallRecording] isRecording:$isRecording');
    state = state.copyWith(
      isRecording: isRecording,
    );
  }

  void setCallTranscribing({required bool isTranscribing}) {
    _logger.v(() => '[setCallTranscribing] isTranscribing:$isTranscribing');
    state = state.copyWith(
      isTranscribing: isTranscribing,
    );
  }

  void setCallClosedCaptioning({required bool isCaptioning}) {
    _logger.v(() => '[setCallClosedCaptioning] isCaptioning:$isCaptioning');
    state = state.copyWith(
      isCaptioning: isCaptioning,
    );
  }

  void setCallAudioProcessing({required bool isAudioProcessing}) {
    _logger.v(
      () => '[setCallAudioProcessing] isAudioProcessing:$isAudioProcessing',
    );
    state = state.copyWith(
      isAudioProcessing: isAudioProcessing,
    );
  }

  void setCallBroadcasting({
    required bool isBroadcasting,
    String? hlsPlaylistUrl,
  }) {
    _logger.v(
      () => '[setCallBroadcasting] isBroadcasting:$isBroadcasting'
          ', hlsPlaylistUrl: $hlsPlaylistUrl',
    );
    final curEgress = state.egress;
    final newEgress = curEgress.copyWith(
      hlsPlaylistUrl: hlsPlaylistUrl,
    );

    state = state.copyWith(
      isBroadcasting: isBroadcasting,
      egress: newEgress,
    );
  }
}
