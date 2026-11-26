import 'dart:async';

import 'third_party/webrtc_interface/media_stream.dart';

/// Processes a local media stream before it is sent.
///
/// [apply] receives the captured stream and returns the stream to send in its
/// place. A filter that processes frames natively, inside the capture, can
/// return its input unchanged.
///
/// Extend [VideoFilter] or [AudioFilter] to write one.
abstract base class MediaStreamFilter {
  const MediaStreamFilter();

  /// Applies this filter to [input].
  ///
  /// Called for every new capture, and again on the capture in use when the
  /// chain the filter is part of changes. The returned
  /// [MediaStreamFilterResult.stop] is called when that capture is replaced or
  /// released, or the chain changes.
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input);
}

/// A [MediaStreamFilter] for camera and screen share video.
abstract base class VideoFilter extends MediaStreamFilter {
  const VideoFilter();
}

/// A [MediaStreamFilter] for microphone audio.
abstract base class AudioFilter extends MediaStreamFilter {
  const AudioFilter();
}

/// The local media a [MediaStreamFilter] runs on.
enum MediaStreamFilterSource {
  /// The camera.
  camera,

  /// The microphone.
  microphone,

  /// The screen share.
  screenShare,
}

/// What a [MediaStreamFilter] is applied to.
final class MediaStreamFilterInput {
  const MediaStreamFilterInput({required this.stream, required this.source});

  /// The stream to filter: the capture, or what the filter before this one
  /// made of it.
  final MediaStream stream;

  /// The local media [stream] comes from.
  final MediaStreamFilterSource source;
}

/// Why [MediaStreamFilterResult.stop] is called.
enum MediaStreamFilterStopReason {
  /// The capture the filter ran on is replaced by a new one.
  captureReplaced,

  /// The capture the filter ran on is stopped.
  captureReleased,

  /// The chain the filter is part of changed, and was applied again.
  chainChanged,

  /// What the filter made is not sent: a filter of the chain failed where it
  /// must apply, the new stream could not be sent, or the output had no track.
  rejected,
}

/// Details of a [MediaStreamFilterResult.stop] call.
final class MediaStreamFilterStopDetails {
  const MediaStreamFilterStopDetails({required this.reason});

  /// Why the filter is stopped.
  final MediaStreamFilterStopReason reason;
}

/// What a [MediaStreamFilter] made of its input.
final class MediaStreamFilterResult {
  const MediaStreamFilterResult(this.output, {this.stop});

  /// The stream to send in place of the input. The input stream itself when
  /// the filter processes frames in place.
  final MediaStream output;

  /// Undoes the filter and releases what it holds. When [output] is not the
  /// input stream, it stops [output] as well.
  final FutureOr<void> Function(MediaStreamFilterStopDetails details)? stop;
}
