import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_screen/call_diagnostics_content/call_diagnostics_content.dart';

class LivestreamContent extends StatefulWidget {
  const LivestreamContent({
    Key? key,
    required this.call,
    required this.callState,
    this.backButtonBuilder,
    this.displayDiagnostics = false,
  }) : super(key: key);

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  final WidgetBuilder? backButtonBuilder;

  final bool displayDiagnostics;

  @override
  State<LivestreamContent> createState() => _LivestreamContentState();
}

class _LivestreamContentState extends State<LivestreamContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  @override
  Widget build(BuildContext context) {
    final Widget bodyWidget;
    if (callState.status.isConnected) {
      final participant =
          callState.callParticipants.where((e) => e.isVideoEnabled).first;

      bodyWidget = StreamCallParticipant(
        // We use the sessionId as the key to avoid rebuilding the widget
        // when the participant changes.
        key: ValueKey(participant.sessionId),
        call: call,
        participant: participant,
        showConnectionQualityIndicator: false,
        showParticipantLabel: false,
        showSpeakerBorder: false,
        videoFit: VideoFit.contain,
      );
    } else {
      final isReconnecting = callState.status.isReconnecting;
      bodyWidget = Center(
        child: Text(isReconnecting ? 'Reconnecting' : 'Connecting'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0XFF272A30),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.backButtonBuilder?.call(context),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          bodyWidget,
          if (widget.displayDiagnostics)
            CallDiagnosticsContent(
              call: call,
            ),
        ],
      ),
    );
  }
}
