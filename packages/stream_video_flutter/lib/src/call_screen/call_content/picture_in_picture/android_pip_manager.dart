import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../stream_video_flutter.dart';

class AndroidPipManager {
  factory AndroidPipManager.instance() {
    return _instance ??= AndroidPipManager._();
  }

  AndroidPipManager._() {
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  static const String _pipChannel = 'stream_video_flutter_android_pip';
  static const MethodChannel _methodChannel = MethodChannel(_pipChannel);

  static AndroidPipManager? _instance;

  final _logger = taggedLogger(tag: 'SV:AndroidPipManager');

  final List<ValueChanged<bool>> _onPictureInPictureModeChangedListeners = [];

  bool _isInPictureInPictureMode = false;
  bool get isInPictureInPictureMode => _isInPictureInPictureMode;

  void addOnPictureInPictureModeChangedListener(ValueChanged<bool> listener) {
    _onPictureInPictureModeChangedListeners.add(listener);
  }

  void removeOnPictureInPictureModeChangedListener(
    ValueChanged<bool> listener,
  ) {
    _onPictureInPictureModeChangedListeners.remove(listener);
  }

  /// Updates the Android side about whether PiP should be allowed based on current call state
  Future<void> setPictureInPictureAllowed(bool isAllowed) async {
    if (!CurrentPlatform.isAndroid) return;

    try {
      await _methodChannel.invokeMethod(
        'setPictureInPictureAllowed',
        isAllowed,
      );
    } catch (e) {
      _logger.e(
        () =>
            '[_setPictureInPictureAllowed] Failed to set picture in picture allowed: $e',
      );
    }
  }

  // The params each view last set, in the order they set them. The last
  // one is the one Android has, so when it goes, the one before it takes
  // over.
  final _paramsByOwner = <Object, _PictureInPictureParams>{};

  // What was last sent, so the same isn't sent twice.
  _PictureInPictureParams? _sentParams;

  // Set once the channel turns out to have no handler, as without the
  // SDK's Android activities, so a value sent every frame doesn't log every
  // frame. Cleared when an activity attaches one.
  bool _isChannelMissing = false;

  /// Sets the shape of the picture-in-picture window, and the area it
  /// animates in from, on behalf of [owner], updating the window if it is
  /// already showing. The last owner to set them is the one Android gets.
  ///
  /// The window takes the aspect ratio of [videoSize], within Android's limit
  /// of 1:2.39 to 2.39:1, or the device's orientation's when it is null. It
  /// animates in from [sourceRectHint], where that video is drawn, in
  /// physical pixels relative to the Flutter view, rather than showing the
  /// app's icon until the app draws again.
  ///
  /// Only the SDK's picture-in-picture view calls this. It re-offers its own
  /// params after every change, so a value set from elsewhere would not last.
  @internal
  Future<void> setPictureInPictureParams({
    required Object owner,
    Size? videoSize,
    Rect? sourceRectHint,
  }) {
    _paramsByOwner
      ..remove(owner)
      ..[owner] = (videoSize: videoSize, sourceRectHint: sourceRectHint);
    return _sendParams();
  }

  /// Forgets the params [owner] set, so the owner before it, if any, has
  /// them sent instead, or the window falls back to the device's
  /// orientation and no area to animate from.
  @internal
  Future<void> clearPictureInPictureParams({required Object owner}) {
    if (_paramsByOwner.remove(owner) == null) return Future.value();
    return _sendParams();
  }

  /// Forgets every view's params and what was sent, as a fresh app would
  /// start. For tests.
  @internal
  void debugResetPictureInPictureParams() {
    _paramsByOwner.clear();
    _sentParams = null;
    _isChannelMissing = false;
  }

  Future<void> _sendParams() async {
    final params =
        _paramsByOwner.values.lastOrNull ??
        (videoSize: null, sourceRectHint: null);
    if (params == _sentParams) return;
    _sentParams = params;

    final (:videoSize, sourceRectHint: hint) = params;
    await _invokeParamsMethod('setPictureInPictureParams', {
      if (videoSize != null) ...{
        'width': videoSize.width.round(),
        'height': videoSize.height.round(),
      },
      if (hint != null) ...{
        'left': hint.left.round(),
        'top': hint.top.round(),
        'right': hint.right.round(),
        'bottom': hint.bottom.round(),
      },
    });
  }

  Future<void> _invokeParamsMethod(String method, Object? arguments) async {
    if (!CurrentPlatform.isAndroid || _isChannelMissing) return;

    try {
      await _methodChannel.invokeMethod(method, arguments);
    } on MissingPluginException catch (e) {
      _isChannelMissing = true;
      _logger.w(
        () =>
            '[$method] No picture-in-picture handler, as the activity does '
            'not extend StreamFlutterActivity; not sending again: $e',
      );
    } catch (e) {
      _logger.e(() => '[$method] Failed: $e');
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPictureInPictureModeChanged':
        final isInPictureInPictureMode = call.arguments as bool;
        _isInPictureInPictureMode = isInPictureInPictureMode;

        for (final listener in _onPictureInPictureModeChangedListeners) {
          listener(isInPictureInPictureMode);
        }

        break;
      case 'onPictureInPictureHandlerAttached':
        // An activity attached to this engine, without the params the one
        // before it had, and the channel works now if it didn't.
        _sentParams = null;
        _isChannelMissing = false;
        await _sendParams();

        break;
    }
  }
}

typedef _PictureInPictureParams = ({Size? videoSize, Rect? sourceRectHint});
