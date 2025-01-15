import 'package:meta/meta.dart';

import '../../../../stream_video.dart';
import 'sfu_codec.dart';

@immutable
class SfuAudioSender {
  const SfuAudioSender({
    required this.codec,
    required this.trackType,
    this.publishOptionId,
  });

  final SfuCodec codec;
  final SfuTrackType trackType;
  final int? publishOptionId;

  @override
  String toString() {
    return 'SfuAudioSender{codec: $codec, trackType: $trackType, publishOptionId: $publishOptionId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuAudioSender &&
          runtimeType == other.runtimeType &&
          trackType == other.trackType &&
          publishOptionId == other.publishOptionId &&
          codec == other.codec;

  @override
  int get hashCode =>
      codec.hashCode ^ trackType.hashCode ^ publishOptionId.hashCode;
}
