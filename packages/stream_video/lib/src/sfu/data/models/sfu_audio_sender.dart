import 'package:meta/meta.dart';

import 'sfu_codec.dart';

@immutable
class SfuAudioSender {
  const SfuAudioSender({
    required this.codec,
  });

  final SfuCodec codec;

  @override
  String toString() {
    return 'SfuAudioSender{codec: $codec}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuAudioSender &&
          runtimeType == other.runtimeType &&
          codec == other.codec;

  @override
  int get hashCode => codec.hashCode;
}
