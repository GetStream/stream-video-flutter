import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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

  /// The params last offered to Android, and whether any have been. The
  /// first go out at once, so the window has a shape before anything has
  /// settled; later ones once they have held for [_paramsDebounceDuration].
  /// A renderer that has just mounted reports its size and its rotation as
  /// two events, and a moving tile moves every frame, so sending each change
  /// would reshape the window twice, or call Android every frame.
  ({Size? videoSize, Rect? sourceRectHint})? _offeredParams;
  bool _hasOfferedParams = false;
  Timer? _paramsDebounce;
  static const _paramsDebounceDuration = Duration(milliseconds: 100);

  /// The last size seen for the track the overlay shows, kept while no
  /// renderer of it reports one.
  String? _lastKnownTrackId;
  Size? _lastKnownSize;

  /// Bumped whenever tracking stops, so a check scheduled before then does
  /// not schedule another.
  int _trackingGeneration = 0;

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
      _startTrackingPictureInPictureParams();
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
        _startTrackingPictureInPictureParams();
        _updatePictureInPictureAllowedState();
      } else {
        _cleanupPictureInPictureListener();
        _hideOverlay();
        _callStateSubscription?.cancel();
        _stopTrackingPictureInPictureParams();
        _setPictureInPictureAllowed(false);
      }
    } else if (widget.configuration.enablePictureInPicture) {
      if (widget.call != oldWidget.call) {
        _stopTrackingPictureInPictureParams();
        _startTrackingPictureInPictureParams();
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
      _stopTrackingPictureInPictureParams();
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

  /// Starts sending Android the shape of the video the picture-in-picture
  /// window will show, and where it is drawn.
  void _startTrackingPictureInPictureParams() {
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
    _scheduleParamsCheck(_trackingGeneration);
  }

  void _stopTrackingPictureInPictureParams() {
    _trackingGeneration++;
    _participantsSubscription?.cancel();
    _participantsSubscription = null;
    _paramsDebounce?.cancel();
    _paramsDebounce = null;
    _offeredParams = null;
    _hasOfferedParams = false;
    _lastKnownTrackId = null;
    _lastKnownSize = null;
    _androidPipManager.clearPictureInPictureParams(owner: this);
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
  }

  /// The id of the track the overlay shows, or null when there is none or a
  /// custom builder decides what is shown.
  String? _pipTrackId() {
    final hasCustomBuilder =
        widget
            .configuration
            .androidPiPConfiguration
            .callPictureInPictureWidgetBuilder !=
        null;
    if (hasCustomBuilder) return null;

    final pipTrack = resolveAndroidPipTrack(
      sortedParticipants,
      widget.configuration.pipTrackPriority,
    );
    if (pipTrack == null) return null;

    return call
        .getTrack(pipTrack.participant.trackIdPrefix, pipTrack.trackType)
        ?.trackId;
  }

  /// Checks the params after each frame that is drawn anyway, never asking
  /// for one: what they are read from, the participants, the videos' sizes
  /// and where their tiles are laid out, all change with a frame.
  void _scheduleParamsCheck(int generation) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _trackingGeneration) return;
      _offerParams(_currentParams());
      _scheduleParamsCheck(generation);
    });
  }

  ({Size? videoSize, Rect? sourceRectHint}) _currentParams() {
    final trackId = _pipTrackId();
    var videoSize = trackId == null
        ? null
        : RenderedVideoSizes.instance.sizeOf(trackId);

    // A track keeps its size while no renderer shows it for a moment: on
    // entering picture-in-picture the call's tiles go before the overlay's
    // renderer has its first frame, and falling back in between would
    // reshape the window twice.
    if (videoSize != null) {
      _lastKnownTrackId = trackId;
      _lastKnownSize = videoSize;
    } else if (trackId != null && trackId == _lastKnownTrackId) {
      videoSize = _lastKnownSize;
    }

    // Laid out inside the small window in picture-in-picture; the area from
    // before is the one that matches the full-size layout it returns to.
    final sourceRectHint = _androidPipManager.isInPictureInPictureMode
        ? _offeredParams?.sourceRectHint
        : _sourceRectHintOf(trackId);

    return (videoSize: videoSize, sourceRectHint: sourceRectHint);
  }

  /// Where the track with [trackId] is drawn, in physical pixels, clipped to
  /// the view, so the window animates in from it instead of showing the
  /// app's icon until the overlay is drawn.
  Rect? _sourceRectHintOf(String? trackId) {
    final logicalRect = trackId == null
        ? null
        : RenderedVideoSizes.instance.screenRectOf(trackId);
    final view = View.maybeOf(context);
    if (logicalRect == null || view == null) return null;

    final pixelRatio = view.devicePixelRatio;
    final visible = Rect.fromLTRB(
      (logicalRect.left * pixelRatio).roundToDouble(),
      (logicalRect.top * pixelRatio).roundToDouble(),
      (logicalRect.right * pixelRatio).roundToDouble(),
      (logicalRect.bottom * pixelRatio).roundToDouble(),
    ).intersect(Offset.zero & view.physicalSize);
    // Off screen, the intersection is inverted, which counts as empty.
    return visible.isEmpty ? null : visible;
  }

  void _offerParams(({Size? videoSize, Rect? sourceRectHint}) params) {
    if (_hasOfferedParams && params == _offeredParams) return;

    final isFirst = !_hasOfferedParams;
    _hasOfferedParams = true;
    _offeredParams = params;
    _paramsDebounce?.cancel();

    void send() => _androidPipManager.setPictureInPictureParams(
      owner: this,
      videoSize: params.videoSize,
      sourceRectHint: params.sourceRectHint,
    );

    if (isFirst) return send();
    _paramsDebounce = Timer(_paramsDebounceDuration, send);
  }

  /// Shows the fullscreen PiP overlay
  void _showOverlay() {
    if (_isOverlayVisible || !mounted) return;

    // The root one, so nothing drawn over the call, such as a route on an
    // outer navigator, is drawn over the window.
    final overlay = Overlay.of(context, rootOverlay: true);

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
