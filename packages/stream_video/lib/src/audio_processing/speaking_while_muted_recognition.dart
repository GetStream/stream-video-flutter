import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../stream_video.dart';
import 'audio_recognition.dart';

class SpeakingWhileMutedRecognition
    extends StateNotifier<SpeakingWhileMutedState> {
  SpeakingWhileMutedRecognition({
    required this.call,
    AudioRecognition? audioRecognition,
  })  : audioRecognition = audioRecognition ?? AudioRecognition(),
        super(SpeakingWhileMutedState._(isSpeakingWhileMuted: false)) {
    _init();
  }

  final Call call;
  final AudioRecognition audioRecognition;
  bool _isActive = false;

  void _init() {
    call.state
        .asStream()
        .distinct(
          (oldState, newState) =>
              oldState.isAudioEnabled == newState.isAudioEnabled &&
              oldState.canSendAudio == newState.canSendAudio &&
              oldState.status == newState.status,
        )
        .listen((state) {
      if (state.status.isDisconnected) _stop();
      if (!(state.status.isJoined || state.status.isConnected)) return;

      if (state.isAudioEnabled) {
        _stop();
      } else if (state.canSendAudio) {
        start();
      }
    });
  }

  Future<void> start() async {
    if (_isActive) return;
    _isActive = true;
    await audioRecognition.start(
      onSoundStateChanged: (isSpeaking, audioLevel) {
        state = SpeakingWhileMutedState._(isSpeakingWhileMuted: isSpeaking);
      },
    );
  }

  Future<void> _stop() async {
    if (!_isActive) return;
    _isActive = false;
    state = SpeakingWhileMutedState._(isSpeakingWhileMuted: false);
    await audioRecognition.stop();
  }

  Future<void> dispose() {
    return audioRecognition.dispose();
  }
}

extension on CallState {
  bool get isAudioEnabled => localParticipant?.isAudioEnabled ?? false;
  bool get canSendAudio => ownCapabilities.contains(CallPermission.sendAudio);
}

class SpeakingWhileMutedState extends Equatable {
  SpeakingWhileMutedState._({
    required this.isSpeakingWhileMuted,
  });

  final bool isSpeakingWhileMuted;

  @override
  List<Object?> get props => [isSpeakingWhileMuted];
}
