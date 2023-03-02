import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Builder used to create a custom call app bar.
typedef CallAppBarBuilder = PreferredSizeWidget Function(
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
    this.onParticipantsInfoTap,
    this.callAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.participantsInfoBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// The action to perform when the participants button is pressed.
  final VoidCallback? onParticipantsInfoTap;

  /// Builder used to create a custom call app bar.
  final CallAppBarBuilder? callAppBarBuilder;

  /// Builder used to create a custom participants grid.
  final CallParticipantsBuilder? callParticipantsBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  /// Builder used to create a custom participants info screen.
  final CallParticipantsInfoBuilder? participantsInfoBuilder;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  @override
  Widget build(BuildContext context) {
    final Widget bodyWidget;
    if (callState.status.isConnected) {
      bodyWidget = widget.callParticipantsBuilder?.call(
            context,
            call,
            callState,
          ) ??
          StreamCallParticipants(
            call: call,
            participants: callState.callParticipants,
            enableLocalVideo: !isDesktopDevice,
          );
    } else {
      bodyWidget = const Center(
        child: Text('Connecting'),
      );
    }

    return Scaffold(
      appBar: !isMobileLandscape(context)
          ? widget.callAppBarBuilder?.call(context, call, callState) ??
              CallAppBar(
                call: call,
                onBackPressed: widget.onBackPressed,
                onParticipantsInfoTap: widget.onParticipantsInfoTap,
                participantsInfoBuilder: widget.participantsInfoBuilder,
              )
          : null,
      body: bodyWidget,
      bottomNavigationBar: !isMobileLandscape(context)
          ? widget.callControlsBuilder?.call(context, call, callState) ??
              StreamCallControls.withDefaultOptions(
                call: call,
                localParticipant: callState.localParticipant!,
                onLeaveCallTap: widget.onLeaveCallTap,
              )
          : null,
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await call.disconnect();
  }
}
