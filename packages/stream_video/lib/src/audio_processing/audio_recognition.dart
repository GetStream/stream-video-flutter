import 'dart:async';

abstract interface class AudioRecognition {
  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  });

  Future<void> stop();

  Future<void> dispose();
}

typedef SoundStateChangedCallback = void Function(SoundState state);

class SoundState {
  const SoundState({
    required this.isSpeaking,
    required this.audioLevel,
  });

  final bool isSpeaking;
  final double audioLevel;
}
