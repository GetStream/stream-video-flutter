abstract class SdpCodec {
  abstract final String alias;
}

enum VideoCodec implements SdpCodec {
  vp8('VP8'),
  vp9('VP9'),
  h264('H264');

  const VideoCodec(this.alias);

  final String alias;

  @override
  String toString() => alias;
}

enum AudioCodec implements SdpCodec {
  opus('opus');

  const AudioCodec(this.alias);

  final String alias;

  @override
  String toString() => alias;
}
