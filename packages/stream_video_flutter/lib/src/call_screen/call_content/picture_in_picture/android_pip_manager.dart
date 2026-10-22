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

  /// The object that last set the aspect ratio, so that another one doesn't
  /// clear it by accident.
  Object? _aspectRatioOwner;

  /// Sets the shape of the picture-in-picture window to the aspect ratio of
  /// [videoSize] on behalf of [owner], updating the window if it is already
  /// showing.
  ///
  /// Pass null when the video's size is unknown, so the window falls back to
  /// the device's orientation. Android limits the ratio to between 1:2.39 and
  /// 2.39:1.
  Future<void> setPictureInPictureAspectRatio(
    Size? videoSize, {
    required Object owner,
  }) {
    _aspectRatioOwner = owner;
    return _sendAspectRatio(videoSize);
  }

  /// Falls back to the device's orientation for the window's shape, unless
  /// an object other than [owner] has set the aspect ratio since.
  Future<void> clearPictureInPictureAspectRatio({required Object owner}) async {
    if (!identical(_aspectRatioOwner, owner)) return;

    _aspectRatioOwner = null;
    return _sendAspectRatio(null);
  }

  Future<void> _sendAspectRatio(Size? videoSize) async {
    if (!CurrentPlatform.isAndroid) return;

    final hasSize =
        videoSize != null && videoSize.width > 0 && videoSize.height > 0;

    try {
      await _methodChannel.invokeMethod(
        'setPictureInPictureAspectRatio',
        hasSize
            ? {
                'width': videoSize.width.round(),
                'height': videoSize.height.round(),
              }
            : null,
      );
    } catch (e) {
      _logger.e(
        () =>
            '[setPictureInPictureAspectRatio] Failed to set picture in picture aspect ratio: $e',
      );
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
    }
  }
}
