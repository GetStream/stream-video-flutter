import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_screen/call_diagnostics_content/call_diagnostics_content.dart';
import '../l10n/localization_extension.dart';

typedef LivestreamHostsUnavailableBuilder = Widget Function(
  BuildContext context,
  LivestreamHostsUnavailableProperties properties,
);

class LivestreamHostsUnavailableProperties {
  LivestreamHostsUnavailableProperties(
    this.call,
  );

  final Call call;
}

typedef LivestreamNotConnectedBuilder = Widget Function(
  BuildContext context,
  LivestreamNotConnectedProperties properties,
);

class LivestreamNotConnectedProperties {
  LivestreamNotConnectedProperties(
    this.call, {
    required this.isMigrating,
    required this.isReconnecting,
  });

  final Call call;
  final bool isMigrating;
  final bool isReconnecting;
}

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
  /// * [videoPlaceholderBuilder] allows you to build a video placeholder for the
  /// video renderer. This is useful when the video is not available or
  /// disconnected. By default, it uses the [StreamUserAvatar] widget
  ///
  /// * [videoRendererBuilder] allows you to build a custom video renderer
  ///
  /// * [livestreamHostsUnavailableBuilder] allows you to build a custom widget when
  /// a livestream is connected but no hosts have video enabled.
  ///
  /// * [livestreamNotConnectedBuilder] allows you to build a custom widget when
  /// the livestream is not connected. Provides connection state information.
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
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.livestreamHostsUnavailableBuilder,
    this.livestreamNotConnectedBuilder,
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

  /// The builder used to create a custom widget for the video placeholder.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  final VideoRendererBuilder? videoRendererBuilder;

  /// Builder function used to create a custom widget when a livestream is connected
  /// but no hosts have video enabled.
  final LivestreamHostsUnavailableBuilder? livestreamHostsUnavailableBuilder;

  /// Builder function used to create a custom widget when the livestream is not connected.
  /// Provides connection state information (isMigrating, isReconnecting) that can be
  /// used to show appropriate status messages.
  final LivestreamNotConnectedBuilder? livestreamNotConnectedBuilder;

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
    final translations = context.translations;

    late Widget bodyWidget;
    if (callState.status.isConnected) {
      final streamingParticipants =
          callState.callParticipants.where((e) => e.isVideoEnabled).toList();

      if (streamingParticipants.isEmpty) {
        bodyWidget = widget.livestreamHostsUnavailableBuilder?.call(
              context,
              LivestreamHostsUnavailableProperties(call),
            ) ??
            Center(
              child: Text(
                translations.livestreamHostNotAvailable,
                style: theme.livestreamTheme.callStateButtonTextStyle,
              ),
            );
      } else {
        final participant = streamingParticipants.first;

        bodyWidget = StreamCallParticipant(
          backgroundColor: theme.colorTheme.livestreamBackground,
          key: ValueKey(participant.uniqueParticipantKey),
          call: call,
          participant: participant,
          showConnectionQualityIndicator: false,
          showParticipantLabel: false,
          showSpeakerBorder: false,
          videoFit: videoFit,
          videoRendererBuilder: widget.videoRendererBuilder,
          videoPlaceholderBuilder: widget.videoPlaceholderBuilder,
        );
      }
    } else {
      final isMigrating = callState.status.isMigrating;
      final isReconnecting = callState.status.isReconnecting;
      final statusText = isMigrating
          ? 'Migrating'
          : isReconnecting
              ? 'Reconnecting'
              : 'Connecting';

      bodyWidget = widget.livestreamNotConnectedBuilder?.call(
            context,
            LivestreamNotConnectedProperties(
              call,
              isMigrating: isMigrating,
              isReconnecting: isReconnecting,
            ),
          ) ??
          Center(
            child: Text(
              statusText,
              style: theme.livestreamTheme.callStateButtonTextStyle,
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
