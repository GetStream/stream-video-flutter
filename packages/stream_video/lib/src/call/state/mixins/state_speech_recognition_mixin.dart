import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../audio_processing/speech_recognition.dart';
import '../../../call_state.dart';
import '../../../models/call_permission.dart';

mixin StateSpeechRecognitionMixin on StateNotifier<CallState> {
  @protected
  void updateSpeechRecognition({
    required CallState oldState,
    required CallState newState,
    required SpeechRecognition speechRecognition,
  }) {
    final isAudioEnabled = newState.localParticipant?.isAudioEnabled ?? false;
    final wasAudioEnabled = oldState.localParticipant?.isAudioEnabled ?? false;
    final canSendAudio =
        newState.ownCapabilities.contains(CallPermission.sendAudio);

    if (!oldState.status.isDisconnected && newState.status.isDisconnected) {
      stopSpeakingWhileMutedDetection(speechRecognition);
      return;
    }

    if (!(newState.status.isJoined || newState.status.isConnected)) return;

    if (canSendAudio && isAudioEnabled != wasAudioEnabled) {
      if (isAudioEnabled) {
        stopSpeakingWhileMutedDetection(speechRecognition);
      } else {
        startSpeakingWhileMutedDetection(speechRecognition);
      }
    }
  }

  void startSpeakingWhileMutedDetection(SpeechRecognition speechRecognition) {
    speechRecognition.start(onSoundStateChanged: (isSpeaking) {
      if (isSpeaking) {
        state = state.copyWith(isSpeakingWhileMuted: true);
      } else {
        state = state.copyWith(isSpeakingWhileMuted: false);
      }
    });
  }

  void stopSpeakingWhileMutedDetection(SpeechRecognition speechRecognition) {
    speechRecognition.stop();
    if (state.isSpeakingWhileMuted) {
      state = state.copyWith(isSpeakingWhileMuted: false);

      print(
        'SpeechRecognition test stopSpeakingWhileMutedDetection: ${state.isSpeakingWhileMuted}',
      );
    }
  }
}
