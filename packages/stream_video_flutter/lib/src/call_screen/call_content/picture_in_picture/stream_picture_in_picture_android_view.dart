import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../stream_video_flutter.dart';

/// Android implementation of Picture-in-Picture functionality.
/// This widget handles all PiP logic internally and provides a clean interface
/// similar to the iOS StreamPictureInPictureUiKitView.
class StreamPictureInPictureAndroidView extends StatefulWidget {
  const StreamPictureInPictureAndroidView({
    super.key,
    required this.call,
    required this.configuration,
  });

  final Call call;
  final PictureInPictureConfiguration configuration;

  @override
  State<StreamPictureInPictureAndroidView> createState() =>
      _StreamPictureInPictureAndroidViewState();
}

class _StreamPictureInPictureAndroidViewState
    extends State<StreamPictureInPictureAndroidView> {
  static const String _pipChannel = 'stream_video_flutter_android_pip';
  static const MethodChannel _methodChannel = MethodChannel(_pipChannel);

  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

  StreamSubscription<CallStatus>? _callStateSubscription;

  Call get call => widget.call;

  @override
  void initState() {
    super.initState();

    if (widget.configuration.enablePictureInPicture) {
      _setupPictureInPictureListener();
      _startListeningToCallState();
    }
  }

  @override
  void didUpdateWidget(covariant StreamPictureInPictureAndroidView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.configuration.enablePictureInPicture !=
        oldWidget.configuration.enablePictureInPicture) {
      if (widget.configuration.enablePictureInPicture) {
        _setupPictureInPictureListener();
        _startListeningToCallState();
      } else {
        _cleanupPictureInPictureListener();
        _hideOverlay();
        _callStateSubscription?.cancel();
      }
    }

    if (widget.call != oldWidget.call) {
      _callStateSubscription?.cancel();
      _startListeningToCallState();
    }
  }

  @override
  void dispose() {
    if (widget.configuration.enablePictureInPicture) {
      _cleanupPictureInPictureListener();
    }

    _hideOverlay();
    _callStateSubscription?.cancel();
    super.dispose();
  }

  void _startListeningToCallState() {
    _callStateSubscription = call
        .partialState(
      (state) => state.status,
    )
        .listen((status) {
      if (status.isDisconnected) {
        disablePictureInPictureMode();
      }
    });
  }

  void _setupPictureInPictureListener() {
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPictureInPictureModeChanged':
        final isInPictureInPictureMode = call.arguments as bool;
        _handlePictureInPictureModeChanged(isInPictureInPictureMode);
        break;
    }
  }

  /// Disables Picture-in-Picture mode if currently active
  Future<void> disablePictureInPictureMode() async {
    _hideOverlay();
    await _methodChannel.invokeMethod('disablePictureInPictureMode');
  }

  void _handlePictureInPictureModeChanged(bool isInPictureInPictureMode) {
    if (isInPictureInPictureMode) {
      // Check if we should actually be in PiP mode
      if (_shouldAllowPictureInPicture()) {
        _showOverlay();
      } else {
        disablePictureInPictureMode();
      }
    } else {
      _hideOverlay();
    }
  }

  void _cleanupPictureInPictureListener() {
    _methodChannel.setMethodCallHandler(null);
  }

  /// Shows the fullscreen PiP overlay
  void _showOverlay() {
    if (_isOverlayVisible || !mounted) return;

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => AndroidPipOverlay(
        call: call,
        sort: widget.configuration.sort,
        customBuilder: widget.configuration.androidPiPConfiguration
            .callPictureInPictureWidgetBuilder,
      ),
    );

    overlay.insert(_overlayEntry!);
    _isOverlayVisible = true;
  }

  /// Hides the PiP overlay
  void _hideOverlay() {
    if (!_isOverlayVisible || _overlayEntry == null) return;

    _overlayEntry!.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
  }

  bool _shouldAllowPictureInPicture() {
    // Only proceed if PiP is enabled in configuration
    if (!widget.configuration.enablePictureInPicture) {
      return false;
    }

    // Check if we're in an active call
    final callState = call.state.value;
    final isInCall = callState.status.isConnected;

    // Check if screen sharing is active and should disable PiP
    final isScreenSharing =
        callState.localParticipant?.isScreenShareEnabled ?? false;
    final shouldDisableForScreenShare =
        widget.configuration.disablePictureInPictureWhenScreenSharing &&
            isScreenSharing;

    return isInCall && !shouldDisableForScreenShare;
  }

  @override
  Widget build(BuildContext context) {
    // This widget doesn't render anything visible - it just manages PiP state
    // Similar to how iOS StreamPictureInPictureUiKitView works
    return const SizedBox.shrink();
  }
}
