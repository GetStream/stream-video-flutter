import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_screen/call_diagnostics_content/call_diagnostics_content.dart';

/// The video renderer widget associated with [LivestreamPlayer].
///
/// This widget also contains a diagnostic widget that can be used by
/// double-tapping the whole widget.
///
/// Additionally, there is an action button meant for a back/close action
/// implemented in this widget.
class LivestreamContent extends StatefulWidget {
  /// Creates a [LivestreamContent] widget.
  ///
  /// * [call] is the livestream call intended to be viewed.
  ///
  /// * [callState] is the livestream call state.
  ///
  /// * [backButtonBuilder] allows you to build a back/close button for closing
  /// the livestream.
  ///
  /// * [displayDiagnostics] displays call diagnostics when the widget is
  /// double-tapped.
  ///
  /// * [videoFit] denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  const LivestreamContent({
    super.key,
    required this.call,
    required this.callState,
    this.backButtonBuilder,
    this.displayDiagnostics = false,
    this.videoFit = VideoFit.contain,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// [WidgetBuilder] used to build an action button on the top left side of
  /// the screen.
  final WidgetBuilder? backButtonBuilder;

  /// Boolean to allow a user to double-tap a call to see diagnostic data.
  ///
  /// Defaults to false.
  final bool displayDiagnostics;

  /// Denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  final VideoFit videoFit;

  @override
  State<LivestreamContent> createState() => _LivestreamContentState();
}

class _LivestreamContentState extends State<LivestreamContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  /// Denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  VideoFit get videoFit => widget.videoFit;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    late Widget bodyWidget;
    if (callState.status.isConnected) {
      if (callState.isBackstage) {
        bodyWidget = const Center(
          child: Text('Livestream is backstage'),
        );
      } else {
        final streamingParticipants =
            callState.callParticipants.where((e) => e.isVideoEnabled).toList();

        bodyWidget = const Center(
          child: Text('No livestreaming participants'),
        );

        if (streamingParticipants.isEmpty) {
        } else {
          final participant = streamingParticipants.first;

          bodyWidget = StreamCallParticipant(
            // We use the sessionId as the key to avoid rebuilding the widget
            // when the participant changes.
            key: ValueKey(participant.uniqueParticipantKey),
            call: call,
            participant: participant,
            showConnectionQualityIndicator: false,
            showParticipantLabel: false,
            showSpeakerBorder: false,
            videoFit: videoFit,
          );
        }
      }
    } else {
      final isMigrating = callState.status.isMigrating;
      final isReconnecting = callState.status.isReconnecting;
      final statusText = isMigrating
          ? 'Migrating'
          : isReconnecting
              ? 'Reconnecting'
              : 'Connecting';
      bodyWidget = Center(
        child: Text(
          statusText,
          style: theme.textTheme.title3,
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorTheme.livestreamBackground,
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
