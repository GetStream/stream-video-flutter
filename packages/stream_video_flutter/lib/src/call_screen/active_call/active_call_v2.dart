import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../stream_video_flutter.dart';
import '../../call_controls/call_controls_v2.dart';
import '../../call_participants/call_participants_v2.dart';
import '../../participants_info/call_participants_info_view_v2.dart';
import '../../utils/device_segmentation.dart';
import 'active_call_app_bar_v2.dart';

/// {@template callAppBarBuilder}
/// Builder used to create a custom call app bar.
/// {@endtemplate}
typedef CallAppBarWidgetBuilderV2 = PreferredSizeWidget Function(
  BuildContext context,
  CallV2 call,
);

/// {@template callParticipantsBuilder}
/// Builder used to create a custom participants grid.
/// {@endtemplate}
typedef CallParticipantsWidgetBuilderV2 = Widget Function(
  BuildContext context,
  List<CallParticipantStateV2> participants,
);

/// {@template callControlsBuilder}
/// Builder used to create a custom call controls panel.
/// {@endtemplate}
typedef CallControlsWidgetBuilderV2 = Widget Function(
  BuildContext context,
  CallV2 call,
  List<CallParticipantStateV2> participants,
);

/// Represents the UI in an active call that shows participants and their video,
/// as well as some extra UI features to control the call settings, browse
/// participants and more.
class StreamActiveCallV2 extends StatefulWidget {
  /// Creates a new instance of [StreamActiveCall].
  const StreamActiveCallV2({
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
  final CallAppBarWidgetBuilderV2? callAppBarBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantsWidgetBuilderV2? callParticipantsBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallControlsWidgetBuilderV2? callControlsBuilder;

  /// {@macro callParticipantsBuilder}
  final CallParticipantsInfoWidgetBuilderV2? participantsInfoWidgetBuilder;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action
  final VoidCallback? onHangUp;

  /// The action to perform when the participants button is tapped.
  final VoidCallback? onParticipantsTap;

  /// Enable floating participant in the call
  final bool? enableFloatingView;

  @override
  State<StreamActiveCallV2> createState() => _StreamActiveCallStateV2();
}

class _StreamActiveCallStateV2 extends State<StreamActiveCallV2> {
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
          ActiveCallAppBarV2(
            call: call,
            onBackPressed: widget.onBackPressed,
            onParticipantsTap: widget.onParticipantsTap ??
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          widget.participantsInfoWidgetBuilder
                              ?.call(context, call) ??
                          StreamCallParticipantsInfoViewV2(
                            call: call,
                            usersProvider: usersProvider,
                          ),
                    ),
                  );
                },
          ),
      body: widget.callParticipantsBuilder?.call(context, participants) ??
          StreamCallParticipantsV2(
            call: call,
            participants: participants,
            enableFloatingView: widget.enableFloatingView ?? !isDesktopDevice,
          ),
      bottomNavigationBar:
          widget.callControlsBuilder?.call(context, call, participants) ??
              StreamCallControlsBarV2.withDefaultOptions(
                call: widget.call,
                onHangup: () async {
                  await widget.call.disconnect();
                  widget.onHangUp?.call();
                },
              ),
    );
  }
}
