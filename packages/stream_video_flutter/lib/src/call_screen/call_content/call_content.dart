import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../participants_info/call_participants_info_menu.dart';
import '../../utils/device_segmentation.dart';

/// Builder used to create a custom call app bar.
typedef CallAppBarWidgetBuilder = PreferredSizeWidget Function(
  BuildContext context,
  Call call,
);

/// Builder used to create a custom participants grid.
typedef CallParticipantsWidgetBuilder = Widget Function(
  BuildContext context,
  List<CallParticipantState> participants,
);

/// Builder used to create a custom call controls panel.
typedef CallControlsWidgetBuilder = Widget Function(
  BuildContext context,
  Call call,
  List<CallParticipantState> participants,
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
    this.callAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.participantsInfoWidgetBuilder,
    this.onBackPressed,
    this.onCancelPressed,
    this.onLeaveCall,
    this.onParticipantsTap,
    this.enableLocalVideo,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// Builder used to create a custom call app bar.
  final CallAppBarWidgetBuilder? callAppBarBuilder;

  /// Builder used to create a custom participants grid.
  final CallParticipantsWidgetBuilder? callParticipantsBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsWidgetBuilder? callControlsBuilder;

  /// Builder used to create a custom participants info screen.
  final CallParticipantsInfoWidgetBuilder? participantsInfoWidgetBuilder;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the cancel button is tapped.
  final VoidCallback? onCancelPressed;

  /// The action to perform when the leave call button is pressed.
  final VoidCallback? onLeaveCall;

  /// The action to perform when the participants button is pressed.
  final VoidCallback? onParticipantsTap;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  @override
  Future<void> dispose() async {
    super.dispose();
    await widget.call.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = StreamUsersConfiguration.of(context);
    final participants = callState.callParticipants;
    final localParticipant = callState.localParticipant;

    if (callState.status.isConnected) {
      return Scaffold(
        appBar: widget.callAppBarBuilder?.call(context, call) ??
            CallAppBar(
              call: call,
              onBackPressed: widget.onBackPressed,
              onParticipantsTap: widget.onParticipantsTap ??
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            widget.participantsInfoWidgetBuilder
                                ?.call(context, call) ??
                            StreamCallParticipantsInfoMenu(
                              call: call,
                              usersProvider: usersProvider,
                            ),
                      ),
                    );
                  },
            ),
        body: widget.callParticipantsBuilder?.call(context, participants) ??
            StreamCallParticipants(
              call: call,
              participants: participants,
              enableLocalVideo: widget.enableLocalVideo ?? !isDesktopDevice,
            ),
        bottomNavigationBar:
            widget.callControlsBuilder?.call(context, call, participants) ??
                StreamCallControls.withDefaultOptions(
                  call: widget.call,
                  localParticipant: localParticipant!,
                  onLeaveCall: () async {
                    await widget.call.disconnect();
                    widget.onLeaveCall?.call();
                  },
                ),
      );
    } else {
      final callCid = callState.callCid.value;
      final theme = StreamVideoTheme.of(context);

      return Scaffold(
        appBar: AppBar(
          elevation: 8,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colorTheme.textHighEmphasis,
            ),
            onPressed: widget.onCancelPressed,
          ),
          backgroundColor: theme.colorTheme.barsBg,
          centerTitle: false,
          title: Text(
            callCid,
            style: theme.textTheme.title3Bold,
            overflow: TextOverflow.visible,
          ),
        ),
        body: const Center(
          child: Text('Connecting'),
        ),
      );
    }
  }
}
