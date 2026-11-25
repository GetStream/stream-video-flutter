import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

import 'audio_playback_watchdog.dart';
import 'third_party/dart_webrtc/media_stream_track_impl.dart';

/// The id of the hidden element that holds the remote audio elements.
const audioContainerId = 'stream_audio_container';

/// The prefix of a remote audio element's id; the renderer's id follows it.
const audioElementPrefix = 'stream_audio_';

/// Creates the renderer that plays a remote audio track in an audio element
/// whose id ends in [id].
RTCAudioRenderer createAudioRenderer(
  String id, {
  AudioRendererTraceHandler? onTrace,
}) {
  return WebAudioRenderer(id, onTrace: onTrace);
}

/// Mutes or unmutes every remote audio renderer, including the ones created
/// later while [paused] is set.
///
/// Uses the element's `muted` flag rather than pausing it, so playback keeps
/// running (and is not recovered) and resumes in sync.
Future<void> setAudioPlayoutPaused(bool paused) async {
  WebAudioRenderer._playoutPaused = paused;
  for (final renderer in WebAudioRenderer._live) {
    renderer.muted = paused;
  }
}

/// An [RTCAudioRenderer] on an audio element in the [audioContainerId]
/// container.
@internal
class WebAudioRenderer implements RTCAudioRenderer {
  WebAudioRenderer(this.id, {this.onTrace}) {
    _live.add(this);
  }

  /// The renderers not disposed yet.
  static final _live = <WebAudioRenderer>{};

  /// Whether remote audio playout is paused, see [setAudioPlayoutPaused].
  static bool _playoutPaused = false;

  @override
  final String id;

  final AudioRendererTraceHandler? onTrace;

  web.HTMLAudioElement? _element;
  MediaStreamTrack? _track;
  AudioPlaybackWatchdog? _watchdog;
  bool _disposed = false;

  bool _blocked = false;
  final _blockedController = StreamController<bool>.broadcast(sync: true);

  @override
  MediaStreamTrack? get track => _track;

  @override
  bool get isAttached => _element?.srcObject != null;

  @override
  bool isAttachedTo(MediaStreamTrack track) {
    final attached = _track;
    if (attached is! MediaStreamTrackWeb || track is! MediaStreamTrackWeb) {
      return identical(attached, track);
    }
    return attached.jsTrack.strictEquals(track.jsTrack).toDart;
  }

  @override
  void attach(MediaStreamTrack track) {
    if (_disposed || track is! MediaStreamTrackWeb) return;

    final element = _element ??= _createElement();
    final stream = web.MediaStream()..addTrack(track.jsTrack);
    element.srcObject = stream;
    _track = track;

    // `autoplay` alone fails silently when the browser's autoplay policy
    // blocks playback, so drive `play()` explicitly and watch the element.
    _watchdog?.dispose();
    _watchdog = AudioPlaybackWatchdog(
      trackId: id,
      element: _HtmlPlaybackElement(element),
      isBlocked: () => _blocked,
      markBlocked: () => _setBlocked(true),
      markUnblocked: () => _setBlocked(false),
      onTrace: onTrace,
    );
  }

  web.HTMLAudioElement _createElement() {
    final elementId = audioElementPrefix + id;
    final existing = web.document.getElementById(elementId);
    final element = existing != null && existing.isA<web.HTMLAudioElement>()
        ? existing as web.HTMLAudioElement
        : (web.HTMLAudioElement()
            ..id = elementId
            ..autoplay = true);
    if (existing == null) _findOrCreateContainer().append(element);
    element.muted = _playoutPaused;
    return element;
  }

  @override
  void detach() {
    // Dispose first, so the detach is not reported as an outage.
    _watchdog?.dispose();
    _watchdog = null;
    _element?.srcObject = null;
  }

  @override
  bool get muted => _element?.muted ?? _playoutPaused;

  @override
  set muted(bool muted) => _element?.muted = muted;

  @override
  Future<void> setSinkId(String deviceId) async {
    final element = _element;
    if (element == null || !element.hasProperty('setSinkId'.toJS).toDart) {
      throw UnsupportedError(
        'Audio output device change is not supported on this browser.',
      );
    }
    await element.setSinkId(deviceId).toDart;
  }

  @override
  bool get isBlocked => _blocked;

  @override
  Stream<bool> get playbackBlocked => _blockedController.stream;

  /// Returns whether the blocked state changed.
  bool _setBlocked(bool blocked) {
    if (_blocked == blocked) return false;
    _blocked = blocked;
    _blockedController.add(blocked);
    return true;
  }

  @override
  bool get isRecovering => _watchdog?.isRecovering ?? false;

  @override
  Future<void> resume() => _watchdog?.resume() ?? Future.value();

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _live.remove(this);

    _watchdog?.dispose();
    _watchdog = null;
    _setBlocked(false);
    await _blockedController.close();

    final element = _element;
    _element = null;
    if (element != null) {
      element.srcObject = null;
      element.remove();
    }
  }
}

web.HTMLDivElement _findOrCreateContainer() {
  final existing = web.document.getElementById(audioContainerId);
  if (existing != null) return existing as web.HTMLDivElement;

  final div = web.HTMLDivElement()
    ..id = audioContainerId
    ..style.display = 'none';
  web.document.body?.append(div);
  return div;
}

/// A [PlaybackElement] on an audio element.
class _HtmlPlaybackElement implements PlaybackElement {
  _HtmlPlaybackElement(this._element);

  final web.HTMLAudioElement _element;

  JSFunction? _onPauseOrSuspend;
  JSFunction? _onPlaying;

  @override
  Future<void> play() => _element.play().toDart;

  @override
  bool get hasSource => _element.srcObject != null;

  @override
  bool get ended => _element.ended;

  @override
  bool get paused => _element.paused;

  @override
  int get readyState => _element.readyState;

  /// Whether [error] is a `NotAllowedError`, which the autoplay policy throws
  /// until the page gets a user gesture.
  @override
  bool isAutoplayBlocked(Object error) {
    if (error is JSObject) {
      final name = error.getProperty<JSString?>('name'.toJS)?.toDart;
      if (name != null) return name == 'NotAllowedError';
    }

    return '$error'.contains('NotAllowedError');
  }

  @override
  void listen({
    required void Function(String type) onPauseOrSuspend,
    required void Function() onPlaying,
  }) {
    final pauseOrSuspend = _onPauseOrSuspend = ((web.Event event) {
      onPauseOrSuspend(event.type);
    }).toJS;
    final playing = _onPlaying = ((web.Event _) => onPlaying()).toJS;

    _element.addEventListener('pause', pauseOrSuspend);
    _element.addEventListener('suspend', pauseOrSuspend);
    _element.addEventListener('playing', playing);
  }

  @override
  void unlisten() {
    final pauseOrSuspend = _onPauseOrSuspend;
    if (pauseOrSuspend != null) {
      _element.removeEventListener('pause', pauseOrSuspend);
      _element.removeEventListener('suspend', pauseOrSuspend);
    }
    final playing = _onPlaying;
    if (playing != null) _element.removeEventListener('playing', playing);
    _onPauseOrSuspend = null;
    _onPlaying = null;
  }
}
