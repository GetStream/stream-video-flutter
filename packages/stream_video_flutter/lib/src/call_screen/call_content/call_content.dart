import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../call_participants/layout/participant_layout_mode.dart';
import '../call_diagnostics_content/call_diagnostics_content.dart';

/// Builder used to create a custom call app bar.
typedef CallAppBarBuilder = PreferredSizeWidget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom call app bar in landscape mode.
typedef OverlayAppBarBuilder = Widget Function(
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
    this.callAppBarBuilder,
    this.overlayAppBarBuilder,
    this.callParticipantsBuilder,
    this.callControlsBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// Builder used to create a custom call app bar.
  final CallAppBarBuilder? callAppBarBuilder;

  /// Builder used to create a custom call app bar in landscape mode.
  final OverlayAppBarBuilder? overlayAppBarBuilder;

  /// Builder used to create a custom participants grid.
  final CallParticipantsBuilder? callParticipantsBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  @override
  State<StreamCallContent> createState() => _StreamCallContentState();
}

class _StreamCallContentState extends State<StreamCallContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  /// Controls the visibility of [CallDiagnosticsContent].
  bool _isStatsVisible = false;

  ParticipantLayoutMode _currentLayoutMode = ParticipantLayoutMode.grid;

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
            layoutMode: _currentLayoutMode,
          );
    } else {
      final isReconnecting = callState.status.isReconnecting;
      bodyWidget = Center(
        child: Text(isReconnecting ? 'Reconnecting' : 'Connecting'),
      );
    }

    final localParticipant = callState.localParticipant;

    return Scaffold(
      backgroundColor: const Color(0XFF272A30),
      appBar: widget.callAppBarBuilder?.call(context, call, callState) ??
          CallAppBar(
            call: call,
            onBackPressed: widget.onBackPressed,
            onLayoutModeChanged: (mode) {
              setState(() => _currentLayoutMode = mode);
            },
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
        ],
      ),
      bottomNavigationBar: localParticipant != null
          ? widget.callControlsBuilder?.call(context, call, callState) ??
              StreamCallControls.withDefaultOptions(
                call: call,
                localParticipant: localParticipant,
                onLeaveCallTap: widget.onLeaveCallTap,
              )
          : null,
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
