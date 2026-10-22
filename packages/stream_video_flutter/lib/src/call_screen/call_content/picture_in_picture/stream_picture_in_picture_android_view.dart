import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../stream_video_flutter.dart';
import '../../../renderer/rendered_video_sizes.dart';
import 'android_pip_track.dart';

final _logger = taggedLogger(tag: 'SV:PictureInPictureAndroidView');

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
    extends State<StreamPictureInPictureAndroidView>
    with CallParticipantsSortingMixin {
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  final AndroidPipManager _androidPipManager = AndroidPipManager.instance();

  StreamSubscription<(CallStatus, bool?)>? _callStateSubscription;
  StreamSubscription<List<CallParticipantState>?>? _participantsSubscription;

  /// Whether a size has been sent to Android yet, and which one, so the same
  /// size isn't sent twice.
  bool _hasSentAspectRatio = false;
  Size? _sentAspectRatioSize;

  /// Holds a new size back until it settles. A renderer that has just mounted
  /// reports its size and its rotation as two events, and a replaced track
  /// briefly has no size, so sending each change would reshape the window
  /// twice.
  Timer? _aspectRatioDebounce;
  static const _aspectRatioDebounceDuration = Duration(milliseconds: 100);

  Call get call => widget.call;

  // The same participant order as [AndroidPipOverlay], so the window takes
  // the shape of the video the overlay shows.
  @override
  CallParticipantFilter<CallParticipantState>? get participantFilter => null;

  @override
  CallParticipantSort<CallParticipantState> get participantSort =>
      widget.configuration.sort ?? CallParticipantSorts.pictureInPicture;

  @override
  void initState() {
    super.initState();

    if (widget.configuration.enablePictureInPicture) {
      _setupPictureInPictureListener();
      _startListeningToCallState();
      _startTrackingAspectRatio();
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
        _startTrackingAspectRatio();
        _updatePictureInPictureAllowedState();
      } else {
        _cleanupPictureInPictureListener();
        _hideOverlay();
        _callStateSubscription?.cancel();
        _stopTrackingAspectRatio();
        _setPictureInPictureAllowed(false);
      }
    } else if (widget.configuration.enablePictureInPicture) {
      if (widget.call != oldWidget.call) {
        _stopTrackingAspectRatio();
        _startTrackingAspectRatio();
      } else if (!_androidPipManager.isInPictureInPictureMode) {
        // The sort, track priority or custom builder may have changed. Not
        // while the overlay is showing: it keeps the configuration it was
        // shown with and only re-sorts when the participants change, so
        // re-sorting here could pick a different participant.
        _recalculatePipTarget();
      }
    }

    if (widget.call != oldWidget.call) {
      _callStateSubscription?.cancel();
      _startListeningToCallState();
      _updatePictureInPictureAllowedState();

      // The entry draws the overlay for the call this widget holds, and
      // nothing else asks it to build again.
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    if (widget.configuration.enablePictureInPicture) {
      _cleanupPictureInPictureListener();
      _stopTrackingAspectRatio();
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
    // The overlay starts sorting afresh when it's shown, so start afresh here
    // too to pick the same participant.
    clearParticipantSortingCache();
    _recalculatePipTarget();

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

  /// Starts sending Android the aspect ratio of the video that the
  /// picture-in-picture window will show.
  void _startTrackingAspectRatio() {
    RenderedVideoSizes.instance.addListener(_sendAspectRatio);

    // A custom `participantsThrottleIntervalResolver` that throws surfaces as
    // an error here; without `onError` it would reach the zone uncaught.
    _participantsSubscription = call.participantsStream.listen(
      _recalculatePipTarget,
      onError: (Object error, StackTrace stackTrace) {
        _logger.e(
          () =>
              '[StreamPictureInPictureAndroidView] participantsStream error: '
              '$error; $stackTrace',
        );
      },
    );

    clearParticipantSortingCache();
    _recalculatePipTarget();
  }

  void _stopTrackingAspectRatio() {
    RenderedVideoSizes.instance.removeListener(_sendAspectRatio);
    _participantsSubscription?.cancel();
    _participantsSubscription = null;
    _aspectRatioDebounce?.cancel();
    _aspectRatioDebounce = null;
    _hasSentAspectRatio = false;
    _sentAspectRatioSize = null;
    _androidPipManager.clearPictureInPictureAspectRatio(owner: this);
  }

  void _recalculatePipTarget([List<CallParticipantState>? participants]) {
    // Outside picture-in-picture, sort afresh each time, as the overlay would
    // if it were shown now. Inside it, keep the order the overlay keeps.
    if (!_androidPipManager.isInPictureInPictureMode) {
      clearParticipantSortingCache();
    }
    recalculateParticipants(
      participants ?? call.state.value.callParticipants,
    );
    _sendAspectRatio();
  }

  /// Sends Android the size of the video the overlay shows, or null when it
  /// is unknown or a custom builder decides what is shown.
  void _sendAspectRatio() {
    final hasCustomBuilder =
        widget
            .configuration
            .androidPiPConfiguration
            .callPictureInPictureWidgetBuilder !=
        null;

    final pipTrack = hasCustomBuilder
        ? null
        : resolveAndroidPipTrack(
            sortedParticipants,
            widget.configuration.pipTrackPriority,
          );

    final trackId = pipTrack == null
        ? null
        : call
              .getTrack(pipTrack.participant.trackIdPrefix, pipTrack.trackType)
              ?.trackId;
    final size = trackId == null
        ? null
        : RenderedVideoSizes.instance.sizeOf(trackId);

    _aspectRatioDebounce?.cancel();
    _aspectRatioDebounce = null;
    if (_hasSentAspectRatio && size == _sentAspectRatioSize) return;

    // The first value goes out at once, so the window has a shape before
    // anything has settled.
    if (!_hasSentAspectRatio) return _commitAspectRatio(size);

    _aspectRatioDebounce = Timer(
      _aspectRatioDebounceDuration,
      () => _commitAspectRatio(size),
    );
  }

  void _commitAspectRatio(Size? size) {
    _aspectRatioDebounce = null;
    _hasSentAspectRatio = true;
    _sentAspectRatioSize = size;
    _androidPipManager.setPictureInPictureAspectRatio(size, owner: this);
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
