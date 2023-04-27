import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
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

  /// Controls the visibility of [CallStatsContent].
  bool _isStatsVisible = false;

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
            onBackPressed: widget.onBackPressed,
            onLeaveCallTap: widget.onLeaveCallTap,
            overlayAppBarBuilder: widget.overlayAppBarBuilder,
          );
    } else {
      final isReconnecting = callState.status.isReconnecting;
      bodyWidget = Center(
        child: Row(
          children: [
            Text('${callState.callType}: '),
            Text(isReconnecting ? 'Reconnecting' : 'Connecting'),
          ],
        ),
      );
    }

    final localParticipant = callState.localParticipant;
    final isDesktopOrPortrait = !isMobileLandscape(context);

    return Scaffold(
      appBar: isDesktopOrPortrait
          ? widget.callAppBarBuilder?.call(context, call, callState) ??
              CallAppBar(
                call: call,
                onBackPressed: widget.onBackPressed,
              )
          : null,
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
      bottomNavigationBar: isDesktopOrPortrait && localParticipant != null
          ? widget.callControlsBuilder?.call(context, call, callState) ??
              StreamCallControls.withDefaultOptions(
                call: call,
                localParticipant: localParticipant,
                onLeaveCallTap: widget.onLeaveCallTap,
              )
          : null,
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  void _toggleStatsVisibility() {
    setState(() {
      _isStatsVisible = !_isStatsVisible;
    });
  }
}
