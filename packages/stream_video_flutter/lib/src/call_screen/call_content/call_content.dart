// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

typedef CallNotConnectedBuilder =
    Widget Function(
      BuildContext context,
      CallNotConnectedProperties properties,
    );

class CallNotConnectedProperties {
  CallNotConnectedProperties(this.call);

  final Call call;
}

typedef CallConnectionBannerBuilder =
    Widget Function(
      BuildContext context,
      CallConnectionBannerProperties properties,
    );

/// What [StreamCallContent.callConnectionBannerBuilder] builds a banner
/// from.
class CallConnectionBannerProperties {
  CallConnectionBannerProperties(this.call, {required this.status});

  final Call call;

  /// The call's status, which the banner is rebuilt for when it changes.
  final CallStatus status;
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
    this.callConnectionBannerBuilder,
    this.layoutMode = ParticipantLayoutMode.auto,
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

  /// Builder used to create a custom widget in place of the participants
  /// before the call first connects.
  final CallNotConnectedBuilder? callNotConnectedBuilder;

  /// Builder used to create a custom banner, drawn at the top of the body,
  /// that says what the connection is doing. Built for every status,
  /// connected included. Defaults to [StreamCallConnectionBanner].
  final CallConnectionBannerBuilder? callConnectionBannerBuilder;

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

  final _androidPipManager = AndroidPipManager.instance();
  late bool _isInPictureInPictureMode =
      _androidPipManager.isInPictureInPictureMode;

  StreamSubscription<({CallStatus status, bool isScreenShareEnabled})>?
  _callStateSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToCallState();

    _androidPipManager.addOnPictureInPictureModeChangedListener(
      _handlePictureInPictureModeChanged,
    );
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
    _androidPipManager.removeOnPictureInPictureModeChangedListener(
      _handlePictureInPictureModeChanged,
    );
    super.dispose();
  }

  void _handlePictureInPictureModeChanged(bool isInPictureInPictureMode) {
    setState(() {
      _isInPictureInPictureMode = isInPictureInPictureMode;
    });
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

  static bool _hasLocalParticipant(CallState state) =>
      state.localParticipant != null;

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
    // A reconnect keeps the participants: their media keeps playing until the
    // call is connected again, or until it has left after giving up.
    if (_status.isConnected ||
        _status.isReconnecting ||
        _status.isMigrating ||
        _status is CallStatusReconnectionFailed) {
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
          if (!_isInPictureInPictureMode)
            widget.callParticipantsWidgetBuilder?.call(context, call) ??
                StreamCallParticipants(
                  call: call,
                  layoutMode: widget.layoutMode,
                ),
        ],
      );
    } else {
      bodyWidget =
          widget.callNotConnectedBuilder?.call(
            context,
            CallNotConnectedProperties(call),
          ) ??
          const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor:
          theme.callContentTheme.callContentBackgroundColor ??
          context.streamColorScheme.backgroundApp,
      appBar:
          widget.callAppBarWidgetBuilder?.call(context, call) ??
          // `Scaffold` reserves `preferredSize.height` and adds the top inset
          // itself, and the bar cannot read a themed height without a context —
          // so the height a `CallAppBarTheme` sets is measured out here.
          PreferredSize(
            preferredSize: Size.fromHeight(
              CallAppBar.heightOf(context, primary: false),
            ),
            child: CallAppBar(
              call: call,
              onBackPressed: widget.onBackPressed,
              onLeaveCallTap: widget.onLeaveCallTap,
            ),
          ),
      // The app bar and the controls clear the top and bottom insets; this
      // clears the sides, where a rail or a cutout can sit in landscape.
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            bodyWidget,
            // The picture-in-picture window is too small to show it over.
            if (!_isInPictureInPictureMode)
              Align(
                alignment: Alignment.topCenter,
                child:
                    widget.callConnectionBannerBuilder?.call(
                      context,
                      CallConnectionBannerProperties(call, status: _status),
                    ) ??
                    StreamCallConnectionBanner(call: call),
              ),
          ],
        ),
      ),
      extendBody: widget.extendBody,
      bottomNavigationBar: PartialCallStateBuilder<bool>(
        call: call,
        selector: _hasLocalParticipant,
        builder: (_, hasLocalParticipant) => hasLocalParticipant
            ? widget.callControlsWidgetBuilder?.call(context, call) ??
                  StreamCallControls.withDefaultOptions(
                    call: call,
                  )
            : const SizedBox.shrink(),
      ),
    );
  }
}
