import 'package:meta/meta.dart';

import 'sfu_codec.dart';

@immutable
class SfuAudioSender {
  const SfuAudioSender({
    required this.mediaRequest,
    required this.codec,
  });

  final SfuAudioMediaRequest mediaRequest;
  final SfuCodec codec;

  @override
  String toString() {
    return 'SfuAudioSender{mediaRequest: $mediaRequest, codec: $codec}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuAudioSender &&
          runtimeType == other.runtimeType &&
          mediaRequest == other.mediaRequest &&
          codec == other.codec;

  @override
  int get hashCode => mediaRequest.hashCode ^ codec.hashCode;
}

class SfuAudioMediaRequest {
  SfuAudioMediaRequest({
    required this.channelCount,
  });

  final int channelCount;

  @override
  String toString() {
    return 'SfuAudioLevel{channelCount: $channelCount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuAudioMediaRequest &&
          runtimeType == other.runtimeType &&
          channelCount == other.channelCount;

  @override
  int get hashCode => channelCount.hashCode;
}
