import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';
import '../common/ringing_call_details.dart';
import '../common/ringing_call_style_defaults.dart';
import 'outgoing_call_controls.dart';

/// Represents the Outgoing Call state and UI, when the user is calling
/// other people.
class StreamOutgoingCallContent extends StatefulWidget {
  /// Creates a new instance of [StreamOutgoingCallContent].
  const StreamOutgoingCallContent({
    super.key,
    required this.call,
    this.onCancelCallTap,
    this.onMicrophoneTap,
    this.onCameraTap,
    this.style,
    this.controller,
    this.callBackgroundWidgetBuilder,
    this.participantsAvatarWidgetBuilder,
    this.participantsDisplayNameWidgetBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the cancel call button is tapped.
  final VoidCallback? onCancelCallTap;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback? onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback? onCameraTap;

  /// Overrides for this screen alone.
  ///
  /// Resolved over [StreamOutgoingCallTheme], so setting one property here
  /// leaves the rest coming from the theme.
  final StreamRingingCallStyle? style;

  /// The camera the screen previews and the call is placed with.
  ///
  /// When null the screen makes one for [call] and disposes of it itself.
  /// Supply one to keep the preview running across a screen the host rebuilds,
  /// or to drive the camera from outside this widget.
  final StreamRingingCameraController? controller;

  /// Builder used to create a custom widget for participants avatars.
  final CallWidgetBuilderWithData<ParticipantsData>?
  participantsAvatarWidgetBuilder;

  /// Builder used to create a custom widget for participants display names.
  final CallWidgetBuilderWithData<ParticipantsData>?
  participantsDisplayNameWidgetBuilder;

  /// A widget that is placed behind the outgoing call UI instead of the Stream
  /// default.
  ///
  /// The default draws the caller's own camera behind a blur and a scrim.
  /// Preferably use a [Stack] widget to layer your UI like in the default
  /// [RingingCallBackground].
  final CallWidgetChildBuilder? callBackgroundWidgetBuilder;

  @override
  State<StreamOutgoingCallContent> createState() =>
      _StreamOutgoingCallContentState();
}

class _StreamOutgoingCallContentState extends State<StreamOutgoingCallContent> {
  StreamRingingCameraController? _ownedController;

  StreamRingingCameraController get _controller =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    _createOwnedController();
  }

  @override
  void didUpdateWidget(StreamOutgoingCallContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.call != oldWidget.call) {
      _disposeOwnedController();
      _createOwnedController();
    }
  }

  @override
  void dispose() {
    _disposeOwnedController();
    super.dispose();
  }

  void _createOwnedController() {
    if (widget.controller != null) return;
    _ownedController = StreamRingingCameraController(call: widget.call)
      ..addListener(_onControllerChanged);
  }

  void _disposeOwnedController() {
    _ownedController
      ?..removeListener(_onControllerChanged)
      ..dispose();
    _ownedController = null;
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final style = _StreamOutgoingCallStyleDefaults(
      context,
      StreamOutgoingCallTheme.of(context).style?.merge(widget.style) ??
          widget.style,
    );

    Widget buildContent(List<UserInfo> participants) {
      final child = Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: RingingCallDetails(
                  participants: participants,
                  status: context.translations.ringingCalling,
                  style: style,
                  avatar: widget.participantsAvatarWidgetBuilder?.call(
                    context,
                    widget.call,
                    ParticipantsData(participants: participants),
                  ),
                  nameLine: widget.participantsDisplayNameWidgetBuilder?.call(
                    context,
                    widget.call,
                    ParticipantsData(participants: participants),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: style.controlsPadding,
                  child: OutgoingCallControls(
                    style: style,
                    isMicrophoneEnabled: _controller.microphoneEnabled,
                    isCameraEnabled: _controller.cameraEnabled,
                    onCancelCallTap: () => _onCancelCallTap(context),
                    onMicrophoneTap: _onMicrophoneTap,
                    onCameraTap: _onCameraTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      return widget.callBackgroundWidgetBuilder?.call(
            context,
            widget.call,
            child,
          ) ??
          RingingCallBackground(
            style: style,
            cameraTrack: _controller.cameraTrack,
            child: child,
          );
    }

    return PartialCallStateBuilder(
      call: widget.call,
      selector: (state) =>
          state.ringingMembers.map((e) => e.toUserInfo()).toList(),
      builder: (_, members) => buildContent(members),
    );
  }

  Future<void> _onCancelCallTap(BuildContext context) async {
    if (widget.onCancelCallTap != null) {
      widget.onCancelCallTap!();
    } else {
      await widget.call.reject(reason: CallRejectReason.cancel());
    }
  }

  void _onMicrophoneTap() {
    if (widget.onMicrophoneTap != null) {
      widget.onMicrophoneTap!();
    } else {
      _controller.toggleMicrophone();
    }
  }

  void _onCameraTap() {
    if (widget.onCameraTap != null) {
      widget.onCameraTap!();
    } else {
      unawaited(_controller.toggleCamera());
    }
  }
}

// Default style values for [StreamOutgoingCallContent].
//
// The screen is drawn on top of the caller's own camera, so its text is the
// text used on an image rather than on a surface.
class _StreamOutgoingCallStyleDefaults extends RingingCallStyleDefaults {
  _StreamOutgoingCallStyleDefaults(super.context, super.style);

  @override
  Color get backgroundColor =>
      style?.backgroundColor ?? colorScheme.backgroundApp;

  @override
  TextStyle get titleTextStyle =>
      style?.titleTextStyle ??
      textTheme.headingLg.copyWith(color: colorScheme.textOnAccent);

  @override
  TextStyle get statusTextStyle =>
      style?.statusTextStyle ??
      textTheme.bodyDefault.copyWith(color: colorScheme.textOnAccent);
}
