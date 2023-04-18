abstract class SdpCodec {
  MediaType get type;

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
  MediaType get type => MediaType.video;

  @override
  String toString() => alias;
}

enum AudioCodec implements SdpCodec {
  opus('opus'),
  red('red');

  const AudioCodec(this.alias);

  @override
  final String alias;

  @override
  MediaType get type => MediaType.audio;

  @override
  String toString() => alias;
}

enum MediaType {
  audio('audio'),
  video('video');

  const MediaType(this.alias);

  final String alias;

  @override
  String toString() => alias;
}
