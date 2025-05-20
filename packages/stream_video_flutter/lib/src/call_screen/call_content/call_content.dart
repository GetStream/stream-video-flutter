import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../../stream_video_flutter_background.dart';
import '../call_diagnostics_content/call_diagnostics_content.dart';

/// Builder used to create a custom call app bar.
typedef CallAppBarBuilder = PreferredSizeWidget? Function(
  BuildContext context,
  Call call,
);

/// Builder used to create a custom call participants widget.
typedef CallParticipantsBuilder = Widget Function(
  BuildContext context,
  Call call,
);

/// Builder used to create a custom call controls widget.
typedef CallControlsBuilder = Widget Function(
  BuildContext context,
  Call call,
);

/// Represents the UI in an active call that shows participants and their video,
/// as well as some extra UI features to control the call settings, browse
/// participants and more.
class StreamCallContent extends StatefulWidget {
  /// Creates a new instance of [StreamCallContent].
  const StreamCallContent({
    super.key,
    required this.call,
    this.onBackPressed,
    this.onLeaveCallTap,
    this.callAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// Builder used to create a custom call app bar.
  final CallAppBarBuilder? callAppBarBuilder;

  /// Builder used to create a custom participants grid.
  final CallParticipantsBuilder? callParticipantsBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  /// Configuration for picture-in-picture mode.
  final PictureInPictureConfiguration pictureInPictureConfiguration;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent>
    with WidgetsBindingObserver {
  /// Represents a call.
  Call get call => widget.call;

  late bool _isScreenShareEnabled;
  late CallStatus _status;

  late StreamSubscription<({CallStatus status, bool isScreenShareEnabled})>
      _callStateSubscription;

  /// Controls the visibility of [CallDiagnosticsContent].
  bool _isStatsVisible = false;

  /// Whether the picture in picture mode is on
  bool _isPictureInPictureModeOn = false;

  @override
  void initState() {
    super.initState();
    _startListeningToCallState();

    if (widget.pictureInPictureConfiguration.enablePictureInPicture) {
      StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: true);
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void didUpdateWidget(covariant StreamCallContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pictureInPictureConfiguration.enablePictureInPicture !=
        oldWidget.pictureInPictureConfiguration.enablePictureInPicture) {
      if (widget.pictureInPictureConfiguration.enablePictureInPicture) {
        StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: true);
        WidgetsBinding.instance.addObserver(this);
      } else {
        StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: false);
        WidgetsBinding.instance.removeObserver(this);
      }
    }

    if (widget.call != oldWidget.call) {
      _callStateSubscription.cancel();
      _startListeningToCallState();
    }
  }

  @override
  void dispose() {
    if (widget.pictureInPictureConfiguration.enablePictureInPicture) {
      StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: false);
      WidgetsBinding.instance.removeObserver(this);
    }
    _callStateSubscription.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isPictureInPictureModeOn = false;
      });
    } else if (state == AppLifecycleState.inactive) {
      setState(() {
        _isPictureInPictureModeOn = true;
      });
    }
  }

  void _startListeningToCallState() {
    final callState = call.state.value;
    _status = callState.status;
    _isScreenShareEnabled =
        callState.localParticipant?.isScreenShareEnabled ?? false;
    _callStateSubscription = call
        .listen(
          (call) => (
            status: call.status,
            isScreenShareEnabled:
                call.localParticipant?.isScreenShareEnabled ?? false
          ),
        )
        .listen(_updateCallState);
  }

  void _updateCallState(
      ({CallStatus status, bool isScreenShareEnabled}) callState) {
    // Disable PiP when screen sharing is enabled
    if (callState.isScreenShareEnabled != _isScreenShareEnabled) {
      if (widget.pictureInPictureConfiguration
          .disablePictureInPictureWhenScreenSharing) {
        StreamVideoFlutterBackground.setPictureInPictureEnabled(
          enable: widget.pictureInPictureConfiguration.enablePictureInPicture &&
              !callState.isScreenShareEnabled,
        );
      }
    }

    // Disable PiP when call is disconnected
    if (callState.status != _status) {
      if (callState.status.isDisconnected) {
        StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: false);
      }
    }

    setState(() {
      _status = callState.status;
      _isScreenShareEnabled = callState.isScreenShareEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    final pipEnabled =
        widget.pictureInPictureConfiguration.enablePictureInPicture &&
            (!widget.pictureInPictureConfiguration
                    .disablePictureInPictureWhenScreenSharing ||
                !_isScreenShareEnabled);

    if (pipEnabled && _isPictureInPictureModeOn && CurrentPlatform.isAndroid) {
      return widget.pictureInPictureConfiguration.androidPiPConfiguration
              .callPictureInPictureBuilder
              ?.call(context, call) ??
          StreamCallParticipants(
            call: call,
            layoutMode: ParticipantLayoutMode.pictureInPicture,
          );
    }

    final Widget bodyWidget;
    if (_status.isConnected ||
        _status.isFastReconnecting ||
        _status.isMigrating) {
      bodyWidget = Stack(
        children: [
          if (CurrentPlatform.isIos && pipEnabled)
            SizedBox(
              height: 600,
              width: 300,
              child: StreamPictureInPictureUiKitView(
                call: call,
                includeLocalParticipantVideo: widget
                    .pictureInPictureConfiguration
                    .iOSPiPConfiguration
                    .includeLocalParticipantVideo,
              ),
            ),
          RepaintBoundary(
            child: widget.callParticipantsBuilder?.call(
                  context,
                  call,
                ) ??
                StreamCallParticipants(
                  call: call,
                  layoutMode: widget.layoutMode,
                ),
          ),
        ],
      );
    } else {
      final isReconnecting = _status.isReconnecting;
      final statusText = isReconnecting ? 'Reconnecting' : 'Connecting';
      bodyWidget = Center(
        child: Text(
          statusText,
          style: theme.textTheme.title3,
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.callContentTheme.callContentBackgroundColor,
      appBar: widget.callAppBarBuilder?.call(context, call) ??
          CallAppBar(
            call: call,
            onBackPressed: widget.onBackPressed,
            onLeaveCallTap: widget.onLeaveCallTap,
          ),
      body: Stack(
        children: [
          GestureDetector(
            onDoubleTap: _toggleStatsVisibility,
            child: bodyWidget,
          ),
          Visibility(
            visible: _isStatsVisible,
            child: CallDiagnosticsContent(
              call: call,
              onClosePressed: _toggleStatsVisibility,
            ),
          ),
          if (_status.isFastReconnecting)
            const Positioned(
              top: 25,
              left: 25,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<CallParticipantState?>(
        stream: call.listen((s) => s.localParticipant),
        builder: (context, snapshot) {
          final localParticipant = snapshot.data;

          return localParticipant != null
              ? widget.callControlsBuilder?.call(context, call) ??
                  StreamCallControls.withDefaultOptions(
                    call: call,
                    localParticipant: localParticipant,
                  )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  void _toggleStatsVisibility() {
    if (kDebugMode) {
      setState(() {
        _isStatsVisible = !_isStatsVisible;
      });
    }
  }
}
