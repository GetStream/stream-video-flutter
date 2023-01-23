import 'package:flutter/material.dart';

import '../stream_video_flutter.dart';

/// {@template callAppBarBuilder}
/// Builder used to create a custom call app bar.
/// {@endtemplate}
typedef CallAppBarWidgetBuilder = PreferredSizeWidget Function(
  BuildContext context,
  Call call,
);

/// {@template callParticipantsBuilder}
/// Builder used to create a custom participants grid.
/// {@endtemplate}
typedef CallParticipantsWidgetBuilder = Widget Function(
  BuildContext context,
  List<Participant> participants,
);

/// {@template callControlsBuilder}
/// Builder used to create a custom call controls panel.
/// {@endtemplate}
typedef CallControlsWidgetBuilder = Widget Function(
  BuildContext context,
  Call call,
  List<Participant> participants,
);

/// Represents the UI in an active call that shows participants and their video,
/// as well as some extra UI features to control the call settings, browse
/// participants and more.
class StreamActiveCall extends StatefulWidget {
  /// Creates a new instance of [StreamActiveCall].
  const StreamActiveCall({
    super.key,
    required this.call,
    this.callAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
    this.onBackPressed,
    this.onHangUp,
    this.onParticipantsTap,
    this.enableFloatingView,
  });

  /// Represents a call.
  final Call call;

  /// {@macro callParticipantWidgetBuilder}
  final CallAppBarWidgetBuilder? callAppBarBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantsWidgetBuilder? callParticipantsBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallControlsWidgetBuilder? callControlsBuilder;

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
  /// A handler to remove the listener.
  Function? _cancelListener;

  /// Represents a call.
  Call get call => widget.call;

  List<Participant> participants = [];

  void _onParticipantUpdate() {
    participants = [
      ...widget.call.participants.values,
      if (widget.call.localParticipant != null) widget.call.localParticipant!,
    ];

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _onParticipantUpdate();
    _cancelListener = widget.call.events.listen((_) {
      _onParticipantUpdate();
    });
  }

  @override
  void dispose() async {
    _cancelListener?.call();
    await widget.call.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.callAppBarBuilder?.call(context, call) ??
          StreamCallAppBar(
            call: call,
            onBackPressed: widget.onBackPressed,
            onParticipantsTap: widget.onParticipantsTap,
          ),
      body: widget.callParticipantsBuilder?.call(context, participants) ??
          StreamCallParticipants(
            participants: participants,
            enableFloatingView: widget.enableFloatingView ?? true,
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
