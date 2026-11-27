import 'dart:async';
import 'dart:developer' as developer;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:stream_dart_webrtc/stream_dart_webrtc.dart'
    show MediaStreamTrackWeb, MediaStreamWeb;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:web/web.dart' as web;

import 'browser_effect.dart';
import 'web_video_filters_options.dart';

/// Whether this browser can run the background effects, as
/// `isMediaPipePlatformSupported` of `@stream-io/video-filters-web` says.
/// False when the module cannot be loaded.
///
/// Checked once per module and flags: the check creates a WebGL context, and
/// browsers drop their oldest context when too many are created.
Future<bool> isBrowserEffectSupported(WebVideoFiltersOptions options) {
  final key = (
    options.moduleUrl,
    options.forceSafariSupport,
    options.forceMobileSupport,
  );
  return _supported[key] ??= _checkSupported(options);
}

final _supported = <(String, bool, bool), Future<bool>>{};

Future<bool> _checkSupported(WebVideoFiltersOptions options) async {
  try {
    final module = await _load(options.moduleUrl);
    final supported = await module
        .isMediaPipePlatformSupported(
          _SupportFlags(
            forceSafariSupport: options.forceSafariSupport,
            forceMobileSupport: options.forceMobileSupport,
          ),
        )
        .toDart;
    return supported.toDart;
  } catch (e) {
    _log('Video effects are not available: $e');
    // A module that failed to load is tried again on the next check.
    unawaited(
      _supported.remove((
        options.moduleUrl,
        options.forceSafariSupport,
        options.forceMobileSupport,
      )),
    );
    return false;
  }
}

/// Runs [effect] on the video track of [input], and returns a stream with
/// the processed track.
///
/// The background effects on one track share a processor and its output
/// stream: applying another one changes the effect on the next frame, and
/// stopping one goes back to the latest one still applied. The processor and
/// its track stop shortly after the last of them, see [_stopDelay].
///
/// Throws [UnsupportedError] for a background effect where
/// [isBrowserEffectSupported] is false.
Future<rtc.MediaStreamFilterResult> applyBrowserEffect(
  rtc.MediaStreamFilterInput input,
  BrowserEffect effect,
  WebVideoFiltersOptions options,
) async {
  final videoTrack = input.stream.getVideoTracks().firstOrNull;
  if (videoTrack == null) return rtc.MediaStreamFilterResult(input.stream);
  final track = (videoTrack as MediaStreamTrackWeb).jsTrack;

  return switch (effect) {
    BrowserFullFrameBlur() => _applyFullFrameBlur(track, options),
    BrowserBackgroundBlur(:final level) => _applyBackground(
      track,
      options,
      _BackgroundEffect.blur(level),
    ),
    BrowserBackgroundImage(:final imageUrl) => _applyBackground(
      track,
      options,
      await _BackgroundEffect.ofImage(imageUrl),
    ),
  };
}

Future<rtc.MediaStreamFilterResult> _applyFullFrameBlur(
  web.MediaStreamTrack track,
  WebVideoFiltersOptions options,
) async {
  final module = await _load(options.moduleUrl);
  final processor = module.fullScreenBlur.callAsConstructor<_Processor>(
    track,
    JSObject(),
    _hooks(),
  );
  final web.MediaStreamTrack output;
  try {
    output = await processor.start().toDart;
  } catch (_) {
    _stop(processor);
    rethrow;
  }
  return rtc.MediaStreamFilterResult(
    MediaStreamWeb(web.MediaStream([output].toJS), 'local'),
    stop: (_) => Timer(_stopDelay, () {
      _stop(processor);
      output.stop();
    }),
  );
}

/// How long a processor runs on after its filter is stopped.
///
/// A video element showing a track that ends turns black, so the processor
/// waits for what showed its output to move to the stream that replaces it.
const _stopDelay = Duration(seconds: 1);

/// The background processors, by the id of the track they run on.
final _backgrounds = <String, Future<_SharedBackground>>{};

Future<rtc.MediaStreamFilterResult> _applyBackground(
  web.MediaStreamTrack track,
  WebVideoFiltersOptions options,
  _BackgroundEffect effect,
) async {
  final _SharedBackground background;
  try {
    if (!await isBrowserEffectSupported(options)) {
      throw UnsupportedError(
        'Video effects are not supported in this browser',
      );
    }
    final running = await _backgrounds[track.id];
    if (running != null && !running.stopped) {
      background = running..cancelStop();
      await background.processor.updateOptions(effect.options).toDart;
    } else {
      final starting = _SharedBackground.start(track, options, effect);
      _backgrounds[track.id] = starting;
      try {
        background = await starting;
      } catch (_) {
        if (identical(_backgrounds[track.id], starting)) {
          unawaited(_backgrounds.remove(track.id));
        }
        rethrow;
      }
    }
  } catch (_) {
    effect.release();
    rethrow;
  }

  background.effects.add(effect);
  return rtc.MediaStreamFilterResult(
    background.stream,
    stop: (_) => background.remove(effect),
  );
}

/// One processor running on [trackId], with the effects applied to it in
/// order; the last one runs.
class _SharedBackground {
  _SharedBackground._(this.trackId, this.processor, this.output)
    : stream = MediaStreamWeb(web.MediaStream([output].toJS), 'local');

  static Future<_SharedBackground> start(
    web.MediaStreamTrack track,
    WebVideoFiltersOptions options,
    _BackgroundEffect effect,
  ) async {
    final module = await _load(options.moduleUrl);
    final processor = module.createVirtualBackground(
      track,
      _BackgroundOptions(
        basePath: options.basePath,
        modelPath: options.modelPath,
        backgroundFilter: effect.filter,
        backgroundBlurLevel: effect.blurLevel,
        backgroundImage: effect.image,
      ),
      _hooks(),
    );
    try {
      final output = await processor.start().toDart;
      return _SharedBackground._(track.id, processor, output);
    } catch (_) {
      _stop(processor);
      rethrow;
    }
  }

  final String trackId;
  final _BackgroundProcessor processor;
  final web.MediaStreamTrack output;
  final rtc.MediaStream stream;
  final effects = <_BackgroundEffect>[];

  /// Whether the processor stopped.
  bool stopped = false;

  /// Stops the processor once [_stopDelay] passed, unless an effect is
  /// applied again before.
  Timer? _stopTimer;

  /// Keeps the processor running for an effect applied while its stop waits.
  void cancelStop() {
    _stopTimer?.cancel();
    _stopTimer = null;
  }

  /// Removes [effect]. Runs the latest effect left, or stops the processor
  /// after [_stopDelay] when none is.
  Future<void> remove(_BackgroundEffect effect) async {
    final wasRunning = identical(effects.lastOrNull, effect);
    if (!effects.remove(effect)) return;

    if (effects.isEmpty) {
      cancelStop();
      _stopTimer = Timer(_stopDelay, () => unawaited(_stopNow()));
    } else if (wasRunning) {
      try {
        await processor.updateOptions(effects.last.options).toDart;
      } catch (e) {
        _log('Could not restore the previous video effect: $e');
      }
    }
    effect.release();
  }

  Future<void> _stopNow() async {
    stopped = true;
    _stopTimer = null;
    _stop(processor);
    output.stop();
    final current = await _backgrounds[trackId]?.then<_SharedBackground?>(
      (background) => background,
      onError: (Object _) => null,
    );
    if (identical(current, this)) unawaited(_backgrounds.remove(trackId));
  }
}

/// A background effect: a blur, or an image.
class _BackgroundEffect {
  _BackgroundEffect._(this.filter, {this.blurLevel, this.image, this.assetUrl});

  _BackgroundEffect.blur(String level) : this._('blur', blurLevel: level);

  /// An image effect. An asset is handed over as a blob URL, released with
  /// [release].
  static Future<_BackgroundEffect> ofImage(String imageUrl) async {
    final assetUrl = _isUrl(imageUrl)
        ? null
        : await _objectUrlOfAsset(imageUrl);
    return _BackgroundEffect._(
      'image',
      image: assetUrl ?? imageUrl,
      assetUrl: assetUrl,
    );
  }

  final String filter;
  final String? blurLevel;
  final String? image;
  final String? assetUrl;

  _BackgroundEffectOptions get options => _BackgroundEffectOptions(
    backgroundFilter: filter,
    backgroundBlurLevel: blurLevel,
    backgroundImage: image,
  );

  void release() {
    if (assetUrl case final url?) web.URL.revokeObjectURL(url);
  }
}

/// Stops [processor] and releases the WebGL context it drew on.
///
/// The browser keeps a stopped processor's context until it is garbage
/// collected, and drops its oldest contexts when too many are alive, such as
/// the one the app or a video renders with.
void _stop(_Processor processor) {
  final canvas = processor.canvas;
  processor.stop();
  final gl = canvas?.getContext('webgl2');
  if (gl == null) return;
  gl
      .callMethod<JSObject?>('getExtension'.toJS, 'WEBGL_lose_context'.toJS)
      ?.callMethod<JSAny?>('loseContext'.toJS);
}

_Hooks _hooks() => _Hooks(
  onError: ((JSAny? error) => _log('Video effect failed: $error')).toJS,
);

/// Whether [imageUrl] is a URL rather than an asset key.
bool _isUrl(String imageUrl) => Uri.tryParse(imageUrl)?.hasScheme ?? false;

/// A `blob:` URL of the asset [key], read through [rootBundle]. Null when
/// there is no such asset, and [key] is then used as a URL.
Future<String?> _objectUrlOfAsset(String key) async {
  final ByteData data;
  try {
    data = await rootBundle.load(key);
  } catch (_) {
    return null;
  }
  final blob = web.Blob([data.buffer.asUint8List().toJS].toJS);
  return web.URL.createObjectURL(blob);
}

final _modules = <String, Future<_FiltersModule>>{};

/// The module at [url], loaded once. A failed load is tried again on the
/// next call.
Future<_FiltersModule> _load(String url) => _modules[url] ??= _import(url);

Future<_FiltersModule> _import(String url) async {
  try {
    return await importModule(url.toJS).toDart as _FiltersModule;
  } catch (_) {
    unawaited(_modules.remove(url));
    rethrow;
  }
}

void _log(String message) {
  developer.log(message, name: 'stream_video_filters');
}

/// The exports of `@stream-io/video-filters-web` used here.
extension type _FiltersModule(JSObject _) implements JSObject {
  external JSPromise<JSBoolean> isMediaPipePlatformSupported(
    _SupportFlags flags,
  );

  external _BackgroundProcessor createVirtualBackground(
    web.MediaStreamTrack track,
    _BackgroundOptions options,
    _Hooks hooks,
  );

  @JS('FullScreenBlur')
  external JSFunction get fullScreenBlur;
}

extension type _SupportFlags._(JSObject _) implements JSObject {
  external factory _SupportFlags({
    bool forceSafariSupport,
    bool forceMobileSupport,
  });
}

extension type _BackgroundOptions._(JSObject _) implements JSObject {
  external factory _BackgroundOptions({
    String? basePath,
    String? modelPath,
    String backgroundFilter,
    String? backgroundBlurLevel,
    String? backgroundImage,
  });
}

extension type _BackgroundEffectOptions._(JSObject _) implements JSObject {
  external factory _BackgroundEffectOptions({
    String backgroundFilter,
    String? backgroundBlurLevel,
    String? backgroundImage,
  });
}

extension type _Hooks._(JSObject _) implements JSObject {
  external factory _Hooks({JSFunction onError});
}

/// A `FullScreenBlur`, or the base of a `BackgroundProcessor`.
extension type _Processor(JSObject _) implements JSObject {
  external JSPromise<web.MediaStreamTrack> start();

  external void stop();

  /// The canvas the processor draws on, once started. Absent where it runs
  /// in a worker.
  external web.OffscreenCanvas? get canvas;
}

/// A `BackgroundProcessor`.
extension type _BackgroundProcessor(JSObject _) implements _Processor {
  external JSPromise<JSAny?> updateOptions(_BackgroundEffectOptions options);
}
