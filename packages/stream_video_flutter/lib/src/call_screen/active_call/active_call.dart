import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../stream_video_flutter.dart';
import '../../call_controls/call_controls.dart';
import '../../call_participants/call_participants.dart';
import '../../participants_info/call_participants_info_view.dart';
import '../../utils/device_segmentation.dart';
import 'active_call_app_bar.dart';

/// {@template callAppBarBuilder}
/// Builder used to create a custom call app bar.
/// {@endtemplate}
typedef CallAppBarWidgetBuilder = PreferredSizeWidget Function(
  BuildContext context,
  CallV2 call,
);

/// {@template callParticipantsBuilder}
/// Builder used to create a custom participants grid.
/// {@endtemplate}
typedef CallParticipantsWidgetBuilder = Widget Function(
  BuildContext context,
  List<CallParticipantStateV2> participants,
);

/// {@template callControlsBuilder}
/// Builder used to create a custom call controls panel.
/// {@endtemplate}
typedef CallControlsWidgetBuilder = Widget Function(
  BuildContext context,
  CallV2 call,
  List<CallParticipantStateV2> participants,
);

/// Represents the UI in an active call that shows participants and their video,
/// as well as some extra UI features to control the call settings, browse
/// participants and more.
class StreamActiveCall extends StatefulWidget {
  /// Creates a new instance of [StreamActiveCall].
  const StreamActiveCall({
    super.key,
    required this.call,
    required this.state,
    this.callAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.participantsInfoWidgetBuilder,
    this.onBackPressed,
    this.onHangUp,
    this.onParticipantsTap,
    this.enableFloatingView,
  });

  /// Represents a call.
  final CallV2 call;

  final CallStateV2 state;

  /// {@macro callParticipantWidgetBuilder}
  final CallAppBarWidgetBuilder? callAppBarBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantsWidgetBuilder? callParticipantsBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallControlsWidgetBuilder? callControlsBuilder;

  /// {@macro callParticipantsBuilder}
  final CallParticipantsInfoWidgetBuilder? participantsInfoWidgetBuilder;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action
  final VoidCallback? onHangUp;

  /// The action to perform when the participants button is tapped.
  final VoidCallback? onParticipantsTap;

  /// Enable floating participant in the call
  final bool? enableFloatingView;

  @override
  State<StreamActiveCall> createState() => _StreamActiveCallState();
}

class _StreamActiveCallState extends State<StreamActiveCall> {
  /// Represents a call.
  CallV2 get call => widget.call;

  @override
  void dispose() async {
    await widget.call.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participants = widget.state.callParticipants;

    final usersProvider = StreamUsersConfiguration.of(context);

    return Scaffold(
      appBar: widget.callAppBarBuilder?.call(context, call) ??
          ActiveCallAppBar(
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
              StreamCallControlsBar.withDefaultOptions(
                call: widget.call,
                onHangup: () async {
                  await widget.call.disconnect();
                  widget.onHangUp?.call();
                },
              ),
    );
  }
}
