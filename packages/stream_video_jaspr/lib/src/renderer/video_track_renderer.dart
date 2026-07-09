import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart' show MediaStream;

import 'video_element.dart';

/// Renders a raw [MediaStream] into a `<video>` element.
///
/// The underlying `<video>` element is created via [StreamVideoElement]
/// (`dart_webrtc`-backed on web) and manually appended to a stable host
/// `<div>` (keyed with a [GlobalNodeKey]) rather than rendered through
/// Jaspr's virtual DOM.
/// Because the video element lives outside Jaspr's tree, the reconciler
/// never touches it on rebuild, so playback stays uninterrupted across
/// parent rebuilds — Jaspr's own DOM diffing is not equipped to preserve a
/// live `srcObject` assignment across re-renders of a `<video>` tag.
class VideoTrackRenderer extends StatefulComponent {
  const VideoTrackRenderer({
    required this.mediaStream,
    this.mirror = false,
    this.objectFit = 'cover',
    super.key,
  });

  final MediaStream mediaStream;
  final bool mirror;

  /// CSS `object-fit` value, e.g. `'cover'` or `'contain'`.
  final String objectFit;

  @override
  State<VideoTrackRenderer> createState() => _VideoTrackRendererState();
}

class _VideoTrackRendererState extends State<VideoTrackRenderer> {
  final _hostKey = GlobalNodeKey<web.HTMLDivElement>();
  final _videoElement = createVideoElement();
  bool _attached = false;

  @override
  void initState() {
    super.initState();
    _videoElement.htmlElement.style
      ..width = '100%'
      ..height = '100%'
      ..display = 'block';
    _applyProps();
    _videoElement.srcObject = component.mediaStream;
    context.binding.addPostFrameCallback(_attach);
  }

  void _applyProps() {
    _videoElement.objectFit = component.objectFit;
    _videoElement.htmlElement.style.transform = component.mirror
        ? 'scaleX(-1)'
        : '';
  }

  void _attach() {
    if (_attached) return;
    final host = _hostKey.currentNode;
    if (host == null) {
      // Not mounted on this frame yet — try again on the next one.
      context.binding.addPostFrameCallback(_attach);
      return;
    }
    host.appendChild(_videoElement.htmlElement);
    _attached = true;
  }

  @override
  void didUpdateComponent(VideoTrackRenderer oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.mediaStream != component.mediaStream) {
      _videoElement.srcObject = component.mediaStream;
    }
    _applyProps();
  }

  @override
  void dispose() {
    _videoElement.srcObject = null;
    _videoElement.htmlElement.remove();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(
      key: _hostKey,
      styles: Styles(width: 100.percent, height: 100.percent),
      const [],
    );
  }
}
