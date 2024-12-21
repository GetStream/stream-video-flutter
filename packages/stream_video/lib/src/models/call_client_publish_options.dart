class ClientPublishOptions {
  ClientPublishOptions({
    this.preferredCodec,
    this.fmtpLine,
    this.preferredBitrate,
    this.maxSimulcastLayers,
    this.subscriberCodec,
    this.subscriberFmtpLine,
  });

  /// The preferred codec to use when publishing the video stream.
  final PreferredCodec? preferredCodec;

  /// The fmtp line for the video codec.
  final String? fmtpLine;

  /// The preferred bitrate to use when publishing the video stream.
  final int? preferredBitrate;

  /// The maximum number of simulcast layers to use when publishing the video stream.
  final int? maxSimulcastLayers;

  /// The preferred subscription (incoming video stream) codec.
  final PreferredCodec? subscriberCodec;

  /// The fmtp line for the subscriber codec.
  final String? subscriberFmtpLine;
}

enum PreferredCodec {
  vp8,
  h264,
  vp9,
  av1,
}
