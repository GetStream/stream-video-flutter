import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../../stream_video_flutter_background.dart';
import '../call_diagnostics_content/call_diagnostics_content.dart';

/// Builder used to create a custom call app bar.
typedef CallAppBarBuilder = PreferredSizeWidget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom call app bar in landscape mode.
typedef OverlayAppBarBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom call participants widget.
typedef CallParticipantsBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom call controls widget.
typedef CallControlsBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

typedef CallPictureInPictureBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Represents the UI in an active call that shows participants and their video,
/// as well as some extra UI features to control the call settings, browse
/// participants and more.
class StreamCallContent extends StatefulWidget {
  /// Creates a new instance of [StreamCallContent].
  const StreamCallContent({
    super.key,
    required this.call,
    required this.callState,
    this.onBackPressed,
    this.onLeaveCallTap,
    this.callAppBarBuilder,
    this.overlayAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
    this.enablePictureInPicture = false,
    this.callPictureInPictureBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// Builder used to create a custom call app bar.
  final CallAppBarBuilder? callAppBarBuilder;

  /// Builder used to create a custom call app bar in landscape mode.
  final OverlayAppBarBuilder? overlayAppBarBuilder;

  /// Builder used to create a custom participants grid.
  final CallParticipantsBuilder? callParticipantsBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  /// Whether to enable picture-in-picture mode. (available only on Android)
  final bool enablePictureInPicture;

  /// Builder used to create a custom picture in picture mode. (available only on Android)
  final CallPictureInPictureBuilder? callPictureInPictureBuilder;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent>
    with WidgetsBindingObserver {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  /// Controls the visibility of [CallDiagnosticsContent].
  bool _isStatsVisible = false;

  /// Whether the picture in picture mode is on
  bool _isPictureInPictureModeOn = false;

  @override
  void initState() {
    super.initState();

    if (widget.enablePictureInPicture) {
      StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: true);
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void didUpdateWidget(covariant StreamCallContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enablePictureInPicture != oldWidget.enablePictureInPicture) {
      if (widget.enablePictureInPicture) {
        StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: true);
        WidgetsBinding.instance.addObserver(this);
      } else {
        StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: false);
        WidgetsBinding.instance.removeObserver(this);
      }
    }
  }

  @override
  void dispose() {
    if (widget.enablePictureInPicture) {
      StreamVideoFlutterBackground.setPictureInPictureEnabled(enable: false);
      WidgetsBinding.instance.removeObserver(this);
    }

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

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    if (_isPictureInPictureModeOn && CurrentPlatform.isAndroid) {
      return widget.callPictureInPictureBuilder
              ?.call(context, call, callState) ??
          StreamCallParticipants(
            call: call,
            participants: callState.callParticipants,
            layoutMode: ParticipantLayoutMode.pictureInPicture,
          );
    }

    final Widget bodyWidget;
    if (callState.status.isConnected || callState.status.isFastReconnecting) {
      bodyWidget = widget.callParticipantsBuilder?.call(
            context,
            call,
            callState,
          ) ??
          StreamCallParticipants(
            call: call,
            participants: callState.callParticipants,
            layoutMode: widget.layoutMode,
          );
    } else {
      final isMigrating = callState.status.isMigrating;
      final isReconnecting = callState.status.isReconnecting;
      final statusText = isMigrating
          ? 'Migrating'
          : isReconnecting
              ? 'Reconnecting'
              : 'Connecting';
      bodyWidget = Center(
        child: Text(
          statusText,
          style: theme.textTheme.title3,
        ),
      );
    }

    final localParticipant = callState.localParticipant;

    return Scaffold(
      backgroundColor: theme.callContentTheme.callContentBackgroundColor,
      appBar: widget.callAppBarBuilder?.call(context, call, callState) ??
          CallAppBar(
            call: call,
            onBackPressed: widget.onBackPressed,
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
          if (callState.status.isFastReconnecting)
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
      bottomNavigationBar: localParticipant != null
          ? widget.callControlsBuilder?.call(context, call, callState) ??
              StreamCallControls.withDefaultOptions(
                call: call,
                localParticipant: localParticipant,
                onLeaveCallTap: widget.onLeaveCallTap,
              )
          : null,
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
