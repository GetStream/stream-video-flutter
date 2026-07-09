import 'video_element.dart';

/// Fallback used when no web implementation is selected (i.e. this code is
/// being compiled/run outside a web target). `stream_video_jaspr` only
/// supports client-rendered (browser) targets, so this should never be
/// reached at runtime.
StreamVideoElement createVideoElement() {
  throw UnsupportedError(
    'VideoTrackRenderer is only supported when compiled for the web '
    '(Jaspr client rendering mode).',
  );
}
