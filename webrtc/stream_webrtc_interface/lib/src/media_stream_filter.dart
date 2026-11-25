import 'dart:async';

import 'third_party/webrtc_interface/media_stream.dart';

/// Processes a local media stream before it is sent.
///
/// [apply] receives the captured stream and returns the stream to send in its
/// place. A filter that processes frames natively, inside the capture, can
/// return its input unchanged.
abstract class MediaStreamFilter {
  const MediaStreamFilter();

  /// Applies this filter to [input].
  ///
  /// Called once for every new capture. The returned
  /// [MediaStreamFilterResult.stop] is called when that capture is replaced,
  /// stopped or the filter is removed.
  Future<MediaStreamFilterResult> apply(MediaStream input);
}

/// A [MediaStreamFilter] for camera and screen share video.
abstract class VideoFilter extends MediaStreamFilter {
  const VideoFilter();
}

/// A [MediaStreamFilter] for microphone audio.
abstract class AudioFilter extends MediaStreamFilter {
  const AudioFilter();
}

/// What a [MediaStreamFilter] made of its input.
class MediaStreamFilterResult {
  const MediaStreamFilterResult(this.output, {this.stop});

  /// The stream to send in place of the input. The input itself when the
  /// filter processes frames in place.
  final MediaStream output;

  /// Undoes the filter and releases what it holds. When [output] is not the
  /// input, it stops [output] as well.
  final FutureOr<void> Function()? stop;
}
