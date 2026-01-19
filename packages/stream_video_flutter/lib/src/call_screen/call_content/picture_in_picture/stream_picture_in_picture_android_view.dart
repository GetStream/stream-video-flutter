import 'dart:async';

import 'package:flutter/material.dart';

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
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  final AndroidPipManager _androidPipManager = AndroidPipManager.instance();

  StreamSubscription<(CallStatus, bool?)>? _callStateSubscription;

  Call get call => widget.call;

  @override
  void initState() {
    super.initState();

    if (widget.configuration.enablePictureInPicture) {
      _setupPictureInPictureListener();
      _startListeningToCallState();
      _updatePictureInPictureAllowedState();
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
        _updatePictureInPictureAllowedState();
      } else {
        _cleanupPictureInPictureListener();
        _hideOverlay();
        _callStateSubscription?.cancel();
        _setPictureInPictureAllowed(false);
      }
    }

    if (widget.call != oldWidget.call) {
      _callStateSubscription?.cancel();
      _startListeningToCallState();
      _updatePictureInPictureAllowedState();
    }
  }

  @override
  void dispose() {
    if (widget.configuration.enablePictureInPicture) {
      _cleanupPictureInPictureListener();
      _setPictureInPictureAllowed(false);
    }

    _hideOverlay();
    _callStateSubscription?.cancel();
    super.dispose();
  }

  void _startListeningToCallState() {
    _callStateSubscription = call
        .partialState(
          (state) => (
            state.status,
            state.localParticipant?.isScreenShareEnabled,
          ),
        )
        .listen((_) => _updatePictureInPictureAllowedState());
  }

  void _updatePictureInPictureAllowedState() {
    final shouldAllow = _shouldAllowPictureInPicture();
    _setPictureInPictureAllowed(shouldAllow);
  }

  /// Updates the Android side about whether PiP should be allowed based on current call state
  Future<void> _setPictureInPictureAllowed(bool isAllowed) {
    return _androidPipManager.setPictureInPictureAllowed(isAllowed);
  }

  void _setupPictureInPictureListener() {
    _androidPipManager.addOnPictureInPictureModeChangedListener(
      _handlePictureInPictureModeChanged,
    );
  }

  void _handlePictureInPictureModeChanged(bool isInPictureInPictureMode) {
    if (isInPictureInPictureMode) {
      // Check if we should actually be in PiP mode
      if (_shouldAllowPictureInPicture()) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    } else {
      _hideOverlay();
    }
  }

  void _cleanupPictureInPictureListener() {
    _androidPipManager.removeOnPictureInPictureModeChangedListener(
      _handlePictureInPictureModeChanged,
    );
  }

  /// Shows the fullscreen PiP overlay
  void _showOverlay() {
    if (_isOverlayVisible || !mounted) return;

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => AndroidPipOverlay(
        call: call,
        pictureInPictureConfiguration: widget.configuration,
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
    // The build method is empty on purpose as the content of the call is shown using an `Overlay`
    // so we are sure to cover all existing widgets.
    return const SizedBox.shrink();
  }
}
