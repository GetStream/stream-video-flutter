import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';

class SfuVideoSender {
  SfuVideoSender({
    required this.mediaRequest,
    required this.codec,
  });

  final SfuVideoMediaRequest mediaRequest;
  final SfuCodec codec;

  @override
  String toString() {
    return 'SfuVideoSender{mediaRequest: $mediaRequest, codec: $codec}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuVideoSender &&
          runtimeType == other.runtimeType &&
          mediaRequest == other.mediaRequest &&
          codec == other.codec;

  @override
  int get hashCode => mediaRequest.hashCode ^ codec.hashCode;
}

class SfuVideoMediaRequest {
  SfuVideoMediaRequest({
    required this.idealHeight,
    required this.idealWidth,
    required this.idealFrameRate,
  });

  final int idealHeight;
  final int idealWidth;
  final int idealFrameRate;

  @override
  String toString() {
    return 'SfuVideoMediaRequest{idealHeight: $idealHeight, '
        'idealWidth: $idealWidth, idealFrameRate: $idealFrameRate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuVideoMediaRequest &&
          runtimeType == other.runtimeType &&
          idealHeight == other.idealHeight &&
          idealWidth == other.idealWidth &&
          idealFrameRate == other.idealFrameRate;

  @override
  int get hashCode =>
      idealHeight.hashCode ^ idealWidth.hashCode ^ idealFrameRate.hashCode;
}
