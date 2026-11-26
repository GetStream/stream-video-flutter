enum AppleAudioMode {
  default_,
  gameChat,
  measurement,
  moviePlayback,
  spokenAudio,
  videoChat,
  videoRecording,
  voiceChat,
  voicePrompt,
}

extension AppleAudioModeEnumEx on String {
  AppleAudioMode toAppleAudioMode() =>
      AppleAudioMode.values.firstWhere((d) => d.name == toLowerCase());
}

enum AppleAudioCategory {
  soloAmbient,
  playback,
  record,
  playAndRecord,
  multiRoute,
}

extension AppleAudioCategoryEnumEx on String {
  AppleAudioCategory toAppleAudioCategory() =>
      AppleAudioCategory.values.firstWhere((d) => d.name == toLowerCase());
}

enum AppleAudioCategoryOption {
  mixWithOthers,
  duckOthers,
  interruptSpokenAudioAndMixWithOthers,
  allowBluetooth,
  allowBluetoothA2DP,
  allowAirPlay,
  defaultToSpeaker,
}

extension AppleAudioCategoryOptionEnumEx on String {
  AppleAudioCategoryOption toAppleAudioCategoryOption() =>
      AppleAudioCategoryOption.values.firstWhere(
        (d) => d.name == toLowerCase(),
      );
}

class AppleAudioConfiguration {
  AppleAudioConfiguration({
    this.appleAudioCategory,
    this.appleAudioCategoryOptions,
    this.appleAudioMode,
  });
  final AppleAudioCategory? appleAudioCategory;
  final Set<AppleAudioCategoryOption>? appleAudioCategoryOptions;
  final AppleAudioMode? appleAudioMode;

  Map<String, dynamic> toMap() => <String, dynamic>{
    if (appleAudioCategory != null)
      'appleAudioCategory': appleAudioCategory!.name,
    if (appleAudioCategoryOptions != null)
      'appleAudioCategoryOptions': appleAudioCategoryOptions!
          .map((e) => e.name)
          .toList(),
    if (appleAudioMode != null) 'appleAudioMode': appleAudioMode!.name,
  };
}
