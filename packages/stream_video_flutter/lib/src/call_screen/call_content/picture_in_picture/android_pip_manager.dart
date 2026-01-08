import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart' show taggedLogger;

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
