// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../call_diagnostics_content/call_diagnostics_content.dart';

typedef CallNotConnectedBuilder =
    Widget Function(
      BuildContext context,
      CallNotConnectedProperties properties,
    );

typedef CallFastReconnectingOverlayBuilder =
    Widget Function(
      BuildContext context,
      CallFastReconnectingProperties properties,
    );

class CallNotConnectedProperties {
  CallNotConnectedProperties(
    this.call, {
    required this.isMigrating,
    required this.isReconnecting,
  });

  final Call call;
  final bool isMigrating;
  final bool isReconnecting;
}

class CallFastReconnectingProperties {
  CallFastReconnectingProperties(this.call);

  final Call call;
}

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
    this.callAppBarWidgetBuilder,
    this.callParticipantsWidgetBuilder,
    this.callControlsWidgetBuilder,
    this.callNotConnectedBuilder,
    this.callFastReconnectingOverlayBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
    this.extendBody = false,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// Builder used to create a custom call app bar.
  final CallPreferredSizeWidgetBuilder? callAppBarWidgetBuilder;

  /// Builder used to create a custom participants grid.
  final CallWidgetBuilder? callParticipantsWidgetBuilder;

  /// Builder used to create a custom call controls panel.
  final CallWidgetBuilder? callControlsWidgetBuilder;

  /// Builder used to create a custom widget when the call is not connected.
  final CallNotConnectedBuilder? callNotConnectedBuilder;

  /// Builder used to create a custom widget when the call is fast reconnecting.
  final CallFastReconnectingOverlayBuilder? callFastReconnectingOverlayBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  /// If true participants view will be shown all the way to the bottom of the scaffold,
  /// meaning that the call controls for the local participants will be on top of the camera view.
  ///
  /// See also [Scaffold.extendBody].
  final bool extendBody;

  /// Configuration for picture-in-picture mode.
  final PictureInPictureConfiguration pictureInPictureConfiguration;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent> {
  /// Represents a call.
  Call get call => widget.call;

  late bool _isScreenShareEnabled;
  late CallStatus _status;

  StreamSubscription<({CallStatus status, bool isScreenShareEnabled})>?
  _callStateSubscription;

  /// Controls the visibility of [CallDiagnosticsContent].
  bool _isStatsVisible = false;

  @override
  void initState() {
    super.initState();
    _startListeningToCallState();
  }

  @override
  void didUpdateWidget(covariant StreamCallContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.call != oldWidget.call) {
      _callStateSubscription?.cancel();
      _startListeningToCallState();
    }
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    super.dispose();
  }

  void _startListeningToCallState() {
    final callState = call.state.value;
    _status = callState.status;
    _isScreenShareEnabled =
        callState.localParticipant?.isScreenShareEnabled ?? false;

    _callStateSubscription = call
        .partialState(
          (state) => (
            status: state.status,
            isScreenShareEnabled:
                state.localParticipant?.isScreenShareEnabled ?? false,
          ),
        )
        .listen(_updateCallState);
  }

  void _updateCallState(
    ({CallStatus status, bool isScreenShareEnabled}) callState,
  ) {
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
        (!widget
                .pictureInPictureConfiguration
                .disablePictureInPictureWhenScreenSharing ||
            !_isScreenShareEnabled);

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
                pictureInPictureConfiguration:
                    widget.pictureInPictureConfiguration,
              ),
            ),
          if (CurrentPlatform.isAndroid && pipEnabled)
            StreamPictureInPictureAndroidView(
              call: call,
              configuration: widget.pictureInPictureConfiguration,
            ),
          widget.callParticipantsWidgetBuilder?.call(context, call) ??
              StreamCallParticipants(
                call: call,
                layoutMode: widget.layoutMode,
              ),
        ],
      );
    } else {
      final isReconnecting = _status.isReconnecting;
      bodyWidget =
          widget.callNotConnectedBuilder?.call(
            context,
            CallNotConnectedProperties(
              call,
              isMigrating: _status.isMigrating,
              isReconnecting: isReconnecting,
            ),
          ) ??
          Center(
            child: Text(
              isReconnecting ? 'Reconnecting' : 'Connecting',
              style: theme.textTheme.title3,
            ),
          );
    }

    return Scaffold(
      backgroundColor: theme.callContentTheme.callContentBackgroundColor,
      appBar:
          widget.callAppBarWidgetBuilder?.call(context, call) ??
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
            widget.callFastReconnectingOverlayBuilder?.call(
                  context,
                  CallFastReconnectingProperties(call),
                ) ??
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
      extendBody: widget.extendBody,
      bottomNavigationBar: PartialCallStateBuilder(
        call: call,
        selector: (state) => state.localParticipant,
        builder: (_, localParticipant) => localParticipant != null
            ? widget.callControlsWidgetBuilder?.call(context, call) ??
                  StreamCallControls.withDefaultOptions(
                    call: call,
                  )
            : const SizedBox.shrink(),
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
