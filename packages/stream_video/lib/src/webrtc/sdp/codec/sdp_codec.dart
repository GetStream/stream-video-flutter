abstract class SdpCodec {
  String get alias;
}

enum VideoCodec implements SdpCodec {
  vp8('VP8'),
  vp9('VP9'),
  h264('H264');

  const VideoCodec(this.alias);

  @override
  final String alias;

  @override
  String toString() => alias;
}

enum AudioCodec implements SdpCodec {
  opus('opus');

  const AudioCodec(this.alias);

  @override
  final String alias;

  @override
  String toString() => alias;
}
