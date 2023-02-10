import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../participants_info/call_participants_info_view.dart';
import '../../utils/device_segmentation.dart';
import 'call_app_bar.dart';

/// Builder used to create a custom call app bar.
typedef CallAppBarWidgetBuilder = PreferredSizeWidget Function(
  BuildContext context,
  CallV2 call,
);

/// Builder used to create a custom participants grid.
typedef CallParticipantsWidgetBuilder = Widget Function(
  BuildContext context,
  List<CallParticipantStateV2> participants,
);

/// Builder used to create a custom call controls panel.
typedef CallControlsWidgetBuilder = Widget Function(
  BuildContext context,
  CallV2 call,
  List<CallParticipantStateV2> participants,
);

/// Represents the UI in an active call that shows participants and their video,
/// as well as some extra UI features to control the call settings, browse
/// participants and more.
class StreamCallContent extends StatefulWidget {
  /// Creates a new instance of [StreamCallContent].
  const StreamCallContent({
    super.key,
    required this.call,
    required this.state,
    this.callAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.participantsInfoWidgetBuilder,
    this.onBackPressed,
    this.onLeaveCall,
    this.onParticipantsTap,
    this.enableFloatingView,
  });

  /// Represents a call.
  final CallV2 call;

  final CallStateV2 state;

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

  /// The action to perform when the leave call button is pressed.
  final VoidCallback? onLeaveCall;

  /// The action to perform when the participants button is pressed.
  final VoidCallback? onParticipantsTap;

  /// Enable floating participant in the call.
  final bool? enableFloatingView;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent> {
  /// Represents a call.
  CallV2 get call => widget.call;

  @override
  Future<void> dispose() async {
    await widget.call.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participants = widget.state.callParticipants;
    final localParticipant = widget.state.localParticipant;
    final usersProvider = StreamUsersConfiguration.of(context);

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
                          StreamCallParticipantsInfoView(
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
            enableFloatingView: widget.enableFloatingView ?? !isDesktopDevice,
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
  }
}
