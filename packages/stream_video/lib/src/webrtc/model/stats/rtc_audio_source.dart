// {
//   id: SA4,
//   type: media-source,
//   timestamp: 1679516625237.986,
//   kind: audio,
//   trackIdentifier: 48123de3-c13a-470a-b486-571adb6e9bb1,
//   audioLevel: 0.012970366527298808,
//   totalAudioEnergy: 0.01473122845502261,
//   totalSamplesDuration: 10.02999999999983,
//   echoReturnLoss: -30,
//   echoReturnLossEnhancement: 0.17551203072071075
// }

import 'rtc_media_source.dart';

class RtcAudioSource extends RtcMediaSource {
  const RtcAudioSource({
    super.id,
    super.type,
    super.timestamp,
    super.kind,
    super.trackIdentifier,
    this.audioLevel,
    this.totalAudioEnergy,
    this.totalSamplesDuration,
    this.echoReturnLoss,
    this.echoReturnLossEnhancement,
  });

  final double? audioLevel;
  final double? totalAudioEnergy;
  final double? totalSamplesDuration;
  final double? echoReturnLoss;
  final double? echoReturnLossEnhancement;

  String? get codecId => id;

  static RtcAudioSource? fromJson(dynamic value) {
    if (value is Map) {
      return RtcAudioSource(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        kind: value['kind'],
        trackIdentifier: value['trackIdentifier'],
        audioLevel: value['audioLevel'],
        totalAudioEnergy: value['totalAudioEnergy'],
        totalSamplesDuration: value['totalSamplesDuration'],
        echoReturnLoss: value['echoReturnLoss'],
        echoReturnLossEnhancement: value['echoReturnLossEnhancement'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RtcAudioSource{id: $id, type: $type, timestamp: $timestamp, '
        'kind: $kind, trackIdentifier: $trackIdentifier, '
        'audioLevel: $audioLevel, totalAudioEnergy: $totalAudioEnergy, '
        'totalSamplesDuration: $totalSamplesDuration, '
        'echoReturnLoss: $echoReturnLoss, '
        'echoReturnLossEnhancement: $echoReturnLossEnhancement}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('trackId: ')
      ..write(trackIdentifier)
      ..write('\n')
      ..write('audioLevel: ')
      ..write(audioLevel)
      ..write('\n');
  }
}
